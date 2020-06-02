enum Notes { Do, Re, Mi, Fa, Sol, La, Si }

extension NotesValues on Notes {
  static Notes note(int value) => const {
        1: Notes.Do,
        3: Notes.Re,
        5: Notes.Mi,
        6: Notes.Fa,
        8: Notes.Sol,
        10: Notes.La,
        12: Notes.Si,
      }[value];

  int get value => const {
        Notes.Do: 1,
        Notes.Re: 3,
        Notes.Mi: 5,
        Notes.Fa: 6,
        Notes.Sol: 8,
        Notes.La: 10,
        Notes.Si: 12,
      }[this];
}
