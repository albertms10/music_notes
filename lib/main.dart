import 'package:music_notes/music_notes.dart';

void main() {
  [
    CircleOfFifths.exactFifthsDistance(Note(Notes.Do), Note(Notes.Fa)),
    Interval(Intervals.Quinta, Qualities.Justa).inverted
  ].forEach(print);
}
