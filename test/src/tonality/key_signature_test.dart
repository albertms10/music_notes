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
      });
    });

    group('.clean', () {
      test(
        'should return a new KeySignature without cancellation naturals',
        () {
          expect(
            const KeySignature([Note.f, Note.c, Note.g]).clean,
            KeySignature.empty,
          );
          expect(
            KeySignature([Note.f, Note.b.flat]).clean,
            KeySignature([Note.b.flat]),
          );
          expect(
            (KeySignature.fromDistance(-2) + KeySignature.fromDistance(3))
                .clean,
            KeySignature([Note.f.sharp, Note.c.sharp, Note.g.sharp]),
          );
        },
      );
    });

    group('.distance', () {
      test('should return the fifths distance of this KeySignature', () {
        expect(KeySignature.fromDistance(-7).distance, -7);
        expect(KeySignature.fromDistance(-2).distance, -2);
        expect(KeySignature.empty.distance, 0);
        expect(KeySignature.fromDistance(1).distance, 1);
        expect(KeySignature.fromDistance(5).distance, 5);

        expect(KeySignature([Note.b, Note.f.sharp, Note.c.sharp]).distance, 2);
        expect(
          KeySignature([Note.f, Note.c, Note.g, Note.b.flat]).distance,
          -1,
        );
      });
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
        expect(KeySignature.empty.tonality(TonalMode.major), Note.c.major);
        expect(KeySignature.empty.tonality(TonalMode.minor), Note.a.minor);
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
        expect(
          KeySignature.fromDistance(-10).tonalities,
          (major: Note.e.flat.flat.major, minor: Note.c.flat.minor),
        );
        expect(
          KeySignature.fromDistance(-9).tonalities,
          (major: Note.b.flat.flat.major, minor: Note.g.flat.minor),
        );
        expect(
          KeySignature.fromDistance(-8).tonalities,
          (major: Note.f.flat.major, minor: Note.d.flat.minor),
        );
        expect(
          KeySignature.fromDistance(-7).tonalities,
          (major: Note.c.flat.major, minor: Note.a.flat.minor),
        );
        expect(
          KeySignature.fromDistance(-6).tonalities,
          (major: Note.g.flat.major, minor: Note.e.flat.minor),
        );
        expect(
          KeySignature.fromDistance(-5).tonalities,
          (major: Note.d.flat.major, minor: Note.b.flat.minor),
        );
        expect(
          KeySignature.fromDistance(-4).tonalities,
          (major: Note.a.flat.major, minor: Note.f.minor),
        );
        expect(
          KeySignature.fromDistance(-3).tonalities,
          (major: Note.e.flat.major, minor: Note.c.minor),
        );
        expect(
          KeySignature.fromDistance(-2).tonalities,
          (major: Note.b.flat.major, minor: Note.g.minor),
        );
        expect(
          KeySignature.fromDistance(-1).tonalities,
          (major: Note.f.major, minor: Note.d.minor),
        );
        expect(
          KeySignature.empty.tonalities,
          (major: Note.c.major, minor: Note.a.minor),
        );
        expect(
          KeySignature.fromDistance(1).tonalities,
          (major: Note.g.major, minor: Note.e.minor),
        );
        expect(
          KeySignature.fromDistance(2).tonalities,
          (major: Note.d.major, minor: Note.b.minor),
        );
        expect(
          KeySignature.fromDistance(3).tonalities,
          (major: Note.a.major, minor: Note.f.sharp.minor),
        );
        expect(
          KeySignature.fromDistance(4).tonalities,
          (major: Note.e.major, minor: Note.c.sharp.minor),
        );
        expect(
          KeySignature.fromDistance(5).tonalities,
          (major: Note.b.major, minor: Note.g.sharp.minor),
        );
        expect(
          KeySignature.fromDistance(6).tonalities,
          (major: Note.f.sharp.major, minor: Note.d.sharp.minor),
        );
        expect(
          KeySignature.fromDistance(7).tonalities,
          (major: Note.c.sharp.major, minor: Note.a.sharp.minor),
        );
        expect(
          KeySignature.fromDistance(8).tonalities,
          (major: Note.g.sharp.major, minor: Note.e.sharp.minor),
        );
        expect(
          KeySignature.fromDistance(9).tonalities,
          (major: Note.d.sharp.major, minor: Note.b.sharp.minor),
        );
        expect(
          KeySignature.fromDistance(10).tonalities,
          (major: Note.a.sharp.major, minor: Note.f.sharp.sharp.minor),
        );
      });
    });

    group('.toString()', () {
      test(
        'should return the string representation of this KeySignature',
        () {
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
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal KeySignature instances in a Set', () {
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
      test('should correctly sort KeySignature items in a collection', () {
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
