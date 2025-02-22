import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../tuning/cent.dart';
import '../tuning/equal_temperament.dart';
import '../tuning/temperature.dart';
import '../tuning/tuning_system.dart';
import 'frequency.dart';
import 'pitch.dart';

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

  /// The [Frequency] of this [ClosestPitch] from [tuningSystem] and
  /// [temperature].
  ///
  /// Example:
  /// ```dart
  /// (Note.a.inOctave(4) + const Cent(12)).frequency() == const Frequency(443)
  /// ```
  Frequency frequency({
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
    Celsius temperature = Celsius.reference,
    Celsius referenceTemperature = Celsius.reference,
  }) => Frequency(
    pitch.frequency(
          tuningSystem: tuningSystem,
          temperature: temperature,
          referenceTemperature: referenceTemperature,
        ) *
        cents.ratio,
  );

  /// Respells this [ClosestPitch] to the simplest expression possible.
  ///
  /// Example:
  /// ```dart
  /// ClosestPitch.parse('A4+36').respelledSimple.toString() == 'A4+36'
  /// ClosestPitch.parse('C#2+16').respelledSimple.toString() == 'D♭2+16'
  /// ClosestPitch.parse('Bb3+67').respelledSimple.toString() == 'B3-32'
  /// ClosestPitch.parse('F#5-152').respelledSimple.toString() == 'E5+48'
  /// ```
  ClosestPitch get respelledSimple => frequency().closestPitch();

  /// The string representation of this [ClosestPitch] record.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440).closestPitch().toString() == 'A4'
  /// const Frequency(228.9).closestPitch().toString() == 'A♯3-31'
  /// (Note.g.inOctave(2) + const Cent(2)).toString() == 'G2+2'
  /// (Note.e.flat.inOctave(3) - const Cent(14.6)).toString() == 'E♭3-15'
  /// ```
  @override
  String toString() {
    final roundedCents = cents.round();
    if (roundedCents == 0) return '$pitch';

    return '$pitch${roundedCents.toDeltaString()}';
  }

  /// Adds [cents] to this [ClosestPitch].
  ///
  /// Example:
  /// ```dart
  /// ClosestPitch.parse('A4+8') + const Cent(12) == ClosestPitch.parse('A4+20')
  /// ```
  ClosestPitch operator +(Cent cents) =>
      ClosestPitch(pitch, cents: Cent(this.cents + cents));

  /// Subtracts [cents] from this [ClosestPitch].
  ///
  /// Example:
  /// ```dart
  /// ClosestPitch.parse('A4+8') - const Cent(12) == ClosestPitch.parse('A4-4')
  /// ```
  ClosestPitch operator -(Cent cents) =>
      ClosestPitch(pitch, cents: Cent(this.cents - cents));

  @override
  bool operator ==(Object other) =>
      other is ClosestPitch && pitch == other.pitch && cents == other.cents;

  @override
  int get hashCode => Object.hash(pitch, cents);
}
