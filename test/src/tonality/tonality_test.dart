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
        expect(Note.gSharp.minor.relative, Note.b.major);
        expect(
          Note.aFlat.minor.relative,
          const Tonality(Note(BaseNote.c, Accidental.flat), TonalMode.major),
        );
      });
    });

    group('.keySignature', () {
      test('should return the KeySignature of this Tonality', () {
        expect(Note.c.major.keySignature, const KeySignature(0));
        expect(Note.a.minor.keySignature, const KeySignature(0));

        expect(
          Note.g.major.keySignature,
          const KeySignature(1, Accidental.sharp),
        );
        expect(
          Note.e.minor.keySignature,
          const KeySignature(1, Accidental.sharp),
        );
        expect(
          Note.f.major.keySignature,
          const KeySignature(1, Accidental.flat),
        );
        expect(
          Note.d.minor.keySignature,
          const KeySignature(1, Accidental.flat),
        );

        expect(
          Note.b.major.keySignature,
          const KeySignature(5, Accidental.sharp),
        );
        expect(
          Note.gSharp.minor.keySignature,
          const KeySignature(5, Accidental.sharp),
        );
        expect(
          Note.dFlat.major.keySignature,
          const KeySignature(5, Accidental.flat),
        );
        expect(
          Note.bFlat.minor.keySignature,
          const KeySignature(5, Accidental.flat),
        );
      });
    });

    group('.scaleNotes', () {
      test('should return the scale notes of this Tonality', () {
        expect(Note.d.major.scaleNotes, const [
          Note.d,
          Note.e,
          Note.fSharp,
          Note.g,
          Note.a,
          Note.b,
          Note.cSharp,
          Note.d,
        ]);
        expect(Note.c.minor.scaleNotes, const [
          Note.c,
          Note.d,
          Note.eFlat,
          Note.f,
          Note.g,
          Note.aFlat,
          Note.bFlat,
          Note.c,
        ]);
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Tonality', () {
        expect(Note.c.major.toString(), 'C major');
        expect(Note.d.minor.toString(), 'D minor');
        expect(Note.aFlat.major.toString(), 'A♭ major');
        expect(Note.fSharp.minor.toString(), 'F♯ minor');
        expect(
          const Tonality(
            Note(BaseNote.g, Accidental.doubleSharp),
            TonalMode.major,
          ).toString(),
          'G𝄪 major',
        );
        expect(
          const Tonality(
            Note(BaseNote.e, Accidental.doubleFlat),
            TonalMode.minor,
          ).toString(),
          'E𝄫 minor',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Tonality instances in a Set', () {
        final collection = {
          Note.d.major,
          Note.fSharp.minor,
          Note.gSharp.minor,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.d.major,
          Note.fSharp.minor,
          Note.gSharp.minor,
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Tonality items in a collection', () {
        final orderedSet = SplayTreeSet<Tonality>.of([
          Note.fSharp.minor,
          Note.c.minor,
          Note.d.major,
          Note.c.major,
          Note.dFlat.major,
          Note.eFlat.major,
        ]);
        expect(orderedSet.toList(), [
          Note.c.major,
          Note.c.minor,
          Note.dFlat.major,
          Note.d.major,
          Note.eFlat.major,
          Note.fSharp.minor,
        ]);
      });
    });
  });
}
