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
          const Note(Notes.ut, Accidental.sharp),
          const Note(Notes.re, Accidental.flat),
        }),
        EnharmonicNote({
          const Note(Notes.re),
        }),
        EnharmonicNote({
          const Note(Notes.re, Accidental.sharp),
          const Note(Notes.mi, Accidental.flat),
        }),
        EnharmonicNote({
          const Note(Notes.mi),
        }),
        EnharmonicNote({
          const Note(Notes.fa),
        }),
        EnharmonicNote({
          const Note(Notes.fa, Accidental.sharp),
          const Note(Notes.sol, Accidental.flat),
        }),
        EnharmonicNote({
          const Note(Notes.sol),
        }),
        EnharmonicNote({
          const Note(Notes.sol, Accidental.sharp),
          const Note(Notes.la, Accidental.flat),
        }),
        EnharmonicNote({
          const Note(Notes.la),
        }),
        EnharmonicNote({
          const Note(Notes.la, Accidental.sharp),
          const Note(Notes.si, Accidental.flat),
        }),
        EnharmonicNote({
          const Note(Notes.si),
        }),
      ]),
    );
  });
}
