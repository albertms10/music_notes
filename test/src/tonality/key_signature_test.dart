import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('KeySignature', () {
    group('.fromDistance()', () {
      test('should create a new KeySignature from the given distance', () {
        expect(
          KeySignature.fromDistance(-6),
          KeySignature([
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
            Note.d.flat,
            Note.g.flat,
            Note.c.flat,
          ]),
        );
        expect(KeySignature.fromDistance(-1), KeySignature([Note.b.flat]));
        expect(KeySignature.fromDistance(0), const KeySignature([]));
        expect(KeySignature.fromDistance(1), KeySignature([Note.f.sharp]));
        expect(
          KeySignature.fromDistance(6),
          KeySignature([
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
            Note.e.sharp,
          ]),
        );
      });
    });

    group('.distance', () {
      test('should return the fifths distance of this KeySignature', () {
        expect(KeySignature.fromDistance(-7).distance, -7);
        expect(KeySignature.fromDistance(-2).distance, -2);
        expect(KeySignature.fromDistance(0).distance, 0);
        expect(KeySignature.fromDistance(1).distance, 1);
        expect(KeySignature.fromDistance(5).distance, 5);
      });
    });

    group('.majorNote', () {
      test(
        'should return the Note that corresponds to the major Tonality of '
        'this KeySignature',
        () {
          expect(KeySignature.fromDistance(-4).majorNote, Note.a.flat);
          expect(KeySignature.fromDistance(-3).majorNote, Note.e.flat);
          expect(KeySignature.fromDistance(-2).majorNote, Note.b.flat);
          expect(KeySignature.fromDistance(-1).majorNote, Note.f);
          expect(KeySignature.fromDistance(0).majorNote, Note.c);
          expect(KeySignature.fromDistance(1).majorNote, Note.g);
          expect(KeySignature.fromDistance(2).majorNote, Note.d);
          expect(KeySignature.fromDistance(3).majorNote, Note.a);
          expect(KeySignature.fromDistance(4).majorNote, Note.e);
        },
      );
    });

    group('.tonality()', () {
      test('should return the Tonality from TonalMode', () {
        expect(
          KeySignature.fromDistance(-4).tonality(TonalMode.major),
          Note.a.flat.major,
        );
        expect(
          KeySignature.fromDistance(-4).tonality(TonalMode.minor),
          Note.f.minor,
        );
        expect(
          KeySignature.fromDistance(-2).tonality(TonalMode.major),
          Note.b.flat.major,
        );
        expect(
          KeySignature.fromDistance(-2).tonality(TonalMode.minor),
          Note.g.minor,
        );
        expect(
          KeySignature.fromDistance(0).tonality(TonalMode.major),
          Note.c.major,
        );
        expect(
          KeySignature.fromDistance(0).tonality(TonalMode.minor),
          Note.a.minor,
        );
        expect(
          KeySignature.fromDistance(1).tonality(TonalMode.major),
          Note.g.major,
        );
        expect(
          KeySignature.fromDistance(1).tonality(TonalMode.minor),
          Note.e.minor,
        );
        expect(
          KeySignature.fromDistance(5).tonality(TonalMode.major),
          Note.b.major,
        );
        expect(
          KeySignature.fromDistance(5).tonality(TonalMode.minor),
          Note.g.sharp.minor,
        );
      });
    });

    group('.tonalities', () {
      test('should return the Set of tonalities for this KeySignature', () {
        expect(KeySignature.fromDistance(-10).tonalities, {
          Note.e.flat.flat.major,
          Note.c.flat.minor,
        });
        expect(KeySignature.fromDistance(-9).tonalities, {
          Note.b.flat.flat.major,
          Note.g.flat.minor,
        });
        expect(KeySignature.fromDistance(-8).tonalities, {
          Note.f.flat.major,
          Note.d.flat.minor,
        });
        expect(KeySignature.fromDistance(-7).tonalities, {
          Note.c.flat.major,
          Note.a.flat.minor,
        });
        expect(KeySignature.fromDistance(-6).tonalities, {
          Note.g.flat.major,
          Note.e.flat.minor,
        });
        expect(KeySignature.fromDistance(-5).tonalities, {
          Note.d.flat.major,
          Note.b.flat.minor,
        });
        expect(KeySignature.fromDistance(-4).tonalities, {
          Note.a.flat.major,
          Note.f.minor,
        });
        expect(KeySignature.fromDistance(-3).tonalities, {
          Note.e.flat.major,
          Note.c.minor,
        });
        expect(KeySignature.fromDistance(-2).tonalities, {
          Note.b.flat.major,
          Note.g.minor,
        });
        expect(KeySignature.fromDistance(-1).tonalities, {
          Note.f.major,
          Note.d.minor,
        });
        expect(KeySignature.fromDistance(0).tonalities, {
          Note.c.major,
          Note.a.minor,
        });
        expect(KeySignature.fromDistance(1).tonalities, {
          Note.g.major,
          Note.e.minor,
        });
        expect(KeySignature.fromDistance(2).tonalities, {
          Note.d.major,
          Note.b.minor,
        });
        expect(KeySignature.fromDistance(3).tonalities, {
          Note.a.major,
          Note.f.sharp.minor,
        });
        expect(KeySignature.fromDistance(4).tonalities, {
          Note.e.major,
          Note.c.sharp.minor,
        });
        expect(KeySignature.fromDistance(5).tonalities, {
          Note.b.major,
          Note.g.sharp.minor,
        });
        expect(KeySignature.fromDistance(6).tonalities, {
          Note.f.sharp.major,
          Note.d.sharp.minor,
        });
        expect(KeySignature.fromDistance(7).tonalities, {
          Note.c.sharp.major,
          Note.a.sharp.minor,
        });
        expect(KeySignature.fromDistance(8).tonalities, {
          Note.g.sharp.major,
          Note.e.sharp.minor,
        });
        expect(KeySignature.fromDistance(9).tonalities, {
          Note.d.sharp.major,
          Note.b.sharp.minor,
        });
        expect(KeySignature.fromDistance(10).tonalities, {
          Note.a.sharp.major,
          Note.f.sharp.sharp.minor,
        });
      });
    });

    group('.toString()', () {
      test(
        'should return the string representation of this KeySignature',
        () {
          expect(KeySignature.fromDistance(-10).toString(), '7 ♭, 3 𝄫');
          expect(KeySignature.fromDistance(-8).toString(), '7 ♭, 1 𝄫');
          expect(KeySignature.fromDistance(-7).toString(), '7 ♭');
          expect(KeySignature.fromDistance(-6).toString(), '6 ♭');
          expect(KeySignature.fromDistance(-5).toString(), '5 ♭');
          expect(KeySignature.fromDistance(-4).toString(), '4 ♭');
          expect(KeySignature.fromDistance(-3).toString(), '3 ♭');
          expect(KeySignature.fromDistance(-2).toString(), '2 ♭');
          expect(KeySignature.fromDistance(-1).toString(), '1 ♭');
          expect(KeySignature.fromDistance(0).toString(), '0 ♮');
          expect(KeySignature.fromDistance(1).toString(), '1 ♯');
          expect(KeySignature.fromDistance(2).toString(), '2 ♯');
          expect(KeySignature.fromDistance(3).toString(), '3 ♯');
          expect(KeySignature.fromDistance(4).toString(), '4 ♯');
          expect(KeySignature.fromDistance(5).toString(), '5 ♯');
          expect(KeySignature.fromDistance(6).toString(), '6 ♯');
          expect(KeySignature.fromDistance(7).toString(), '7 ♯');
          expect(KeySignature.fromDistance(8).toString(), '7 ♯, 1 𝄪');
          expect(KeySignature.fromDistance(10).toString(), '7 ♯, 3 𝄪');
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal KeySignature instances in a Set', () {
        final collection = {
          const KeySignature([]),
          KeySignature([Note.f.sharp]),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const KeySignature([]),
          KeySignature([Note.f.sharp]),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort KeySignature items in a collection', () {
        final orderedSet = SplayTreeSet<KeySignature>.of([
          KeySignature.fromDistance(-3),
          KeySignature.fromDistance(0),
          KeySignature.fromDistance(-6),
          KeySignature.fromDistance(4),
          KeySignature.fromDistance(3),
        ]);
        expect(orderedSet.toList(), [
          KeySignature.fromDistance(-6),
          KeySignature.fromDistance(-3),
          KeySignature.fromDistance(0),
          KeySignature.fromDistance(3),
          KeySignature.fromDistance(4),
        ]);
      });
    });
  });
}
