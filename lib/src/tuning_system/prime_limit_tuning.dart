import 'dart:math' as math;

import 'package:meta/meta.dart' show immutable;

import '../cent/cent.dart';
import '../note/note.dart';
import '../pitch/pitch.dart';
import 'just_intonation.dart';

/// A single generator axis for a [PrimeLimitTuning], beyond the base chain
/// of fifths (3/2), like the five-limit’s major third (5/4), or the
/// seven-limit’s harmonic seventh (7/4).
///
/// [fifthsEquivalence] is the number of ascending fifths that one ascending
/// step of [ascendingRatio] conventionally stands in for, up to the comma
/// linking the two. It is not a separate choice you make: it’s discovered by
/// finding the *fewest* fifths (positive or negative) whose octave-folded
/// position lands close enough to [ascendingRatio] to call the difference
/// a comma rather than a different interval. For the major third, that’s
/// 4 fifths, off by the [JustIntonation.syntonicCommaRatio] (~21.5 cents);
/// for the harmonic seventh, -2 fifths, off by the septimal comma, 64/63
/// (~27.3 cents).
///
/// “Fewest fifths, small enough comma” is what reproduces the
/// historically established relationship: naively searching for the
/// single *closest* match at any depth instead would find, for the major
/// third, -8 fifths (off by under 2 cents): mathematically nearer, but not
/// the syntonic comma anyone actually uses.
@immutable
class PrimeLimitGenerator {
  /// The generator ratio itself, e.g. 5/4 for the major third.
  final num ascendingRatio;

  /// The number of ascending fifths this generator stands in for, up to a
  /// comma. See the class documentation for how this is derived.
  final int fifthsEquivalence;

  /// Creates a [PrimeLimitGenerator] for [ascendingRatio], deriving
  /// [fifthsEquivalence] by searching fifths counts of increasing
  /// magnitude (up to [maxFifths]) for the first one within
  /// [commaThreshold] cents of [ascendingRatio].
  ///
  /// Throws a [StateError] if no such count exists within [maxFifths], 
  /// meaning [ascendingRatio] isn’t closely approximated by any small
  /// chain of fifths, so a [PrimeLimitGenerator] isn’t a good fit for it.
  factory PrimeLimitGenerator(
    num ascendingRatio, {
    int maxFifths = 12,
    num commaThreshold = 50,
  }) => PrimeLimitGenerator._(
    ascendingRatio,
    _deriveFifthsEquivalence(ascendingRatio, maxFifths, commaThreshold),
  );

  const PrimeLimitGenerator._(this.ascendingRatio, this.fifthsEquivalence);

  /// The five-limit major third (5/4), 4 ascending fifths away up to the
  /// syntonic comma.
  static final majorThird = PrimeLimitGenerator(5 / 4);

  /// The seven-limit harmonic seventh (7/4), 2 descending fifths away up
  /// to the septimal comma (64/63).
  static final harmonicSeventh = PrimeLimitGenerator(7 / 4);

