part of music_notes;

abstract class CircleOfFifths {
  /// Returns a [Set] of [EnharmonicNote]s that conforms the circle of fifths.
  static Set<EnharmonicNote> get circleOfFifths => {
        for (var i = 0; i < Music.chromaticDivisions; i++)
          Music.chromaticScale.toList()[Music.modValueExcludeZero(
            i * const Interval(Intervals.Quinta, Qualities.Justa).semitones,
          )],
      };

  /// Returns the shortest iteration distance between two [EnharmonicNote]s
  /// in fifth intervals.
  ///
  /// Examples:
  /// ```dart
  /// CircleOfFifths.shortestFifthsDistance(
  ///   EnharmonicNote({const Note(Notes.Fa, Accidentals.Sostingut)}),
  ///   EnharmonicNote({const Note(Notes.La)}),
  /// ) == -3
  ///
  /// CircleOfFifths.shortestFifthsDistance(
  ///   EnharmonicNote.fromSemitones(4),
  ///   EnharmonicNote.fromSemitones(8),
  /// ) == 4
  /// ```
  static int shortestFifthsDistance(
    EnharmonicNote enharmonicNote1,
    EnharmonicNote enharmonicNote2,
  ) {
    final distanceAbove = enharmonicNote1.enharmonicIntervalDistance(
      enharmonicNote2,
      const Interval(Intervals.Quinta, Qualities.Justa),
    );
    final distanceBelow = enharmonicNote1.enharmonicIntervalDistance(
      enharmonicNote2,
      const Interval(Intervals.Quinta, Qualities.Justa, descending: true),
    );

    final minDistance = math.min(distanceAbove, distanceBelow);

    return minDistance * (minDistance == distanceAbove ? 1 : -1);
  }

  /// Returns the exact iteration distance between two [Note]s
  /// in fifth intervals.
  ///
  /// Examples:
  /// ```dart
  /// CircleOfFifths.exactFifthsDistance(
  ///   const Note(Notes.La, Accidentals.Bemoll),
  ///   const Note(Notes.Do, Accidentals.Sostingut),
  /// ) == 11
  ///
  /// CircleOfFifths.exactFifthsDistance(
  ///   const Note(Notes.La, Accidentals.Bemoll),
  ///   const Note(Notes.Re, Accidentals.Bemoll),
  /// ) == -1
  /// ```
  static int exactFifthsDistance(Note note1, Note note2) =>
      note1.intervalDistance(
        note2,
        const Interval(Intervals.Quinta, Qualities.Justa),
      );
}
