import 'dart:collection'
    show SplayTreeSet, UnmodifiableListView, UnmodifiableMapView;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('KeySignature', () {
    group('.notes', () {
      test('returns an unmodifiable collection', () {
        expect(
          KeySignature([.f.sharp]).notes,
          isA<UnmodifiableListView<Note>>(),
        );
      });
    });

    group('.fromDistance()', () {
      test('creates a new KeySignature from the given distance', () {
        expect(
          KeySignature.fromDistance(-9),
          KeySignature([
            .b.flat,
            .e.flat,
            .a.flat,
            .d.flat,
            .g.flat,
            .c.flat,
            .f.flat,
            .b.flat.flat,
            .e.flat.flat,
          ]),
        );
        expect(
          KeySignature.fromDistance(-6),
          KeySignature(const <Note>[.b, .e, .a, .d, .g, .c].flat),
        );
        expect(KeySignature.fromDistance(-1), KeySignature([.b.flat]));
        expect(KeySignature.fromDistance(0), KeySignature.empty);
        expect(KeySignature.fromDistance(1), KeySignature([.f.sharp]));
        expect(
          KeySignature.fromDistance(6),
          KeySignature(const <Note>[.f, .c, .g, .d, .a, .e].sharp),
        );
        expect(
          KeySignature.fromDistance(10),
          KeySignature([
            .f.sharp,
            .c.sharp,
            .g.sharp,
            .d.sharp,
            .a.sharp,
            .e.sharp,
            .b.sharp,
            .f.sharp.sharp,
            .c.sharp.sharp,
            .g.sharp.sharp,
          ]),
        );
      });
    });

    group('.clean', () {
      test('returns a new KeySignature without cancellation naturals', () {
        expect(const KeySignature([.f, .c, .g]).clean, KeySignature.empty);
        expect(KeySignature([.f, .b.flat]).clean, KeySignature([.b.flat]));
        expect(
          KeySignature([.b, .e, .f.sharp, .c.sharp, .g.sharp]).clean,
          KeySignature([.f.sharp, .c.sharp, .g.sharp]),
        );
      });
    });

    group('.distance', () {
      test('returns the fifths distance of this KeySignature', () {
        expect(KeySignature.fromDistance(-9).distance, -9);
        expect(KeySignature.fromDistance(-7).distance, -7);
        expect(KeySignature.fromDistance(-2).distance, -2);
        expect(KeySignature.empty.distance, 0);
        expect(const KeySignature([.b, .e]).distance, 0);
        expect(KeySignature.fromDistance(1).distance, 1);
        expect(KeySignature.fromDistance(5).distance, 5);
        expect(KeySignature.fromDistance(10).distance, 10);

        expect(KeySignature([.b, .f.sharp, .c.sharp]).distance, 2);
        expect(KeySignature([.f, .c, .g, .b.flat]).distance, -1);
      });

      test('returns null when this KeySignature is not canonical', () {
        expect(KeySignature([.b.flat, .a.flat]).distance, isNull);
        expect(KeySignature([.g.sharp]).distance, isNull);
      });
    });

    group('.isCanonical', () {
      test('returns whether this KeySignature is canonical', () {
        expect(KeySignature.fromDistance(-3).isCanonical, isTrue);
        expect(KeySignature.empty.isCanonical, isTrue);
        expect(KeySignature([.b, .f.sharp, .c.sharp]).isCanonical, isTrue);

        expect(KeySignature([.g.sharp]).isCanonical, isFalse);
        expect(KeySignature([.a.flat.flat]).isCanonical, isFalse);
      });
    });

    group('.keys', () {
      test('returns an unmodifiable collection', () {
        expect(
          KeySignature([.f.sharp]).keys,
          isA<UnmodifiableMapView<TonalMode, Key>>(),
        );
      });

      test('returns the TonalMode to Keys Map for this KeySignature', () {
        expect(KeySignature.fromDistance(-10).keys, {
          TonalMode.major: Note.e.flat.flat.major,
          TonalMode.minor: Note.c.flat.minor,
        });
        expect(KeySignature.fromDistance(-9).keys, {
          TonalMode.major: Note.b.flat.flat.major,
          TonalMode.minor: Note.g.flat.minor,
        });
        expect(KeySignature.fromDistance(-8).keys, {
          TonalMode.major: Note.f.flat.major,
          TonalMode.minor: Note.d.flat.minor,
        });
        expect(KeySignature.fromDistance(-7).keys, {
          TonalMode.major: Note.c.flat.major,
          TonalMode.minor: Note.a.flat.minor,
        });
        expect(KeySignature.fromDistance(-6).keys, {
          TonalMode.major: Note.g.flat.major,
          TonalMode.minor: Note.e.flat.minor,
        });
        expect(KeySignature.fromDistance(-5).keys, {
          TonalMode.major: Note.d.flat.major,
          TonalMode.minor: Note.b.flat.minor,
        });
        expect(KeySignature.fromDistance(-4).keys, {
          TonalMode.major: Note.a.flat.major,
          TonalMode.minor: Note.f.minor,
        });
        expect(KeySignature.fromDistance(-3).keys, {
          TonalMode.major: Note.e.flat.major,
          TonalMode.minor: Note.c.minor,
        });
        expect(KeySignature.fromDistance(-2).keys, {
          TonalMode.major: Note.b.flat.major,
          TonalMode.minor: Note.g.minor,
        });
        expect(KeySignature.fromDistance(-1).keys, {
          TonalMode.major: Note.f.major,
          TonalMode.minor: Note.d.minor,
        });
        expect(KeySignature.empty.keys, {
          TonalMode.major: Note.c.major,
          TonalMode.minor: Note.a.minor,
        });
        expect(KeySignature.fromDistance(1).keys, {
          TonalMode.major: Note.g.major,
          TonalMode.minor: Note.e.minor,
        });
        expect(KeySignature.fromDistance(2).keys, {
          TonalMode.major: Note.d.major,
          TonalMode.minor: Note.b.minor,
        });
        expect(KeySignature.fromDistance(3).keys, {
          TonalMode.major: Note.a.major,
          TonalMode.minor: Note.f.sharp.minor,
        });
        expect(KeySignature.fromDistance(4).keys, {
          TonalMode.major: Note.e.major,
          TonalMode.minor: Note.c.sharp.minor,
        });
        expect(KeySignature.fromDistance(5).keys, {
          TonalMode.major: Note.b.major,
          TonalMode.minor: Note.g.sharp.minor,
        });
        expect(KeySignature.fromDistance(6).keys, {
          TonalMode.major: Note.f.sharp.major,
          TonalMode.minor: Note.d.sharp.minor,
        });
        expect(KeySignature.fromDistance(7).keys, {
          TonalMode.major: Note.c.sharp.major,
          TonalMode.minor: Note.a.sharp.minor,
        });
        expect(KeySignature.fromDistance(8).keys, {
          TonalMode.major: Note.g.sharp.major,
          TonalMode.minor: Note.e.sharp.minor,
        });
        expect(KeySignature.fromDistance(9).keys, {
          TonalMode.major: Note.d.sharp.major,
          TonalMode.minor: Note.b.sharp.minor,
        });
        expect(KeySignature.fromDistance(10).keys, {
          TonalMode.major: Note.a.sharp.major,
          TonalMode.minor: Note.f.sharp.sharp.minor,
        });
      });

      test('returns an empty Map when this KeySignature is not canonical', () {
        expect(KeySignature([.d.flat]).keys, const <TonalMode, Key>{});
        expect(KeySignature([.c.sharp.sharp]).keys, const <TonalMode, Key>{});
      });
    });

    group('.incrementBy()', () {
      test('returns a new KeySignature increasing the fifths distance', () {
        expect(KeySignature.empty.incrementBy(-1), KeySignature([.b.flat]));
        expect(KeySignature.empty.incrementBy(0), KeySignature.empty);
        expect(KeySignature.empty.incrementBy(1), KeySignature([.f.sharp]));

        expect(
          KeySignature([.f.sharp, .c.sharp]).incrementBy(3),
          KeySignature.fromDistance(5),
        );
        expect(
          KeySignature.fromDistance(-3).incrementBy(-1),
          KeySignature([.b.flat, .e.flat]),
        );
      });

      test('returns null when this KeySignature is not canonical', () {
        expect(KeySignature([.e.flat]).incrementBy(1), isNull);
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
        expect(KeySignature.fromDistance(-5).toString(), '-5 (B♭ E♭ A♭ D♭ G♭)');
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

        expect(const KeySignature([.b]).toString(), '0 (B♮)');
        expect(const KeySignature([.f, .c]).toString(), '0 (F♮ C♮)');
        expect(
          KeySignature([.f, .c, .g, .b.flat, .e.flat]).toString(),
          '-2 (F♮ C♮ G♮ B♭ E♭)',
        );
      });
    });

    group('operator |()', () {
      test('keeps the same KeySignature when this is empty', () {
        expect(KeySignature.empty | .empty, KeySignature.empty);
        expect(
          KeySignature.empty | KeySignature([.b.flat]),
          KeySignature([.b.flat]),
        );

        expect(
          const KeySignature([.b]) | const KeySignature([.e]),
          const KeySignature([.e]),
        );
      });

      test('keeps the other KeySignature when it has more Accidentals of '
          'the same kind', () {
        expect(
          KeySignature([.b.flat]) | KeySignature([.b.flat, .e.flat, .a.flat]),
          KeySignature([.b.flat, .e.flat, .a.flat]),
        );
        expect(
          KeySignature([.f.sharp]) |
              KeySignature([.f.sharp, .c.sharp, .g.sharp]),
          KeySignature([.f.sharp, .c.sharp, .g.sharp]),
        );
      });

      test('ignores any previously cancelled Accidentals', () {
        expect(
          KeySignature([.b, .e, .f.sharp, .c.sharp]) |
              KeySignature([.f.sharp, .c.sharp, .g.sharp]),
          KeySignature([.f.sharp, .c.sharp, .g.sharp]),
        );
        expect(
          KeySignature([.b, .e, .f.sharp, .c.sharp]) |
              KeySignature([.b.flat, .e.flat, .a.flat]),
          KeySignature([.f, .c, .b.flat, .e.flat, .a.flat]),
        );
      });

      test('cancels Accidentals when needed', () {
        expect(
          KeySignature([.f.sharp, .c.sharp]) | .empty,
          const KeySignature([.f, .c]),
        );

        expect(
          KeySignature([.b.flat]) | KeySignature([.f.sharp, .c.sharp]),
          KeySignature([.b, .f.sharp, .c.sharp]),
        );
        expect(
          KeySignature([.f.sharp, .c.sharp]) | KeySignature([.b.flat, .e.flat]),
          KeySignature([.f, .c, .b.flat, .e.flat]),
        );
        expect(
          KeySignature([.f.sharp, .c.sharp]) | KeySignature([.f.sharp]),
          KeySignature([.c, .f.sharp]),
        );
        expect(
          KeySignature([.b.flat, .e.flat, .a.flat]) | KeySignature([.b.flat]),
          KeySignature([.e, .a, .b.flat]),
        );

        expect(
          KeySignature.fromDistance(-8) | .fromDistance(1),
          KeySignature([.b, .e, .a, .d, .g, .c, .f, .f.sharp]),
        );
      });

      test('shows each cancelled Accidental once in edge KeySignatures', () {
        expect(
          KeySignature.fromDistance(10) | .fromDistance(-3),
          KeySignature([.f, .c, .g, .d, .a, .e, .b, .b.flat, .e.flat, .a.flat]),
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal KeySignature instances in a Set', () {
        final collection = <KeySignature>{
          .empty,
          KeySignature([.f.sharp]),
        };
        collection.addAll(collection);
        expect(collection.toList(), <KeySignature>[
          .empty,
          KeySignature([.f.sharp]),
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts KeySignatures in a collection', () {
        final orderedSet = SplayTreeSet<KeySignature>.of({
          .fromDistance(-3),
          .empty,
          .fromDistance(-6),
          .fromDistance(4),
          .fromDistance(3),
        });
        expect(orderedSet.toList(), <KeySignature>[
          .fromDistance(-6),
          .fromDistance(-3),
          .empty,
          .fromDistance(3),
          .fromDistance(4),
        ]);
      });
    });
  });
}
