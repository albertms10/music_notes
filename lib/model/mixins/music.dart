import 'package:music_notes_relations/model/enharmonic_note.dart';

mixin Music {
  static const int chromaticDivisions = 12;

  static final chromaticScale = {
    for (int i = 1; i <= chromaticDivisions; i++)
      EnharmonicNote.fromSemitone(i)
  };

  static int modValue(int value) => value % chromaticDivisions;

  static int modValueWithZero(int value) {
    int modValue = value % chromaticDivisions;
    return modValue == 0 ? chromaticDivisions : modValue;
  }
}
