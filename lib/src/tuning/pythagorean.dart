import 'dart:math' as math;

import 'package:meta/meta.dart' show immutable;

import '../interval/interval.dart';
import '../note/pitch.dart';
import 'equal_temperament.dart';
import 'just_intonation.dart';

/// A representation of the three-limit (a.k.a. Pythagorean) tuning formatter.
///
/// See [Pythagorean tuning](https://en.wikipedia.org/wiki/Pythagorean_tuning).
@immutable
class PythagoreanTuning extends JustIntonation {
  /// Creates a new [PythagoreanTuning] from [fork].
  const PythagoreanTuning({super.fork});

  @override
  num ratio(Pitch pitch) {
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);
    var ratio = 1.0;
    for (var i = 1; i <= distance.abs(); i++) {
      ratio *= distance.isNegative
          ? JustIntonation.ascendingFourthRatio
          : JustIntonation.ascendingFifthRatio;
      // When ratio is greater than 2, so greater than [Size.octave],
      // divide by 2 to transpose it down by one octave.
      if (ratio >= 2) ratio /= 2;
    }

    final octaveDelta =
        pitch.interval(fork.pitch).semitones.abs() ~/ chromaticDivisions;

    return ratio * math.pow(2, octaveDelta);
  }

  /// See [Pythagorean comma](https://en.wikipedia.org/wiki/Pythagorean_comma).
  num get pythagoreanComma => ratio(fork.pitch.transposeBy(-Interval.d2));
}
