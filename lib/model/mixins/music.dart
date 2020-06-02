import 'package:music_notes_relations/model/enharmonic_note.dart';

mixin Music {
  static int chromaticDivisions = 12;

  static int modValue(int value) =>
      value == chromaticDivisions ? value : value % chromaticDivisions;

  static final chromaticScale = [
    for (int i = 1; i <= Music.chromaticDivisions; i++)
      EnharmonicNote.fromValue(i)
  ];
}
