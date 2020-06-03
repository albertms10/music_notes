import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/mixins/music.dart';
import 'package:music_notes_relations/model/note.dart';

class EnharmonicNote with Music {
  final Set<Note> enharmonicNotes;

  EnharmonicNote(this.enharmonicNotes)
      : assert(enharmonicNotes.isNotEmpty),
        assert(
          enharmonicNotes.every(
            (element) => element.value == enharmonicNotes.toList()[0].value,
          ),
          "The notes are not enharmonic",
        );

  EnharmonicNote.fromValue(int value)
      : this(getEnharmonicNote(value).enharmonicNotes);

  int get value => enharmonicNotes.toList()[0].value;

  static EnharmonicNote getEnharmonicNote(int value) {
    final note = NotesValues.note(value);

    if (note != null) return EnharmonicNote({Note(note)});

    var noteBelow = NotesValues.note(value - 1);
    var noteAbove = NotesValues.note(value + 1);

    return EnharmonicNote({
      Note(noteBelow, Accidentals.Sostingut),
      Note(noteAbove, Accidentals.Bemoll)
    });
  }

  int enharmonicIntervalDistance(EnharmonicNote note, int interval) {
    int distance = 0;
    int currentPitch = this.value;
    EnharmonicNote tempNote = EnharmonicNote.fromValue(currentPitch);

    while (tempNote != note) {
      distance++;
      currentPitch += interval;
      tempNote = EnharmonicNote.fromValue(currentPitch);
    }

    return distance;
  }

  @override
  String toString() => '$enharmonicNotes';

  @override
  bool operator ==(other) =>
      other is EnharmonicNote && this.value == other.value;
}
