part of '../../music_notes.dart';

/// A representation of a hearing range.
typedef HearingRange = ({Frequency min, Frequency max});

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

  /// See [Hearing range](https://en.wikipedia.org/wiki/Hearing_range).
  static const HearingRange humanHearingRange =
      (min: Frequency(20), max: Frequency(20000));

  /// Whether this [Frequency] is inside the [humanHearingRange].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(880).isHumanAudible == true
  /// Note.a.inOctave(4).frequency().isHumanAudible == true
  /// Note.g.inOctave(12).frequency().isHumanAudible == false
  /// ```
  bool get isHumanAudible =>
      hertz >= humanHearingRange.min.hertz &&
      hertz <= humanHearingRange.max.hertz;

  /// Returns the [ClosestPitch] to this [Frequency] from [referenceFrequency]
  /// and [tuningSystem].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(467).closestPitch()
  ///   == ClosestPitch(Note.a.sharp.inOctave(4), cents: Cent(3.1))
  ///
  /// const Frequency(260).closestPitch()
  ///   == ClosestPitch(Note.c.inOctave(4), cents: Cent(-10.79))
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
