import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

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
      (note) => Music.modValue(value) == notesValues[note],
      orElse: () => null);

  static int index(int value) => notesValues.values.toList().indexOf(value);

  int get value => notesValues[this];

  Intervals interval(Notes note) => IntervalsValues.interval(
        NotesValues.index(note.value) - NotesValues.index(this.value) + 1,
      );
}
