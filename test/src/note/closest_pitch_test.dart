import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ClosestPitch', () {
    group('.parse()', () {
      test('should throw a FormatException when source is invalid', () {
        expect(() => ClosestPitch.parse('invalid'), throwsFormatException);
        expect(() => ClosestPitch.parse('A4+'), throwsFormatException);
        expect(() => ClosestPitch.parse('G3?'), throwsFormatException);
        expect(() => ClosestPitch.parse('B5-?'), throwsFormatException);
      });

      test('should parse source as a ClosestPitch and return its value', () {
        expect(ClosestPitch.parse('A4'), ClosestPitch(Note.a.inOctave(4)));
        expect(
          ClosestPitch.parse('G3+6'),
          ClosestPitch(Note.g.inOctave(3), cents: const Cent(6)),
        );
        expect(
          ClosestPitch.parse('Eb5-14.6'),
          ClosestPitch(Note.e.flat.inOctave(5), cents: const Cent(-14.6)),
        );
        expect(
          ClosestPitch.parse('Cx2+36.23912'),
          ClosestPitch(
            Note.c.sharp.sharp.inOctave(2),
            cents: const Cent(36.23912),
          ),
        );
      });
    });

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
