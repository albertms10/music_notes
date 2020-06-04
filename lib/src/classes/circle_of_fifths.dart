part of music_notes;

abstract class CircleOfFifths {
  static Set<EnharmonicNote> get circleOfFifths {
    final notes = <EnharmonicNote>{};

    for (int i = 0; i < Music.chromaticDivisions; i++)
      notes.add(
        Music.chromaticScale.toList()[Music.modValueExcludeZero(
          i * const Interval(Intervals.Quinta, Qualities.Justa).semitones,
        )],
      );

    return notes;
  }

  static int shortestFifthsDistance(
    EnharmonicNote enharmonicNote1,
    EnharmonicNote enharmonicNote2,
  ) {
    final int distanceAbove = enharmonicNote1.enharmonicIntervalDistance(
      enharmonicNote2,
      const Interval(Intervals.Quinta, Qualities.Justa),
    );
    final int distanceBelow = enharmonicNote1.enharmonicIntervalDistance(
      enharmonicNote2,
      const Interval(Intervals.Quinta, Qualities.Justa, descending: true),
    );

    int minDistance = math.min(distanceAbove, distanceBelow);

    return minDistance * (minDistance == distanceAbove ? 1 : -1);
  }

  static int exactFifthsDistance(Note note1, Note note2) =>
      note1.intervalDistance(
        note2,
        const Interval(Intervals.Quinta, Qualities.Justa),
      );
}
