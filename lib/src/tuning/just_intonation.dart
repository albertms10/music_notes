part of '../../music_notes.dart';

/// A representation of a just tuning system.
///
/// See [Just intonation](https://en.wikipedia.org/wiki/Just_intonation).
@immutable
sealed class JustIntonation extends TuningSystem {
  /// Creates a new [JustIntonation] from [referenceNote].
  const JustIntonation({
    super.referenceNote = const PositionedNote(Note.c, octave: 4),
  });

  /// The ratio of an ascending [Interval.P5].
  static const double ascendingFifthRatio = 3 / 2;

  /// The ratio of an ascending [Interval.P4].
  static const double ascendingFourthRatio = 4 / 3;

  @override
  double get generatorCents => TuningSystem.cents(ascendingFifthRatio);
}

/// A representation of the Pythagorean tuning system.
///
/// See [Pythagorean tuning](https://en.wikipedia.org/wiki/Pythagorean_tuning).
@immutable
class PythagoreanTuning extends JustIntonation {
  /// Creates a new [PythagoreanTuning] from [referenceNote].
  const PythagoreanTuning({super.referenceNote});

  @override
  double ratioFromNote(PositionedNote note) {
    final distance = referenceNote.note.fifthsDistanceWith(note.note);
    var ratio = 1.0;
    for (var i = 1; i <= distance.abs(); i++) {
      ratio *= distance.isNegative
          ? JustIntonation.ascendingFourthRatio
          : JustIntonation.ascendingFifthRatio;
      // When ratio is larger than 2, so larger than an octave, divide by 2 to
      // transpose it down by one octave.
      if (ratio >= 2) ratio /= 2;
    }
    return ratio *
        math.pow(
          2,
          note.interval(referenceNote).semitones.abs() ~/ chromaticDivisions,
        );
  }

  @override
  double centsFromNote(PositionedNote note) =>
      referenceNote.note.fifthsDistanceWith(note.note) *
      generatorCents %
      TuningSystem.octaveCents;

  /// See [Pythagorean comma](https://en.wikipedia.org/wiki/Pythagorean_comma).
  ({double ratio, double cents}) get pythagoreanComma {
    final enharmonicReference = referenceNote.transposeBy(-Interval.d2);

    return (
      ratio: ratioFromNote(enharmonicReference),
      cents: centsFromNote(enharmonicReference) - centsFromNote(referenceNote)
    );
  }
}
