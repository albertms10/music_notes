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

        const temperature = Celsius(18);
        expect(
          frequency
              .closestPitch(temperature: temperature)
              .frequency(temperature: temperature),
          frequency,
        );
      });
    });

    group('.respelledSimple', () {
      test('respells this ClosestPitch to the simplest expression', () {
        expect(ClosestPitch.parse('A4+36').respelledSimple.toString(), 'A4+36');
        expect(
          ClosestPitch.parse('C#2+16').respelledSimple.toString(),
          'D♭2+16',
        );
        expect(
          ClosestPitch.parse('Bb3+68').respelledSimple.toString(),
          'B3-32',
        );
        expect(
          ClosestPitch.parse('F#5-152').respelledSimple.toString(),
          'E5+48',
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this ClosestPitch', () {
        expect(ClosestPitch(Note.a.inOctave(-3)).toString(), 'A-3');
        expect(
          ClosestPitch(Note.f.sharp.inOctave(6), cents: const Cent(0.4))
              .toString(),
          'F♯6',
        );
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

    group('operator +()', () {
      test('adds Cents to this ClosestPitch', () {
        expect(
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(12)) +
              const Cent(16),
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(28)),
        );
        expect(
          ClosestPitch(Note.b.flat.inOctave(3), cents: const Cent(12)) +
              const Cent(-16),
          ClosestPitch(Note.b.flat.inOctave(3), cents: const Cent(-4)),
        );
        expect(
          ClosestPitch(Note.g.sharp.inOctave(2), cents: const Cent(-40)) +
              const Cent(-24),
          ClosestPitch(Note.g.sharp.inOctave(2), cents: const Cent(-64)),
        );
      });
    });

    group('operator -()', () {
      test('subtracts Cents from this ClosestPitch', () {
        expect(
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(12)) -
              const Cent(16),
          ClosestPitch(Note.a.inOctave(4), cents: const Cent(-4)),
        );
        expect(
          ClosestPitch(Note.b.flat.inOctave(3), cents: const Cent(12)) -
              const Cent(-16),
          ClosestPitch(Note.b.flat.inOctave(3), cents: const Cent(28)),
        );
        expect(
          ClosestPitch(Note.g.sharp.inOctave(2), cents: const Cent(-40)) -
              const Cent(24),
          ClosestPitch(Note.g.sharp.inOctave(2), cents: const Cent(-64)),
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
