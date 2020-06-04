part of music_notes;

enum Notes { Do, Re, Mi, Fa, Sol, La, Si }

extension NotesValues on Notes {
  static const notesValues = {
    Notes.Do: 1,
    Notes.Re: 3,
    Notes.Mi: 5,
    Notes.Fa: 6,
    Notes.Sol: 8,
    Notes.La: 10,
    Notes.Si: 12,
  };

  static Notes fromValue(int value) => notesValues.keys.firstWhere(
        (note) => Music.modValueExcludeZero(value) == notesValues[note],
        orElse: () => null,
      );

  static Notes fromOrdinal(int ordinal) => Notes
      .values[Music.nModValueExcludeZero(ordinal, Notes.values.length) - 1];

  static bool needsAccidental(int value) => fromValue(value) == null;

  int get ordinal => Notes.values.indexOf(this) + 1;

  int get value => notesValues[this];

  Intervals interval(Notes note, {descending: false}) {
    int noteOrdinal1 = this.ordinal;
    int noteOrdinal2 = note.ordinal;

    if (!descending && noteOrdinal1 > noteOrdinal2)
      noteOrdinal2 += notesValues.length;

    return IntervalsValues.fromSemitones(
      ((noteOrdinal2 - noteOrdinal1) * (descending ? -1 : 1)) + 1,
    );
  }
}
