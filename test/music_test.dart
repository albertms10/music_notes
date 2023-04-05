import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  test('Chromatic scale is correct', () {
    expect(
      chromaticScale,
      equals([
        EnharmonicNote({
          const Note(Notes.ut),
        }),
        EnharmonicNote({
          const Note(Notes.ut, Accidentals.sharp),
          const Note(Notes.re, Accidentals.flat),
        }),
        EnharmonicNote({
          const Note(Notes.re),
        }),
        EnharmonicNote({
          const Note(Notes.re, Accidentals.sharp),
          const Note(Notes.mi, Accidentals.flat),
        }),
        EnharmonicNote({
          const Note(Notes.mi),
        }),
        EnharmonicNote({
          const Note(Notes.fa),
        }),
        EnharmonicNote({
          const Note(Notes.fa, Accidentals.sharp),
          const Note(Notes.sol, Accidentals.flat),
        }),
        EnharmonicNote({
          const Note(Notes.sol),
        }),
        EnharmonicNote({
          const Note(Notes.sol, Accidentals.sharp),
          const Note(Notes.la, Accidentals.flat),
        }),
        EnharmonicNote({
          const Note(Notes.la),
        }),
        EnharmonicNote({
          const Note(Notes.la, Accidentals.sharp),
          const Note(Notes.si, Accidentals.flat),
        }),
        EnharmonicNote({
          const Note(Notes.si),
        }),
      ]),
    );
  });
}
