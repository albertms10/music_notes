import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

void main() {
  print(FifthsCircle.chromaticScale);
  print(FifthsCircle.fifthsCircle);
}

class FifthsCircle {
  static final chromaticScale = [
    for (int i = 1; i <= Music.chromaticDivisions; i++)
      EnharmonicNote.fromValue(i)
  ];

  static List<EnharmonicNote> get fifthsCircle {
    final notes = <EnharmonicNote>[];

    for (int i = 0; i < Music.chromaticDivisions * 7; i += 7)
      notes.add(chromaticScale[i % chromaticScale.length]);

    return notes;
  }

  static int fifthsDistance(EnharmonicNote note1, EnharmonicNote note2) {}
}
