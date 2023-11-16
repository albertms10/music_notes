part of '../../music_notes.dart';

/// See [Cent (Wikipedia)](https://en.wikipedia.org/wiki/Cent_(music)) and
/// [Cent (Xenharmonic Wiki)](https://en.xen.wiki/w/Cent).
///
/// ---
/// See also:
/// * [TuningSystem].
extension type const Cent(num value) {
  /// The unit symbol for cent.
  static const centUnitSymbol = '¢';

  /// The number of cents in an [Interval.P8].
  static const int octaveCents = chromaticDivisions * 100;

  /// Returns the [Ratio] for this [Cent].
  Ratio get ratio => Ratio(math.pow(2, value / octaveCents));
}
