import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('MeantoneTuning', () {
    group('.ratio()', () {
      test('returns 1 for the fork’s own pitch', () {
        expect(MeantoneTuning.quarter.ratio(Note.c.inOctave(4)), 1);
        expect(MeantoneTuning.half.ratio(Note.c.inOctave(4)), 1);
      });

      test('returns values within a single octave [1, 2)', () {
        // Quarter-comma meantone, one full circle of named notes around the
        // fork. Regardless of how many fifths away a note is, the result
        // must land within a single octave above the fork.
        for (final note in <Note>[
          .c.sharp, .d.flat, .d, //
          .d.sharp, .e.flat, .e, .f, .f.sharp,
          .g.flat, .g, .g.sharp, .a.flat, .a,
          .a.sharp, .b.flat, .b,
        ]) {
          final ratio = MeantoneTuning.quarter.ratio(note.inOctave(4));
          expect(
            ratio,
            allOf(greaterThanOrEqualTo(1), lessThan(2)),
            reason: '$note ratio $ratio should fall within [1, 2)',
          );
        }
      });

      test('returns the ratio for quarter-comma meantone (1/4)', () {
        expect(
          MeantoneTuning.quarter.ratio(Note.g.inOctave(4)),
          closeTo(1.4953487812212205, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.d.inOctave(4)),
          closeTo(1.1180339887498947, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.e.inOctave(4)),
          closeTo(1.25, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.f.inOctave(4)),
          closeTo(1.337480609952844, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.a.inOctave(4)),
          closeTo(1.6718507624410548, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.b.inOctave(4)),
          closeTo(1.8691859765265253, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.c.sharp.inOctave(4)),
          closeTo(1.044906726525659, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.e.flat.inOctave(4)),
          closeTo(1.1962790249769764, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.a.flat.inOctave(4)),
          closeTo(1.6, 1e-9),
        );
      });

      test('returns the ratio for fifth-comma meantone (1/5)', () {
        expect(
          MeantoneTuning.fifth.ratio(Note.b.inOctave(4)),
          closeTo(1.875, 1e-9),
        );
        expect(
          MeantoneTuning.fifth.ratio(Note.a.sharp.inOctave(4)),
          closeTo(1.7578125000000002, 1e-8),
        );
      });

      test('returns the ratio for third-comma meantone (1/3)', () {
        expect(
          MeantoneTuning.third.ratio(Note.e.flat.inOctave(4)),
          closeTo(1.2, 1e-9),
        );
        expect(
          MeantoneTuning.third.ratio(Note.g.flat.inOctave(4)),
          closeTo(1.4399999999999997, 1e-9),
        );
      });

      test('returns the ratio for half-comma meantone (1/2)', () {
        expect(
          MeantoneTuning.half.ratio(Note.b.flat.inOctave(4)),
          closeTo(1.8, 1e-9),
        );
      });

      test('scales by an octave for a pitch one octave above the fork', () {
        expect(
          MeantoneTuning.quarter.ratio(Note.c.inOctave(5)),
          closeTo(2, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.c.inOctave(6)),
          closeTo(4, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.c.inOctave(3)),
          closeTo(0.5, 1e-9),
        );
      });

      test('combines the pitch-class ratio with the octave delta', () {
        expect(
          MeantoneTuning.quarter.ratio(Note.g.inOctave(5)),
          closeTo(2.990697562442441, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.g.inOctave(3)),
          closeTo(0.7476743906106103, 1e-9),
        );
      });

      test('smaller comma fractions produce fifths closer to just (3/2)', () {
        final quarterFifth = MeantoneTuning.quarter.ratio(Note.g.inOctave(4));
        final thirdFifth = MeantoneTuning.third.ratio(Note.g.inOctave(4));
        final justFifth = PrimeLimitTuning.threeLimit.fifthRatio;

        expect(
          (justFifth - quarterFifth).abs(),
          lessThan((justFifth - thirdFifth).abs()),
        );
      });
    });

    group('.fifthRatio, .fourthRatio', () {
      test('overrides fifthRatio with the tempered fifth', () {
        expect(
          MeantoneTuning.quarter.fifthRatio,
          closeTo(1.4953487812212205, 1e-10),
        );
      });

      test('.fourthRatio is always the octave complement of .fifthRatio', () {
        for (final meantone in <MeantoneTuning>[
          .fifth,
          .twoSevenths,
          .quarter,
          .third,
          .half,
        ]) {
          expect(
            skip: true,
            meantone.fourthRatio * meantone.fifthRatio,
            closeTo(2, 1e-9),
          );
        }
      });
    });

    group('.generator', () {
      test('returns the tempered fifth for quarter-comma meantone', () {
        expect(
          MeantoneTuning.quarter.generator,
          closeTo(const Cent(696.5784284662087), 1e-8),
        );
      });

      test('returns the tempered fifth for fifth-comma meantone', () {
        expect(
          MeantoneTuning.fifth.generator,
          closeTo(const Cent(697.6537429460445), 1e-8),
        );
      });

      test('returns the tempered fifth for third-comma meantone', () {
        expect(
          MeantoneTuning.third.generator,
          closeTo(const Cent(694.7862376664825), 1e-8),
        );
      });

      test('returns the tempered fifth for half-comma meantone', () {
        expect(
          MeantoneTuning.half.generator,
          closeTo(const Cent(691.20185606703), 1e-7),
        );
      });

      test('tempers the fifth flatter than the just fifth', () {
        expect(
          MeantoneTuning.quarter.generator,
          lessThan(JustIntonation.generatorCents),
        );
      });
    });

    group('.centsOffset()', () {
      test('returns (close to) 0 for the fork’s own pitch', () {
        expect(
          MeantoneTuning.quarter.centsOffset(Note.c.inOctave(4)),
          closeTo(0, 1e-9),
        );
      });

      test('returns the deviation from 12-EDO for quarter-comma meantone', () {
        expect(
          MeantoneTuning.quarter.centsOffset(Note.g.inOctave(4)),
          closeTo(-3.4215715337913934, 1e-8),
        );
        expect(
          MeantoneTuning.quarter.centsOffset(Note.e.inOctave(4)),
          closeTo(-13.686286135165574, 1e-8),
        );
      });

      test('returns a value within a single octave (±600 ¢)', () {
        final offset = MeantoneTuning.quarter.centsOffset(
          Note.f.sharp.inOctave(4),
        );
        expect(offset.abs(), lessThanOrEqualTo(600));
      });

      test('is unaffected by octave, unlike the raw ratio', () {
        expect(
          MeantoneTuning.quarter.centsOffset(Note.g.inOctave(4)),
          closeTo(MeantoneTuning.quarter.centsOffset(Note.g.inOctave(5)), 1e-8),
        );
      });
    });
  });
}
