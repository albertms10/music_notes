part of '../../music_notes.dart';

class EnharmonicNote extends Enharmonic<Note> {
  EnharmonicNote(super.items);

  EnharmonicNote.fromSemitones(int semitones) : this(_fromSemitones(semitones));

  /// Returns the [EnharmonicNote] from [semitones].
  ///
  /// It is mainly used by [EnharmonicNote.fromSemitones] constructor.
  static Set<Note> _fromSemitones(int semitones) {
    final note = NotesValues.fromValue(semitones);

    if (note != null) {
      final noteBelow = NotesValues.fromOrdinal(Notes.values.indexOf(note));
      final noteAbove = NotesValues.fromOrdinal(Notes.values.indexOf(note) + 2);

      return SplayTreeSet<Note>.from({
        Note(
          noteBelow,
          Accidental(note.value - noteBelow.value),
        ),
        Note(note),
        Note(
          noteAbove,
          Accidental(note.value - noteAbove.value),
        ),
      });
    }

    return SplayTreeSet<Note>.from({
      Note(
        NotesValues.fromValue(semitones - 1)!,
        Accidental.sharp,
      ),
      Note(
        NotesValues.fromValue(semitones + 1)!,
        Accidental.flat,
      ),
    });
  }

  /// Returns the [Note] from [semitones] and a [preferredAccidental].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.note(4, Accidental.sharp)
  ///   == const Note(Notes.re, Accidental.sharp)
  ///
  /// EnharmonicNote.note(5, Accidental.flat)
  ///   == const Note(Notes.fa, Accidental.flat)
  /// ```
  static Note note(
    int semitones, [
    Accidental preferredAccidental = Accidental.natural,
  ]) {
    final enharmonicNotes = EnharmonicNote.fromSemitones(semitones).items;

    return enharmonicNotes.firstWhere(
      (note) => note.accidental == preferredAccidental,
      orElse: () => enharmonicNotes.firstWhere(
        (note) => note.accidental.value == 0,
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
  ///   const Note(Notes.re, Accidental.flat),
  ///   const Note(Notes.ut, Accidental.sharp),
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
  ///     const Note(Notes.fa, Accidental.sharp),
  ///     const Note(Notes.sol, Accidental.flat),
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
