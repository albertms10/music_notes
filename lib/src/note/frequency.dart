part of '../../music_notes.dart';

/// Represents an absolute pitch, a physical frequency.
@immutable
class Frequency implements Comparable<Frequency> {
  /// The value of this [Frequency] in Hertz.
  final double hertz;

  /// Creates a new [Frequency] instance from [hertz].
  const Frequency(this.hertz) : assert(hertz >= 0, 'Hertz must be positive');

  /// The symbol for the Hertz unit.
  static const hertzUnitSymbol = 'Hz';

  /// Whether this [Frequency] is inside the human hearing range.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(880).isHumanAudible == true
  /// Note.a.inOctave(4).frequency().isHumanAudible == true
  /// Note.g.inOctave(12).frequency().isHumanAudible == false
  /// ```
  bool get isHumanAudible {
    const minFrequency = 20;
    const maxFrequency = 20000;

    return hertz >= minFrequency && hertz <= maxFrequency;
  }

  /// Returns the closest [Pitch] to this [Frequency] from
  /// [referenceFrequency] and [tuningSystem], with the difference in `cents`
  /// and `hertz`.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(467).closestPitch()
  ///   == (Note.a.sharp.inOctave(4), cents: const Cent(3.1028), hertz: 0.8362)
  ///
  /// const Frequency(260).closestPitch()
  ///   == (Note.c.inOctave(4), cents: const Cent(-10.7903), hertz: -1.6256)
  /// ```
  ///
  /// This method and [Pitch.frequency] are inverses of each other for
  /// a specific input `frequency`.
  ///
  /// ```dart
  /// const frequency = Frequency(442);
  /// final (closestNote, cents: _, :hertz) = frequency.closestPitch();
  /// closestNote.frequency() == Frequency(frequency.hertz - hertz);
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

    // Whether `closestNote` is closer to the upwards spelling (so, positive
    // `hertzDelta`), e.g. `Accidental.flat` instead of `Accidental.sharp`.
    final isCloserToUpwardsSpelling =
        closestPitch.note.accidental == Accidental.sharp &&
            !hertzDelta.isNegative;

    return (
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
  /// Note.c.inOctave(1).frequency().harmonic(3)
  ///   .closestPitch().displayString() == 'E3-14'
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
  /// Note.c.inOctave(1).frequency().harmonics(upToIndex: 7)
  ///   .map((frequency) => frequency.closestPitch().displayString())
  ///   .toSet()
  ///     == const {'C1', 'C2', 'G2+2', 'C3', 'E3-14', 'G3+2', 'A♯3-31', 'C4'}
  /// ```
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

/// A record containing the closest [Pitch], with delta `cents` and
/// `hertz`.
typedef ClosestPitch = (
  Pitch closestPitch, {
  Cent cents,
  double hertz,
});

/// A [ClosestPitch] extension.
extension ClosestPitchExtension on ClosestPitch {
  /// Returns the string representation of this [ClosestPitch] record.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440).closestPitch().displayString() == 'A4'
  /// const Frequency(98.1).closestPitch().displayString() == 'G2+2'
  /// const Frequency(163.5).closestPitch().displayString() == 'E3-14'
  /// const Frequency(228.9).closestPitch().displayString() == 'A♯3-31'
  /// ```
  String displayString() {
    final roundedCents = cents.value.round();
    if (roundedCents == 0) return '${$1}';

    return '${$1}${roundedCents.toDeltaString()}';
  }
}
