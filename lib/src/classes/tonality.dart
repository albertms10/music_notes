part of music_notes;

class Tonality {
  final Note note;
  final Modes mode;

  const Tonality(this.note, this.mode)
      : assert(note != null),
        assert(mode != null);

  Tonality.copy(Tonality tonality)
      : note = tonality.note,
        mode = tonality.mode;

  Tonality.fromAccidentals(int accidentals, Modes mode,
      [Accidentals accidental])
      : this(
          Note.tonalityNoteFromAccidentals(accidentals, mode, accidental),
          mode,
        );

  /// Returns the number of [accidentals] of this [Tonality].
  /// 
  /// ```dart
  /// Tonality(Note(Notes.Si), Modes.Major) == 5
  /// ```
  int get accidentals =>
      CircleOfFifths.exactFifthsDistance(Note(Notes.Do), note).abs();

  /// Returns the [Modes.Major] or [Modes.Menor] relative [Tonality] of this [Tonality].
  ///
  /// ```dart
  /// Tonality(Note(Notes.Re), Modes.Menor).relative
  ///   == Tonality(Note(Notes.Fa), Modes.Major)
  ///
  /// Tonality(Note(Notes.Si, Accidentals.Bemoll), Modes.Major).relative
  ///   == Tonality(Note(Notes.Sol), Modes.Menor)
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
  /// ```dart
  /// Tonality(Note(Notes.La), Modes.Major).keySignature
  ///   == KeySignature(3, Accidentals.Sostingut)
  /// ```
  KeySignature get keySignature => KeySignature.fromDistance(
        CircleOfFifths.exactFifthsDistance(
          Note(Notes.Do),
          mode == Modes.Major ? note : this.relative.note,
        ),
      );

  @override
  String toString() => '$note ${mode.toText()}';
}
