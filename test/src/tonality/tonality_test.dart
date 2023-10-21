import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Tonality', () {
    group('.relative', () {
      test('should return the relative Tonality of this', () {
        expect(Note.c.major.relative, Note.a.minor);
        expect(Note.f.major.relative, Note.d.minor);
        expect(Note.d.major.relative, Note.b.minor);
        expect(Note.g.sharp.minor.relative, Note.b.major);
        expect(Note.a.flat.minor.relative, Note.c.flat.major);
      });
    });

    group('.keySignature', () {
      test('should return the KeySignature of this Tonality', () {
        expect(Note.c.major.keySignature, KeySignature.empty);
        expect(Note.a.minor.keySignature, KeySignature.empty);

        expect(Note.g.major.keySignature, KeySignature([Note.f.sharp]));
        expect(Note.e.minor.keySignature, KeySignature([Note.f.sharp]));
        expect(Note.f.major.keySignature, KeySignature([Note.b.flat]));
        expect(Note.d.minor.keySignature, KeySignature([Note.b.flat]));

        expect(
          Note.b.major.keySignature,
          KeySignature([
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
          ]),
        );
        expect(
          Note.g.sharp.minor.keySignature,
          KeySignature([
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
          ]),
        );
        expect(
          Note.d.flat.major.keySignature,
          KeySignature([
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
            Note.d.flat,
            Note.g.flat,
          ]),
        );
        expect(
          Note.b.flat.minor.keySignature,
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

    group('.scale', () {
      test('should return the scale notes of this Tonality', () {
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
      test('should return the string representation of this Tonality', () {
        expect(Note.c.major.toString(), 'C major');
        expect(Note.d.minor.toString(), 'D minor');
        expect(Note.a.flat.major.toString(), 'A♭ major');
        expect(Note.f.sharp.minor.toString(), 'F♯ minor');
        expect(Note.g.sharp.sharp.major.toString(), 'G𝄪 major');
        expect(Note.e.flat.flat.minor.toString(), 'E𝄫 minor');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Tonality instances in a Set', () {
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
      test('should correctly sort Tonality items in a collection', () {
        final orderedSet = SplayTreeSet<Tonality>.of({
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
