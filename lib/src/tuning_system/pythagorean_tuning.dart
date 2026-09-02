import 'dart:math' as math;

import '../cent/cent.dart';
import '../note/note.dart';
import '../pitch/pitch.dart';
import 'just_intonation.dart';

/// A representation of the three-limit (a.k.a. Pythagorean) tuning formatter.
///
/// See [Pythagorean tuning](https://en.wikipedia.org/wiki/Pythagorean_tuning).
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

    // `ratio` is the pitch-class ratio, always within [1, 2), e.g., as if
    // [pitch] were in the same octave as [fork]. The actual octave delta
    // between [pitch] and [fork] is derived (with its sign) from their real
    // semitone distance, discounting the octave already embedded in `ratio`.
    final realCents = fork.pitch.difference(pitch) * Cent.divisionsPerSemitone;
    final chainCents = Cent.fromRatio(ratio);
    final octaveDelta = ((realCents - chainCents) / Cent.octave).round();

    return ratio * math.pow(2, octaveDelta);
  }

  /// See [Pythagorean comma](https://en.wikipedia.org/wiki/Pythagorean_comma).
  num get pythagoreanComma => ratio(fork.pitch.transposeBy(.d2.descending));
}
