part of music_notes;

class EnharmonicNote extends Enharmonic<Note> {
  EnharmonicNote(Set<Note> items) : super(items);

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
        NotesValues.fromValue(semitones - 1)!,
        Accidentals.sharp,
      ),
      Note(
        NotesValues.fromValue(semitones + 1)!,
        Accidentals.flat,
      ),
    };
  }

  /// Returns the [Note] from [semitones] and a [preferredAccidental].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.getNote(4, Accidentals.sharp)
  ///   == const Note(Notes.re, Accidentals.sharp)
  ///
  /// EnharmonicNote.getNote(5, Accidentals.flat)
  ///   == const Note(Notes.fa, Accidentals.flat)
  /// ```
  static Note getNote(int semitones, [Accidentals? preferredAccidental]) {
    final enharmonicNotes = EnharmonicNote.fromSemitones(semitones).items;

    return enharmonicNotes.firstWhere(
      (note) => note.accidental == preferredAccidental,
      orElse: () => enharmonicNotes.firstWhere(
        (note) => note.accidentalValue == 0,
        orElse: () => enharmonicNotes.first,
      ),
    );
  }

  /// Returns the number of semitones of the common chromatic pitch
  /// this [EnharmonicNote].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote({
  ///   const Note(Notes.re, Accidentals.flat),
  ///   const Note(Notes.ut, Accidentals.sharp),
  /// }).semitones == 2
  ///
  /// EnharmonicNote.fromSemitones(4).semitones == 4
  /// ```
  @override
  int get semitones => super.semitones;

  /// Returns a transposed [EnharmonicNote] by [semitones]
  /// from this [EnharmonicNote].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote({const Note(Notes.ut)}).transposeBy(6)
  ///   == EnharmonicNote({
  ///     const Note(Notes.fa, Accidentals.sharp),
  ///     const Note(Notes.sol, Accidentals.flat),
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
  /// EnharmonicNote({const Note(Notes.sol)})
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
  ///     EnharmonicNote({const Note(Notes.re)}),
  ///     const Interval(Intervals.fifth, Qualities.perfect),
  ///   ) == 10
  ///
  /// EnharmonicNote.fromSemitones(5)
  ///   .enharmonicIntervalDistance(
  ///     EnharmonicNote({const Note(Notes.re)}),
  ///     const Interval(Intervals.fifth, Qualities.perfect, descending: true),
  ///   ) == 2
  /// ```
  int enharmonicIntervalDistance(
    EnharmonicNote enharmonicNote,
    Interval interval,
  ) =>
      enharmonicSemitonesDistance(enharmonicNote, interval.semitones);
}
