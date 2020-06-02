import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/mixins/music.dart';
import 'package:music_notes_relations/model/note.dart';

class EnharmonicNote with Music {
  final List<Note> enharmonicNotes;

  EnharmonicNote(this.enharmonicNotes)
      : assert(
          enharmonicNotes.length > 0,
          enharmonicNotes.every(
              (element) => element.noteValue == enharmonicNotes[0].noteValue),
        );

  EnharmonicNote.fromValue(int value)
      : this(getEnharmonicNote(value).enharmonicNotes);

  int get value => enharmonicNotes[0].noteValue;

  static EnharmonicNote getEnharmonicNote(int value) {
    final modValue = Music.modValue(value);
    final note = NotesValues.note(modValue);

    if (note != null) return EnharmonicNote([Note(note)]);

    var noteBelow = NotesValues.note(Music.modValue(modValue - 1));
    var noteAbove = NotesValues.note(Music.modValue(modValue + 1));

    return EnharmonicNote([
      Note(noteBelow, Accidentals.Sostingut),
      Note(noteAbove, Accidentals.Bemoll)
    ]);
  }

  @override
  String toString() => '$enharmonicNotes';

  @override
  bool operator ==(other) =>
      other is EnharmonicNote && this.value == other.value;
}
