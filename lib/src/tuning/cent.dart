import 'dart:math' as math;

import 'package:meta/meta.dart' show redeclare;

import '../interval/interval.dart';
import '../music.dart';
import 'tuning_system.dart';

/// See [Cent (Wikipedia)](https://en.wikipedia.org/wiki/Cent_(music)) and
/// [Cent (Xenharmonic Wiki)](https://en.xen.wiki/w/Cent).
///
/// ---
/// See also:
/// * [TuningSystem].
extension type const Cent(num value) implements num {
  /// The unit symbol for [Cent].
  static const unitSymbol = '¢';

  /// The [Cent] divisions per semitone.
  static const divisionsPerSemitone = Cent(100);

  /// The number of cents in an [Interval.P8].
  static const octave = Cent(chromaticDivisions * divisionsPerSemitone);

  /// The [Cent] value from [ratio].
  ///
  /// Example:
  /// ```dart
  /// const pt = PythagoreanTuning();
  /// Cent.fromRatio(pt.ratio(Note.f.inOctave(4))) == const Cent(498.04)
  /// Cent.fromRatio(pt.ratio(Note.g.inOctave(4))) == const Cent(701.96)
  ///
  /// const edo12 = EqualTemperament.edo12();
  /// Cent.fromRatio(edo12.ratioFromSemitones(1)) == const Cent(100)
  /// Cent.fromRatio(edo12.ratioFromSemitones(6)) == const Cent(600)
  ///
  /// const edo19 = EqualTemperament.edo19();
  /// Cent.fromRatio(edo19.ratioFromSemitones(1)) == const Cent(63.16)
  /// Cent.fromRatio(edo19.ratioFromSemitones(10)) == const Cent(631.58)
  /// ```
  Cent.fromRatio(num ratio) : value = math.log(ratio) / math.log(2) * octave;

  /// The ratio for this [Cent].
  num get ratio => math.pow(2, value / octave);

  /// This [Cent] formatted as a string.
  ///
  /// Example:
  /// ```dart
  /// const Cent(700).format() == '700 ¢'
  /// const Cent(701.95).format() == '701.95 ¢'
  /// ```
  String format() => '$value $unitSymbol';

  /// The negation of this [Cent].
  ///
  /// Example:
  /// ```dart
  /// -const Cent(24) == const Cent(-24)
  /// -const Cent(-18.32) == const Cent(18.32)
  /// ```
  @redeclare
  Cent operator -() => Cent(-value);
}
