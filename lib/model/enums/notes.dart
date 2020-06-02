enum Notes { Do, Re, Mi, Fa, Sol, La, Si }

extension NotesValues on Notes {
  static const noteValues = {
    1: Notes.Do,
    3: Notes.Re,
    5: Notes.Mi,
    6: Notes.Fa,
    8: Notes.Sol,
    10: Notes.La,
    12: Notes.Si,
  };

  static Notes note(int value) => noteValues[value];

  int get value => noteValues.keys.firstWhere((element) => this == element);
}
