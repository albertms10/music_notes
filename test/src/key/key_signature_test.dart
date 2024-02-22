import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('KeySignature', () {
    group('.fromDistance()', () {
      test('creates a new KeySignature from the given distance', () {
        expect(
          KeySignature.fromDistance(-9),
          KeySignature([
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
            Note.d.flat,
            Note.g.flat,
            Note.c.flat,
            Note.f.flat,
            Note.b.flat.flat,
            Note.e.flat.flat,
          ]),
        );
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
        expect(KeySignature.fromDistance(0), KeySignature.empty);
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
        expect(
          KeySignature.fromDistance(10),
          KeySignature([
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
            Note.e.sharp,
            Note.b.sharp,
            Note.f.sharp.sharp,
            Note.c.sharp.sharp,
            Note.g.sharp.sharp,
          ]),
        );
      });
    });

    group('.clean', () {
      test('returns a new KeySignature without cancellation naturals', () {
        expect(
          const KeySignature([Note.f, Note.c, Note.g]).clean,
          KeySignature.empty,
        );
        expect(
          KeySignature([Note.f, Note.b.flat]).clean,
          KeySignature([Note.b.flat]),
        );
        expect(
          KeySignature(
            [Note.b, Note.e, Note.f.sharp, Note.c.sharp, Note.g.sharp],
          ).clean,
          KeySignature([Note.f.sharp, Note.c.sharp, Note.g.sharp]),
        );
      });
    });

    group('.distance', () {
      test('returns the fifths distance of this KeySignature', () {
        expect(KeySignature.fromDistance(-9).distance, -9);
        expect(KeySignature.fromDistance(-7).distance, -7);
        expect(KeySignature.fromDistance(-2).distance, -2);
        expect(KeySignature.empty.distance, 0);
        expect(const KeySignature([Note.b, Note.e]).distance, 0);
        expect(KeySignature.fromDistance(1).distance, 1);
        expect(KeySignature.fromDistance(5).distance, 5);
        expect(KeySignature.fromDistance(10).distance, 10);

        expect(KeySignature([Note.b, Note.f.sharp, Note.c.sharp]).distance, 2);
        expect(
          KeySignature([Note.f, Note.c, Note.g, Note.b.flat]).distance,
          -1,
        );
      });

      test('returns null when this KeySignature is not canonical', () {
        expect(KeySignature([Note.b.flat, Note.a.flat]).distance, isNull);
        expect(KeySignature([Note.g.sharp]).distance, isNull);
      });
    });

    group('.isCanonical', () {
      test('returns whether this KeySignature is canonical', () {
        expect(KeySignature.fromDistance(-3).isCanonical, isTrue);
        expect(KeySignature.empty.isCanonical, isTrue);
        expect(
          KeySignature([Note.b, Note.f.sharp, Note.c.sharp]).isCanonical,
          isTrue,
        );

        expect(KeySignature([Note.g.sharp]).isCanonical, isFalse);
        expect(KeySignature([Note.a.flat.flat]).isCanonical, isFalse);
      });
    });

    group('.keys', () {
      test('returns the TonalMode to Keys Map for this KeySignature', () {
        expect(
          KeySignature.fromDistance(-10).keys,
          {
            TonalMode.major: Note.e.flat.flat.major,
            TonalMode.minor: Note.c.flat.minor,
          },
        );
        expect(
          KeySignature.fromDistance(-9).keys,
          {
            TonalMode.major: Note.b.flat.flat.major,
            TonalMode.minor: Note.g.flat.minor,
          },
        );
        expect(
          KeySignature.fromDistance(-8).keys,
          {
            TonalMode.major: Note.f.flat.major,
            TonalMode.minor: Note.d.flat.minor,
          },
        );
        expect(
          KeySignature.fromDistance(-7).keys,
          {
            TonalMode.major: Note.c.flat.major,
            TonalMode.minor: Note.a.flat.minor,
          },
        );
        expect(
          KeySignature.fromDistance(-6).keys,
          {
            TonalMode.major: Note.g.flat.major,
            TonalMode.minor: Note.e.flat.minor,
          },
        );
        expect(
          KeySignature.fromDistance(-5).keys,
          {
            TonalMode.major: Note.d.flat.major,
            TonalMode.minor: Note.b.flat.minor,
          },
        );
        expect(
          KeySignature.fromDistance(-4).keys,
          {TonalMode.major: Note.a.flat.major, TonalMode.minor: Note.f.minor},
        );
        expect(
          KeySignature.fromDistance(-3).keys,
          {TonalMode.major: Note.e.flat.major, TonalMode.minor: Note.c.minor},
        );
        expect(
          KeySignature.fromDistance(-2).keys,
          {TonalMode.major: Note.b.flat.major, TonalMode.minor: Note.g.minor},
        );
        expect(
          KeySignature.fromDistance(-1).keys,
          {TonalMode.major: Note.f.major, TonalMode.minor: Note.d.minor},
        );
        expect(
          KeySignature.empty.keys,
          {TonalMode.major: Note.c.major, TonalMode.minor: Note.a.minor},
        );
        expect(
          KeySignature.fromDistance(1).keys,
          {TonalMode.major: Note.g.major, TonalMode.minor: Note.e.minor},
        );
        expect(
          KeySignature.fromDistance(2).keys,
          {TonalMode.major: Note.d.major, TonalMode.minor: Note.b.minor},
        );
        expect(
          KeySignature.fromDistance(3).keys,
          {TonalMode.major: Note.a.major, TonalMode.minor: Note.f.sharp.minor},
        );
        expect(
          KeySignature.fromDistance(4).keys,
          {TonalMode.major: Note.e.major, TonalMode.minor: Note.c.sharp.minor},
        );
        expect(
          KeySignature.fromDistance(5).keys,
          {TonalMode.major: Note.b.major, TonalMode.minor: Note.g.sharp.minor},
        );
        expect(
          KeySignature.fromDistance(6).keys,
          {
            TonalMode.major: Note.f.sharp.major,
            TonalMode.minor: Note.d.sharp.minor,
          },
        );
        expect(
          KeySignature.fromDistance(7).keys,
          {
            TonalMode.major: Note.c.sharp.major,
            TonalMode.minor: Note.a.sharp.minor,
          },
        );
        expect(
          KeySignature.fromDistance(8).keys,
          {
            TonalMode.major: Note.g.sharp.major,
            TonalMode.minor: Note.e.sharp.minor,
          },
        );
        expect(
          KeySignature.fromDistance(9).keys,
          {
            TonalMode.major: Note.d.sharp.major,
            TonalMode.minor: Note.b.sharp.minor,
          },
        );
        expect(
          KeySignature.fromDistance(10).keys,
          {
            TonalMode.major: Note.a.sharp.major,
            TonalMode.minor: Note.f.sharp.sharp.minor,
          },
        );
      });

      test('returns an empty Map when this KeySignature is not canonical', () {
        expect(KeySignature([Note.d.flat]).keys, <TonalMode, Key>{});
        expect(KeySignature([Note.c.sharp.sharp]).keys, <TonalMode, Key>{});
      });
    });

    group('.toString()', () {
      test('returns the string representation of this KeySignature', () {
        expect(
          KeySignature.fromDistance(-10).toString(),
          '-10 (B♭ E♭ A♭ D♭ G♭ C♭ F♭ B𝄫 E𝄫 A𝄫)',
        );
        expect(
          KeySignature.fromDistance(-8).toString(),
          '-8 (B♭ E♭ A♭ D♭ G♭ C♭ F♭ B𝄫)',
        );
        expect(
          KeySignature.fromDistance(-7).toString(),
          '-7 (B♭ E♭ A♭ D♭ G♭ C♭ F♭)',
        );
        expect(
          KeySignature.fromDistance(-6).toString(),
          '-6 (B♭ E♭ A♭ D♭ G♭ C♭)',
        );
        expect(
          KeySignature.fromDistance(-5).toString(),
          '-5 (B♭ E♭ A♭ D♭ G♭)',
        );
        expect(KeySignature.fromDistance(-4).toString(), '-4 (B♭ E♭ A♭ D♭)');
        expect(KeySignature.fromDistance(-3).toString(), '-3 (B♭ E♭ A♭)');
        expect(KeySignature.fromDistance(-2).toString(), '-2 (B♭ E♭)');
        expect(KeySignature.fromDistance(-1).toString(), '-1 (B♭)');
        expect(KeySignature.empty.toString(), '0 ()');
        expect(KeySignature.fromDistance(1).toString(), '1 (F♯)');
        expect(KeySignature.fromDistance(2).toString(), '2 (F♯ C♯)');
        expect(KeySignature.fromDistance(3).toString(), '3 (F♯ C♯ G♯)');
        expect(KeySignature.fromDistance(4).toString(), '4 (F♯ C♯ G♯ D♯)');
        expect(KeySignature.fromDistance(5).toString(), '5 (F♯ C♯ G♯ D♯ A♯)');
        expect(
          KeySignature.fromDistance(6).toString(),
          '6 (F♯ C♯ G♯ D♯ A♯ E♯)',
        );
        expect(
          KeySignature.fromDistance(7).toString(),
          '7 (F♯ C♯ G♯ D♯ A♯ E♯ B♯)',
        );
        expect(
          KeySignature.fromDistance(8).toString(),
          '8 (F♯ C♯ G♯ D♯ A♯ E♯ B♯ F𝄪)',
        );
        expect(
          KeySignature.fromDistance(10).toString(),
          '10 (F♯ C♯ G♯ D♯ A♯ E♯ B♯ F𝄪 C𝄪 G𝄪)',
        );

        expect(const KeySignature([Note.b]).toString(), '0 (B♮)');
        expect(const KeySignature([Note.f, Note.c]).toString(), '0 (F♮ C♮)');
        expect(
          KeySignature([Note.f, Note.c, Note.g, Note.b.flat, Note.e.flat])
              .toString(),
          '-2 (F♮ C♮ G♮ B♭ E♭)',
        );
      });
    });

    group('operator |()', () {
      test('keeps the same KeySignature when this is empty', () {
        expect(KeySignature.empty | KeySignature.empty, KeySignature.empty);
        expect(
          KeySignature.empty | KeySignature([Note.b.flat]),
          KeySignature([Note.b.flat]),
        );

        expect(
          const KeySignature([Note.b]) | const KeySignature([Note.e]),
          const KeySignature([Note.e]),
        );
      });

      test(
        'keeps the other KeySignature when it has more Accidentals of '
        'the same kind',
        () {
          expect(
            KeySignature([Note.b.flat]) |
                KeySignature([Note.b.flat, Note.e.flat, Note.a.flat]),
            KeySignature([Note.b.flat, Note.e.flat, Note.a.flat]),
          );
          expect(
            KeySignature([Note.f.sharp]) |
                KeySignature([Note.f.sharp, Note.c.sharp, Note.g.sharp]),
            KeySignature([Note.f.sharp, Note.c.sharp, Note.g.sharp]),
          );
        },
      );

      test('ignores any previously cancelled Accidentals', () {
        expect(
          KeySignature([Note.b, Note.e, Note.f.sharp, Note.c.sharp]) |
              KeySignature([Note.f.sharp, Note.c.sharp, Note.g.sharp]),
          KeySignature([Note.f.sharp, Note.c.sharp, Note.g.sharp]),
        );
        expect(
          KeySignature([Note.b, Note.e, Note.f.sharp, Note.c.sharp]) |
              KeySignature([Note.b.flat, Note.e.flat, Note.a.flat]),
          KeySignature([Note.f, Note.c, Note.b.flat, Note.e.flat, Note.a.flat]),
        );
      });

      test('cancels Accidentals when needed', () {
        expect(
          KeySignature([Note.f.sharp, Note.c.sharp]) | KeySignature.empty,
          const KeySignature([Note.f, Note.c]),
        );

        expect(
          KeySignature([Note.b.flat]) |
              KeySignature([Note.f.sharp, Note.c.sharp]),
          KeySignature([Note.b, Note.f.sharp, Note.c.sharp]),
        );
        expect(
          KeySignature([Note.f.sharp, Note.c.sharp]) |
              KeySignature([Note.b.flat, Note.e.flat]),
          KeySignature([Note.f, Note.c, Note.b.flat, Note.e.flat]),
        );
        expect(
          KeySignature([Note.f.sharp, Note.c.sharp]) |
              KeySignature([Note.f.sharp]),
          KeySignature([Note.c, Note.f.sharp]),
        );
        expect(
          KeySignature([Note.b.flat, Note.e.flat, Note.a.flat]) |
              KeySignature([Note.b.flat]),
          KeySignature([Note.e, Note.a, Note.b.flat]),
        );

        expect(
          KeySignature.fromDistance(-8) | KeySignature.fromDistance(1),
          KeySignature([
            Note.b,
            Note.e,
            Note.a,
            Note.d,
            Note.g,
            Note.c,
            Note.f,
            Note.f.sharp,
          ]),
        );
      });

      test('shows each cancelled Accidental once in edge KeySignatures', () {
        expect(
          KeySignature.fromDistance(10) | KeySignature.fromDistance(-3),
          KeySignature([
            Note.f,
            Note.c,
            Note.g,
            Note.d,
            Note.a,
            Note.e,
            Note.b,
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
          ]),
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal KeySignature instances in a Set', () {
        final collection = {
          KeySignature.empty,
          KeySignature([Note.f.sharp]),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          KeySignature.empty,
          KeySignature([Note.f.sharp]),
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts KeySignatures in a collection', () {
        final orderedSet = SplayTreeSet<KeySignature>.of({
          KeySignature.fromDistance(-3),
          KeySignature.empty,
          KeySignature.fromDistance(-6),
          KeySignature.fromDistance(4),
          KeySignature.fromDistance(3),
        });
        expect(orderedSet.toList(), [
          KeySignature.fromDistance(-6),
          KeySignature.fromDistance(-3),
          KeySignature.empty,
          KeySignature.fromDistance(3),
          KeySignature.fromDistance(4),
        ]);
      });
    });
  });
}
