import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Meantone', () {
    group('.ratio()', () {
      test('returns 1 for the fork’s own pitch class', () {
        expect(MeantoneTuning.quarter.ratio(Note.c.inOctave(4)), 1);
        expect(MeantoneTuning.half.ratio(Note.c.inOctave(4)), 1);
      });

      test('returns the ratio for quarter-comma meantone (1/4)', () {
        expect(
          MeantoneTuning.quarter.ratio(Note.g.inOctave(4)),
          closeTo(1.4953487812212205, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.d.inOctave(4)),
          closeTo(2.2360679774997894, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.e.inOctave(4)),
          closeTo(5, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.f.inOctave(4)),
          closeTo(0.668740304976422, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.a.inOctave(4)),
          closeTo(3.3437015248821105, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.b.inOctave(4)),
          closeTo(7.476743906106103, 1e-9),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.c.sharp.inOctave(4)),
          closeTo(16.71850762441055, 1e-8),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.e.flat.inOctave(4)),
          closeTo(0.2990697562442441, 1e-10),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.a.flat.inOctave(4)),
          closeTo(0.2, 1e-10),
        );
      });

      test('returns the ratio for fifth-comma meantone (1/5)', () {
        expect(
          MeantoneTuning.fifth.ratio(Note.b.inOctave(4)),
          closeTo(7.5, 1e-9),
        );
        expect(
          MeantoneTuning.fifth.ratio(Note.a.sharp.inOctave(4)),
          closeTo(56.25, 1e-8),
        );
      });

      test('returns the ratio for third-comma meantone (1/3)', () {
        expect(
          MeantoneTuning.third.ratio(Note.e.flat.inOctave(4)),
          closeTo(0.3, 1e-10),
        );
        expect(
          MeantoneTuning.third.ratio(Note.g.flat.inOctave(4)),
          closeTo(0.09, 1e-10),
        );
      });

      test('returns the ratio for half-comma meantone (1/2)', () {
        expect(
          MeantoneTuning.half.ratio(Note.b.flat.inOctave(4)),
          closeTo(0.45, 1e-9),
        );
      });

      test('only depends on the note name, regardless of octave', () {
        expect(
          MeantoneTuning.quarter.ratio(Note.g.inOctave(4)),
          MeantoneTuning.quarter.ratio(Note.g.inOctave(5)),
        );
        expect(
          MeantoneTuning.quarter.ratio(Note.g.inOctave(4)),
          MeantoneTuning.quarter.ratio(Note.g.inOctave(2)),
        );
      });

      test('smaller comma fractions produce fifths closer to just (3/2)', () {
        final quarterFifth = MeantoneTuning.quarter.ratio(Note.g.inOctave(4));
        final thirdFifth = MeantoneTuning.third.ratio(Note.g.inOctave(4));
        const justFifth = JustIntonation.ascendingFifthRatio;

        expect(
          (justFifth - quarterFifth).abs(),
          lessThan((justFifth - thirdFifth).abs()),
        );
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
    });
  });
}
