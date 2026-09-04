import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('PrimeLimitTuning', () {
    group('.threeLimit (Pythagorean)', () {
      test('has no generators beyond the fifth', () {
        expect(PrimeLimitTuning.threeLimit.generators, isEmpty);
      });

      test('returns the ratio for the chromatic notes', () {
        expect(PrimeLimitTuning.threeLimit.ratio(Note.c.inOctave(4)), 1);
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.c.sharp.inOctave(4)),
          2187 / 2048,
        );
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.d.flat.inOctave(4)),
          closeTo(256 / 243, 1e-15),
        );
        expect(PrimeLimitTuning.threeLimit.ratio(Note.d.inOctave(4)), 9 / 8);
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.d.sharp.inOctave(4)),
          19683 / 16384,
        );
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.e.flat.inOctave(4)),
          32 / 27,
        );
        expect(PrimeLimitTuning.threeLimit.ratio(Note.e.inOctave(4)), 81 / 64);
        expect(PrimeLimitTuning.threeLimit.ratio(Note.f.inOctave(4)), 4 / 3);
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.f.sharp.inOctave(4)),
          729 / 512,
        );
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.g.flat.inOctave(4)),
          closeTo(1024 / 729, 1e-15),
        );
        expect(PrimeLimitTuning.threeLimit.ratio(Note.g.inOctave(4)), 3 / 2);
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.g.sharp.inOctave(4)),
          6561 / 4096,
        );
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.a.flat.inOctave(4)),
          128 / 81,
        );
        expect(PrimeLimitTuning.threeLimit.ratio(Note.a.inOctave(4)), 27 / 16);
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.a.sharp.inOctave(4)),
          59049 / 32768,
        );
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.b.inOctave(4)),
          243 / 128,
        );
      });

      test('scales by an octave above and below the fork', () {
        expect(PrimeLimitTuning.threeLimit.ratio(Note.c.inOctave(5)), 2);
        expect(PrimeLimitTuning.threeLimit.ratio(Note.f.inOctave(5)), 8 / 3);
        expect(PrimeLimitTuning.threeLimit.ratio(Note.c.inOctave(3)), 0.5);
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.f.inOctave(3)),
          closeTo(2 / 3, 1e-12),
        );
        expect(
          PrimeLimitTuning.threeLimit.ratio(Note.b.flat.inOctave(2)),
          closeTo(4 / 9, 1e-12),
        );
      });

      test('.comma returns the Pythagorean comma', () {
        expect(PrimeLimitTuning.threeLimit.comma, 1.0136432647705078);
      });
    });

    group('.fiveLimit', () {
      test('has exactly one generator: the major third', () {
        expect(PrimeLimitTuning.fiveLimit.generators, hasLength(1));
        expect(
          PrimeLimitTuning.fiveLimit.generators.single.ascendingRatio,
          5 / 4,
        );
        expect(
          PrimeLimitTuning.fiveLimit.generators.single.fifthsEquivalence,
          4,
        );
      });

      test('returns the 5-limit ratio for the diatonic notes', () {
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.d.inOctave(4)),
          closeTo(9 / 8, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.e.inOctave(4)),
          closeTo(5 / 4, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.f.inOctave(4)),
          closeTo(4 / 3, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.g.inOctave(4)),
          closeTo(3 / 2, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.a.inOctave(4)),
          closeTo(5 / 3, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.b.inOctave(4)),
          closeTo(15 / 8, 1e-12),
        );
      });

      test('returns the 5-limit ratio for the chromatic notes', () {
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.c.sharp.inOctave(4)),
          closeTo(25 / 24, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.d.flat.inOctave(4)),
          closeTo(16 / 15, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.f.sharp.inOctave(4)),
          closeTo(45 / 32, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.a.flat.inOctave(4)),
          closeTo(8 / 5, 1e-12),
        );
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.b.flat.inOctave(4)),
          closeTo(16 / 9, 1e-12),
        );
      });

      test('gives enharmonic spellings different ratios', () {
        // Unlike 12-EDO, C♯ and D♭ are not the same pitch in just
        // intonation: they differ by the diesis (128/125).
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.c.sharp.inOctave(4)),
          isNot(PrimeLimitTuning.fiveLimit.ratio(Note.d.flat.inOctave(4))),
        );
      });

      test('respects real octave placement even when it crosses a letter '
          'boundary', () {
        // C♭4 is enharmonically B3 (see Pitch.respelledSimple's doc
        // comment); its 5-limit pitch class (48/25) folds down by one
        // octave to land where C♭4 really sits: just under the fork.
        expect(
          PrimeLimitTuning.fiveLimit.ratio(Note.c.flat.inOctave(4)),
          closeTo(24 / 25, 1e-9),
        );
      });

      test('.comma returns the diesis, not the Pythagorean comma', () {
        expect(PrimeLimitTuning.fiveLimit.comma, closeTo(125 / 128, 1e-9));
      });
    });

    group('.sevenLimitSeptimal', () {
      test('has two generators: the major third, then the harmonic '
          'seventh (not auto-resolved)', () {
        final generators = PrimeLimitTuning.sevenLimitSeptimal.generators;
        expect(generators, hasLength(2));
        expect(generators[0].autoResolve, isTrue);
        expect(generators[1].ascendingRatio, 7 / 4);
        expect(generators[1].fifthsEquivalence, -2);
        expect(generators[1].autoResolve, isFalse);
      });

      test('.ratio() matches five-limit for every standard note, since the '
          'seventh is never auto-resolved', () {
        for (final note in [
          Note.c, Note.c.sharp, Note.d.flat, Note.d, //
          Note.d.sharp, Note.e.flat, Note.e, Note.f, Note.f.sharp,
          Note.g.flat, Note.g, Note.g.sharp, Note.a.flat, Note.a,
          Note.a.sharp, Note.b.flat, Note.b,
        ]) {
          expect(
            PrimeLimitTuning.sevenLimitSeptimal.ratio(note.inOctave(4)),
            PrimeLimitTuning.fiveLimit.ratio(note.inOctave(4)),
            reason: '$note should be unaffected by the seventh axis',
          );
        }
      });

      test('the harmonic seventh for B♭ is reachable deliberately, not '
          'automatically', () {
        final pitch = Note.b.flat.inOctave(4);

        // .ratio() stays conservative...
        expect(
          PrimeLimitTuning.sevenLimitSeptimal.ratio(pitch),
          PrimeLimitTuning.fiveLimit.ratio(pitch),
        );

        // ...but the harmonic seventh is still one lookup away.
        final harmonicSeventh = PrimeLimitTuning.sevenLimitSeptimal
            .pathsTo(pitch)
            .firstWhere((path) => path.steps[0] == 0 && path.steps[1] == 1);
        expect(harmonicSeventh.ratio, 7 / 4);
        expect(harmonicSeventh.isCanonical, isFalse);
      });
    });

    group('.pitchClassRatioFrom()', () {
      test('returns 1 at the origin', () {
        expect(
          PrimeLimitTuning.fiveLimit.pitchClassRatioFrom(
            fifths: 0,
            steps: [0],
          ),
          1,
        );
      });

      test('throws if steps doesn’t match generators in length', () {
        expect(
          () => PrimeLimitTuning.fiveLimit.pitchClassRatioFrom(
            fifths: 0,
            steps: [0, 0],
          ),
          throwsArgumentError,
        );
        expect(
          () => PrimeLimitTuning.threeLimit.pitchClassRatioFrom(
            fifths: 0,
            steps: [0],
          ),
          throwsArgumentError,
        );
      });

      test('combines multiple generator axes correctly (7-limit B♭)', () {
        expect(
          PrimeLimitTuning.sevenLimitSeptimal.pitchClassRatioFrom(
            fifths: 0,
            steps: [0, 1],
          ),
          7 / 4,
        );
      });
    });

    group('.pathsTo()', () {
      test('every path satisfies fifths + sum(steps * fifthsEquivalence) '
          '== fifthsDistance', () {
        final paths = PrimeLimitTuning.fiveLimit.pathsTo(
          Note.f.sharp.inOctave(4),
        );
        for (final path in paths) {
          expect(path.fifths + 4 * path.steps.single, 6);
        }
      });

      test('exactly one path is canonical, and it matches .ratio()', () {
        final pitch = Note.f.sharp.inOctave(4);
        final paths = PrimeLimitTuning.fiveLimit.pathsTo(pitch);
        final canonical = paths.where((path) => path.isCanonical);

        expect(canonical, hasLength(1));
        expect(
          canonical.single.ratio,
          PrimeLimitTuning.fiveLimit.ratio(pitch),
        );
      });

      test('surfaces the two commonly-cited alternatives for F♯ (45/32 '
          'conventional vs the juster 25/18)', () {
        final paths = PrimeLimitTuning.fiveLimit.pathsTo(
          Note.f.sharp.inOctave(4),
        );

        final conventional = paths.firstWhere(
          (path) => path.steps.single == 1 && path.fifths == 2,
        );
        expect(conventional.ratio, 45 / 32);
        expect(conventional.isCanonical, isTrue);

        final juster = paths.firstWhere(
          (path) => path.steps.single == 2 && path.fifths == -2,
        );
        expect(juster.ratio, closeTo(25 / 18, 1e-9));
        expect(juster.isCanonical, isFalse);
      });

      test('adjacent paths differ by exactly the syntonic comma, away from '
          'octave-fold boundaries', () {
        final paths = PrimeLimitTuning.fiveLimit.pathsTo(
          Note.f.sharp.inOctave(4),
        );
        const comma = JustIntonation.syntonicCommaRatio;

        for (var i = 1; i < paths.length; i++) {
          expect(
            paths[i - 1].ratio / paths[i].ratio,
            closeTo(comma, 1e-9),
          );
        }
      });

      test('works across multiple simultaneous axes (7-limit)', () {
        final pitch = Note.b.flat.inOctave(4);
        final paths = PrimeLimitTuning.sevenLimitSeptimal.pathsTo(
          pitch,
          maxSteps: 2,
        );

        // 5 values per axis, 2 axes.
        expect(paths, hasLength(25));

        // The canonical path only auto-resolves the third axis (steps[0]);
        // the seventh (steps[1]) stays at 0, matching five-limit's 16/9.
        final canonical = paths.singleWhere((path) => path.isCanonical);
        expect(canonical.steps, [0, 0]);
        expect(canonical.ratio, 16 / 9);

        // The harmonic seventh is still discoverable, just not canonical.
        final harmonicSeventh = paths.singleWhere(
          (path) => path.steps[0] == 0 && path.steps[1] == 1,
        );
        expect(harmonicSeventh.ratio, 7 / 4);
        expect(harmonicSeventh.isCanonical, isFalse);
      });

      test('respects a custom maxSteps window', () {
        final paths = PrimeLimitTuning.fiveLimit.pathsTo(
          Note.c.inOctave(4),
          maxSteps: 1,
        );
        expect(paths, hasLength(3)); // steps in {-1, 0, 1}
      });
    });

    group('custom generators', () {
      test('accepts an arbitrary custom generator', () {
        // An 11-limit-style undecimal generator (11/8), 5 descending
        // fifths away up to its own comma, purely as a construction test.
        const custom = PrimeLimitTuning([
          (ascendingRatio: 11 / 8, fifthsEquivalence: -5, autoResolve: true),
        ]);
        expect(custom.generators.single.ascendingRatio, 11 / 8);
        expect(
          custom.pitchClassRatioFrom(fifths: 0, steps: [1]),
          11 / 8,
        );
      });
    });
  });
}
