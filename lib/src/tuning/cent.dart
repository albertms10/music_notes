part of '../../music_notes.dart';

/// See [Cent (Wikipedia)](https://en.wikipedia.org/wiki/Cent_(music)) and
/// [Cent (Xenharmonic Wiki)](https://en.xen.wiki/w/Cent).
///
/// ---
/// See also:
/// * [TuningSystem].
@immutable
final class Cent {
  /// The value of this [Cent].
  final num value;

  /// Creates a new [Cent] from [value].
  const Cent(this.value);

  /// The unit symbol for [Cent].
  static const unitSymbol = '¢';

  /// The number of cents in an [Interval.P8].
  static const octaveCents = chromaticDivisions * 100;

  /// Returns the [Ratio] for this [Cent].
  Ratio get ratio => Ratio(math.pow(2, value / octaveCents));

  @override
  String toString() => '$value $unitSymbol';

  /// The negation of this [Cent].
  ///
  /// Example:
  /// ```dart
  /// -const Cent(24) == const Cent(-24)
  /// -const Cent(-18.32) == const Cent(18.32)
  /// ```
  Cent operator -() => Cent(-value);

  @override
  bool operator ==(Object other) => other is Cent && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
