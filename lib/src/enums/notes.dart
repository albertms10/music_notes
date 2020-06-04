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

  static Notes note(int value) => notesValues.keys.firstWhere(
        (note) => Music.modValueWithZero(value) == notesValues[note],
        orElse: () => null,
      );

  static bool needsAccidental(int value) => note(value) == null;

  static int index(int value) => notesValues.values.toList().indexOf(value);

  int get value => notesValues[this];

  Intervals interval(Notes note) {
    int noteIndex1 = NotesValues.index(this.value);
    int noteIndex2 = NotesValues.index(note.value);

    if (noteIndex1 > noteIndex2) noteIndex2 += notesValues.length;

    return IntervalsValues.interval(noteIndex2 - noteIndex1 + 1);
  }
}
