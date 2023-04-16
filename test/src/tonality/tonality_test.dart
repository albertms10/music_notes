import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Tonality', () {
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
