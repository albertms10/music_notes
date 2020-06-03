import 'package:music_notes_relations/model/enharmonic_note.dart';

mixin Music {
  static final int chromaticDivisions = 12;

  static final chromaticScale = {
    for (int i = 1; i <= Music.chromaticDivisions; i++)
      EnharmonicNote.fromValue(i)
  };

  static int modValue(int value) {
    int modValue = value % chromaticDivisions;
    return modValue == 0 ? chromaticDivisions : modValue;
  }
}
