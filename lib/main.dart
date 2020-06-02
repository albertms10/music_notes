import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

void main() {
  print(Music.chromaticScale);
  print(FifthsCircle.fifthsCircle);
}

class FifthsCircle {
  static List<EnharmonicNote> get fifthsCircle {
    final notes = <EnharmonicNote>[];

    for (int i = 0; i < Music.chromaticDivisions * 7; i += 7)
      notes.add(Music.chromaticScale[Music.modValue(i)]);

    return notes;
  }

  static int fifthsDistance(EnharmonicNote note1, EnharmonicNote note2) {}
}
