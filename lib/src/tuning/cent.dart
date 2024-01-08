part of '../../music_notes.dart';

/// See [Cent (Wikipedia)](https://en.wikipedia.org/wiki/Cent_(music)) and
/// [Cent (Xenharmonic Wiki)](https://en.xen.wiki/w/Cent).
///
/// ---
/// See also:
/// * [TuningSystem].
extension type const Cent(num value) implements num {
  /// The unit symbol for [Cent].
  static const unitSymbol = '¢';

  /// The number of cents in an [Interval.P8].
  static const octaveCents = Cent(chromaticDivisions * 100);

  /// Returns the [Ratio] for this [Cent].
  Ratio get ratio => Ratio(math.pow(2, value / octaveCents));

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
