part of music_notes;

class EnharmonicNote {
  final Set<Note> enharmonicNotes;

  const EnharmonicNote(this.enharmonicNotes)
      : assert(enharmonicNotes != null && enharmonicNotes.length > 0);

  EnharmonicNote.fromValue(int value)
      : this(_enharmonicNoteFromValue(value).enharmonicNotes);

  int get value => enharmonicNotes.toList()[0].value;

  static EnharmonicNote _enharmonicNoteFromValue(int value) {
    final note = NotesValues.note(value);

    if (note != null) {
      var noteBelow = NotesValues.fromOrdinal(Notes.values.indexOf(note));
      var noteAbove = NotesValues.fromOrdinal(Notes.values.indexOf(note) + 2);

      return EnharmonicNote({
        Note(
          noteBelow,
          AccidentalsValues.accidental(note.value - noteBelow.value),
        ),
        Note(note),
        Note(
          noteAbove,
          AccidentalsValues.accidental(note.value - noteAbove.value),
        ),
      });
    }

    var noteBelow = NotesValues.note(value - 1);
    var noteAbove = NotesValues.note(value + 1);

    return EnharmonicNote({
      Note(noteBelow, Accidentals.Sostingut),
      Note(noteAbove, Accidentals.Bemoll),
    });
  }

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

  int enharmonicIntervalDistance(EnharmonicNote note, Interval interval) =>
      enharmonicSemitonesDistance(note, interval.semitones);

  EnharmonicNote transposeBy(int semitones) =>
      EnharmonicNote.fromValue(this.value + semitones);

  @override
  String toString() => '$enharmonicNotes';

  @override
  bool operator ==(other) =>
      other is EnharmonicNote && this.value == other.value;
}