  static int _deriveFifthsEquivalence(
    num ascendingRatio,
    int maxFifths,
    num commaThreshold,
  ) {
    final target = Cent.fromRatio(ascendingRatio) % Cent.octave;
    for (var magnitude = 0; magnitude <= maxFifths; magnitude++) {
      for (final n in {magnitude, -magnitude}) {
        final candidate = (n * JustIntonation.generatorCents) % Cent.octave;
        final distance = math.min(
          (candidate - target).abs(),
          Cent.octave - (candidate - target).abs(),
        );
        if (distance < commaThreshold) return n;
      }
    }
    throw StateError(
      'No chain of at most $maxFifths fifths approximates $ascendingRatio '
      'within $commaThreshold cents.',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PrimeLimitGenerator &&
      ascendingRatio == other.ascendingRatio &&
      fifthsEquivalence == other.fifthsEquivalence;

  @override
  int get hashCode => Object.hash(ascendingRatio, fifthsEquivalence);

  @override
  String toString() =>
      'PrimeLimitGenerator($ascendingRatio, '
      'fifthsEquivalence: $fifthsEquivalence)';
}

/// A specific point on a [PrimeLimitTuning]’s lattice: `fifths` ascending
/// fifths, plus `steps` ascending generator steps (one entry per
/// [PrimeLimitTuning.generators], in the same order) together with the
/// resulting pitch-class `ratio`.
///
/// `isCanonical` marks the specific path [PrimeLimitTuning.ratio] actually
/// uses for a given note.
///
/// ---
/// See also:
///  * [PrimeLimitTuning.pathsTo].
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
/// [PrimeLimitTuning] captures that shape once. For a given note, its
/// three-limit fifths distance is resolved sequentially across
/// [generators], in order: each one claims the nearest whole number of
/// its own steps, leaving the remainder for the next axis, with any final
/// leftover absorbed by the fifths themselves.
///
/// ## Where convention ends and judgment begins
///
/// Three-limit and five-limit tuning have essentially one accepted
/// generator each ([threeLimit] has none to choose; [fiveLimit]’s major
/// third reproduces the conventional 12-tone “asymmetric” 5-limit scale,
/// per [Five-limit tuning](https://en.wikipedia.org/wiki/Five-limit_tuning)).
/// Beyond that, there generally isn’t a single settled choice—not just of
/// which comma to use, but of which notes should even be reinterpreted at
/// all: a later axis resolved the same way as the third can silently
/// “absorb” notes that were never meant to change (a five-limit whole
/// tone can land exactly on one descending seventh step, for instance,
/// with no numeric way to tell that apart from the minor seventh
/// genuinely becoming the harmonic seventh).
///
/// [manualGenerators] holds axes exactly like [generators], except
/// [ratio] never auto-resolves them—they only ever contribute `0` there.
/// [sevenLimitSeptimal] puts the harmonic seventh here: [ratio] matches
/// [fiveLimit] for every note, and the harmonic seventh is reached
/// deliberately, via [pathsTo] or [pitchClassRatioFrom], rather than
/// guessed.
class PrimeLimitTuning extends JustIntonation {
  /// The generator axes [ratio] resolves automatically, in order.
  final List<PrimeLimitGenerator> generators;

  /// Generator axes available via [pathsTo] and [pitchClassRatioFrom], but
  /// never auto-resolved by [ratio]—see the class documentation for why.
  final List<PrimeLimitGenerator> manualGenerators;

  /// Creates a new [PrimeLimitTuning] from [generators], [manualGenerators]
  /// and [fork].
  const PrimeLimitTuning(
    this.generators, {
    this.manualGenerators = const [],
    super.fork,
  });

  /// Three-limit (Pythagorean) tuning: no generators beyond the fifth.
  static const threeLimit = PrimeLimitTuning([]);

  /// Five-limit tuning: adds the major third.
  static final fiveLimit = PrimeLimitTuning([PrimeLimitGenerator.majorThird]);

  /// Seven-limit tuning using the septimal comma: adds the major third
  /// (auto-resolved, as in [fiveLimit]) and the harmonic seventh (manual).
  ///
  /// [ratio] matches [fiveLimit] for every note. Reach the harmonic
  /// seventh (and other septimal alternatives) explicitly via [pathsTo] or
  /// [pitchClassRatioFrom].
  static final sevenLimitSeptimal = PrimeLimitTuning(
    [PrimeLimitGenerator.majorThird],
    manualGenerators: [PrimeLimitGenerator.harmonicSeventh],
  );

  /// All generator axes beyond the fifth, [generators] followed by
  /// [manualGenerators], in the order [pitchClassRatioFrom]’s `steps` and
  /// [pathsTo]’s [PrimeLimitPath.steps] are indexed.
  List<PrimeLimitGenerator> get _allGenerators => [
    ...generators,
    ...manualGenerators,
  ];

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
  /// fifths plus [steps] ascending generator steps—matching
  /// [_allGenerators] pairwise, in order—independent of any particular
  /// [Note] spelling.
  ///
  /// This is the building block behind [ratio] and [pathsTo]: rather than
  /// resolving which coordinates best represent a note, it lets you choose
  /// the lattice point directly.
  num pitchClassRatioFrom({required int fifths, required List<int> steps}) {
    final allGenerators = _allGenerators;
    if (steps.length != allGenerators.length) {
      throw ArgumentError.value(
        steps,
        'steps',
        'Must have exactly ${allGenerators.length} entries, matching '
            'generators followed by manualGenerators.',
      );
    }

    var ratio = chainRatio(fifths, fifthRatio);
    for (var i = 0; i < allGenerators.length; i++) {
      ratio = foldIntoOctave(
        ratio * chainRatio(steps[i], allGenerators[i].ascendingRatio),
      );
    }

    return ratio;
  }

  /// Every combination of generator steps—each within [maxSteps] of
  /// zero—that reaches the same pitch class as [pitch]’s note, together
  /// with the fifths needed to complete each path and the ratio it
  /// produces.
  ///
  /// Adjacent values along a single axis differ by exactly that
  /// generator’s comma—except where the step also crosses an octave fold,
  /// which additionally doubles or halves it.
  List<PrimeLimitPath> pathsTo(Pitch pitch, {int maxSteps = 3}) {
    final allGenerators = _allGenerators;
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);
    final canonical = _resolveCoordinates(distance);
    final window = [for (var s = -maxSteps; s <= maxSteps; s++) s];

    return [
      for (final steps in _cartesianProduct(
        List.filled(allGenerators.length, window),
      ))
        (
          fifths: distance - _weightedSum(steps, allGenerators),
          steps: steps,
          ratio: pitchClassRatioFrom(
            fifths: distance - _weightedSum(steps, allGenerators),
            steps: steps,
          ),
          isCanonical: _stepsEqual(steps, canonical.steps),
        ),
    ];
  }

  /// Resolves the canonical (fifths, steps) coordinates for
  /// [fifthsDistance]: [generators] each claim the nearest whole number of
  /// their own steps in order, minimizing what’s left over at each stage
  /// and handing the remainder down the chain; [manualGenerators] always
  /// contribute `0` here (see the class documentation for why); any final
  /// leftover is absorbed by the fifths.
  ({int fifths, List<int> steps}) _resolveCoordinates(int fifthsDistance) {
    var remaining = fifthsDistance;
    final steps = <int>[];
    for (final generator in generators) {
      final count = _nearestSteps(remaining, generator.fifthsEquivalence);
      steps.add(count);
      remaining -= count * generator.fifthsEquivalence;
    }
    steps.addAll(List.filled(manualGenerators.length, 0));

    return (fifths: remaining, steps: steps);
  }

  int _weightedSum(List<int> steps, List<PrimeLimitGenerator> allGenerators) {
    var sum = 0;
    for (var i = 0; i < steps.length; i++) {
      sum += steps[i] * allGenerators[i].fifthsEquivalence;
    }

    return sum;
  }

  /// The number of steps of a generator with [fifthsEquivalence]—each
  /// standing in for that many fifths, up to a comma—that best
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
