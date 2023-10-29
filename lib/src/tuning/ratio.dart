part of '../../music_notes.dart';

/// A representation of a ratio.
@immutable
final class Ratio {
  /// The value of the ratio.
  final num value;

  /// Creates a new [Ratio] from [value].
  const Ratio(this.value)
      : assert(value > 0, 'Value must be positive, non-zero');

  /// Returns the number of cents for this [Ratio].
  ///
  /// Example:
  /// ```dart
  /// const pt = PythagoreanTuning();
  /// pt.ratio(Note.f.inOctave(4)).cents == const Cent(498.04)
  /// pt.ratio(Note.g.inOctave(4)).cents == const Cent(701.96)
  ///
  /// const edo12 = EqualTemperament.edo12();
  /// edo12.ratioFromSemitones().cents == const Cent(100)
  /// edo12.ratioFromSemitones(6).cents == const Cent(600)
  ///
  /// const edo19 = EqualTemperament.edo19();
  /// edo19.ratioFromSemitones().cents == const Cent(63.16)
  /// edo19.ratioFromSemitones(10).cents == const Cent(631.58)
  /// ```
  Cent get cents => Cent(math.log(value) / math.log(2) * Cent.octaveCents);

  @override
  String toString() => '$value';

  @override
  bool operator ==(Object other) => other is Ratio && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
