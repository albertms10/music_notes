import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Frequency', () {
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
          const Frequency(440)
              .closestPitch(referenceFrequency: const Frequency(415)),
          Note.b.flat.inOctave(4) + const Cent(1.270624748447127),
        );
        expect(
          const Frequency(512).closestPitch(
            referenceFrequency: const Frequency(512),
            tuningSystem:
                EqualTemperament.edo12(referencePitch: Note.c.inOctave(5)),
          ),
          Note.c.inOctave(5) + const Cent(0),
        );
        expect(
          const Frequency(440).closestPitch(
            referenceFrequency: const Frequency(512),
            tuningSystem:
                EqualTemperament.edo12(referencePitch: Note.c.inOctave(5)),
          ),
          Note.a.inOctave(4) + const Cent(37.63165622959145),
        );
      });

      test('returns the same Frequency after Pitch.frequency()', () {
        final pitch = Note.a.inOctave(5);
        final closestPitch = pitch.frequency().closestPitch();
        expect(closestPitch.pitch, pitch);
        expect(closestPitch.cents, const Cent(0));
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
      test(
        'returns a Set of the harmonic series up to index from this Frequency',
        () {
          expect(
            const Frequency(512).harmonics(upToIndex: -15),
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
          expect(
            const Frequency(400).harmonics(upToIndex: -1),
            {const Frequency(400), const Frequency(200)},
          );
          expect(
            const Frequency(220).harmonics(upToIndex: 0),
            {const Frequency(220)},
          );
          expect(
            const Frequency(110).harmonics(upToIndex: 1),
            {const Frequency(110), const Frequency(220)},
          );
          expect(
            const Frequency(32).harmonics(upToIndex: 15),
            {
              const Frequency(32),
              const Frequency(64),
              const Frequency(96),
              const Frequency(128),
              const Frequency(160),
              const Frequency(192),
              const Frequency(224),
              const Frequency(256),
              const Frequency(288),
              const Frequency(320),
              const Frequency(352),
              const Frequency(384),
              const Frequency(416),
              const Frequency(448),
              const Frequency(480),
              const Frequency(512),
            },
          );
        },
      );
    });

    group('operator +()', () {
      test('adds other to this Frequency', () {
        expect(
          const Frequency(0) + const Frequency(1200),
          const Frequency(1200),
        );
        expect(
          const Frequency(277.18) + const Frequency(415.3),
          const Frequency(692.48),
        );
        expect(
          const Frequency(440) + const Frequency(220),
          const Frequency(660),
        );
      });
    });

    group('operator -()', () {
      test('subtracts other from this Frequency', () {
        expect(
          const Frequency(20000.12) - const Frequency(0),
          const Frequency(20000.12),
        );
        expect(
          const Frequency(415.3) - const Frequency(277.18),
          const Frequency(138.12),
        );
        expect(
          const Frequency(440) - const Frequency(220),
          const Frequency(220),
        );
      });
    });

    group('operator *()', () {
      test('multiplies this Frequency by factor', () {
        expect(const Frequency(467) * 0, const Frequency(0));
        expect(const Frequency(2200.2) * 1, const Frequency(2200.2));
        expect(const Frequency(415.3) * 2, const Frequency(830.6));
        expect(const Frequency(440) * 0.5, const Frequency(220));
      });
    });

    group('operator /()', () {
      test('divides this Frequency by factor', () {
        expect(const Frequency(467) / 1, const Frequency(467));
        expect(const Frequency(415.3) / 2, const Frequency(207.65));
        expect(const Frequency(440) / 0.5, const Frequency(880));
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Frequency', () {
        expect(const Frequency(440).toString(), '440 Hz');
        expect(const Frequency(415.62).toString(), '415.62 Hz');
        expect(const Frequency(2200.2968).toString(), '2200.2968 Hz');
      });
    });

    group('.hashCode', () {
      test('ignores equal Frequency instances in a Set', () {
        final collection = {
          const Frequency(432),
          const Frequency(440),
          const Frequency(467),
        };
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [Frequency(432), Frequency(440), Frequency(467)],
        );
      });
    });

    group('.compareTo()', () {
      test('sorts Frequencies in a collection', () {
        final orderedSet = SplayTreeSet<Frequency>.of({
          const Frequency(2000),
          const Frequency(10),
          const Frequency(400),
          const Frequency(500),
        });
        expect(orderedSet.toList(), const [
          Frequency(10),
          Frequency(400),
          Frequency(500),
          Frequency(2000),
        ]);
      });
    });
  });
}
