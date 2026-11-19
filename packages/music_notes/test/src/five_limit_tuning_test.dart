import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('FiveLimitTuning', () {
    group('.ratio()', () {
      test('returns 1 for the fork’s own pitch', () {
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(4)), 1);
      });

      test('returns the 5-limit ratio for the diatonic notes', () {
        expect(
          const FiveLimitTuning().ratio(Note.d.inOctave(4)),
          closeTo(9 / 8, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.e.inOctave(4)),
          closeTo(5 / 4, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.f.inOctave(4)),
          closeTo(4 / 3, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.inOctave(4)),
          closeTo(3 / 2, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.a.inOctave(4)),
          closeTo(5 / 3, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.b.inOctave(4)),
          closeTo(15 / 8, 1e-12),
        );
      });

      test('returns the 5-limit ratio for the chromatic notes', () {
        expect(
          const FiveLimitTuning().ratio(Note.c.sharp.inOctave(4)),
          closeTo(25 / 24, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.d.flat.inOctave(4)),
          closeTo(16 / 15, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.d.sharp.inOctave(4)),
          closeTo(75 / 64, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.e.flat.inOctave(4)),
          closeTo(6 / 5, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.f.sharp.inOctave(4)),
          closeTo(45 / 32, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.flat.inOctave(4)),
          closeTo(64 / 45, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.sharp.inOctave(4)),
          closeTo(25 / 16, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.a.flat.inOctave(4)),
          closeTo(8 / 5, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.a.sharp.inOctave(4)),
          closeTo(225 / 128, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.b.flat.inOctave(4)),
          closeTo(16 / 9, 1e-12),
        );
      });

      test('gives enharmonic spellings different ratios', () {
        // Unlike 12-EDO, C♯ and D♭ are not the same pitch in just
        // intonation: they differ by the diesis (128/125).
        expect(
          const FiveLimitTuning().ratio(Note.c.sharp.inOctave(4)),
          isNot(const FiveLimitTuning().ratio(Note.d.flat.inOctave(4))),
        );
      });

      test('returns values within a single octave [1, 2)', () {
        for (final note in <Note>[
          .c, .c.sharp, .d.flat, .d, .d.sharp, .e.flat, .e, .f, .f.sharp, //
          .g.flat, .g, .g.sharp, .a.flat, .a, .a.sharp, .b.flat, .b,
        ]) {
          final ratio = const FiveLimitTuning().ratio(note.inOctave(4));
          expect(
            ratio,
            allOf(greaterThanOrEqualTo(1), lessThan(2)),
            reason: '$note ratio $ratio should fall within [1, 2)',
          );
        }
      });

      test('scales by an octave for pitches above the fork’s octave', () {
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(5)), 2);
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(6)), 4);
        expect(const FiveLimitTuning().ratio(Note.e.inOctave(5)), 2.5);
      });

      test('scales by an octave for pitches below the fork’s octave', () {
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(3)), 0.5);
        expect(const FiveLimitTuning().ratio(Note.g.inOctave(3)), 0.75);
      });

      test('computes ratios for notes outside the standard 12, unlike a '
          'fixed lookup table', () {
        // F𝄪 (double sharp, distance 13): 3 ascending thirds and 1
        // ascending fifth, landing in the same octave as the fork.
        expect(
          const FiveLimitTuning().ratio(Note.f.sharp.sharp.inOctave(4)),
          closeTo(375 / 256, 1e-12),
        );
      });

      test('respects real octave placement even when it crosses a letter '
          'boundary', () {
        // C♭ ’s accidental pushes its real pitch height *below* its
        // letter’s octave: C♭4 is enharmonically B3 (see
        // Pitch.respelledSimple’s doc comment). Its 5-limit pitch class,
        // 48/25 (2 descending thirds + 1 ascending fifth), therefore gets
        // folded down by one octave to land where C♭4 really sits: just
        // under the C4 fork, not almost an octave above it.
        expect(
          const FiveLimitTuning().ratio(Note.c.flat.inOctave(4)),
          closeTo(24 / 25, 1e-9),
        );
        expect(
          const FiveLimitTuning().ratio(Note.c.flat.inOctave(4)),
          lessThan(1),
        );
      });

      test('prefers the fewest fifths, matching the “asymmetric scale” '
          'convention for C♯ (25/24, not the also-common 135/128)', () {
        expect(
          const FiveLimitTuning().ratio(Note.c.sharp.inOctave(4)),
          closeTo(25 / 24, 1e-12),
        );
      });
    });

    group('.pitchClassRatioFrom()', () {
      test('returns 1 for the origin (0 fifths, 0 thirds)', () {
        expect(
          const FiveLimitTuning().pitchClassRatioFrom(fifths: 0, thirds: 0),
          1,
        );
      });

      test('returns the pure fifth/third for a single step on each axis', () {
        expect(
          const FiveLimitTuning().pitchClassRatioFrom(fifths: 1, thirds: 0),
          3 / 2,
        );
        expect(
          const FiveLimitTuning().pitchClassRatioFrom(fifths: 0, thirds: 1),
          5 / 4,
        );
      });

      test('matches the coordinates .ratio() resolves to, for a pitch in '
          'the fork’s own octave', () {
        // F♯4 (distance 6) is a pitch in the same octave as the C4 fork,
        // so no additional octave adjustment applies and .ratio() should
        // equal the canonical path’s pitchClassRatioFrom() exactly.
        expect(
          const FiveLimitTuning().ratio(Note.f.sharp.inOctave(4)),
          const FiveLimitTuning().pitchClassRatioFrom(fifths: 2, thirds: 1),
        );
      });
    });

    group('.pathsTo()', () {
      test('every path satisfies fifths + 4 * thirds == fifthsDistance', () {
        final paths = const FiveLimitTuning().pathsTo(
          Note.f.sharp.inOctave(4),
        );
        for (final path in paths) {
          expect(path.fifths + 4 * path.thirds, 6); // F♯ distance from C
        }
      });

      test('exactly one path is canonical, and it matches .ratio()', () {
        final pitch = Note.f.sharp.inOctave(4);
        final paths = const FiveLimitTuning().pathsTo(pitch);
        final canonical = paths.where((path) => path.isCanonical);

        expect(canonical, hasLength(1));
        expect(canonical.single.ratio, const FiveLimitTuning().ratio(pitch));
      });

      test('returns the two commonly-cited alternatives for F♯ (45/32 vs '
          'the juster but fifths-heavier 25/18)', () {
        final paths = const FiveLimitTuning().pathsTo(
          Note.f.sharp.inOctave(4),
        );

        final conventional = paths.firstWhere(
          (path) => path.thirds == 1 && path.fifths == 2,
        );
        expect(conventional.ratio, 45 / 32);
        expect(conventional.isCanonical, isTrue);

        final juster = paths.firstWhere(
          (path) => path.thirds == 2 && path.fifths == -2,
        );
        expect(juster.ratio, closeTo(25 / 18, 1e-9));
        expect(juster.isCanonical, isFalse);
      });

      test('adjacent paths differ by exactly the syntonic comma, away from '
          'octave-fold boundaries', () {
        // F♯ (distance 6): none of these paths cross an octave fold, so
        // every step divides the ratio by exactly 81/80 as thirds
        // increases by one.
        final paths = const FiveLimitTuning().pathsTo(
          Note.f.sharp.inOctave(4),
        );
        const comma = JustIntonation.syntonicCommaRatio;

        for (var i = 1; i < paths.length; i++) {
          expect(
            paths[i - 1].ratio / paths[i].ratio,
            closeTo(comma, 1e-9),
            reason: 'thirds ${paths[i - 1].thirds} -> ${paths[i].thirds}',
          );
        }
      });

      test('respects a custom maxThirds window', () {
        final paths = const FiveLimitTuning().pathsTo(
          Note.c.inOctave(4),
          maxThirds: 1,
        );
        expect(paths, hasLength(3)); // thirds in {-1, 0, 1}
      });
    });

    group('.generator', () {
      test('returns the pure ascending fifth, inherited from '
          'JustIntonation', () {
        expect(
          const FiveLimitTuning().generator,
          const PythagoreanTuning().generator,
        );
      });
    });
  });
}
