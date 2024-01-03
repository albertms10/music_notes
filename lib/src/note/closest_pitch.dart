part of '../../music_notes.dart';

/// An abstraction of the closest representation of a [Frequency] as a [Pitch].
@immutable
class ClosestPitch {
  /// The pitch closest to the original [Frequency].
  final Pitch pitch;

  /// The difference in cents.
  final Cent cents;

  /// The difference in hertz.
  final double hertz;

  /// Creates a new [ClosestPitch] from [pitch], [cents] and [hertz].
  const ClosestPitch(this.pitch, {this.cents = const Cent(0), this.hertz = 0});

  /// Returns the string representation of this [ClosestPitch] record.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440).closestPitch().toString() == 'A4'
  /// const Frequency(98.1).closestPitch().toString() == 'G2+2'
  /// const Frequency(163.5).closestPitch().toString() == 'E3-14'
  /// const Frequency(228.9).closestPitch().toString() == 'A♯3-31'
  /// ```
  @override
  String toString() {
    final roundedCents = cents.value.round();
    if (roundedCents == 0) return '$pitch';

    return '$pitch${roundedCents.toDeltaString()}';
  }

  @override
  bool operator ==(Object other) =>
      other is ClosestPitch &&
      pitch == other.pitch &&
      cents == other.cents &&
      hertz == other.hertz;

  @override
  int get hashCode => Object.hash(pitch, cents, hertz);
}
