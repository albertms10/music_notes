import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Tonality', () {
    group('.relative', () {
      test('should return the relative Tonality of this', () {
        expect(Tonality.cMajor.relative, Tonality.aMinor);
        expect(Tonality.fMajor.relative, Tonality.dMinor);
        expect(Tonality.dMajor.relative, Tonality.bMinor);
        expect(Tonality.gSharpMinor.relative, Tonality.bMajor);
        expect(
          Tonality.aFlatMinor.relative,
          const Tonality(Note(Notes.c, Accidental.flat), Modes.major),
        );
      });
    });

    group('.keySignature', () {
      test('should return the KeySignature of this Tonality', () {
        expect(Tonality.cMajor.keySignature, const KeySignature(0));
        expect(Tonality.aMinor.keySignature, const KeySignature(0));

        expect(
          Tonality.gMajor.keySignature,
          const KeySignature(1, Accidental.sharp),
        );
        expect(
          Tonality.eMinor.keySignature,
          const KeySignature(1, Accidental.sharp),
        );
        expect(
          Tonality.fMajor.keySignature,
          const KeySignature(1, Accidental.flat),
        );
        expect(
          Tonality.dMinor.keySignature,
          const KeySignature(1, Accidental.flat),
        );

        expect(
          Tonality.bMajor.keySignature,
          const KeySignature(5, Accidental.sharp),
        );
        expect(
          Tonality.gSharpMinor.keySignature,
          const KeySignature(5, Accidental.sharp),
        );
        expect(
          Tonality.dFlatMajor.keySignature,
          const KeySignature(5, Accidental.flat),
        );
        expect(
          Tonality.bFlatMinor.keySignature,
          const KeySignature(5, Accidental.flat),
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Tonality', () {
        expect(Tonality.cMajor.toString(), 'C major');
        expect(Tonality.dMinor.toString(), 'D minor');
        expect(Tonality.aFlatMajor.toString(), 'A♭ major');
        expect(Tonality.fSharpMinor.toString(), 'F♯ minor');
        expect(
          const Tonality(Note(Notes.g, Accidental.doubleSharp), Modes.major)
              .toString(),
          'G𝄪 major',
        );
        expect(
          const Tonality(Note(Notes.e, Accidental.doubleFlat), Modes.minor)
              .toString(),
          'E𝄫 minor',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Tonality instances in a Set', () {
        final collection = {
          Tonality.dMajor,
          Tonality.fSharpMinor,
          Tonality.gSharpMinor,
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          Tonality.dMajor,
          Tonality.fSharpMinor,
          Tonality.gSharpMinor,
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Tonality items in a collection', () {
        final orderedSet = SplayTreeSet<Tonality>.of(const [
          Tonality.fSharpMinor,
          Tonality.cMinor,
          Tonality.dMajor,
          Tonality.cMajor,
          Tonality.dFlatMajor,
          Tonality.eFlatMajor,
        ]);
        expect(orderedSet.toList(), const [
          Tonality.cMajor,
          Tonality.cMinor,
          Tonality.dFlatMajor,
          Tonality.dMajor,
          Tonality.eFlatMajor,
          Tonality.fSharpMinor,
        ]);
      });
    });
  });
}
