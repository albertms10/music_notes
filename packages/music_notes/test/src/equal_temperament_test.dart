import 'package:music_notes/music_notes.dart';
import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('EqualTemperament', () {
    group('constructor', () {
      test('throws an assertion error when edo is not positive', () {
        expect(() => EqualTemperament(0), throwsA(isA<AssertionError>()));
        expect(() => EqualTemperament(-5), throwsA(isA<AssertionError>()));
      });
    });

    group('.cents', () {
      test('returns the cents for each division step', () {
        for (final system in [
          const EqualTemperament(12),
          const EqualTemperament(19),
          const EqualTemperament(31),
        ]) {
          for (final (index, value) in system.cents.indexed) {
            expect(
              value,
              closeTo(index * 1200 / system.edo, 1e-12),
              reason: 'Cents at division step $index for $system',
            );
          }
        }
      });
    });

    group('.fifthSteps()', () {
      test('returns the nearest integer step count approximating a just '
          'fifth (3/2) for the given edo', () {
        // 12-EDO: reproduces the historical 7-semitone fifth exactly.
        expect(EqualTemperament.fifthSteps(12), 7);
        // 19-EDO, 22-EDO, 31-EDO, 53-EDO: standard meantone-family fifths.
        expect(EqualTemperament.fifthSteps(19), 11);
        expect(EqualTemperament.fifthSteps(22), 13);
        expect(EqualTemperament.fifthSteps(31), 18);
        expect(EqualTemperament.fifthSteps(53), 31);
        // 17-EDO: known for a fifth ~4 cents sharp of just.
        expect(EqualTemperament.fifthSteps(17), 10);
      });
    });

    group('.stepsFor()', () {
      test('reproduces the original hardcoded 12-EDO NoteName positions', () {
        const edo12 = EqualTemperament(12);
        expect(edo12.stepsFor(.c), 0);
        expect(edo12.stepsFor(.d), 2);
        expect(edo12.stepsFor(.e), 4);
        expect(edo12.stepsFor(.f), 5);
        expect(edo12.stepsFor(.g), 7);
        expect(edo12.stepsFor(.a), 9);
        expect(edo12.stepsFor(.b), 11);
      });

      test('derives the accepted 19-EDO diatonic mapping via the circle '
          'of fifths', () {
        const edo19 = EqualTemperament(19);
        expect(edo19.stepsFor(.c), 0);
        expect(edo19.stepsFor(.d), 3);
        expect(edo19.stepsFor(.e), 6);
        expect(edo19.stepsFor(.f), 8);
        expect(edo19.stepsFor(.g), 11);
        expect(edo19.stepsFor(.a), 14);
        expect(edo19.stepsFor(.b), 17);
      });

      test('derives the 22-EDO diatonic mapping', () {
        const edo22 = EqualTemperament(22);
        expect(edo22.stepsFor(.c), 0);
        expect(edo22.stepsFor(.d), 4);
        expect(edo22.stepsFor(.e), 8);
        expect(edo22.stepsFor(.f), 9);
        expect(edo22.stepsFor(.g), 13);
        expect(edo22.stepsFor(.a), 17);
        expect(edo22.stepsFor(.b), 21);
      });

      test('still returns a value for EDOs with a poor fifth, without '
          'throwing — musical coherence is not guaranteed there', () {
        expect(() => const EqualTemperament(5).stepsFor(.c), returnsNormally);
        expect(() => const EqualTemperament(6).stepsFor(.f), returnsNormally);
      });
    });

    group('.steps', () {
      test('reproduces the original hardcoded 12-EDO and 19-EDO step '
          'patterns', () {
        expect(const EqualTemperament(12).steps, const [2, 2, 1, 2, 2, 2, 1]);
        expect(const EqualTemperament(19).steps, const [3, 3, 2, 3, 3, 3, 2]);
      });

      test('derives the accepted 22-EDO and 31-EDO diatonic patterns', () {
        expect(const EqualTemperament(22).steps, const [4, 4, 1, 4, 4, 4, 1]);
        expect(const EqualTemperament(31).steps, const [5, 5, 3, 5, 5, 5, 3]);
      });

      test('always has 7 entries summing to edo, regardless of whether the '
          'fifth actually yields a well-formed (MOS) diatonic scale — this '
          'is the invariant the original hand-patched constructor could '
          'violate', () {
        for (final edo in [5, 6, 12, 13, 17, 18, 19, 20, 22, 24, 31, 41, 53]) {
          final steps = EqualTemperament(edo).steps;
          expect(steps, hasLength(7), reason: 'edo=$edo');
          expect(
            steps.fold(0, (sum, step) => sum + step),
            edo,
            reason: 'edo=$edo',
          );
        }
      });
    });

    group('.nominalStepFor()', () {
      test('matches .stepsFor() exactly at 12-EDO (the identity case)', () {
        const edo12 = EqualTemperament(12);
        for (final noteName in NoteName.values) {
          expect(
            edo12.nominalStepFor(noteName),
            edo12.stepsFor(noteName),
            reason: '$noteName',
          );
        }
      });

      test('scales exactly (no rounding) when edo is a multiple of 12', () {
        const edo24 = EqualTemperament(24);
        expect(edo24.nominalStepFor(.c), 0);
        expect(edo24.nominalStepFor(.d), 4);
        expect(edo24.nominalStepFor(.e), 8);
        expect(edo24.nominalStepFor(.f), 10);
        expect(edo24.nominalStepFor(.g), 14);
        expect(edo24.nominalStepFor(.a), 18);
        expect(edo24.nominalStepFor(.b), 22);
      });

      test('rounds to the nearest step for EDOs that do not divide 12 '
          'evenly — the always-defined "ups and downs" fallback', () {
        const edo17 = EqualTemperament(17);
        expect(edo17.nominalStepFor(.c), 0);
        expect(edo17.nominalStepFor(.d), 3);
        expect(edo17.nominalStepFor(.e), 6);
        expect(edo17.nominalStepFor(.f), 7);
        expect(edo17.nominalStepFor(.g), 10);
        expect(edo17.nominalStepFor(.a), 13);
        expect(edo17.nominalStepFor(.b), 16);
      });
    });

    group('.ratio()', () {
      test('returns the ratio from a Pitch, unchanged from the original '
          '12-EDO behavior', () {
        const edo12 = EqualTemperament.edo12();
        expect(edo12.ratio(Note.g.inOctave(4)), 0.8908987181403393);
        expect(edo12.ratio(Note.a.inOctave(4)), 1);
        expect(edo12.ratio(Note.b.flat.inOctave(4)), 1.0594630943592953);
        expect(edo12.ratio(Note.a.inOctave(5)), 2);
        expect(edo12.ratio(Note.a.inOctave(6)), 4);
      });

      test('resolves exactly for any edo when the Pitch is a whole number '
          'of octaves from the fork, since that always lands on the grid', () {
        expect(const EqualTemperament(19).ratio(Note.a.inOctave(5)), 2);
        expect(const EqualTemperament(24).ratio(Note.a.inOctave(5)), 2);
        expect(const EqualTemperament(19).ratio(Note.a.inOctave(3)), 0.5);
      });

      test('throws when a 12-EDO-notated Pitch does not land on this '
          "edo's exact grid — e.g. a fifth has no exact position in "
          '19-EDO relative to 12-EDO semitone counting', () {
        expect(
          () => const EqualTemperament(19).ratio(Note.e.inOctave(5)),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.ratioFromRationalSemitones()', () {
      test('returns 1 for a zero offset, regardless of edo', () {
        expect(
          const EqualTemperament(12).ratioFromRationalSemitones(.zero),
          1,
        );
        expect(
          const EqualTemperament(31).ratioFromRationalSemitones(.zero),
          1,
        );
      });

      test('returns the exact octave ratio for a whole-octave offset', () {
        expect(
          const EqualTemperament(19).ratioFromRationalSemitones(
            const Rational(12),
          ),
          2,
        );
      });

      test('resolves a fractional (microtonal) offset when it lands '
          "exactly on the edo's grid", () {
        // A quarter-tone (half a 12-EDO semitone) is exactly 1 step in
        // 24-EDO.
        expect(
          const EqualTemperament(24).ratioFromRationalSemitones(
            const Rational(1, 2),
          ),
          closeTo(1.029302236643492, 1e-9),
        );
      });

      test("throws when the offset has no exact step on this edo's grid", () {
        // A quarter-tone does not exist on the 12-EDO grid.
        expect(
          () => const EqualTemperament(12).ratioFromRationalSemitones(
            const Rational(1, 2),
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.generator', () {
      test('returns the number of cents for the generator at Interval.P5, '
          'matching the previously hand-tuned 12-EDO and 19-EDO values', () {
        expect(const EqualTemperament.edo12().generator, const Cent(700));
        expect(
          const EqualTemperament(19).generator,
          closeTo(694.7368421052632, 1e-12),
        );
      });

      test('derives the generator for other EDOs from the same fifths '
          'formula .steps and .stepsFor() use, so all three stay '
          'consistent with each other', () {
        expect(
          const EqualTemperament(31).generator,
          closeTo(696.7741935483871, 1e-9),
        );
      });
    });

    group('.centsOffset()', () {
      test('is always 0 in 12-EDO, since it defines equal temperament '
          'itself', () {
        const edo12 = EqualTemperament(12);
        for (final note in <Note>[
          .c, .d.flat, .d, .e.flat, .e, .f, //
          .f.sharp, .g, .a, .b.flat, .b,
          // TODO(albertms10): .a.flat is -200.
        ]) {
          expect(
            edo12.centsOffset(note.inOctave(4)),
            closeTo(0, 1e-9),
            reason: '$note should have 0 centsOffset in 12-EDO',
          );
        }
      });

      test('is 0 for any edo when the Pitch is a whole octave from the '
          'fork, since both the actual and 12-EDO-equal cents agree '
          'exactly there', () {
        expect(
          const EqualTemperament(19).centsOffset(Note.a.inOctave(5)),
          closeTo(0, 1e-9),
        );
      });

      test("throws for a Pitch that does not land on this edo's exact "
          'grid, since it is derived from .ratio()', () {
        expect(
          () => const EqualTemperament(19).centsOffset(Note.g.inOctave(4)),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('operator ==()', () {
      test('compares this EqualTemperament to other by edo and fork', () {
        expect(const EqualTemperament(12), const EqualTemperament.edo12());
        expect(const EqualTemperament(31), const EqualTemperament(31));
        expect(
          const EqualTemperament(12),
          isNot(const EqualTemperament(19)),
        );
        expect(
          const EqualTemperament(12),
          isNot(const EqualTemperament(12, fork: TuningFork.c256)),
        );
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal EqualTemperaments', () {
        expect(
          const EqualTemperament(12).hashCode,
          const EqualTemperament.edo12().hashCode,
        );
      });

      test('returns different hashCodes for different EqualTemperaments', () {
        expect(
          const EqualTemperament(12).hashCode,
          isNot(const EqualTemperament(19).hashCode),
        );
      });
    });

    group('.toString()', () {
      test('returns the string representation of this EqualTemperament, '
          'with .steps derived rather than hand-authored', () {
        expect(
          const EqualTemperament.edo12().toString(),
          'EDO 12 (2 2 1 2 2 2 1) at A440',
        );
        expect(
          const EqualTemperament(19).toString(),
          'EDO 19 (3 3 2 3 3 3 2) at A440',
        );
        expect(
          const EqualTemperament(19, fork: .c256).toString(),
          'EDO 19 (3 3 2 3 3 3 2) at C256',
        );
        expect(
          const EqualTemperament(31).toString(),
          'EDO 31 (5 5 3 5 5 5 3) at A440',
        );
      });
    });
  });
}
