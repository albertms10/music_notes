import 'dart:math' as math;

import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/enums/qualities.dart';
import 'package:music_notes_relations/model/interval.dart';
import 'package:music_notes_relations/model/mixins/music.dart';
import 'package:music_notes_relations/model/note.dart';

class CircleOfFifths {
  static Set<EnharmonicNote> get fifthsCircle {
    final notes = <EnharmonicNote>{};

    int fifthSt = Interval(Intervals.Quinta, Qualities.Justa).semitones;

    for (int i = 0; i < Music.chromaticDivisions * fifthSt; i += fifthSt)
      notes.add(Music.chromaticScale.toList()[Music.modValueWithZero(i)]);

    return notes;
  }

  static int shortestFifthsDistance(
      EnharmonicNote enharmonicNote1, EnharmonicNote enharmonicNote2) {
    int fifthSt = Interval(Intervals.Quinta, Qualities.Justa).semitones;

    final int distanceAbove =
        enharmonicNote1.enharmonicSemitonesDistance(enharmonicNote2, fifthSt);
    final int distanceBelow =
        enharmonicNote1.enharmonicSemitonesDistance(enharmonicNote2, -fifthSt);

    return math.min(distanceAbove, distanceBelow);
  }

  static int exactFifthsDistance(Note note1, Note note2) =>
      note1.intervalDistance(
          note2, Interval(Intervals.Quinta, Qualities.Justa).semitones);
}
