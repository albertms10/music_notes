import 'package:music_notes/music_notes.dart';

void main() {
  [
    const Note(Notes.Do).exactInterval(
      const Note(Notes.Fa, Accidentals.Sostingut),
    ),
  ].forEach(print);
}
