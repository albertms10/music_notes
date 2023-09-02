part of '../../music_notes.dart';

/// A tuning system representation.
@immutable
sealed class TuningSystem {
  /// The reference note from which this [TuningSystem] is tuned.
  final PositionedNote referenceNote;

  /// Creates a new [TuningSystem].
  const TuningSystem({required this.referenceNote});

  /// The number of cents in an [Interval.P8].
  static const int octaveCents = 1200;

  /// Returns the number of cents for the generator at [Interval.P5].
  double get generatorCents;

  /// Returns the number of cents for [ratio] in this [TuningSystem].
  ///
  /// See [Cent](https://en.wikipedia.org/wiki/Cent_(music)).
  ///
  /// Example:
  /// ```dart
  /// const pt = PythagoreanTuning();
  /// TuningSystem.cents(pt.ratioFromNote(Note.f.inOctave(4))) == 498.04
  /// TuningSystem.cents(pt.ratioFromNote(Note.g.inOctave(4))) == 701.96
  ///
  /// const edo12 = EqualTemperament.edo12;
  /// TuningSystem.cents(edo12.ratio()) == 100
  /// TuningSystem.cents(edo12.ratio(6)) == 600
  ///
  /// const edo19 = EqualTemperament.edo19;
  /// TuningSystem.cents(edo19.ratio()) == 63.16
  /// TuningSystem.cents(edo19.ratio(10)) == 631.58
  /// ```
  static double cents(double ratio) =>
      math.log(ratio) / math.log(2) * octaveCents;

  /// Returns the ratio from [note] in this [TuningSystem].
  double ratioFromNote(PositionedNote note);

  /// Returns the cents from [note] in this [TuningSystem].
  double centsFromNote(PositionedNote note);
}
