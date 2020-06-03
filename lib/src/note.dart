part of music_notes;

class Note with Music {
  final Notes note;
  final Accidentals accidental;

  Note(this.note, [this.accidental]) : assert(note != null);

  Note.copy(Note note)
      : this.note = note.note,
        this.accidental = note.accidental;

  Note.fromValue(int value, [Accidentals preferAccidental])
      : this.copy(EnharmonicNote.getNote(value, preferAccidental));

  int get value => Music.modValueWithZero(
      note.value + (accidental != null ? accidental.value : 0));

  int get accidentalValue => accidental != null ? accidental.value : 0;

  int semitonesDelta(Note note) => Music.modValue(note.value - this.value);

  int intervalDistance(Note note, int semitones) {
    int distance = 0;
    int currentPitch = this.value;
    EnharmonicNote tempNote = EnharmonicNote.fromSemitone(currentPitch);

    while (tempNote.enharmonicNotes.every((temp) => temp != note)) {
      distance++;
      currentPitch += semitones;
      tempNote = EnharmonicNote.fromSemitone(currentPitch);
    }

    return distance;
  }

  Interval exactInterval(Note note) {
    Intervals interval = this.note.interval(note.note);

    return Interval.fromDelta(
        interval,
        semitonesDelta(note) -
            IntervalsValues.intervalsQualitiesIndex[interval] +
            1);
  }

  @override
  String toString() =>
      '${note.toText()}' +
      (accidental != null ? ' ${accidental.toText()}' : '');

  @override
  bool operator ==(other) =>
      other is Note &&
      this.note == other.note &&
      this.accidental == other.accidental;
}
