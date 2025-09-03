import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../notation_system.dart';
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
    List<Parser<ClosestPitch>> chain = const [StandardClosestPitchNotation()],
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
  String toString({
    Formatter<ClosestPitch> formatter = const StandardClosestPitchNotation(),
  }) => formatter.format(this);

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

/// The [NotationSystem] for standard [ClosestPitch].
class StandardClosestPitchNotation extends NotationSystem<ClosestPitch> {
  /// The [NotationSystem] for [Pitch] notation.
  final NotationSystem<Pitch> pitchNotation;

  /// Whether to use ASCII characters instead of Unicode characters.
  final bool _useAscii;

  /// Creates a new [StandardClosestPitchNotation].
  const StandardClosestPitchNotation({
    this.pitchNotation = ScientificPitchNotation.english,
  }) : _useAscii = false;

  /// Creates a new [StandardClosestPitchNotation] using ASCII characters.
  const StandardClosestPitchNotation.ascii({
    this.pitchNotation = const ScientificPitchNotation.ascii(),
  }) : _useAscii = true;

  @override
  RegExp get regExp => RegExp(
    '${pitchNotation.regExp?.pattern}\\s*'
    '(?<cents>[+-${NumExtension.minusSign}]\\d+(?:\\.\\d+)?)?',
    caseSensitive: false,
  );

  @override
  ClosestPitch parseMatch(RegExpMatch match) => ClosestPitch(
    pitchNotation.parseMatch(match),
    cents: Cent(num.parse(match.namedGroup('cents')?.toNegativeAscii() ?? '0')),
  );

  @override
  String format(ClosestPitch closestPitch) {
    final roundedCents = closestPitch.cents.round();
    final pitch = closestPitch.pitch.toString(formatter: pitchNotation);
    if (roundedCents == 0) return pitch;

    return '$pitch${roundedCents.toDeltaString(useAscii: _useAscii)}';
  }
}
