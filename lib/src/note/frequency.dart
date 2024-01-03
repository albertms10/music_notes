part of '../../music_notes.dart';

/// Represents an absolute pitch, a physical frequency.
///
/// ---
/// See also:
/// * [Pitch].
/// * [ClosestPitch].
@immutable
class Frequency implements Comparable<Frequency> {
  /// The value of this [Frequency] in Hertz.
  final double hertz;

  /// Creates a new [Frequency] instance from [hertz].
  const Frequency(this.hertz) : assert(hertz >= 0, 'Hertz must be positive');

  /// The symbol for the Hertz unit.
  static const hertzUnitSymbol = 'Hz';

  /// Whether this [Frequency] is inside the [HearingRange.human].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(880).isHumanAudible == true
  /// Note.a.inOctave(4).frequency().isHumanAudible == true
  /// Note.g.inOctave(12).frequency().isHumanAudible == false
  /// ```
  bool get isHumanAudible => HearingRange.human.isAudible(this);

  /// Returns the [ClosestPitch] to this [Frequency] from [referenceFrequency]
  /// and [tuningSystem].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(467).closestPitch()
  ///   == ClosestPitch(Note.a.sharp.inOctave(4), cents: Cent(3.1), hertz: 0.84)
  ///
  /// const Frequency(260).closestPitch()
  ///   == ClosestPitch(Note.c.inOctave(4), cents: Cent(-10.79), hertz: -1.63)
  /// ```
  ///
  /// This method and [Pitch.frequency] are inverses of each other for a
  /// specific input `frequency`.
  ///
  /// ```dart
  /// const frequency = Frequency(442);
  /// final (closestPitch, cents: _, :hertz) = frequency.closestPitch();
  /// closestPitch.frequency() == Frequency(frequency.hertz - hertz);
  /// ```
  ClosestPitch closestPitch({
    Frequency referenceFrequency = const Frequency(440),
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
  }) {
    final cents = Ratio(hertz / referenceFrequency.hertz).cents;
    final semitones =
        tuningSystem.referencePitch.semitones + (cents.value / 100).round();

    final closestPitch = PitchClass(semitones)
        .resolveClosestSpelling()
        .inOctave(Pitch.octaveFromSemitones(semitones));

    final closestPitchFrequency = closestPitch.frequency(
      referenceFrequency: referenceFrequency,
      tuningSystem: tuningSystem,
    );
    final hertzDelta = hertz - closestPitchFrequency.hertz;

    // Whether `closestPitch` is closer to the upwards spelling (so, positive
    // `hertzDelta`), e.g. `Accidental.flat` instead of `Accidental.sharp`.
    final isCloserToUpwardsSpelling =
        closestPitch.note.accidental == Accidental.sharp &&
            !hertzDelta.isNegative;

    return ClosestPitch(
      isCloserToUpwardsSpelling ? closestPitch.respelledUpwards : closestPitch,
      cents: Ratio(hertz / closestPitchFrequency.hertz).cents,
      hertz: hertzDelta,
    );
  }

  /// Returns the harmonic at [index] from this [Frequency], including negative
  /// values as part of the [undertone series](https://en.wikipedia.org/wiki/Undertone_series).
  ///
  /// Example:
  /// ```dart
  /// const Frequency(220).harmonic(1) == const Frequency(440)
  /// const Frequency(880).harmonic(-3) == const Frequency(220)
  ///
  /// Note.c.inOctave(1).frequency().harmonic(3).closestPitch().toString()
  ///   == 'E3-14'
  /// ```
  Frequency harmonic(int index) =>
      index.isNegative ? this / (index.abs() + 1) : this * (index + 1);

  /// Returns a [Set] of the [harmonics series](https://en.wikipedia.org/wiki/Harmonic_series_(music))
  /// [upToIndex] from this [Frequency].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(3).frequency().harmonics(upToIndex: 2)
  ///   == {const Frequency(220), const Frequency(440), const Frequency(660)}
  ///
  /// Note.a.inOctave(5).frequency().harmonics(upToIndex: -2)
  ///   == {const Frequency(880), const Frequency(440), const Frequency(293.33)}
  ///
  /// Note.c.inOctave(1).frequency().harmonics(upToIndex: 7).closestPitches
  ///     .toString() == '{C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4}'
  /// ```
  ///
  /// ---
  /// See also:
  /// - [FrequencyIterableExtension.closestPitches].
  Set<Frequency> harmonics({required int upToIndex}) => {
        for (var i = 0; i <= upToIndex.abs(); i++) harmonic(i * upToIndex.sign),
      };

  /// Adds [other] to this [Frequency].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440) + const Frequency(220) == const Frequency(660)
  /// ```
  Frequency operator +(Frequency other) => Frequency(hertz + other.hertz);

  /// Subtracts [other] from this [Frequency].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440) - const Frequency(220) == const Frequency(220)
  /// ```
  Frequency operator -(Frequency other) => Frequency(hertz - other.hertz);

  /// Multiplies this [Frequency] by [factor].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440) * 2 == const Frequency(880)
  /// const Frequency(440) * 0.5 == const Frequency(220)
  /// ```
  Frequency operator *(num factor) => Frequency(hertz * factor);

  /// Divides this [Frequency] by [factor].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440) / 2 == const Frequency(220)
  /// ```
  Frequency operator /(num factor) => Frequency(hertz / factor);

  @override
  String toString() => '$hertz $hertzUnitSymbol';

  @override
  bool operator ==(Object other) => other is Frequency && hertz == other.hertz;

  @override
  int get hashCode => hertz.hashCode;

  @override
  int compareTo(Frequency other) => hertz.compareTo(other.hertz);
}

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

/// A [Frequency] Iterable extension.
extension FrequencyIterableExtension on Iterable<Frequency> {
  /// Returns the set of [ClosestPitch] for each [Frequency] element.
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(1).frequency().harmonics(upToIndex: 7).closestPitches
  ///     .toString() == '{C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4}'
  /// ```
  Set<ClosestPitch> get closestPitches =>
      map((frequency) => frequency.closestPitch()).toSet();
}
