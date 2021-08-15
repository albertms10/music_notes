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
  /// const Tonality(Note(Notes.Si), Modes.Major).accidentals == 5
  /// const Tonality(Note(Notes.Sol), Modes.Menor).accidentals == 2
  /// ```
  int get accidentals => CircleOfFifths.exactFifthsDistance(
        Tonality.fromAccidentals(0, mode).note,
        note,
      ).abs();

  /// Returns an [Accidentals] enum item of this [Tonality]’s key signature.
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note(Notes.Mi), Modes.Major).accidental
  ///   == Accidentals.Sostingut
  ///
  /// const Tonality(Note(Notes.Fa), Modes.Menor).accidental
  ///   == Accidentals.Bemoll
  /// ```
  Accidentals get accidental => CircleOfFifths.exactFifthsDistance(
            Tonality.fromAccidentals(0, mode).note,
            note,
          ) >
          0
      ? Accidentals.Sostingut
      : Accidentals.Bemoll;

  /// Returns the [Modes.Major] or [Modes.Menor] relative [Tonality]
  /// of this [Tonality].
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note(Notes.Re), Modes.Menor).relative
  ///   == const Tonality(Note(Notes.Fa), Modes.Major)
  ///
  /// const Tonality(Note(Notes.Si, Accidentals.Bemoll), Modes.Major).relative
  ///   == const Tonality(Note(Notes.Sol), Modes.Menor)
  /// ```
  Tonality get relative => Tonality(
        note.transposeBySemitones(
          Interval(
            Intervals.Tercera,
            Qualities.Menor,
            descending: mode == Modes.Major,
          ).semitones,
        ),
        mode.opposite,
      );

  /// Returns the [KeySignature] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// const Tonality(Note(Notes.La), Modes.Major).keySignature
  ///   == const KeySignature(3, Accidentals.Sostingut)
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
