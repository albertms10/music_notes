import '../note/note.dart';
import '../pitch/pitch.dart';
import 'just_intonation.dart';

/// A single generator axis for a [PrimeLimitTuning], beyond the base chain
/// of fifths (3/2).
///
/// [ascendingRatio] is the generator itself: 5/4 for the five-limit’s
/// major third, 7/4 for the seven-limit’s harmonic seventh, 11/8 for an
/// eleven-limit undecimal generator, and so on.
///
/// [fifthsEquivalence] is the number of ascending fifths that one
/// ascending step of this generator conventionally stands in for, up to
/// the comma linking the two. E.g., `4` for the major third (the two differ
/// by the [JustIntonation.syntonicCommaRatio]), or `-2` for the harmonic
/// seventh (the two differ by the septimal comma, 64/63).
///
/// [autoResolve] controls whether [PrimeLimitTuning.ratio] is allowed to
/// pick this axis’s step count automatically. It exists because “nearest
/// fit” isn’t a safe default beyond the very first extra generator: with
/// two or more axes active, a later axis with a small
/// [fifthsEquivalence] (like the seventh’s `-2`) can numerically absorb
/// leftover fifths from notes that were never meant to be reinterpreted
/// (e.g. a five-limit whole tone lining up exactly with one descending
/// seventh step), with no purely numeric way to tell that case apart from
/// a genuine one (e.g. the minor seventh becoming the harmonic seventh).
/// Set this to `false` for any axis whose auto-selection can’t be trusted
/// generically; [PrimeLimitTuning.pathsTo] and
/// [PrimeLimitTuning.pitchClassRatioFrom] still let you reach it
/// deliberately.
typedef PrimeLimitGenerator = ({
  num ascendingRatio,
  int fifthsEquivalence,
  bool autoResolve,
});

/// A specific point on a [PrimeLimitTuning]’s lattice: [fifths] ascending
/// fifths, plus [steps] ascending generator steps (one entry per
/// [PrimeLimitTuning.generators], in the same order) together with the
/// resulting pitch-class [ratio].
///
/// [isCanonical] marks the specific path [PrimeLimitTuning.ratio] actually
/// uses for a given note.
///
/// ---
/// See [PrimeLimitTuning.pathsTo].
typedef PrimeLimitPath = ({
  int fifths,
  List<int> steps,
  num ratio,
  bool isCanonical,
});

/// A generalized n-limit just intonation tuning system.
///
/// Three-limit (Pythagorean) tuning builds every pitch class from a single
/// generator: the chain of fifths already implemented by
/// [JustIntonation]’s default [ratio]. Five-limit tuning adds a second
/// generator, the major third, and needs a rule for splitting a note’s
/// single fifths distance across both axes (see [fiveLimit] below).
/// Seven-limit tuning adds a third generator, the harmonic seventh;
/// eleven-limit a fourth; and so on, each one following the exact same
/// shape.
///
/// [PrimeLimitTuning] captures that shape once: [generators] is an ordered
/// list of axes beyond the fifth. For a given note, its three-limit fifths
/// distance is resolved sequentially; each generator with
/// [PrimeLimitGenerator.autoResolve] set claims the nearest whole number
/// of its own steps, leaving the remainder for the next axis, with any
/// leftover finally absorbed by the fifths themselves.
///
/// ## Where convention ends and judgment begins
///
/// Three-limit and five-limit tuning have essentially one accepted
/// [PrimeLimitGenerator.fifthsEquivalence] each ([threeLimit] has no
/// generators to choose; [fiveLimit]’s `4` reproduces the conventional
/// 12-tone “asymmetric” 5-limit scale, per
/// [Five-limit tuning](https://en.wikipedia.org/wiki/Five-limit_tuning)).
/// Beyond that, there generally isn’t a single settled choice. Tuning
/// theorists use different commas depending on what they’re optimizing
/// for, *and*, as [PrimeLimitGenerator.autoResolve] explains, no settled
/// rule for which notes should even be reinterpreted at all.
/// [sevenLimitSeptimal] uses the septimal comma (64/63), the most
/// commonly cited seven-limit convention, but with `autoResolve: false`:
/// [ratio] matches [fiveLimit] for every note, and the harmonic seventh is
/// reached deliberately, via [pathsTo] or [pitchClassRatioFrom], rather
/// than guessed. Construct [PrimeLimitTuning] directly with different
/// [generators] for other conventions.
class PrimeLimitTuning extends JustIntonation {
  /// The generator axes beyond the base chain of fifths, in the order
  /// they’re resolved.
  final List<PrimeLimitGenerator> generators;

  /// Creates a new [PrimeLimitTuning] from [generators] and [fork].
  const PrimeLimitTuning(this.generators, {super.fork});

  /// Three-limit (Pythagorean) tuning: no generators beyond the fifth.
  static final threeLimit = PrimeLimitTuning([]);

  /// Five-limit tuning: adds the major third (5/4), 4 fifths away from
  /// unison up to the syntonic comma.
  static final fiveLimit = PrimeLimitTuning([
    (ascendingRatio: 5 / 4, fifthsEquivalence: 4, autoResolve: true),
  ]);

