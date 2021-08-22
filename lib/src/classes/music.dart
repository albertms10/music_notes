part of music_notes;

abstract class Music {
  /// Number of chromatic divisions in an octave.
  static const int chromaticDivisions = 12;

  /// [Set] of [EnharmonicNote]s that form the chromatic scale.
  static final chromaticScale = {
    for (var i = 1; i <= chromaticDivisions; i++)
      EnharmonicNote.fromSemitones(i),
  };

  /// Returns a [Set] of [EnharmonicNote]s that conforms the circle of fifths.
  static Set<EnharmonicNote> get circleOfFifths => {
        for (var i = 0; i < chromaticDivisions; i++)
          chromaticScale.elementAt(chromaticMod(
            i * const Interval(Intervals.fifth, Qualities.perfect).semitones,
          )),
      };

  /// Returns the shortest iteration distance between two [EnharmonicNote]s
  /// in fifth intervals.
  ///
  /// Examples:
  /// ```dart
  /// Music.shortestFifthsDistance(
  ///   EnharmonicNote({const Note(Notes.fa, Accidentals.sharp)}),
  ///   EnharmonicNote({const Note(Notes.la)}),
  /// ) == -3
  ///
  /// Music.shortestFifthsDistance(
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
      const Interval(Intervals.fifth, Qualities.perfect),
    );
    final distanceBelow = enharmonicNote1.enharmonicIntervalDistance(
      enharmonicNote2,
      const Interval(Intervals.fifth, Qualities.perfect, descending: true),
    );

    final minDistance = math.min(distanceAbove, distanceBelow);

    return minDistance * (minDistance == distanceAbove ? 1 : -1);
  }

  /// Returns the exact iteration distance between two [Note]s
  /// in fifth intervals.
  ///
  /// Examples:
  /// ```dart
  /// Music.exactFifthsDistance(
  ///   const Note(Notes.la, Accidentals.flat),
  ///   const Note(Notes.ut, Accidentals.sharp),
  /// ) == 11
  ///
  /// Music.exactFifthsDistance(
  ///   const Note(Notes.la, Accidentals.flat),
  ///   const Note(Notes.re, Accidentals.flat),
  /// ) == -1
  /// ```
  static int exactFifthsDistance(Note note1, Note note2) =>
      note1.intervalDistance(
        note2,
        const Interval(Intervals.fifth, Qualities.perfect),
      );

  /// Returns the modulus [chromaticDivisions] of [value].
  ///
  /// Examples:
  /// ```dart
  /// Music.chromaticMod(4) == 4
  /// Music.chromaticMod(14) == 2
  /// Music.chromaticMod(-5) == 7
  /// Music.chromaticMod(0) == 0
  /// Music.chromaticMod(12) == 0
  /// ```
  static int chromaticMod(int value) => value % chromaticDivisions;

  /// Returns the modulus [chromaticDivisions] of [value]. If the
  /// is 0, it returns [chromaticDivisions].
  ///
  /// Examples:
  /// ```dart
  /// Music.chromaticModExcludeZero(15) == 3
  /// Music.chromaticModExcludeZero(12) == 12
  /// Music.chromaticModExcludeZero(0) == 12
  /// ```
  static int chromaticModExcludeZero(int value) =>
      nModExcludeZero(value, chromaticDivisions);

  /// Returns the modulus [n] of [value]. If the
  /// given value is 0, it returns [n].
  ///
  /// Examples:
  /// ```dart
  /// Music.nModExcludeZero(9, 3) == 3
  /// Music.nModExcludeZero(0, 5) == 5
  /// Music.nModExcludeZero(7, 7) == 7
  /// ```
  static int nModExcludeZero(int value, int n) {
    final modValue = value % n;
    return modValue == 0 ? n : modValue;
  }
}
