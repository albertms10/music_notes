import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('KeySignature', () {
    group('constructor', () {
      test('should throw an assertion error when arguments are incorrect', () {
        expect(() => KeySignature(-1), throwsA(isA<AssertionError>()));
        expect(() => KeySignature(1), throwsA(isA<AssertionError>()));
        expect(
          () => KeySignature(1, Accidental.doubleFlat),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => KeySignature(2, Accidental.tripleSharp),
          throwsA(isA<AssertionError>()),
        );
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

    group('.majorNote', () {
      test(
        'should return the Note that corresponds to the major Tonality of '
        'this KeySignature',
        () {
          expect(const KeySignature(4, Accidental.flat).majorNote, Note.aFlat);
          expect(const KeySignature(3, Accidental.flat).majorNote, Note.eFlat);
          expect(const KeySignature(2, Accidental.flat).majorNote, Note.bFlat);
          expect(const KeySignature(1, Accidental.flat).majorNote, Note.f);
          expect(const KeySignature(0).majorNote, Note.c);
          expect(const KeySignature(1, Accidental.sharp).majorNote, Note.g);
          expect(const KeySignature(2, Accidental.sharp).majorNote, Note.d);
          expect(const KeySignature(3, Accidental.sharp).majorNote, Note.a);
          expect(const KeySignature(4, Accidental.sharp).majorNote, Note.e);
        },
      );
    });

    group('.tonality()', () {
      test('should return the Tonality from TonalMode', () {
        expect(
          const KeySignature(4, Accidental.flat).tonality(TonalMode.major),
          Tonality.aFlatMajor,
        );
        expect(
          const KeySignature(4, Accidental.flat).tonality(TonalMode.minor),
          Tonality.fMinor,
        );
        expect(
          const KeySignature(2, Accidental.flat).tonality(TonalMode.major),
          Tonality.bFlatMajor,
        );
        expect(
          const KeySignature(2, Accidental.flat).tonality(TonalMode.minor),
          Tonality.gMinor,
        );
        expect(
          const KeySignature(0).tonality(TonalMode.major),
          Tonality.cMajor,
        );
        expect(
          const KeySignature(0).tonality(TonalMode.minor),
          Tonality.aMinor,
        );
        expect(
          const KeySignature(1, Accidental.sharp).tonality(TonalMode.major),
          Tonality.gMajor,
        );
        expect(
          const KeySignature(1, Accidental.sharp).tonality(TonalMode.minor),
          Tonality.eMinor,
        );
        expect(
          const KeySignature(5, Accidental.sharp).tonality(TonalMode.major),
          Tonality.bMajor,
        );
        expect(
          const KeySignature(5, Accidental.sharp).tonality(TonalMode.minor),
          Tonality.gSharpMinor,
        );
      });
    });

    group('.tonalities', () {
      test('should return the Set of tonalities for this KeySignature', () {
        expect(const KeySignature(10, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.e, Accidental.doubleFlat), TonalMode.major),
          const Tonality(Note(Notes.c, Accidental.flat), TonalMode.minor),
        });
        expect(const KeySignature(9, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.b, Accidental.doubleFlat), TonalMode.major),
          const Tonality(Note.gFlat, TonalMode.minor),
        });
        expect(const KeySignature(8, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.f, Accidental.flat), TonalMode.major),
          const Tonality(Note.dFlat, TonalMode.minor),
        });
        expect(const KeySignature(7, Accidental.flat).tonalities, {
          const Tonality(Note(Notes.c, Accidental.flat), TonalMode.major),
          Tonality.aFlatMinor,
        });
        expect(const KeySignature(6, Accidental.flat).tonalities, {
          Tonality.gFlatMajor,
          Tonality.eFlatMinor,
        });
        expect(const KeySignature(5, Accidental.flat).tonalities, {
          Tonality.dFlatMajor,
          Tonality.bFlatMinor,
        });
        expect(const KeySignature(4, Accidental.flat).tonalities, {
          Tonality.aFlatMajor,
          Tonality.fMinor,
        });
        expect(const KeySignature(3, Accidental.flat).tonalities, {
          Tonality.eFlatMajor,
          Tonality.cMinor,
        });
        expect(const KeySignature(2, Accidental.flat).tonalities, {
          Tonality.bFlatMajor,
          Tonality.gMinor,
        });
        expect(const KeySignature(1, Accidental.flat).tonalities, {
          Tonality.fMajor,
          Tonality.dMinor,
        });
        expect(const KeySignature(0).tonalities, {
          Tonality.cMajor,
          Tonality.aMinor,
        });
        expect(const KeySignature(1, Accidental.sharp).tonalities, {
          Tonality.gMajor,
          Tonality.eMinor,
        });
        expect(const KeySignature(2, Accidental.sharp).tonalities, {
          Tonality.dMajor,
          Tonality.bMinor,
        });
        expect(const KeySignature(3, Accidental.sharp).tonalities, {
          Tonality.aMajor,
          Tonality.fSharpMinor,
        });
        expect(const KeySignature(4, Accidental.sharp).tonalities, {
          Tonality.eMajor,
          Tonality.cSharpMinor,
        });
        expect(const KeySignature(5, Accidental.sharp).tonalities, {
          Tonality.bMajor,
          Tonality.gSharpMinor,
        });
        expect(const KeySignature(6, Accidental.sharp).tonalities, {
          Tonality.fSharpMajor,
          Tonality.dSharpMinor,
        });
        expect(const KeySignature(7, Accidental.sharp).tonalities, {
          Tonality.cSharpMajor,
          Tonality.aSharpMinor,
        });
        expect(const KeySignature(8, Accidental.sharp).tonalities, {
          const Tonality(Note.gSharp, TonalMode.major),
          const Tonality(Note(Notes.e, Accidental.sharp), TonalMode.minor),
        });
        expect(const KeySignature(9, Accidental.sharp).tonalities, {
          const Tonality(Note.dSharp, TonalMode.major),
          const Tonality(Note(Notes.b, Accidental.sharp), TonalMode.minor),
        });
        expect(const KeySignature(10, Accidental.sharp).tonalities, {
          const Tonality(Note.aSharp, TonalMode.major),
          const Tonality(
            Note(Notes.f, Accidental.doubleSharp),
            TonalMode.minor,
          ),
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
