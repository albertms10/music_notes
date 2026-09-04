import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('JustIntonation', () {
    group('.generator', () {
      test('returns the number of cents for the generator at Interval.P5 in '
          'this JustIntonation', () {
        const generator = Cent(701.9550008653874);
        expect(PrimeLimitTuning.threeLimit.generator, generator);
        expect(
          PrimeLimitTuning(
            const [],
            fork: Note.a.flat.inOctave(3).at(.reference),
          ).generator,
          generator,
        );
      });
    });

    group('.fifthRatio / .fourthRatio', () {
      test('defaults to the pure ascending fifth and fourth ratios', () {
        expect(
          PrimeLimitTuning.threeLimit.fifthRatio,
          JustIntonation.ascendingFifthRatio,
        );
        expect(
          PrimeLimitTuning.threeLimit.fourthRatio,
          JustIntonation.ascendingFourthRatio,
        );
      });

      test('.fourthRatio is always the octave complement of .fifthRatio', () {
        const tuning = PrimeLimitTuning.threeLimit;
        expect(tuning.fourthRatio * tuning.fifthRatio, 2);
      });
    });

    group('.comma', () {
      test('returns the Pythagorean comma for three-limit tuning', () {
        const pythagoreanComma = 1.0136432647705078;
        expect(PrimeLimitTuning.threeLimit.comma, pythagoreanComma);
        expect(
          PrimeLimitTuning(
            const [],
            fork: Note.f.sharp.inOctave(5).at(.reference),
          ).comma,
          pythagoreanComma,
        );
      });

      test('generalizes beyond three-limit: five-limit closes by a '
          'different amount (the diesis, not the Pythagorean comma)', () {
        expect(
          PrimeLimitTuning.fiveLimit.comma,
          isNot(PrimeLimitTuning.threeLimit.comma),
        );
      });
    });

    group('.centsOffset()', () {
      test('returns 0 for the fork’s own pitch', () {
        expect(PrimeLimitTuning.threeLimit.centsOffset(Note.c.inOctave(4)), 0);
      });

      test('is inherited from TuningSystem, not tied to any one subclass', () {
        // The pure fifth (G4) is sharper than its 12-EDO counterpart by
        // exactly the same amount as JustIntonation.generatorCents - 700.
        expect(
          PrimeLimitTuning.threeLimit.centsOffset(Note.g.inOctave(4)),
          closeTo(1.9550008653874, 1e-9),
        );
      });
    });
  });
}
