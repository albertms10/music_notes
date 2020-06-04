part of music_notes;

abstract class CircleOfFifths {
  /// Returns a [Set] of [EnharmonicNotes] that conforms the circle of fifths.
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

  /// Returns the shortest iteration distance between two [EnharmonicNote]s
  /// in fifth intervals.
  ///
  /// ```dart
  /// CircleOfFifths.shortestFifthsDistance(
  ///   EnharmonicNote({Note(Notes.Fa, Accidentals.Sostingut)}),
  ///   EnharmonicNote({Note(Notes.La)})
  /// ) == -3
  /// 
  /// CircleOfFifths.shortestFifthsDistance(
  ///   EnharmonicNote.fromValue(4),
  ///   EnharmonicNote.fromValue(8)
  /// ) == 4
  /// ```
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

  /// Returns the exact iteration distance between two [Note]s
  /// in fifth intervals.
  /// 
  /// ```dart
  /// CircleOfFifths.exactFifthsDistance(
  ///   Note(Notes.La, Accidentals.Bemoll),
  ///   Note(Notes.Do, Accidentals.Sostingut)
  /// ) == 11
  /// 
  /// CircleOfFifths.exactFifthsDistance(
  ///   Note(Notes.La, Accidentals.Bemoll),
  ///   Note(Notes.Re, Accidentals.Bemoll)
  /// ) == -1
  /// ```
  static int exactFifthsDistance(Note note1, Note note2) =>
      note1.intervalDistance(
        note2,
        const Interval(Intervals.Quinta, Qualities.Justa),
      );
}
