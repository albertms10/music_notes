import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/mixins/music.dart';
import 'package:music_notes_relations/model/note.dart';
import 'package:test/test.dart';

void main() {
  test('Chromatic scale is calculed correctly', () {
    expect(
        Music.chromaticScale,
        equals([
          EnharmonicNote([
            Note(Notes.Do),
          ]),
          EnharmonicNote([
            Note(Notes.Do, Accidentals.Sostingut),
            Note(Notes.Re, Accidentals.Bemoll)
          ]),
          EnharmonicNote([
            Note(Notes.Re),
          ]),
          EnharmonicNote([
            Note(Notes.Re, Accidentals.Sostingut),
            Note(Notes.Mi, Accidentals.Bemoll)
          ]),
          EnharmonicNote([
            Note(Notes.Mi),
          ]),
          EnharmonicNote([
            Note(Notes.Fa),
          ]),
          EnharmonicNote([
            Note(Notes.Fa, Accidentals.Sostingut),
            Note(Notes.Sol, Accidentals.Bemoll)
          ]),
          EnharmonicNote([
            Note(Notes.Sol),
          ]),
          EnharmonicNote([
            Note(Notes.Sol, Accidentals.Sostingut),
            Note(Notes.La, Accidentals.Bemoll)
          ]),
          EnharmonicNote([
            Note(Notes.La),
          ]),
          EnharmonicNote([
            Note(Notes.La, Accidentals.Sostingut),
            Note(Notes.Si, Accidentals.Bemoll),
          ]),
          EnharmonicNote([
            Note(Notes.Si),
          ])
        ]));
  });
}
