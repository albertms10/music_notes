import 'package:music_notes/music_notes.dart';

void main() {
  [
    Note(Notes.Do).exactInterval(Note(Notes.Fa, Accidentals.Sostingut)),
  ].forEach(print);
}
