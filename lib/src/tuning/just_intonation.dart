import 'dart:math' as math;

import 'package:meta/meta.dart' show immutable;

import '../interval/interval.dart';
import '../music.dart';
import '../note/note.dart';
import '../note/pitch.dart';
import 'cent.dart';
import 'ratio.dart';
import 'tuning_system.dart';

/// A representation of a just tuning system.
///
/// See [Just intonation](https://en.wikipedia.org/wiki/Just_intonation).
///
/// ---
/// See also:
/// * [TuningSystem].
@immutable
sealed class JustIntonation extends TuningSystem {
  /// Creates a new [JustIntonation] from [referencePitch].
  const JustIntonation({
    super.referencePitch = const Pitch(Note.c, octave: 4),
  });

  /// The [Ratio] of an ascending [Interval.P5].
  static const ascendingFifthRatio = Ratio(3 / 2);

  /// The [Ratio] of an ascending [Interval.P4].
  static const ascendingFourthRatio = Ratio(4 / 3);

  /// See [Syntonic comma](https://en.wikipedia.org/wiki/Syntonic_comma)
  /// (a.k.a. Didymean comma).
  static const syntonicComma = Ratio((81 / 64) / (5 / 4));

  @override
  Cent get generator => ascendingFifthRatio.cents;
}

/// A representation of the three-limit (a.k.a Pythagorean) tuning system.
///
/// See [Pythagorean tuning](https://en.wikipedia.org/wiki/Pythagorean_tuning).
@immutable
class PythagoreanTuning extends JustIntonation {
  /// Creates a new [PythagoreanTuning] from [referencePitch].
  const PythagoreanTuning({super.referencePitch});

  @override
  Ratio ratio(Pitch pitch) {
    final distance = referencePitch.note.fifthsDistanceWith(pitch.note);
    var ratio = 1.0;
    for (var i = 1; i <= distance.abs(); i++) {
      ratio *= distance.isNegative
          ? JustIntonation.ascendingFourthRatio.value
          : JustIntonation.ascendingFifthRatio.value;
      // When ratio is greater than 2, so greater than [Size.octave],
      // divide by 2 to transpose it down by one octave.
      if (ratio >= 2) ratio /= 2;
    }

    final octaveDelta =
        pitch.interval(referencePitch).semitones.abs() ~/ chromaticDivisions;

    return Ratio(ratio * math.pow(2, octaveDelta));
  }

  /// See [Pythagorean comma](https://en.wikipedia.org/wiki/Pythagorean_comma).
  Ratio get pythagoreanComma => ratio(referencePitch.transposeBy(-Interval.d2));
}
