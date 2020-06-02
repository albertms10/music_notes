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
          [
            Note(Notes.Do),
          ],
          [
            Note(Notes.Do, Accidentals.Sostingut),
            Note(Notes.Re, Accidentals.Bemoll)
          ],
          [
            Note(Notes.Re),
          ],
          [
            Note(Notes.Re, Accidentals.Sostingut),
            Note(Notes.Mi, Accidentals.Bemoll)
          ],
          [
            Note(Notes.Mi),
          ],
          [
            Note(Notes.Fa),
          ],
          [
            Note(Notes.Fa, Accidentals.Sostingut),
            Note(Notes.Sol, Accidentals.Bemoll)
          ],
          [
            Note(Notes.Sol),
          ],
          [
            Note(Notes.Sol, Accidentals.Sostingut),
            Note(Notes.La, Accidentals.Bemoll)
          ],
          [
            Note(Notes.La),
          ],
          [
            Note(Notes.La, Accidentals.Sostingut),
            Note(Notes.Si, Accidentals.Bemoll),
          ],
          [
            Note(Notes.Si),
          ]
        ]));
  });
}
