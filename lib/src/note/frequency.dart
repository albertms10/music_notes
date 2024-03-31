import '../tuning/equal_temperament.dart';
import '../tuning/ratio.dart';
import '../tuning/temperature.dart';
import '../tuning/tuning_system.dart';
import 'closest_pitch.dart';
import 'hearing_range.dart';
import 'pitch.dart';
import 'pitch_class.dart';

/// Represents an absolute pitch, a physical frequency.
///
/// ---
/// See also:
/// * [Pitch].
/// * [ClosestPitch].
extension type const Frequency._(num hertz) implements num {
  /// Creates a new [Frequency] instance from [hertz].
  const Frequency(this.hertz) : assert(hertz >= 0, 'Hertz must be positive.');

  /// The symbol for the Hertz unit.
  static const hertzUnitSymbol = 'Hz';

  /// The standard reference [Frequency].
  static const reference = Frequency(440);

  /// Whether this [Frequency] is inside the [HearingRange.human].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(880).isHumanAudible == true
  /// Note.a.inOctave(4).frequency().isHumanAudible == true
  /// Note.g.inOctave(12).frequency().isHumanAudible == false
  /// ```
  bool get isHumanAudible => HearingRange.human.isAudible(this);

  /// The [ClosestPitch] to this [Frequency] from [tuningSystem] and
  /// [temperature].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(467).closestPitch()
  ///   == Note.a.sharp.inOctave(4) + const Cent(3.1028)
  ///
  /// const Frequency(260).closestPitch()
  ///   == Note.c.inOctave(4) - const Cent(10.7903)
  ///
  /// const Frequency(440).closestPitch(temperature: const Celsius(24))
  ///   == Note.a.inOctave(4) - const Cent(12.06)
  /// ```
  ///
  /// This method and [ClosestPitch.frequency] are inverses of each other for a
  /// specific input `frequency`.
  ///
  /// ```dart
  /// const reference = Frequency(415);
  /// reference.closestPitch().frequency() == reference;
  /// ```
  ClosestPitch closestPitch({
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
    Celsius temperature = Celsius.reference,
  }) {
    final cents = Ratio(at(temperature) / tuningSystem.fork.frequency).cents;
    final semitones = tuningSystem.fork.pitch.semitones + (cents / 100).round();

    final closestPitch = PitchClass(semitones)
        .resolveClosestSpelling()
        .inOctave(Pitch.octaveFromSemitones(semitones));

    final closestPitchFrequency = closestPitch.frequency(
      tuningSystem: tuningSystem,
      temperature: temperature,
    );
    final hertzDelta = hertz - closestPitchFrequency;

    // Whether `closestPitch` is closer to the upwards spelling (so, positive
    // `hertzDelta`), e.g. `Accidental.flat` instead of `Accidental.sharp`.
    final isCloserToUpwardsSpelling =
        closestPitch.note.accidental.isSharp && !hertzDelta.isNegative;

    return ClosestPitch(
      isCloserToUpwardsSpelling ? closestPitch.respelledUpwards : closestPitch,
      cents: Ratio(hertz / closestPitchFrequency).cents,
    );
  }

  /// The harmonic at [index] from this [Frequency], including negative
  /// values as part of the [undertone series](https://en.wikipedia.org/wiki/Undertone_series).
  ///
  /// Example:
  /// ```dart
  /// const Frequency(220).harmonic(1) == const Frequency(440)
  /// const Frequency(880).harmonic(-3) == const Frequency(220)
  ///
  /// Note.c.inOctave(1).frequency().harmonic(3).closestPitch()
  ///   == Note.e.inOctave(3) - const Cent(14)
  /// ```
  Frequency harmonic(int index) => Frequency(
        index.isNegative ? hertz / (index.abs() + 1) : hertz * (index + 1),
      );

  /// The [Set] of [harmonics series](https://en.wikipedia.org/wiki/Harmonic_series_(music))
  /// [upToIndex] from this [Frequency].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(3).frequency().harmonics(upToIndex: 2)
  ///   == const {Frequency(220), Frequency(440), Frequency(660)}
  ///
  /// Note.a.inOctave(5).frequency().harmonics(upToIndex: -2)
  ///   == {const Frequency(880), const Frequency(440), const Frequency(293.33)}
  /// ```
  ///
  /// ---
  /// See also:
  /// * [Pitch.harmonics] for a [ClosestPitch] set of harmonic series.
  Set<Frequency> harmonics({required int upToIndex}) => {
        for (var i = 0; i <= upToIndex.abs(); i++) harmonic(i * upToIndex.sign),
      };

  /// This [Frequency] formatted as a string.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440).format() == '440 Hz'
  /// const Frequency(466.16).format() == '466.16 Hz'
  /// ```
  String format() => '$hertz $hertzUnitSymbol';
}

/// A Frequency extension based on temperature.
extension TemperatureFrequency on Frequency {
  /// Speed of sound at [Celsius.zero] in m/s.
  static const _baseSpeedOfSound = 331.3;

  /// The speed of sound in m/s based on [temperature].
  ///
  /// See [Speed of sound in ideal gases and air](https://en.wikipedia.org/wiki/Speed_of_sound#Speed_of_sound_in_ideal_gases_and_air).
  static num speedOfSoundAt(Celsius temperature) =>
      _baseSpeedOfSound + 0.6 * temperature;

  /// This [Frequency] at [temperature], based on [reference].
  Frequency at(Celsius temperature, {Celsius reference = Celsius.reference}) =>
      Frequency(
        hertz * (speedOfSoundAt(temperature) / speedOfSoundAt(reference)),
      );
}
