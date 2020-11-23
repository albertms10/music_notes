part of music_notes;

class Note implements MusicItem {
  final Notes note;
  final Accidentals accidental;

  const Note(this.note, [this.accidental]) : assert(note != null);

  Note.copy(Note note) : this(note.note, note.accidental);

  Note.fromSemitones(int semitones, [Accidentals preferredAccidental])
      : this.copy(EnharmonicNote.getNote(semitones, preferredAccidental));

  /// Returns the [Note] from the [Tonality] given its [accidentals] number,
  /// [mode] and optional [accidental].
  ///
  /// Examples:
  /// ```dart
  /// Note.fromTonalityAccidentals(2, Modes.Major, Accidentals.Sostingut)
  ///   == const Note(Notes.Re)
  ///
  /// Note.fromTonalityAccidentals(0, Modes.Menor)
  ///   == const Note(Notes.La)
  /// ```
  static Note fromTonalityAccidentals(int accidentals, Modes mode,
      [Accidentals accidental]) {
    final Note note = Note.fromSemitones(
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
            Interval(Intervals.Tercera, Qualities.Menor, descending: true)
                .semitones,
            accidental,
          );
  }

  /// Returns the number of semitones that correspond to this [Note] from [Notes.Do].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.Re).semitones == 3
  /// const Note(Notes.Fa, Accidentals.Sostingut).semitones == 7
  /// ```
  @override
  int get semitones => Music.modValueExcludeZero(note.value + accidentalValue);

  /// Returns this [Note]’s [accidental] value.
  int get accidentalValue => accidental != null ? accidental.value : 0;

  /// Returns the `delta` difference between this [Note] and [note].
  int semitonesDelta(Note note) => Music.modValue(note.semitones - semitones);

  /// Returns the iteration distance of an [interval] between this [Note] and [note].
  ///
  /// Example:
  /// ```dart
  /// const Note(Notes.Do).intervalDistance(
  ///   const Note(Notes.Re),
  ///   const Interval(Intervals.Quinta, Qualities.Justa),
  /// ) == 2
  /// ```
  int intervalDistance(Note note, Interval interval) {
    final distance = _runSemitonesDistance(
      note,
      interval.semitones,
      Accidentals.Sostingut,
    );

    return distance < Music.chromaticDivisions
        ? distance
        : _runSemitonesDistance(
              note,
              interval.inverted.semitones,
              Accidentals.Bemoll,
            ) *
            -1;
  }

  /// Returns the iteration distance of an [interval] between this [Note] and [note]
  /// with a [preferredAccidental].
  ///
  /// It is mainly used by [intervalDistance].
  int _runSemitonesDistance(
    Note note,
    int semitones,
    Accidentals preferredAccidental,
  ) {
    var distance = 0;
    var currentPitch = this.semitones;

    var tempNote = Note.fromSemitones(currentPitch, preferredAccidental);

    while (tempNote != note && distance < Music.chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = Note.fromSemitones(currentPitch, preferredAccidental);
    }

    return distance;
  }

  /// Returns the exact interval between this [Note] and [note].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.Do).exactInterval(const Note(Notes.Re))
  ///   == const Interval(Intervals.Segona, Qualities.Menor)
  ///
  /// const Note(Notes.Re).exactInterval(const Note(Notes.La, Accidentals.Bemoll))
  ///   == const Interval(Intervals.Quinta, Qualities.Disminuida)
  /// ```
  Interval exactInterval(Note note) {
    final interval = this.note.interval(note.note);

    return Interval.fromDelta(
      interval,
      semitonesDelta(note) - interval.semitones + 1,
    );
  }

  /// Returns the transposed [Note] by [semitones], with an optional
  /// [preferredAccidental].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.Mi, Accidentals.Bemoll).transposeBySemitones(-3)
  ///   == const Note(Notes.Do)
  ///
  /// const Note(Notes.La).transposeBySemitones(5)
  ///   == const Note(Notes.Re)
  /// ```
  Note transposeBySemitones(int semitones, [Accidentals preferredAccidental]) =>
      Note.fromSemitones(this.semitones + semitones, preferredAccidental);

  /// Returns the [Note] transposed by [interval].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.Mi).transposeByInterval(
  ///   const Interval(Intervals.Quinta, Qualities.Justa),
  /// ) == const Note(Notes.Si)
  ///
  /// const Note(Notes.Sol).transposeByInterval(
  ///   const Interval(Intervals.Tercera, Qualities.Major, descending: true),
  /// ) == const Note(Notes.Mi, Accidentals.Bemoll)
  /// ```
  Note transposeByInterval(Interval interval) {
    final note = this.note.transpose(
          interval.interval,
          descending: interval.descending,
        );

    return Note(
      note,
      AccidentalsValues.fromValue(semitones + interval.semitones - note.value),
    );
  }

  @override
  String toString() =>
      note.toText() + (accidental != null ? ' ${accidental.toText()}' : '');

  @override
  bool operator ==(other) =>
      other is Note && note == other.note && accidental == other.accidental;
}
