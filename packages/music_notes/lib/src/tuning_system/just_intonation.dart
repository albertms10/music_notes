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

  @override
  num ratio(Pitch pitch) {
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);
    var ratio = 1.0;
    for (var i = 1; i <= distance.abs(); i++) {
      ratio *= distance.isNegative ? fourthRatio : fifthRatio;
      // When ratio is greater than 2, so greater than [Size.octave],
      // divide by 2 to transpose it down by one octave.
      if (ratio >= 2) ratio /= 2;
    }

    return octaveAdjustedRatio(pitch, ratio);
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
