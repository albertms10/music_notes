import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/note.dart';

class EnharmonicNote {
  final List<Note> enharmonicNotes;

  EnharmonicNote(this.enharmonicNotes);

  static List<Note> getEnharmonicNotes(int value) {
    final notes = <Note>[];

    final note = NotesValues.note(value);

    if (note != null) {
      notes.add(Note(note));
    } else {
      var noteBelow = NotesValues.note(value - 1);
      var noteAbove = NotesValues.note(value + 1);

      notes.addAll([
        Note(noteBelow, Accidentals.Sostingut),
        Note(noteAbove, Accidentals.Bemoll)
      ]);
    }

    return notes;
  }
}
