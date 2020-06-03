part of music_notes;

class EnharmonicNote {
  final Set<Note> enharmonicNotes;

  EnharmonicNote(this.enharmonicNotes)
      : assert(enharmonicNotes.isNotEmpty),
        assert(
          enharmonicNotes.every(
            (element) => element.value == enharmonicNotes.toList()[0].value,
          ),
          "The notes are not enharmonic",
        );

  EnharmonicNote.fromSemitone(int semitone)
      : this(getEnharmonicNote(semitone).enharmonicNotes);

  int get value => enharmonicNotes.toList()[0].value;

  static EnharmonicNote getEnharmonicNote(int semitone) {
    final note = NotesValues.note(semitone);

    if (note != null) return EnharmonicNote({Note(note)});

    var noteBelow = NotesValues.note(semitone - 1);
    var noteAbove = NotesValues.note(semitone + 1);

    return EnharmonicNote({
      Note(noteBelow, Accidentals.Sostingut),
      Note(noteAbove, Accidentals.Bemoll)
    });
  }

  static Note getNote(int semitone, [Accidentals preferAccidental]) =>
      getEnharmonicNote(semitone)
          .enharmonicNotes
          .firstWhere((note) => note.accidental == preferAccidental);

  int enharmonicSemitonesDistance(EnharmonicNote note, int semitones) {
    int distance = 0;
    int currentPitch = this.value;
    EnharmonicNote tempNote = EnharmonicNote.fromSemitone(currentPitch);

    while (tempNote != note) {
      distance++;
      currentPitch += semitones;
      tempNote = EnharmonicNote.fromSemitone(currentPitch);
    }

    return distance;
  }

  EnharmonicNote transposeBy(int semitones) =>
      EnharmonicNote.fromSemitone(this.value + semitones);

  @override
  String toString() => '$enharmonicNotes';

  @override
  bool operator ==(other) =>
      other is EnharmonicNote && this.value == other.value;
}
