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
          () => KeySignature(0, Accidental.sharp),
          throwsA(isA<AssertionError>()),
        );
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

    group('.distance', () {
      test('should return the fifths distance of this KeySignature', () {
        expect(const KeySignature(7, Accidental.flat).distance, -7);
        expect(const KeySignature(2, Accidental.flat).distance, -2);
        expect(const KeySignature(0).distance, 0);
        expect(const KeySignature(1, Accidental.sharp).distance, 1);
        expect(const KeySignature(5, Accidental.sharp).distance, 5);
      });
    });

    group('.majorNote', () {
      test(
        'should return the Note that corresponds to the major Tonality of '
        'this KeySignature',
        () {
          expect(const KeySignature(4, Accidental.flat).majorNote, Note.a.flat);
          expect(const KeySignature(3, Accidental.flat).majorNote, Note.e.flat);
          expect(const KeySignature(2, Accidental.flat).majorNote, Note.b.flat);
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
          Note.a.flat.major,
        );
        expect(
          const KeySignature(4, Accidental.flat).tonality(TonalMode.minor),
          Note.f.minor,
        );
        expect(
          const KeySignature(2, Accidental.flat).tonality(TonalMode.major),
          Note.b.flat.major,
        );
        expect(
          const KeySignature(2, Accidental.flat).tonality(TonalMode.minor),
          Note.g.minor,
        );
        expect(
          const KeySignature(0).tonality(TonalMode.major),
          Note.c.major,
        );
        expect(
          const KeySignature(0).tonality(TonalMode.minor),
          Note.a.minor,
        );
        expect(
          const KeySignature(1, Accidental.sharp).tonality(TonalMode.major),
          Note.g.major,
        );
        expect(
          const KeySignature(1, Accidental.sharp).tonality(TonalMode.minor),
          Note.e.minor,
        );
        expect(
          const KeySignature(5, Accidental.sharp).tonality(TonalMode.major),
          Note.b.major,
        );
        expect(
          const KeySignature(5, Accidental.sharp).tonality(TonalMode.minor),
          Note.g.sharp.minor,
        );
      });
    });

    group('.tonalities', () {
      test('should return the Set of tonalities for this KeySignature', () {
        expect(const KeySignature(10, Accidental.flat).tonalities, {
          Note.e.flat.flat.major,
          Note.c.flat.minor,
        });
        expect(const KeySignature(9, Accidental.flat).tonalities, {
          Note.b.flat.flat.major,
          Note.g.flat.minor,
        });
        expect(const KeySignature(8, Accidental.flat).tonalities, {
          Note.f.flat.major,
          Note.d.flat.minor,
        });
        expect(const KeySignature(7, Accidental.flat).tonalities, {
          Note.c.flat.major,
          Note.a.flat.minor,
        });
        expect(const KeySignature(6, Accidental.flat).tonalities, {
          Note.g.flat.major,
          Note.e.flat.minor,
        });
        expect(const KeySignature(5, Accidental.flat).tonalities, {
          Note.d.flat.major,
          Note.b.flat.minor,
        });
        expect(const KeySignature(4, Accidental.flat).tonalities, {
          Note.a.flat.major,
          Note.f.minor,
        });
        expect(const KeySignature(3, Accidental.flat).tonalities, {
          Note.e.flat.major,
          Note.c.minor,
        });
        expect(const KeySignature(2, Accidental.flat).tonalities, {
          Note.b.flat.major,
          Note.g.minor,
        });
        expect(const KeySignature(1, Accidental.flat).tonalities, {
          Note.f.major,
          Note.d.minor,
        });
        expect(const KeySignature(0).tonalities, {
          Note.c.major,
          Note.a.minor,
        });
        expect(const KeySignature(1, Accidental.sharp).tonalities, {
          Note.g.major,
          Note.e.minor,
        });
        expect(const KeySignature(2, Accidental.sharp).tonalities, {
          Note.d.major,
          Note.b.minor,
        });
        expect(const KeySignature(3, Accidental.sharp).tonalities, {
          Note.a.major,
          Note.f.sharp.minor,
        });
        expect(const KeySignature(4, Accidental.sharp).tonalities, {
          Note.e.major,
          Note.c.sharp.minor,
        });
        expect(const KeySignature(5, Accidental.sharp).tonalities, {
          Note.b.major,
          Note.g.sharp.minor,
        });
        expect(const KeySignature(6, Accidental.sharp).tonalities, {
          Note.f.sharp.major,
          Note.d.sharp.minor,
        });
        expect(const KeySignature(7, Accidental.sharp).tonalities, {
          Note.c.sharp.major,
          Note.a.sharp.minor,
        });
        expect(const KeySignature(8, Accidental.sharp).tonalities, {
          Note.g.sharp.major,
          Note.e.sharp.minor,
        });
        expect(const KeySignature(9, Accidental.sharp).tonalities, {
          Note.d.sharp.major,
          Note.b.sharp.minor,
        });
        expect(const KeySignature(10, Accidental.sharp).tonalities, {
          Note.a.sharp.major,
          Note.f.sharp.sharp.minor,
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
