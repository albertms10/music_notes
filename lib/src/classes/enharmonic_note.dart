part of music_notes;

class EnharmonicNote extends Enharmonic<Note> {
  final Set<Note> notes;

  EnharmonicNote(this.notes) : super(notes);

  EnharmonicNote.fromSemitones(int semitones) : this(_fromSemitones(semitones));

  /// Returns the [EnharmonicNote] from [semitones].
  ///
  /// It is mainly used by [EnharmonicNote.fromSemitones] constructor.
  static Set<Note> _fromSemitones(int semitones) {
    final note = NotesValues.fromValue(semitones);

    if (note != null) {
      final noteBelow = NotesValues.fromOrdinal(Notes.values.indexOf(note));
      final noteAbove = NotesValues.fromOrdinal(Notes.values.indexOf(note) + 2);

      return {
        Note(
          noteBelow,
          AccidentalsValues.fromValue(note.value - noteBelow.value),
        ),
        Note(note),
        Note(
          noteAbove,
          AccidentalsValues.fromValue(note.value - noteAbove.value),
        ),
      };
    }

    return {
      Note(
        NotesValues.fromValue(semitones - 1),
        Accidentals.Sostingut,
      ),
      Note(
        NotesValues.fromValue(semitones + 1),
        Accidentals.Bemoll,
      ),
    };
  }

  /// Returns the number of semitones of the common chromatic pitch of [notes].
  ///
  /// It is used by [semitones] getter.
  static int _itemsSemitones(Set<Note> notes) => notes.first.semitones;

  /// Returns the [Note] from [semitones] and a [preferredAccidental].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.getNote(4, Accidentals.Sostingut)
  ///   == const Note(Notes.Re, Accidentals.Sostingut)
  ///
  /// EnharmonicNote.getNote(5, Accidentals.Bemoll)
  ///   == const Note(Notes.Fa, Accidentals.Bemoll)
  /// ```
  static Note getNote(int semitones, [Accidentals preferredAccidental]) {
    final enharmonicNotes = EnharmonicNote.fromSemitones(semitones).notes;

    return enharmonicNotes.firstWhere(
      (note) => note.accidental == preferredAccidental,
      orElse: () => enharmonicNotes.firstWhere(
        (note) => note.accidentalValue == 0,
        orElse: () => enharmonicNotes.first,
      ),
    );
  }

  /// Returns the number of semitones of the common chromatic pitch this [EnharmonicNote].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote({
  ///   const Note(Notes.Re, Accidentals.Bemoll),
  ///   const Note(Notes.Do, Accidentals.Sostingut),
  /// }).semitones == 2
  ///
  /// EnharmonicNote.fromSemitones(4).semitones == 4
  /// ```
  @override
  int get semitones => _itemsSemitones(notes);

  /// Returns a transposed [EnharmonicNote] by [semitones] from this [EnharmonicNote].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote({const Note(Notes.Do)}).transposeBy(6)
  ///   == EnharmonicNote({
  ///     const Note(Notes.Fa, Accidentals.Sostingut),
  ///     const Note(Notes.Sol, Accidentals.Bemoll),
  ///   })
  /// ```
  @override
  EnharmonicNote transposeBy(int semitones) =>
      EnharmonicNote.fromSemitones(this.semitones + semitones);

  /// Returns the shortest iteration distance from [enharmonicNote]
  /// to [semitones].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote({const Note(Notes.Sol)})
  ///   .enharmonicSemitonesDistance(
  ///     EnharmonicNote.fromSemitones(10),
  ///     7,
  ///   ) == 2
  /// ```
  int enharmonicSemitonesDistance(
    EnharmonicNote enharmonicNote,
    int semitones,
  ) {
    var distance = 0;
    var currentPitch = this.semitones;
    var tempEnharmonicNote = EnharmonicNote.fromSemitones(currentPitch);

    while (tempEnharmonicNote != enharmonicNote) {
      distance++;
      currentPitch += semitones;
      tempEnharmonicNote = EnharmonicNote.fromSemitones(currentPitch);
    }

    return distance;
  }

  /// Returns the shortest iteration distance from [enharmonicNote]
  /// to [interval].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.fromSemitones(5)
  ///   .enharmonicIntervalDistance(
  ///     EnharmonicNote({const Note(Notes.Re)}),
  ///     const Interval(Intervals.Quinta, Qualities.Justa),
  ///   ) == 10
  ///
  /// EnharmonicNote.fromSemitones(5)
  ///   .enharmonicIntervalDistance(
  ///     EnharmonicNote({const Note(Notes.Re)}),
  ///     const Interval(Intervals.Quinta, Qualities.Justa, descending: true),
  ///   ) == 2
  /// ```
  int enharmonicIntervalDistance(EnharmonicNote note, Interval interval) =>
      enharmonicSemitonesDistance(note, interval.semitones);
}
