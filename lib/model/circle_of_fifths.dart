import 'dart:math' as math;

import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

class CircleOfFifths {
  static List<EnharmonicNote> get fifthsCircle {
    final notes = <EnharmonicNote>[];

    for (int i = 0; i < Music.chromaticDivisions * 7; i += 7)
      notes.add(Music.chromaticScale[Music.modValue(i)]);

    return notes;
  }

    int distanceAbove = note1.intervalDistance(note2, 7);
    int distanceBelow = note1.intervalDistance(note2, -7);

    return math.min(distanceAbove, distanceBelow);
  }
}
