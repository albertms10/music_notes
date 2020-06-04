part of music_notes;

class Note {
  final Notes note;
  final Accidentals accidental;

  const Note(this.note, [this.accidental]) : assert(note != null);

  Note.copy(Note note)
      : this.note = note.note,
        this.accidental = note.accidental;

  Note.fromValue(int value, [Accidentals preferredAccidental])
      : this.copy(EnharmonicNote.getNote(value, preferredAccidental));

  /// Returns the [Note] from the [Tonality] given its [accidentals] number,
  /// [mode] and optional [accidental].
  /// 
  /// ```dart
  /// Note.tonalityNoteFromAccidentals(2, Modes.Major, Accidentals.Sostingut)
  ///   == Note(Notes.Re)
  /// 
  /// Note.tonalityNoteFromAccidentals(0, Modes.Menor)
  ///   == Note(Notes.La)
  /// ```
  static Note tonalityNoteFromAccidentals(int accidentals, Modes mode,
      [Accidentals accidental]) {
    Note note = Note.fromValue(
      Interval(
                Intervals.Quinta,
                Qualities.Justa,
                descending: accidental == Accidentals.Bemoll,
              ).semitones *
              accidentals +
          1,
      accidental,
    );

    return mode == Modes.Major
        ? note
        : note.transposeBySemitones(
            -Interval(Intervals.Tercera, Qualities.Menor).semitones,
          );
  }

  /// Returns the semitones that correspond to this [Note] from [Notes.Do].
  ///
  /// ```dart
  /// Note(Notes.Re).value == 3
  /// Note(Notes.Fa, Accidentals.Sostingut).value == 6
  /// ```
  int get value => Music.modValueExcludeZero(note.value + accidentalValue);

  /// Returns this [Note]’s [accidental] value.
  int get accidentalValue => accidental != null ? accidental.value : 0;

  /// Returns the `delta` difference between this [Note] and a given [note].
  int semitonesDelta(Note note) => Music.modValue(note.value - this.value);

  /// Returns the iteration distance of an [interval] between this [Note] and a given [note].
  ///
  /// ```dart
  /// Note(Notes.Do).intervalDistance(
  ///   Note(Notes.Re),
  ///   Interval(Intervals.Quinta, Qualities.Justa),
  /// ) == 2
  /// ```
  int intervalDistance(Note note, Interval interval) {
    int distance = _runSemitonesDistance(
      note,
      interval.semitones,
      Accidentals.Sostingut,
    );

    return distance < Music.chromaticDivisions
        ? distance
        : -_runSemitonesDistance(
            note,
            interval.inverted.semitones,
            Accidentals.Bemoll,
          );
  }

  /// Returns the iteration distance of an [interval] between this [Note] and a given [note]
  /// with a [preferredAccidental].
  int _runSemitonesDistance(
    Note note,
    int semitones,
    Accidentals preferredAccidental,
  ) {
    int distance = 0;
    int currentPitch = this.value;

    var tempNote = Note.fromValue(currentPitch, preferredAccidental);

    while (tempNote != note && distance < Music.chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = Note.fromValue(currentPitch, preferredAccidental);
    }

    return distance;
  }

  /// Returns the exact interval between this [Note] and a given [note].
  ///
  /// ```dart
  /// Note(Notes.Do).exactInterval(Note(Notes.Re))
  ///   == Interval(Intervals.Segona, Qualities.Menor)
  ///
  /// Note(Notes.Re).exactInterval(Note(Notes.La, Accidentals.Bemoll))
  ///   == Interval(Intervals.Quinta, Qualities.Disminuida)
  /// ```
  Interval exactInterval(Note note) {
    Intervals interval = this.note.interval(note.note);

    return Interval.fromDelta(
      interval,
      semitonesDelta(note) -
          IntervalsValues.intervalsQualitiesIndex[interval] +
          1,
    );
  }

  /// Returns the transposed [Note] by given [semitones].
  ///
  /// ```dart
  /// Note(Notes.Mi, Accidentals.Bemoll).transposeBySemitones(-3)
  ///   == Note(Notes.Do)
  ///
  /// Note(Notes.La).transposeBySemitones(5)
  ///   == Note(Notes.Re)
  /// ```
  Note transposeBySemitones(int semitones) =>
      Note.fromValue(this.value + semitones);

  /// Returns the [Note] transposed by given [interval].
  ///
  /// ```dart
  /// Note(Notes.Mi).transposeByInterval(
  ///   Interval(Intervals.Quinta, Qualities.Justa),
  /// ) == Note(Notes.Si)
  ///
  /// Note(Notes.Sol).transposeByInterval(
  ///   Interval(Intervals.Tercera, Qualities.Major, descending: true),
  /// ) == Note(Notes.Mi, Accidentals.Bemoll)
  /// ```
  Note transposeByInterval(Interval interval) =>
      transposeBySemitones(interval.semitones);

  @override
  String toString() =>
      note.toText() + (accidental != null ? ' ${accidental.toText()}' : '');

  @override
  bool operator ==(other) =>
      other is Note &&
      this.note == other.note &&
      this.accidental == other.accidental;
}
