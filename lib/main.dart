import 'package:music_notes_relations/model/enharmonic_note.dart';

void main() {
  print(FifthsCircle.chromaticScale);
  print(FifthsCircle.fifthsCircle);
}

class FifthsCircle {
  static final chromaticScale = [
    for (int i = 1; i <= 12; i++) EnharmonicNote.getEnharmonicNotes(i)
  ];

  static List<EnharmonicNote> get fifthsCircle {
    final notes = <EnharmonicNote>[];

    for (int i = 0; i < 12 * 7; i += 7)
      notes.add(chromaticScale[i % chromaticScale.length]);

    return notes;
  }
}
