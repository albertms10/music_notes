import 'dart:math' as math;

import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/mixins/music.dart';
import 'package:music_notes_relations/model/note.dart';

class CircleOfFifths {
  static Set<EnharmonicNote> get fifthsCircle {
    final notes = <EnharmonicNote>{};

    for (int i = 0; i < Music.chromaticDivisions * 7; i += 7)
      notes.add(Music.chromaticScale.toList()[Music.modValueWithZero(i)]);

    return notes;
  }

  static int shortestFifthsDistance(
      EnharmonicNote enharmonicNote1, EnharmonicNote enharmonicNote2) {
    final int distanceAbove =
        enharmonicNote1.enharmonicSemitonesDistance(enharmonicNote2, 7);
    final int distanceBelow =
        enharmonicNote1.enharmonicSemitonesDistance(enharmonicNote2, -7);

    return math.min(distanceAbove, distanceBelow);
  }

  static int exactFifthsDistance(Note note1, Note note2) =>
      note1.exactIntervalDistance(note2, 7);
}
