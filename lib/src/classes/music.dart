part of music_notes;

abstract class Music {
  /// Number of chromatic divisions in an octave.
  static const int chromaticDivisions = 12;

  /// [Set] of [EnharmonicNote]s that form the chromatic scale.
  static final chromaticScale = {
    for (int i = 1; i <= chromaticDivisions; i++) EnharmonicNote.fromSemitones(i)
  };

  /// Returns the modulus [chromaticDivisions] of [value].
  ///
  /// Examples:
  /// ```dart
  /// Music.modValue(4) == 4
  /// Music.modValue(14) == 2
  /// Music.modValue(-5) == 7
  /// Music.modValue(0) == 0
  /// Music.modValue(12) == 0
  /// ```
  static int modValue(int value) => nModValue(value, chromaticDivisions);

  /// Returns the modulus [n] of [value].
  ///
  /// Examples:
  /// ```dart
  /// Music.nModValue(6, 12) == 6
  /// Music.nModValue(8, 6) == 2
  /// ```
  static int nModValue(int value, int n) => value % n;

  /// Returns the modulus [chromaticDivisions] of [value]. If the
  /// is 0, it returns [chromaticDivisions].
  ///
  /// Examples:
  /// ```dart
  /// Music.modValueExcludeZero(15) == 3
  /// Music.modValueExcludeZero(12) == 12
  /// Music.modValueExcludeZero(0) == 12
  /// ```
  static int modValueExcludeZero(int value) =>
      nModValueExcludeZero(value, chromaticDivisions);

  /// Returns the modulus [n] of [value]. If the
  /// given value is 0, it returns [n].
  ///
  /// Examples:
  /// ```dart
  /// Music.nModValueExcludeZero(9, 3) == 3
  /// Music.nModValueExcludeZero(0, 5) == 5
  /// Music.nModValueExcludeZero(7, 7) == 7
  /// ```
  static int nModValueExcludeZero(int value, int n) {
    int modValue = value % n;
    return modValue == 0 ? n : modValue;
  }
}
