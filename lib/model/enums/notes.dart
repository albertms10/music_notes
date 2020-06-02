import 'package:music_notes_relations/model/mixins/music.dart';

enum Notes { Do, Re, Mi, Fa, Sol, La, Si }

extension NotesValues on Notes {
  static const noteValues = {
    Notes.Do: 1,
    Notes.Re: 3,
    Notes.Mi: 5,
    Notes.Fa: 6,
    Notes.Sol: 8,
    Notes.La: 10,
    Notes.Si: 12,
  };

  static Notes note(int value) => noteValues.keys.firstWhere(
      (note) => Music.modValue(value) == noteValues[note],
      orElse: () => null);

  int get value => noteValues[this];
}
