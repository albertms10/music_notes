part of '../../music_notes.dart';

/// An abstraction of the closest representation of a [Frequency] as a [Pitch].
///
/// ---
/// See also:
/// * [Pitch].
/// * [Cent].
/// * [Frequency].
@immutable
class ClosestPitch {
  /// The [Pitch] closest to the original [Frequency].
  final Pitch pitch;

  /// The difference in cents.
  final Cent cents;

  /// Creates a new [ClosestPitch] from [pitch] and [cents].
  const ClosestPitch(this.pitch, {this.cents = const Cent(0)});

  static final _regExp = RegExp(r'^(.*?\d+)([+-].+)?$');

  /// Parse [source] as a [ClosestPitch] and return its value.
  ///
  /// Example:
  /// ```dart
  /// ClosestPitch.parse('A4') == Note.a.inOctave(4) + const Cent(0)
  /// ClosestPitch.parse('A4+12.4') == Note.a.inOctave(4) + const Cent(12.4)
  /// ClosestPitch.parse('E♭3-28') == Note.e.flat.inOctave(3) - const Cent(28)
  /// ClosestPitch.parse('z') // throws a FormatException
  /// ```
  factory ClosestPitch.parse(String source) {
    final match = _regExp.firstMatch(source);
    if (match == null) throw FormatException('Invalid ClosestPitch', source);

    final digits = match[2];
    var cents = const Cent(0);
    if (digits != null) {
      final parsed = num.tryParse(digits);
      if (parsed == null) {
        throw FormatException(
          'Invalid ClosestPitch',
          source,
          // Adding 1 to skip the sign position.
          source.indexOf(digits) + 1,
        );
      }
      cents = Cent(parsed);
    }

    return ClosestPitch(Pitch.parse(match[1]!), cents: cents);
  }

  /// Returns the string representation of this [ClosestPitch] record.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440).closestPitch().toString() == 'A4'
  /// const Frequency(228.9).closestPitch().toString() == 'A♯3-31'
  /// (Note.g.inOctave(2) + const Cent(2)).toString() == 'G2+2'
  /// (Note.e.flat.inOctave(3) - const Cent(14)).toString() == 'E♭3-14'
  /// ```
  @override
  String toString() {
    final roundedCents = cents.value.round();
    if (roundedCents == 0) return '$pitch';

    return '$pitch${roundedCents.toDeltaString()}';
  }

  @override
  bool operator ==(Object other) =>
      other is ClosestPitch && pitch == other.pitch && cents == other.cents;

  @override
  int get hashCode => Object.hash(pitch, cents);
}
