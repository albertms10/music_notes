import 'package:meta/meta.dart' show immutable;

import '../interval/interval.dart';
import '../note/pitch.dart';
import 'cent.dart';
import 'ratio.dart';

/// A tuning system representation.
///
/// ---
/// See also:
/// * [Pitch].
@immutable
abstract class TuningSystem {
  /// The reference [Pitch] from which this [TuningSystem] is tuned.
  final Pitch referencePitch;

  /// Creates a new [TuningSystem].
  const TuningSystem({required this.referencePitch});

  /// Returns the number of [Cent] for the generator at [Interval.P5] in this
  /// [TuningSystem].
  ///
  /// Example:
  /// ```dart
  /// const PythagoreanTuning().generator == const Cent(701.96)
  /// const EqualTemperament.edo12().generator == const Cent(700)
  /// const EqualTemperament.edo19().generator == const Cent(694.74)
  /// ```
  /// ---
  /// ![Temperaments](https://upload.wikimedia.org/wikipedia/commons/4/4c/Rank-2_temperaments_with_the_generator_close_to_a_fifth_and_period_an_octave.jpg)
  Cent get generator;

  /// Returns the [Ratio] from [pitch] in this [TuningSystem].
  ///
  /// Example:
  /// ```dart
  /// final pt = PythagoreanTuning(referencePitch: Note.c.inOctave(4));
  /// pt.ratio(Note.d.inOctave(4)) == const Ratio(9 / 8)
  /// pt.ratio(Note.f.inOctave(4)) == const Ratio(4 / 3)
  ///
  /// final edo12 = EqualTemperament.edo12(referencePitch: Note.a.inOctave(4));
  /// edo12.ratio(Note.b.inOctave(4)) == const Ratio(1.12)
  /// edo12.ratio(Note.d.inOctave(5)) == const Ratio(1.33)
  /// ```
  Ratio ratio(Pitch pitch);
}
