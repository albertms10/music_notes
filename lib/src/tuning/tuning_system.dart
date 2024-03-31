import 'package:meta/meta.dart' show immutable;

import '../interval/interval.dart';
import '../note/pitch.dart';
import 'cent.dart';
import 'ratio.dart';
import 'tuning_fork.dart';

/// A tuning system representation.
///
/// ---
/// See also:
/// * [Pitch].
@immutable
abstract class TuningSystem {
  /// The [TuningFork] from which this [TuningSystem] is based.
  final TuningFork fork;

  /// Creates a new [TuningSystem].
  const TuningSystem({required this.fork});

  /// The number of [Cent] for the generator at [Interval.P5] in this
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

  /// The [Ratio] from [pitch] in this [TuningSystem].
  ///
  /// Example:
  /// ```dart
  /// final edo12 = EqualTemperament.edo12();
  /// edo12.ratio(Note.b.inOctave(4)) == const Ratio(1.12)
  /// edo12.ratio(Note.d.inOctave(5)) == const Ratio(1.33)
  ///
  /// final pt = PythagoreanTuning(fork: TuningFork.c256);
  /// pt.ratio(Note.d.inOctave(4)) == const Ratio(9 / 8)
  /// pt.ratio(Note.f.inOctave(4)) == const Ratio(4 / 3)
  /// ```
  Ratio ratio(Pitch pitch);
}
