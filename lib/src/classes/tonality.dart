part of music_notes;

class Tonality {
  final Note note;
  final Modes mode;

  const Tonality(this.note, this.mode)
      : assert(note != null),
        assert(mode != null);

  Tonality.copy(Tonality tonality) : this(tonality.note, tonality.mode);

  Tonality.fromAccidentals(int accidentals, Modes mode,
      [Accidentals accidental])
      : this(
          Note.fromTonalityAccidentals(accidentals, mode, accidental),
          mode,
        );

  /// Returns the number of [accidentals] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// const Tonality(const Note(Notes.Si), Modes.Major) == 5
  /// ```
  int get accidentals =>
      CircleOfFifths.exactFifthsDistance(Note(Notes.Do), note).abs();

  /// Returns the [Modes.Major] or [Modes.Menor] relative [Tonality] of this [Tonality].
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(const Note(Notes.Re), Modes.Menor).relative
  ///   == const Tonality(const Note(Notes.Fa), Modes.Major)
  ///
  /// const Tonality(const Note(Notes.Si, Accidentals.Bemoll), Modes.Major).relative
  ///   == const Tonality(const Note(Notes.Sol), Modes.Menor)
  /// ```
  Tonality get relative => Tonality(
        note.transposeBySemitones(
          Interval(
            Intervals.Tercera,
            Qualities.Menor,
            descending: mode == Modes.Major,
          ).semitones,
        ),
        mode.inverted,
      );

  /// Returns the [KeySignature] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// const Tonality(const Note(Notes.La), Modes.Major).keySignature
  ///   == const KeySignature(3, Accidentals.Sostingut)
  /// ```
  KeySignature get keySignature => KeySignature.fromDistance(
        CircleOfFifths.exactFifthsDistance(
          Note(Notes.Do),
          mode == Modes.Major ? note : this.relative.note,
        ),
      );

  @override
  String toString() => '$note ${mode.toText()}';

  @override
  bool operator ==(other) =>
      other is Tonality && this.note == other.note && this.mode == other.mode;
}
