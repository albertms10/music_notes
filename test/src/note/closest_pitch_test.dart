import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ClosestPitch', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => ClosestPitch.parse('invalid'), throwsFormatException);
        expect(() => ClosestPitch.parse('A4+'), throwsFormatException);
        expect(() => ClosestPitch.parse('G3?'), throwsFormatException);
        expect(() => ClosestPitch.parse('B5-?'), throwsFormatException);
      });

      test('parses source as a ClosestPitch and return its value', () {
        expect(ClosestPitch.parse('A4'), ClosestPitch(Note.a.inOctave(4)));
        expect(ClosestPitch.parse('C0+0'), ClosestPitch(Note.c.inOctave(0)));
        expect(ClosestPitch.parse('G-0-0.0'), ClosestPitch(Note.g.inOctave(0)));
        expect(
          ClosestPitch.parse('Db-2'),
          ClosestPitch(Note.d.flat.inOctave(-2)),
        );
        expect(
          ClosestPitch.parse('G3+6'),
          ClosestPitch(Note.g.inOctave(3), cents: const Cent(6)),
        );
        expect(
          ClosestPitch.parse('E♭5-14.6'),
          ClosestPitch(Note.e.flat.inOctave(5), cents: const Cent(-14.6)),
        );
        expect(
          ClosestPitch.parse('F#-1+45.3'),
          ClosestPitch(Note.f.sharp.inOctave(-1), cents: const Cent(45.3)),
        );
        expect(
          ClosestPitch.parse('Abb-3-5.97'),
          ClosestPitch(Note.a.flat.flat.inOctave(-3), cents: const Cent(-5.97)),
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

    group('.frequency()', () {
      test('returns the Frequency of this ClosestPitch', () {
        expect(
          (Note.a.inOctave(4) + const Cent(12)).frequency(),
          const Frequency(443.06044202495633),
        );
        expect(
          (Note.a.inOctave(4) - const Cent(12)).frequency(),
          const Frequency(436.9606979922958),
        );
      });

      test('returns the same Frequency after Frequency.closestPitch()', () {
        const frequency = Frequency(415);
        expect(frequency.closestPitch().frequency(), frequency);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this ClosestPitch', () {
        expect(
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(3.456)).toString(),
          'A4+3',
        );
        expect(
          ClosestPitch(Note.d.flat.inOctave(3), cents: const Cent(-28.6))
              .toString(),
          'D♭3-29',
        );
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal ClosestPitches', () {
        expect(
          ClosestPitch(Note.a.inOctave(4)).hashCode,
          ClosestPitch(Note.a.inOctave(4)).hashCode,
        );
        expect(
          ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-2.123))
              .hashCode,
          ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-2.123))
              .hashCode,
        );
      });

      test('returns different hashCodes for different ClosestPitches', () {
        expect(
          ClosestPitch(Note.a.inOctave(4)).hashCode,
          isNot(ClosestPitch(Note.g.inOctave(4)).hashCode),
        );
        expect(
          ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-2.123))
              .hashCode,
          isNot(
            ClosestPitch(Note.c.sharp.inOctave(3), cents: const Cent(-0.345))
                .hashCode,
          ),
        );
      });

      test('ignores equal ClosestPitch instances in a Set', () {
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
