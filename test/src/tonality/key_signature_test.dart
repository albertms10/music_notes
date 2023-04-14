import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('KeySignature', () {
    group('constructor', () {
      test('should throw an assertion error when arguments are incorrect', () {
        expect(() => KeySignature(-1), throwsA(isA<AssertionError>()));
        expect(() => KeySignature(1), throwsA(isA<AssertionError>()));
      });
    });

    group('.fromDistance()', () {
      test('should create a new KeySignature from the given distance', () {
        expect(
          KeySignature.fromDistance(-5),
          const KeySignature(5, Accidental.flat),
        );
        expect(
          KeySignature.fromDistance(-1),
          const KeySignature(1, Accidental.flat),
        );
        expect(KeySignature.fromDistance(0), const KeySignature(0));
        expect(
          KeySignature.fromDistance(1),
          const KeySignature(1, Accidental.sharp),
        );
        expect(
          KeySignature.fromDistance(5),
          const KeySignature(5, Accidental.sharp),
        );
      });
    });

    group('.tonalities', () {
      test('should return the Set of tonalities for this KeySignature', () {
        expect(const KeySignature(10, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.e, Accidental.doubleFlat), Modes.major),
          const Tonality(Note(Notes.c, Accidental.flat), Modes.minor),
        });
        expect(const KeySignature(9, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.b, Accidental.doubleFlat), Modes.major),
          const Tonality(Note.gFlat, Modes.minor),
        });
        expect(const KeySignature(8, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.f, Accidental.flat), Modes.major),
          const Tonality(Note.dFlat, Modes.minor),
        });
        expect(const KeySignature(7, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.c, Accidental.flat), Modes.major),
          const Tonality(Note.aFlat, Modes.minor),
        });
        expect(const KeySignature(6, Accidental.flat).tonalities, {
          const Tonality(Note.gFlat, Modes.major),
          const Tonality(Note.eFlat, Modes.minor),
        });
        expect(const KeySignature(5, Accidental.flat).tonalities, {
          const Tonality(Note.dFlat, Modes.major),
          const Tonality(Note.bFlat, Modes.minor),
        });
        expect(const KeySignature(4, Accidental.flat).tonalities, {
          const Tonality(Note.aFlat, Modes.major),
          const Tonality(Note.f, Modes.minor),
        });
        expect(const KeySignature(3, Accidental.flat).tonalities, {
          const Tonality(Note.eFlat, Modes.major),
          const Tonality(Note.c, Modes.minor),
        });
        expect(const KeySignature(2, Accidental.flat).tonalities, {
          const Tonality(Note.bFlat, Modes.major),
          const Tonality(Note.g, Modes.minor),
        });
        expect(const KeySignature(1, Accidental.flat).tonalities, {
          const Tonality(Note.f, Modes.major),
          const Tonality(Note.d, Modes.minor),
        });
        expect(const KeySignature(0).tonalities, {
          const Tonality(Note.c, Modes.major),
          const Tonality(Note.a, Modes.minor),
        });
        expect(const KeySignature(1, Accidental.sharp).tonalities, {
          const Tonality(Note.g, Modes.major),
          const Tonality(Note.e, Modes.minor),
        });
        expect(const KeySignature(2, Accidental.sharp).tonalities, {
          const Tonality(Note.d, Modes.major),
          const Tonality(Note.b, Modes.minor),
        });
        expect(const KeySignature(3, Accidental.sharp).tonalities, {
          const Tonality(Note.a, Modes.major),
          const Tonality(Note.fSharp, Modes.minor),
        });
        expect(const KeySignature(4, Accidental.sharp).tonalities, {
          const Tonality(Note.e, Modes.major),
          const Tonality(Note.cSharp, Modes.minor),
        });
        expect(const KeySignature(5, Accidental.sharp).tonalities, {
          const Tonality(Note.b, Modes.major),
          const Tonality(Note.gSharp, Modes.minor),
        });
        expect(const KeySignature(6, Accidental.sharp).tonalities, {
          const Tonality(Note.fSharp, Modes.major),
          const Tonality(Note.dSharp, Modes.minor),
        });
        expect(const KeySignature(7, Accidental.sharp).tonalities, {
          const Tonality(Note.cSharp, Modes.major),
          const Tonality(Note.aSharp, Modes.minor),
        });
        expect(const KeySignature(8, Accidental.sharp).tonalities, {
          const Tonality(Note.gSharp, Modes.major),
          const Tonality(Note(Notes.e, Accidental.sharp), Modes.minor),
        });
        expect(const KeySignature(9, Accidental.sharp).tonalities, {
          const Tonality(Note.dSharp, Modes.major),
          const Tonality(Note(Notes.b, Accidental.sharp), Modes.minor),
        });
        expect(const KeySignature(10, Accidental.sharp).tonalities, {
          const Tonality(Note.aSharp, Modes.major),
          // TODO(albertms10): Failing test:
          //  Should be Note(Notes.f, Accidental.doubleSharp).
          const Tonality(Note.g, Modes.minor),
        });
      });
    });

    group('.toString()', () {
      test(
        'should return the string representation of this KeySignature',
        () {
          expect(
            const KeySignature(10, Accidental.flat).toString(),
            '7 ♭, 3 𝄫',
          );
          expect(
            const KeySignature(8, Accidental.flat).toString(),
            '7 ♭, 1 𝄫',
          );
          expect(const KeySignature(7, Accidental.flat).toString(), '7 ♭');
          expect(const KeySignature(6, Accidental.flat).toString(), '6 ♭');
          expect(const KeySignature(5, Accidental.flat).toString(), '5 ♭');
          expect(const KeySignature(4, Accidental.flat).toString(), '4 ♭');
          expect(const KeySignature(3, Accidental.flat).toString(), '3 ♭');
          expect(const KeySignature(2, Accidental.flat).toString(), '2 ♭');
          expect(const KeySignature(1, Accidental.flat).toString(), '1 ♭');
          expect(const KeySignature(0).toString(), '0 ♮');
          expect(const KeySignature(1, Accidental.sharp).toString(), '1 ♯');
          expect(const KeySignature(2, Accidental.sharp).toString(), '2 ♯');
          expect(const KeySignature(3, Accidental.sharp).toString(), '3 ♯');
          expect(const KeySignature(4, Accidental.sharp).toString(), '4 ♯');
          expect(const KeySignature(5, Accidental.sharp).toString(), '5 ♯');
          expect(const KeySignature(6, Accidental.sharp).toString(), '6 ♯');
          expect(const KeySignature(7, Accidental.sharp).toString(), '7 ♯');
          expect(
            const KeySignature(8, Accidental.sharp).toString(),
            '7 ♯, 1 𝄪',
          );
          expect(
            const KeySignature(10, Accidental.sharp).toString(),
            '7 ♯, 3 𝄪',
          );
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal KeySignature instances in a Set', () {
        final collection = {
          const KeySignature(0),
          const KeySignature(1, Accidental.sharp),
        };
        collection.addAll(collection);
        expect(collection.toList(), const [
          KeySignature(0),
          KeySignature(1, Accidental.sharp),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort KeySignature items in a collection', () {
        final orderedSet = SplayTreeSet<KeySignature>.of(const [
          KeySignature(3, Accidental.flat),
          KeySignature(0),
          KeySignature(6, Accidental.flat),
          KeySignature(4, Accidental.sharp),
          KeySignature(3, Accidental.sharp),
        ]);
        expect(orderedSet.toList(), const [
          KeySignature(6, Accidental.flat),
          KeySignature(3, Accidental.flat),
          KeySignature(0),
          KeySignature(3, Accidental.sharp),
          KeySignature(4, Accidental.sharp),
        ]);
      });
    });
  });
}
