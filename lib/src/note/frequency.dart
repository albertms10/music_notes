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
  /// Note.a.inOctave(4).equalTemperamentFrequency().isHumanAudible == true
  /// Note.g.inOctave(12).equalTemperamentFrequency(const Frequency(442))
  ///   .isHumanAudible == false
  /// ```
  bool get isHumanAudible {
    const minFrequency = 20;
    const maxFrequency = 20000;

    return hertz >= minFrequency && hertz <= maxFrequency;
  }

  /// Returns the closest [PositionedNote] to this [Frequency], with the
  /// difference in `cents` and `hertz`.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(467).closestPositionedNote()
  ///   == (Note.a.sharp.inOctave(4), cents: 3.1028, hertz: 0.8362)
  ///
  /// const Frequency(260).closestPositionedNote()
  ///   == (Note.c.inOctave(4), cents: -10.7903, hertz: -1.6256)
  /// ```
  ///
  /// This method and [PositionedNote.equalTemperamentFrequency] are inverses of
  /// each other for a specific input `frequency`.
  ///
  /// ```dart
  /// const frequency = Frequency(442);
  /// final (note, cents: _, :hertz) = frequency.closestPositionedNote();
  /// note.equalTemperamentFrequency() == Frequency(frequency.hertz - hertz);
  /// ```
  (PositionedNote, {double cents, double hertz}) closestPositionedNote({
    PositionedNote referenceNote = const PositionedNote(Note.a, octave: 4),
    Frequency referenceFrequency = const Frequency(440),
  }) {
    final cents =
        EqualTemperament.edo12.cents(hertz / referenceFrequency.hertz);
    final semitones = referenceNote.semitones + (cents / 100).round();

    final closestNote = PitchClass(semitones)
        .resolveClosestSpelling()
        .inOctave(PositionedNote.octaveFromSemitones(semitones));

    final closestNoteFrequency = closestNote.equalTemperamentFrequency(
      reference: referenceNote,
      frequency: referenceFrequency,
    );

    return (
      closestNote,
      hertz: hertz - closestNoteFrequency.hertz,
      cents: EqualTemperament.edo12.cents(hertz / closestNoteFrequency.hertz),
    );
  }

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
