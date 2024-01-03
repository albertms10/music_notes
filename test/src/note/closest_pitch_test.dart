import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ClosestPitch', () {
    group('.toString()', () {
      test('should return the string representation of this ClosestPitch', () {
        expect(
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(3.456)).toString(),
          'A4+3',
        );
        expect(
          ClosestPitch(Note.d.flat.inOctave(3), cents: const Cent(-28.6))
              .toString(),
          'D♭3-29',
        );
        expect(
          Note.c
              .inOctave(1)
              .frequency()
              .harmonics(upToIndex: 15)
              .closestPitches
              .toString(),
          '{C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4, '
          'D4+4, E4-14, F♯4-49, G4+2, A♭4+41, A♯4-31, B4-12, C5}',
        );
      });
    });

    group('.hashCode', () {
      test('should return the same hashCode for equal ClosestPitches', () {
        expect(
          ClosestPitch(Note.a.inOctave(4)),
          ClosestPitch(Note.a.inOctave(4)),
        );
        expect(
          ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-2.123)),
          ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-2.123)),
        );
      });

      test(
        'should return different hashCodes for different ClosestPitches',
        () {
          expect(
            ClosestPitch(Note.a.inOctave(4)),
            isNot(equals(ClosestPitch(Note.g.inOctave(4)))),
          );
          expect(
            ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-2.123)),
            isNot(
              equals(
                ClosestPitch(
                  Note.c.sharp.inOctave(3),
                  cents: const Cent(-0.345),
                ),
              ),
            ),
          );
        },
      );

      test('should ignore equal ClosestPitch instances in a Set', () {
        final collection = {
          ClosestPitch(Note.a.inOctave(4)),
          ClosestPitch(Note.b.flat.inOctave(3)),
          ClosestPitch(Note.c.inOctave(3), cents: const Cent(2)),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          ClosestPitch(Note.a.inOctave(4)),
          ClosestPitch(Note.b.flat.inOctave(3)),
          ClosestPitch(Note.c.inOctave(3), cents: const Cent(2)),
        ]);
      });
    });
  });
}
