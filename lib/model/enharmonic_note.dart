import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/mixins/music.dart';
import 'package:music_notes_relations/model/note.dart';

class EnharmonicNote with Music {
  final List<Note> enharmonicNotes;

  EnharmonicNote(this.enharmonicNotes) : assert(enharmonicNotes.length > 0);


  static EnharmonicNote getEnharmonicNotes(int value) {
    EnharmonicNote enharmonicNote;

    final note = NotesValues.note(value);

    if (note != null) {
      enharmonicNote = EnharmonicNote([Note(note)]);
    } else {
      var noteBelow = NotesValues.note(value - 1);
      var noteAbove = NotesValues.note(value + 1);

      enharmonicNote = EnharmonicNote([
        Note(noteBelow, Accidentals.Sostingut),
        Note(noteAbove, Accidentals.Bemoll)
      ]);
    }

    return enharmonicNote;
  }

  @override
  String toString() => '$enharmonicNotes';
}
