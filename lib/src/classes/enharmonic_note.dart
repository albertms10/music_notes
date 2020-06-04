part of music_notes;

class EnharmonicNote {
  final Set<Note> enharmonicNotes;

  const EnharmonicNote(this.enharmonicNotes)
      : assert(enharmonicNotes != null && enharmonicNotes.length > 0);

  EnharmonicNote.fromSemitone(int semitone)
      : this(getEnharmonicNote(semitone).enharmonicNotes);

  int get value => enharmonicNotes.toList()[0].value;

  static EnharmonicNote getEnharmonicNote(int semitone) {
    final note = NotesValues.note(semitone);

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

    var noteBelow = NotesValues.note(semitone - 1);
    var noteAbove = NotesValues.note(semitone + 1);

    return EnharmonicNote({
      Note(noteBelow, Accidentals.Sostingut),
      Note(noteAbove, Accidentals.Bemoll),
    });
  }

  static Note getNote(int semitone, [Accidentals preferAccidental]) {
    var enharmonicNotes = getEnharmonicNote(semitone).enharmonicNotes;

    return enharmonicNotes.firstWhere(
      (note) => note.accidental == preferAccidental,
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
    var tempEnharmonicNote = EnharmonicNote.fromSemitone(currentPitch);

    while (tempEnharmonicNote != enharmonicNote) {
      distance++;
      currentPitch += semitones;
      tempEnharmonicNote = EnharmonicNote.fromSemitone(currentPitch);
    }

    return distance;
  }

  int enharmonicIntervalDistance(EnharmonicNote note, Interval interval) =>
      enharmonicSemitonesDistance(note, interval.semitones);

  EnharmonicNote transposeBy(int semitones) =>
      EnharmonicNote.fromSemitone(this.value + semitones);

  @override
  String toString() => '$enharmonicNotes';

  @override
  bool operator ==(other) =>
      other is EnharmonicNote && this.value == other.value;
}
