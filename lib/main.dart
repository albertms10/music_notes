import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/note.dart';

void main() {
  print(EnharmonicNote.getEnharmonicNotes(12));
}

class FifthsCircle {
  static final explicitChromaticScale = [
    EnharmonicNote([Note(Notes.Do)]),
    EnharmonicNote([
      Note(Notes.Do, Accidentals.Sostingut),
      Note(Notes.Re, Accidentals.Bemoll)
    ]),
    EnharmonicNote([Note(Notes.Re)]),
    EnharmonicNote([
      Note(Notes.Re, Accidentals.Sostingut),
      Note(Notes.Mi, Accidentals.Bemoll)
    ]),
    EnharmonicNote([Note(Notes.Mi)]),
    EnharmonicNote([Note(Notes.Fa)]),
    EnharmonicNote([Note(Notes.Fa, Accidentals.Sostingut)]),
    EnharmonicNote([Note(Notes.Sol, Accidentals.Bemoll)]),
    EnharmonicNote([Note(Notes.Sol)]),
    EnharmonicNote([Note(Notes.Sol, Accidentals.Sostingut)]),
    EnharmonicNote([Note(Notes.La, Accidentals.Bemoll)]),
    EnharmonicNote([Note(Notes.La)]),
    EnharmonicNote([
      Note(Notes.La, Accidentals.Sostingut),
      Note(Notes.Si, Accidentals.Bemoll)
    ]),
    EnharmonicNote([Note(Notes.Si)]),
  ];

  static List<List<Note>> get fifthsCircle {
    final notes = <List<Note>>[];

    for (int i = -6; i <= 6 * 7; i += 7) {
      //notes.add(explicitChromaticScale[i % explicitChromaticScale.length]);
    }

    return notes;
  }
}
