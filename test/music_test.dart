import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  test('Chromatic scale is correct', () {
    expect(
        Music.chromaticScale,
        equals([
          EnharmonicNote({
            const Note(Notes.Do),
          }),
          EnharmonicNote({
            const Note(Notes.Do, Accidentals.Sostingut),
            const Note(Notes.Re, Accidentals.Bemoll)
          }),
          EnharmonicNote({
            const Note(Notes.Re),
          }),
          EnharmonicNote({
            const Note(Notes.Re, Accidentals.Sostingut),
            const Note(Notes.Mi, Accidentals.Bemoll)
          }),
          EnharmonicNote({
            const Note(Notes.Mi),
          }),
          EnharmonicNote({
            const Note(Notes.Fa),
          }),
          EnharmonicNote({
            const Note(Notes.Fa, Accidentals.Sostingut),
            const Note(Notes.Sol, Accidentals.Bemoll)
          }),
          EnharmonicNote({
            const Note(Notes.Sol),
          }),
          EnharmonicNote({
            const Note(Notes.Sol, Accidentals.Sostingut),
            const Note(Notes.La, Accidentals.Bemoll)
          }),
          EnharmonicNote({
            const Note(Notes.La),
          }),
          EnharmonicNote({
            const Note(Notes.La, Accidentals.Sostingut),
            const Note(Notes.Si, Accidentals.Bemoll),
          }),
          EnharmonicNote({
            const Note(Notes.Si),
          })
        ]));
  });
}