  /// Seven-limit tuning using the septimal comma: adds the major third
  /// (5/4) and the harmonic seventh (7/4, 2 descending fifths away from
  /// unison up to the septimal comma, 64/63).
  ///
  /// The seventh’s [PrimeLimitGenerator.autoResolve] is `false`: [ratio]
  /// matches [fiveLimit] for every note. Reach the harmonic seventh (and
  /// other septimal alternatives) explicitly via [pathsTo] or
  /// [pitchClassRatioFrom].
  static final sevenLimitSeptimal = PrimeLimitTuning([
    (ascendingRatio: 5 / 4, fifthsEquivalence: 4, autoResolve: true),
    (ascendingRatio: 7 / 4, fifthsEquivalence: -2, autoResolve: false),
  ]);

  @override
  num ratio(Pitch pitch) {
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);
    final coordinates = _resolveCoordinates(distance);

    return octaveAdjustedRatio(
      pitch,
      pitchClassRatioFrom(
        fifths: coordinates.fifths,
        steps: coordinates.steps,
      ),
    );
  }

  /// The pitch-class ratio (within `[1, 2)`) reached by [fifths] ascending
  /// fifths plus [steps] ascending generator steps (matching [generators]
  /// pairwise, in order) independent of any particular [Note] spelling.
  ///
  /// This is the building block behind [ratio] and [pathsTo]: rather than
  /// resolving which coordinates best represent a note, it lets you choose
  /// the lattice point directly.
  num pitchClassRatioFrom({required int fifths, required List<int> steps}) {
    if (steps.length != generators.length) {
      throw ArgumentError.value(
        steps,
        'steps',
        'Must have exactly ${generators.length} entries, matching '
            'generators.',
      );
    }

    var ratio = chainRatio(fifths, fifthRatio);
    for (var i = 0; i < generators.length; i++) {
      ratio = foldIntoOctave(
        ratio * chainRatio(steps[i], generators[i].ascendingRatio),
      );
    }

    return ratio;
  }

  /// Every combination of generator steps (each within [maxSteps] of
  /// zero) that reaches the same pitch class as [pitch]’s note, together
  /// with the fifths needed to complete each path and the ratio it
  /// produces.
  ///
  /// Adjacent values along a single axis differ by exactly that
  /// generator’s comma (e.g. the syntonic comma for the major-third axis),
  /// except where the step also crosses an octave fold, which additionally
  /// doubles or halves it.
  List<PrimeLimitPath> pathsTo(Pitch pitch, {int maxSteps = 3}) {
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);
    final canonical = _resolveCoordinates(distance);
    final window = [for (var s = -maxSteps; s <= maxSteps; s++) s];

    return [
      for (final steps in _cartesianProduct(
        List.filled(generators.length, window),
      ))
        (
          fifths: distance - _weightedSum(steps),
          steps: steps,
          ratio: pitchClassRatioFrom(
            fifths: distance - _weightedSum(steps),
            steps: steps,
          ),
          isCanonical: _stepsEqual(steps, canonical.steps),
        ),
    ];
  }

  /// Resolves the canonical (fifths, steps) coordinates for
  /// [fifthsDistance] by peeling off the nearest whole number of steps of
  /// each [PrimeLimitGenerator.autoResolve]-enabled generator in order,
  /// minimizing what’s left over at each stage, and handing the remainder
  /// down to the next axis, with any final leftover absorbed by the
  /// fifths. Generators with `autoResolve: false` always contribute `0`
  /// here, leaving their step fully available via [pathsTo] and
  /// [pitchClassRatioFrom] without ever being guessed automatically.
  ({int fifths, List<int> steps}) _resolveCoordinates(int fifthsDistance) {
    var remaining = fifthsDistance;
    final steps = <int>[];
    for (final generator in generators) {
      if (!generator.autoResolve) {
        steps.add(0);
        continue;
      }
      final count = _nearestSteps(remaining, generator.fifthsEquivalence);
      steps.add(count);
      remaining -= count * generator.fifthsEquivalence;
    }

    return (fifths: remaining, steps: steps);
  }

  int _weightedSum(List<int> steps) {
    var sum = 0;
    for (var i = 0; i < steps.length; i++) {
      sum += steps[i] * generators[i].fifthsEquivalence;
    }

    return sum;
  }

  /// The number of steps of a generator with [fifthsEquivalence] (each
  /// standing in for that many fifths, up to a comma) that best
  /// approximates [remaining] while minimizing the fifths left over.
  ///
  /// Equivalent to `(remaining / fifthsEquivalence).round()`, with ties
  /// broken towards zero.
  static int _nearestSteps(int remaining, int fifthsEquivalence) {
    final quotient = remaining ~/ fifthsEquivalence;
    final remainder = remaining - quotient * fifthsEquivalence;

    return remainder.abs() * 2 > fifthsEquivalence.abs()
        ? quotient + remainder.sign
        : quotient;
  }

  static List<List<int>> _cartesianProduct(List<List<int>> axes) {
    var result = [<int>[]];
    for (final axis in axes) {
      result = [
        for (final prefix in result)
          for (final value in axis) [...prefix, value],
      ];
    }

    return result;
  }

  static bool _stepsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }
}
