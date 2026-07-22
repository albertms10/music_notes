import 'package:meta/meta.dart' show immutable;

import '../celsius/celsius.dart';
import '../cent/cent.dart';
import '../frequency/frequency.dart';
import '../notation_system/notation_system.dart';
import '../pitch/pitch.dart';
import '../tuning_system/equal_temperament.dart';
import '../tuning_system/tuning_system.dart';
import 'standard_closest_pitch_notation.dart';

/// An abstraction of the closest representation of a [Frequency] as a [Pitch].
///
/// ---
/// See also:
/// * [Pitch].
/// * [Cent].
/// * [Frequency].
@immutable
class ClosestPitch implements Formattable<ClosestPitch> {
  /// The [Pitch] closest to the original [Frequency].
  final Pitch pitch;

  /// The difference in cents.
  final Cent cents;

  /// Creates a new [ClosestPitch] from [pitch] and [cents].
  const ClosestPitch(this.pitch, {this.cents = const Cent(0)});

  /// The chain of [StringParser]s used to parse a [ClosestPitch].
  static const parsers = [StandardClosestPitchNotation()];

  /// Parse [source] as a [ClosestPitch] and return its value.
  ///
  /// If the [source] string does not contain a valid [ClosestPitch], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ClosestPitch.parse('A4') == Note.a.inOctave(4) + const Cent(0)
  /// ClosestPitch.parse('A4+12.4') == Note.a.inOctave(4) + const Cent(12.4)
  /// ClosestPitch.parse('E♭3-28') == Note.e.flat.inOctave(3) - const Cent(28)
  /// ClosestPitch.parse('z') // throws a FormatException
  /// ```
  factory ClosestPitch.parse(
    String source, {
    List<StringParser<ClosestPitch>> chain = parsers,
  }) => chain.parse(source);

  /// The [Frequency] of this [ClosestPitch] from [tuningSystem] and
  /// [temperature].
  ///
  /// Example:
  /// ```dart
  /// (Note.a.inOctave(4) + const Cent(12)).frequency() == const Frequency(443)
  /// ```
  Frequency frequency({
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
    Celsius temperature = .reference,
    Celsius referenceTemperature = .reference,
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
  /// ClosestPitch.parse('A4+36').respelledSimple.format() == 'A4+36'
  /// ClosestPitch.parse('C#2+16').respelledSimple.format() == 'D♭2+16'
  /// ClosestPitch.parse('Bb3+67').respelledSimple.format() == 'B3-32'
  /// ClosestPitch.parse('F#5-152').respelledSimple.format() == 'E5+48'
  /// ```
  ClosestPitch get respelledSimple => frequency().closestPitch();

  /// The string representation of this [ClosestPitch] record.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440).closestPitch().format() == 'A4'
  /// const Frequency(228.9).closestPitch().format() == 'A♯3-31'
  /// (Note.g.inOctave(2) + const Cent(2)).format() == 'G2+2'
  /// (Note.e.flat.inOctave(3) - const Cent(14.6)).format() == 'E♭3-15'
  /// ```
  @override
  String format([
    StringFormatter<ClosestPitch> formatter =
        const StandardClosestPitchNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(pitch: $pitch, cents: $cents)';

  /// Adds [cents] to this [ClosestPitch].
  ///
  /// Example:
  /// ```dart
  /// ClosestPitch.parse('A4+8') + const Cent(12) == .parse('A4+20')
  /// ```
  ClosestPitch operator +(Cent cents) =>
      ClosestPitch(pitch, cents: Cent(this.cents + cents));

  /// Subtracts [cents] from this [ClosestPitch].
  ///
  /// Example:
  /// ```dart
  /// ClosestPitch.parse('A4+8') - const Cent(12) == .parse('A4-4')
  /// ```
  ClosestPitch operator -(Cent cents) =>
      ClosestPitch(pitch, cents: Cent(this.cents - cents));

  @override
  bool operator ==(Object other) =>
      other is ClosestPitch && pitch == other.pitch && cents == other.cents;

  @override
  int get hashCode => Object.hash(pitch, cents);
}
