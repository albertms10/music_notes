import 'dart:math' as math;

import 'package:meta/meta.dart' show protected;

import '../cent/cent.dart';
import '../interval/interval.dart';
import '../note/note.dart';
import '../pitch/pitch.dart';
import 'tuning_system.dart';

/// A representation of a just tuning.
///
/// See [Just intonation](https://en.wikipedia.org/wiki/Just_intonation).
///
/// ---
/// See also:
/// * [TuningSystem].
abstract class JustIntonation extends TuningSystem {
  /// Creates a new [JustIntonation] from [fork].
  const JustIntonation({super.fork = .c256});

  /// The ratio of an ascending [Interval.P5].
  static const ascendingFifthRatio = 3 / 2;

  /// The ratio of an ascending [Interval.P4].
  static const ascendingFourthRatio = 4 / 3;

  /// See [Syntonic comma](https://en.wikipedia.org/wiki/Syntonic_comma)
  /// (a.k.a. Didymean comma).
  static const syntonicCommaRatio = (81 / 64) / (5 / 4);

  /// The number of [Cent] for the generator at [Interval.P5].
  ///
  /// ---
  /// * See [TuningSystem.generator].
  static final generatorCents = Cent.fromRatio(ascendingFifthRatio);

  @override
  Cent get generator => generatorCents;

  /// The ratio of the ascending fifth used to build up the chain of fifths
  /// in this [JustIntonation] system.
  ///
  /// Defaults to the pure [ascendingFifthRatio] (3/2). Tempered subclasses
  /// (e.g. `MeantoneTuning`) override this with their own tempered fifth.
  num get fifthRatio => ascendingFifthRatio;

  /// The ratio of the ascending fourth, i.e. the octave complement of
  /// [fifthRatio] (a fourth and a fifth together span an octave).
  num get fourthRatio => 2 / fifthRatio;

  /// A measure of how far the enharmonic respelling via a descending
  /// [Interval.d2] deviates from unison in this [JustIntonation] system.
  ///
  /// For three-limit (Pythagorean) tuning this is the classic
  /// [Pythagorean comma](https://en.wikipedia.org/wiki/Pythagorean_comma)
  /// (~23.46 cents, from closing a chain of 12 fifths). Other systems
  /// generally close by a different amount (e.g., five-limit tuning closes
  /// by the [Diesis](https://en.wikipedia.org/wiki/Diesis) instead).
  num get comma => ratio(fork.pitch.transposeBy(.d2.descending));

  @override
  num ratio(Pitch pitch) {
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);

    return octaveAdjustedRatio(pitch, chainRatio(distance, fifthRatio));
  }

  /// Builds a pitch-class ratio by applying [ascendingRatio] (or its octave
  /// complement, `2 / ascendingRatio`, if [distance] is negative) up to
  /// [distance] times, folding the running product back into a single
  /// octave whenever it reaches `2`.
  ///
  /// The result always lies within `[1, 2)`.
  @protected
  num chainRatio(int distance, num ascendingRatio) {
    final descendingRatio = 2 / ascendingRatio;
    var ratio = 1.0;
    for (var i = 1; i <= distance.abs(); i++) {
      ratio *= distance.isNegative ? descendingRatio : ascendingRatio;
      // When ratio is greater than 2, so greater than [Size.octave],
      // divide by 2 to transpose it down by one octave.
      if (ratio >= 2) ratio /= 2;
    }

    return ratio;
  }

  /// Folds [ratio] into a single octave, i.e. `[1, 2)`.
  @protected
  num foldIntoOctave(num ratio) {
    var folded = ratio;
    while (folded >= 2) {
      folded /= 2;
    }
    while (folded < 1) {
      folded *= 2;
    }

    return folded;
  }

  /// Applies the correct octave transposition to [pitchClassRatio] for
  /// [pitch] relative to [fork].
  ///
  /// [pitchClassRatio] is assumed to lie within `[1, 2)`, i.e. as if [pitch]
  /// were in the same octave as [fork]. This method derives the real octave
  /// delta between [pitch] and [fork] from their real semitone distance,
  /// discounting the octave already embedded in [pitchClassRatio],
  /// and scales it accordingly.
  @protected
  num octaveAdjustedRatio(Pitch pitch, num pitchClassRatio) {
    final realCents = fork.pitch.difference(pitch) * Cent.divisionsPerSemitone;
    final chainCents = Cent.fromRatio(pitchClassRatio);
    final octaveDelta = ((realCents - chainCents) / Cent.octave).round();

    return pitchClassRatio * math.pow(2, octaveDelta);
  }
}
