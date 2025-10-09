import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Frequency', () {
    group('FrequencySINotation', () {
      group('.parse()', () {
        test('throws a FormatException when source is invalid', () {
          expect(() => Frequency.parse('A4'), throwsFormatException);
          expect(() => Frequency.parse('-0 Hz'), throwsFormatException);
          expect(() => Frequency.parse('-1'), throwsFormatException);
          expect(() => Frequency.parse('-440 Hz'), throwsFormatException);
          expect(() => Frequency.parse('440 kHz'), throwsFormatException);
          expect(() => Frequency.parse('z'), throwsFormatException);
        });

        test('parses source as a Frequency', () {
          expect(Frequency.parse('440'), const Frequency(440));
          expect(Frequency.parse('440 Hz'), const Frequency(440));
          expect(Frequency.parse('415.3 Hz'), const Frequency(415.3));
          expect(Frequency.parse('15.356 Hz'), const Frequency(15.356));
          expect(Frequency.parse('256 Hz'), const Frequency(256));
          expect(Frequency.parse('32 Hz'), const Frequency(32));
          expect(Frequency.parse('0 Hz'), const Frequency(0));
        });
      });
    });

    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(() => Frequency(-0.1), throwsA(isA<AssertionError>()));
      });
    });

    group('.isHumanAudible', () {
      test('returns whether the frequency is audible by humans', () {
        expect(const Frequency(0).isHumanAudible, isFalse);
        expect(const Frequency(100).isHumanAudible, isTrue);
        expect(const Frequency(400).isHumanAudible, isTrue);
        expect(const Frequency(15000).isHumanAudible, isTrue);
        expect(const Frequency(100000).isHumanAudible, isFalse);
      });
    });

    group('.closestPitch()', () {
      test('returns the closest Pitch to this Frequency', () {
        expect(
          const Frequency(440).closestPitch(),
          Note.a.inOctave(4) + const Cent(0),
        );
        expect(
          const Frequency(455).closestPitch(),
          Note.a.sharp.inOctave(4) - const Cent(41.96437412632116),
        );
        expect(
          const Frequency(467).closestPitch(),
          Note.b.flat.inOctave(4) + const Cent(3.1028314220028586),
        );
        expect(
          const Frequency(256).closestPitch(),
          Note.c.inOctave(4) - const Cent(37.63165622959142),
        );

        expect(
          const Frequency(440).closestPitch(
            tuningSystem: const EqualTemperament.edo12(fork: TuningFork.a415),
          ),
          Note.b.flat.inOctave(4) + const Cent(1.270624748447127),
        );
        expect(
          const Frequency(512).closestPitch(
            tuningSystem: EqualTemperament.edo12(
              fork: Note.c.inOctave(5).at(const Frequency(512)),
            ),
          ),
          Note.c.inOctave(5) + const Cent(0),
        );
        expect(
          const Frequency(440).closestPitch(
            tuningSystem: EqualTemperament.edo12(
              fork: Note.c.inOctave(5).at(const Frequency(512)),
            ),
          ),
          Note.a.inOctave(4) + const Cent(37.63165622959145),
        );

        expect(
          const Frequency(440).closestPitch(temperature: const Celsius(24)),
          Note.a.inOctave(4) - const Cent(12.060895566170192),
        );
        expect(
          const Frequency(440).closestPitch(temperature: const Celsius(18)),
          Note.a.inOctave(4) + const Cent(6.062103827228064),
        );
        expect(
          const Frequency(256).closestPitch(temperature: const Celsius(18)),
          Note.c.inOctave(4) - const Cent(31.569552402363644),
        );
      });

      test('returns the same Frequency after Pitch.frequency()', () {
        final pitch = Note.a.inOctave(5);
        var closestPitch = pitch.frequency().closestPitch();
        expect(closestPitch, pitch + const Cent(0));

        const temperature = Celsius(18);
        closestPitch = pitch
            .frequency(temperature: temperature)
            .closestPitch(temperature: temperature);
        expect(closestPitch, pitch + const Cent(0));
      });
    });

    group('.harmonic()', () {
      test('returns the harmonic at index from this Frequency', () {
        expect(const Frequency(880).harmonic(-3), const Frequency(220));
        expect(const Frequency(440).harmonic(-1), const Frequency(220));
        expect(const Frequency(110).harmonic(0), const Frequency(110));
        expect(const Frequency(256).harmonic(1), const Frequency(512));
        expect(const Frequency(32).harmonic(4), const Frequency(160));
      });
    });

    group('.harmonics()', () {
      test('returns a Set of the harmonic series from this Frequency', () {
        expect(
          const Frequency(512).harmonics(undertone: true).take(16).toSet(),
          {
            const Frequency(512),
            const Frequency(256),
            const Frequency(170.66666666666666),
            const Frequency(128),
            const Frequency(102.4),
            const Frequency(85.33333333333333),
            const Frequency(73.14285714285714),
            const Frequency(64),
            const Frequency(56.888888888888886),
            const Frequency(51.2),
            const Frequency(46.54545454545455),
            const Frequency(42.666666666666664),
            const Frequency(39.38461538461539),
            const Frequency(36.57142857142857),
            const Frequency(34.13333333333333),
            const Frequency(32),
          },
        );
        expect(const Frequency(400).harmonics(undertone: true).take(2), const {
          Frequency(400),
          Frequency(200),
        });
        expect(const Frequency(220).harmonics().take(1), const {
          Frequency(220),
        });
        expect(const Frequency(110).harmonics().take(2), const {
          Frequency(110),
          Frequency(220),
        });
        expect(const Frequency(32).harmonics().take(16), const {
          Frequency(32),
          Frequency(64),
          Frequency(96),
          Frequency(128),
          Frequency(160),
          Frequency(192),
          Frequency(224),
          Frequency(256),
          Frequency(288),
          Frequency(320),
          Frequency(352),
          Frequency(384),
          Frequency(416),
          Frequency(448),
          Frequency(480),
          Frequency(512),
        });
      });
    });

    group('.format()', () {
      test('returns this Frequency formatted as a string', () {
        expect(const Frequency(440).format(), '440 Hz');
        expect(const Frequency(415.62).format(), '415.62 Hz');
        expect(const Frequency(2200.296).format(), '2200.296 Hz');
      });
    });
  });
}
