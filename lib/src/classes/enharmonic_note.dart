part of music_notes;

class EnharmonicNote {
  final Set<Note> enharmonicNotes;

  EnharmonicNote(this.enharmonicNotes)
      : assert(enharmonicNotes != null && enharmonicNotes.length > 0),
        assert(
          enharmonicNotes.every(
            (note) => note.value == notesValue(enharmonicNotes),
          ),
          "The notes are not enharmonic",
        );

  EnharmonicNote.fromValue(int value)
      : this(_enharmonicNoteFromValue(value).enharmonicNotes);

  /// Returns the value of the common chromatic pitch of [notes].
  ///
  /// Example:
  /// ```dart
  /// notesValue({
  ///   const Note(Notes.Re, Accidental.Bemoll),
  ///   const Note(Notes.Do, Accidental.Sostingut),
  /// }) == 2
  /// ```
  static int notesValue(Set<Note> notes) => notes.toList()[0].value;

  /// Returns the value of the common chromatic pitch this [EnharmonicNote].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote({
  ///   const Note(Notes.Re, Accidental.Bemoll),
  ///   const Note(Notes.Do, Accidental.Sostingut),
  /// }).value == 2
  ///
  /// EnharmonicNote.fromValue(4).value == 4
  /// ```
  int get value => notesValue(enharmonicNotes);

  /// Returns the [EnharmonicNote] from a given [value].
  ///
  /// It is mainly used by [EnharmonicNote.fromValue] constructor.
  static EnharmonicNote _enharmonicNoteFromValue(int value) {
    final note = NotesValues.fromValue(value);

    if (note != null) {
      var noteBelow = NotesValues.fromOrdinal(Notes.values.indexOf(note));
      var noteAbove = NotesValues.fromOrdinal(Notes.values.indexOf(note) + 2);

      return EnharmonicNote({
        Note(
          noteBelow,
          AccidentalsValues.fromValue(note.value - noteBelow.value),
        ),
        Note(note),
        Note(
          noteAbove,
          AccidentalsValues.fromValue(note.value - noteAbove.value),
        ),
      });
    }

    var noteBelow = NotesValues.fromValue(value - 1);
    var noteAbove = NotesValues.fromValue(value + 1);

    return EnharmonicNote({
      Note(noteBelow, Accidentals.Sostingut),
      Note(noteAbove, Accidentals.Bemoll),
    });
  }

  /// Returns the [Note] from a given [value] and a [preferredAccidental].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.getNote(4, Accidentals.Sostingut)
  ///   == const Note(Notes.Re, Accidentals.Sostingut)
  ///
  /// EnharmonicNote.getNote(5, Accidentals.Bemoll)
  ///   == const Note(Notes.Fa, Accidentals.Bemoll)
  /// ```
  static Note getNote(int value, [Accidentals preferredAccidental]) {
    var enharmonicNotes = EnharmonicNote.fromValue(value).enharmonicNotes;

    return enharmonicNotes.firstWhere(
      (note) => note.accidental == preferredAccidental,
      orElse: () => enharmonicNotes.firstWhere(
        (note) => note.accidentalValue == 0,
        orElse: () => enharmonicNotes.first,
      ),
    );
  }

  /// Returns the shortest iteration distance from [enharmonicNote]
  /// to [semitones].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote({const Note(Notes.Sol)})
  ///   .enharmonicSemitonesDistance(
  ///     EnharmonicNote.fromValue(10),
  ///     7,
  ///   ) == 2
  /// ```
  int enharmonicSemitonesDistance(
    EnharmonicNote enharmonicNote,
    int semitones,
  ) {
    int distance = 0;
    int currentPitch = this.value;
    var tempEnharmonicNote = EnharmonicNote.fromValue(currentPitch);

    while (tempEnharmonicNote != enharmonicNote) {
      distance++;
      currentPitch += semitones;
      tempEnharmonicNote = EnharmonicNote.fromValue(currentPitch);
    }

    return distance;
  }

  /// Returns the shortest iteration distance from [enharmonicNote]
  /// to [interval].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.fromValue(5)
  ///   .enharmonicIntervalDistance(
  ///     EnharmonicNote({const Note(Notes.Re)}),
  ///     const Interval(Intervals.Quinta, Qualities.Justa),
  ///   ) == 10
  ///
  /// EnharmonicNote.fromValue(5)
  ///   .enharmonicIntervalDistance(
  ///     EnharmonicNote({const Note(Notes.Re)}),
  ///     const Interval(Intervals.Quinta, Qualities.Justa, descending: true),
  ///   ) == 2
  /// ```
  int enharmonicIntervalDistance(EnharmonicNote note, Interval interval) =>
      enharmonicSemitonesDistance(note, interval.semitones);

  /// Returns a transposed [EnharmonicNote] by [semitones] from this [EnharmonicNoste].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote({const Note(Notes.Do)}).transposeBy(7)
  ///   == EnharmonicNote({
  ///     const Note(Notes.Fa, Accidentals.Sostingut),
  ///     const Note(Notes.Sol, Accidentals.Bemoll),
  ///   })
  /// ```
  EnharmonicNote transposeBy(int semitones) =>
      EnharmonicNote.fromValue(this.value + semitones);

  @override
  String toString() => '$enharmonicNotes';

  @override
  bool operator ==(other) =>
      other is EnharmonicNote && this.value == other.value;
}
