import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Tonality', () {
    group('.toString()', () {
      test('should return the string representation of this Tonality', () {
        expect(const Tonality(Note.c, Modes.major).toString(), 'C major');
        expect(const Tonality(Note.d, Modes.minor).toString(), 'D minor');
        expect(const Tonality(Note.aFlat, Modes.major).toString(), 'A♭ major');
        expect(const Tonality(Note.fSharp, Modes.minor).toString(), 'F♯ minor');
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
          const Tonality(Note.d, Modes.major),
          const Tonality(Note.fSharp, Modes.minor),
          const Tonality(Note.gSharp, Modes.minor),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const Tonality(Note.d, Modes.major),
          const Tonality(Note.fSharp, Modes.minor),
          const Tonality(Note.gSharp, Modes.minor),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Tonality items in a collection', () {
        final orderedSet = SplayTreeSet<Tonality>.of([
          const Tonality(Note.fSharp, Modes.minor),
          const Tonality(Note.c, Modes.minor),
          const Tonality(Note.d, Modes.major),
          const Tonality(Note.c, Modes.major),
          const Tonality(Note.dFlat, Modes.major),
          const Tonality(Note.eFlat, Modes.major),
        ]);
        expect(orderedSet.toList(), [
          const Tonality(Note.c, Modes.major),
          const Tonality(Note.c, Modes.minor),
          const Tonality(Note.dFlat, Modes.major),
          const Tonality(Note.d, Modes.major),
          const Tonality(Note.eFlat, Modes.major),
          const Tonality(Note.fSharp, Modes.minor),
        ]);
      });
    });
  });
}
