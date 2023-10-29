part of '../../music_notes.dart';

/// See [Cent (Wikipedia)](https://en.wikipedia.org/wiki/Cent_(music)) and
/// [Cent (Xenharmonic Wiki)](https://en.xen.wiki/w/Cent).
@immutable
final class Cent {
  /// The value of this [Cent].
  final num value;

  /// Creates a new [Cent] from [value].
  const Cent(this.value);

  /// The unit symbol for cent.
  static const centUnitSymbol = '¢';

  /// The number of cents in an [Interval.P8].
  static const int octaveCents = chromaticDivisions * 100;

  /// Returns the ratio for this [Cent].
  Ratio get ratio => Ratio(math.pow(2, value / octaveCents));

  @override
  String toString() => '$value $centUnitSymbol';

  @override
  bool operator ==(Object other) => other is Cent && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
