part of '../../music_notes.dart';

/// A representation of a just tuning system.
///
/// See [Just intonation](https://en.wikipedia.org/wiki/Just_intonation).
@immutable
sealed class JustIntonation extends TuningSystem {
  /// Creates a new [JustIntonation] from [referenceNote].
  const JustIntonation({
    super.referenceNote = const Pitch(Note.c, octave: 4),
  });

  /// The [Ratio] of an ascending [Interval.P5].
  static const Ratio ascendingFifthRatio = Ratio(3 / 2);

  /// The [Ratio] of an ascending [Interval.P4].
  static const Ratio ascendingFourthRatio = Ratio(4 / 3);

  /// See [Syntonic comma](https://en.wikipedia.org/wiki/Syntonic_comma)
  /// (a.k.a. Didymean comma).
  static const Ratio syntonicComma = Ratio((81 / 64) / (5 / 4));

  @override
  Cent get generator => ascendingFifthRatio.cents;
}

/// A representation of the three-limit (a.k.a Pythagorean) tuning system.
///
/// See [Pythagorean tuning](https://en.wikipedia.org/wiki/Pythagorean_tuning).
@immutable
class PythagoreanTuning extends JustIntonation {
  /// Creates a new [PythagoreanTuning] from [referenceNote].
  const PythagoreanTuning({super.referenceNote});

  @override
  Ratio ratio(Pitch note) {
    final distance = referenceNote.note.fifthsDistanceWith(note.note);
    var ratio = 1.0;
    for (var i = 1; i <= distance.abs(); i++) {
      ratio *= distance.isNegative
          ? JustIntonation.ascendingFourthRatio.value
          : JustIntonation.ascendingFifthRatio.value;
      // When ratio is larger than 2, so larger than an octave, divide by 2 to
      // transpose it down by one octave.
      if (ratio >= 2) ratio /= 2;
    }

    final octaveDelta =
        note.interval(referenceNote).semitones.abs() ~/ chromaticDivisions;

    return Ratio(ratio * math.pow(2, octaveDelta));
  }

  /// See [Pythagorean comma](https://en.wikipedia.org/wiki/Pythagorean_comma).
  Ratio get pythagoreanComma => ratio(referenceNote.transposeBy(-Interval.d2));
}
