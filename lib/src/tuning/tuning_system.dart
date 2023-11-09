part of '../../music_notes.dart';

/// A tuning system representation.
@immutable
sealed class TuningSystem {
  /// The reference note from which this [TuningSystem] is tuned.
  final Pitch referenceNote;

  /// Creates a new [TuningSystem].
  const TuningSystem({required this.referenceNote});

  /// Returns the number of [Cent] for the generator at [Interval.P5] in this
  /// [TuningSystem].
  ///
  /// Example:
  /// ```dart
  /// const PythagoreanTuning().generatorCents == const Cent(701.96)
  /// const EqualTemperament.edo12().generatorCents == const Cent(700)
  /// const EqualTemperament.edo19().generatorCents == const Cent(694.74)
  /// ```
  ///
  /// ![Temperaments](https://upload.wikimedia.org/wikipedia/commons/4/4c/Rank-2_temperaments_with_the_generator_close_to_a_fifth_and_period_an_octave.jpg)
  Cent get generator;

  /// Returns the [Ratio] from [note] in this [TuningSystem].
  ///
  /// Example:
  /// ```dart
  /// final pt = PythagoreanTuning(referenceNote: Note.c.inOctave(4));
  /// pt.ratioFromNote(Note.d.inOctave(4)) == const Ratio(9 / 8)
  /// pt.ratioFromNote(Note.f.inOctave(4)) == const Ratio(4 / 3)
  ///
  /// final edo12 = EqualTemperament.edo12(referenceNote: Note.a.inOctave(4));
  /// edo12.ratioFromNote(Note.b.inOctave(4)) == const Ratio(1.12)
  /// edo12.ratioFromNote(Note.d.inOctave(5)) == const Ratio(1.33)
  /// ```
  Ratio ratio(Pitch note);
}
