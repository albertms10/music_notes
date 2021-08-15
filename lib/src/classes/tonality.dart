part of music_notes;

class Tonality {
  final Note note;
  final Modes mode;

  const Tonality(this.note, this.mode);

  Tonality.copy(Tonality tonality) : this(tonality.note, tonality.mode);

  Tonality.fromAccidentals(int accidentals, Modes mode,
      [Accidentals? accidental])
      : this(
          Note.fromTonalityAccidentals(accidentals, mode, accidental),
          mode,
        );

  /// Returns the number of [accidentals] of this [Tonality].
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note(Notes.si), Modes.major).accidentals == 5
  /// const Tonality(Note(Notes.sol), Modes.minor).accidentals == 2
  /// ```
  int get accidentals => CircleOfFifths.exactFifthsDistance(
        Tonality.fromAccidentals(0, mode).note,
        note,
      ).abs();

  /// Returns an [Accidentals] enum item of this [Tonality]’s key signature.
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note(Notes.mi), Modes.major).accidental
  ///   == Accidentals.sharp
  ///
  /// const Tonality(Note(Notes.fa), Modes.minor).accidental
  ///   == Accidentals.flat
  /// ```
  Accidentals get accidental => CircleOfFifths.exactFifthsDistance(
            Tonality.fromAccidentals(0, mode).note,
            note,
          ) >
          0
      ? Accidentals.sharp
      : Accidentals.flat;

  /// Returns the [Modes.major] or [Modes.minor] relative [Tonality]
  /// of this [Tonality].
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note(Notes.re), Modes.minor).relative
  ///   == const Tonality(Note(Notes.fa), Modes.major)
  ///
  /// const Tonality(Note(Notes.si, Accidentals.flat), Modes.major).relative
  ///   == const Tonality(Note(Notes.sol), Modes.minor)
  /// ```
  Tonality get relative => Tonality(
        note.transposeBySemitones(
          Interval(
            Intervals.third,
            Qualities.minor,
            descending: mode == Modes.major,
          ).semitones,
        ),
        mode.opposite,
      );

  /// Returns the [KeySignature] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// const Tonality(Note(Notes.la), Modes.major).keySignature
  ///   == const KeySignature(3, Accidentals.sharp)
  /// ```
  KeySignature get keySignature => KeySignature.fromDistance(
        CircleOfFifths.exactFifthsDistance(
          Tonality.fromAccidentals(0, mode).note,
          note,
        ),
      );

  @override
  String toString() => '$note ${mode.toText()}';

  @override
  bool operator ==(Object other) =>
      other is Tonality && note == other.note && mode == other.mode;

  @override
  int get hashCode => hash2(note, mode);
}
