import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Key', () {
    group('.relative', () {
      test('returns the relative of this Key', () {
        expect(Note.c.major.relative, Note.a.minor);
        expect(Note.f.major.relative, Note.d.minor);
        expect(Note.b.minor.relative, Note.d.major);
        expect(Note.g.sharp.minor.relative, Note.b.major);
        expect(Note.a.flat.minor.relative, Note.c.flat.major);
      });
    });

    group('.parallel', () {
      test('returns the parallel of this Key', () {
        expect(Note.c.major.parallel, Note.c.minor);
        expect(Note.f.major.parallel, Note.f.minor);
        expect(Note.b.minor.parallel, Note.b.major);
        expect(Note.g.sharp.minor.parallel, Note.g.sharp.major);
        expect(Note.a.flat.major.parallel, Note.a.flat.minor);
      });
    });

    group('.signature', () {
      test('returns the KeySignature of this Key', () {
        expect(Note.c.major.signature, KeySignature.empty);
        expect(Note.a.minor.signature, KeySignature.empty);

        expect(Note.g.major.signature, KeySignature([Note.f.sharp]));
        expect(Note.e.minor.signature, KeySignature([Note.f.sharp]));
        expect(Note.f.major.signature, KeySignature([Note.b.flat]));
        expect(Note.d.minor.signature, KeySignature([Note.b.flat]));

        expect(
          Note.b.major.signature,
          KeySignature([
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
          ]),
        );
        expect(
          Note.g.sharp.minor.signature,
          KeySignature([
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
          ]),
        );
        expect(
          Note.d.flat.major.signature,
          KeySignature([
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
            Note.d.flat,
            Note.g.flat,
          ]),
        );
        expect(
          Note.b.flat.minor.signature,
          KeySignature([
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
            Note.d.flat,
            Note.g.flat,
          ]),
        );
      });
    });

    group('.isTheoretical', () {
      test('returns whether this Key is theoretical', () {
        expect(Note.c.flat.major.isTheoretical, false);
        expect(Note.a.flat.minor.isTheoretical, false);
        expect(Note.c.minor.isTheoretical, false);
        expect(Note.e.major.isTheoretical, false);
        expect(Note.c.sharp.major.isTheoretical, false);
        expect(Note.a.sharp.minor.isTheoretical, false);

        expect(Note.f.flat.major.isTheoretical, true);
        expect(Note.d.flat.minor.isTheoretical, true);
        expect(Note.c.sharp.sharp.minor.isTheoretical, true);
        expect(Note.a.flat.flat.major.isTheoretical, true);
        expect(Note.g.sharp.major.isTheoretical, true);
        expect(Note.e.sharp.minor.isTheoretical, true);
      });
    });

    group('.scale', () {
      test('returns the scale notes of this Key', () {
        expect(
          Note.d.major.scale,
          Scale([
            Note.d,
            Note.e,
            Note.f.sharp,
            Note.g,
            Note.a,
            Note.b,
            Note.c.sharp,
            Note.d,
          ]),
        );
        expect(
          Note.c.minor.scale,
          Scale([
            Note.c,
            Note.d,
            Note.e.flat,
            Note.f,
            Note.g,
            Note.a.flat,
            Note.b.flat,
            Note.c,
          ]),
        );
      });
    });

    group('.toString()', () {
      test('returns the English string representation of this Key', () {
        expect(Note.c.major.toString(), 'C major');
        expect(Note.d.minor.toString(), 'D minor');
        expect(Note.a.flat.major.toString(), 'A♭ major');
        expect(Note.f.sharp.minor.toString(), 'F♯ minor');
        expect(Note.g.sharp.sharp.major.toString(), 'G𝄪 major');
        expect(Note.e.flat.flat.minor.toString(), 'E𝄫 minor');
      });

      test('returns the German string representation of this Key', () {
        expect(Note.c.major.toString(system: NoteNotation.german), 'C-dur');
        expect(Note.d.minor.toString(system: NoteNotation.german), 'd-moll');
        expect(
          Note.a.flat.major.toString(system: NoteNotation.german),
          'As-dur',
        );
        expect(
          Note.f.sharp.minor.toString(system: NoteNotation.german),
          'fis-moll',
        );
        expect(
          Note.g.sharp.sharp.major.toString(system: NoteNotation.german),
          'Gisis-dur',
        );
        expect(
          Note.e.flat.flat.minor.toString(system: NoteNotation.german),
          'eses-moll',
        );
      });

      test('returns the Romance string representation of this Key', () {
        expect(
          Note.c.major.toString(system: NoteNotation.romance),
          'Do maggiore',
        );
        expect(
          Note.d.minor.toString(system: NoteNotation.romance),
          'Re minore',
        );
        expect(
          Note.a.flat.major.toString(system: NoteNotation.romance),
          'La♭ maggiore',
        );
        expect(
          Note.f.sharp.minor.toString(system: NoteNotation.romance),
          'Fa♯ minore',
        );
        expect(
          Note.g.sharp.sharp.major.toString(system: NoteNotation.romance),
          'Sol𝄪 maggiore',
        );
        expect(
          Note.e.flat.flat.minor.toString(system: NoteNotation.romance),
          'Mi𝄫 minore',
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal Key instances in a Set', () {
        final collection = {
          Note.d.major,
          Note.f.sharp.minor,
          Note.g.sharp.minor,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.d.major,
          Note.f.sharp.minor,
          Note.g.sharp.minor,
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts Keys in a collection', () {
        final orderedSet = SplayTreeSet<Key>.of({
          Note.f.sharp.minor,
          Note.c.minor,
          Note.d.major,
          Note.c.major,
          Note.d.flat.major,
          Note.e.flat.major,
        });
        expect(orderedSet.toList(), [
          Note.c.major,
          Note.c.minor,
          Note.d.flat.major,
          Note.d.major,
          Note.e.flat.major,
          Note.f.sharp.minor,
        ]);
      });
    });
  });
}
