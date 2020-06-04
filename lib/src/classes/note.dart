part of music_notes;

class Note {
  final Notes note;
  final Accidentals accidental;

  const Note(this.note, [this.accidental]) : assert(note != null);

  Note.copy(Note note)
      : this.note = note.note,
        this.accidental = note.accidental;

  Note.fromValue(int value, [Accidentals preferedAccidental])
      : this.copy(EnharmonicNote.getNote(value, preferedAccidental));

  static Note tonalityNoteFromAccidentals(int accidentals, Modes mode,
      [Accidentals accidental]) {
    Interval fifth = Interval(Intervals.Quinta, Qualities.Justa);
    Note note = Note.fromValue(
      (accidental == Accidentals.Sostingut
                  ? fifth.semitones
                  : fifth.inverted.semitones) *
              accidentals +
          1,
      accidental,
    );
    return mode == Modes.Major
        ? note
        : note.transposeBy(
            -Interval(Intervals.Tercera, Qualities.Menor).semitones,
          );
  }

  int get value => Music.modValueWithZero(note.value + accidentalValue);

  int get accidentalValue => accidental != null ? accidental.value : 0;

  int semitonesDelta(Note note) => Music.modValue(note.value - this.value);

  int intervalDistance(Note note, Interval interval) {
    int distance = runSemitonesDistance(
      note,
      interval.semitones,
      Accidentals.Sostingut,
    );

    return distance < Music.chromaticDivisions
        ? distance
        : -runSemitonesDistance(
            note,
            interval.inverted.semitones,
            Accidentals.Bemoll,
          );
  }

  int runSemitonesDistance(
    Note note,
    int semitones,
    Accidentals preferedAccidental,
  ) {
    int distance = 0;
    int currentPitch = this.value;

    var tempNote = Note.fromValue(currentPitch, preferedAccidental);

    while (tempNote != note && distance < Music.chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = Note.fromValue(currentPitch, preferedAccidental);
    }

    return distance;
  }

  Interval exactInterval(Note note) {
    Intervals interval = this.note.interval(note.note);

    return Interval.fromDelta(
      interval,
      semitonesDelta(note) -
          IntervalsValues.intervalsQualitiesIndex[interval] +
          1,
    );
  }

  Note transposeBy(int semitones) => Note.fromValue(this.value + semitones);

  @override
  String toString() =>
      note.toText() + (accidental != null ? ' ${accidental.toText()}' : '');

  @override
  bool operator ==(other) =>
      other is Note &&
      this.note == other.note &&
      this.accidental == other.accidental;
}
