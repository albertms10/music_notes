part of music_notes;

abstract class Music {
  static const int chromaticDivisions = 12;

  static final chromaticScale = {
    for (int i = 1; i <= chromaticDivisions; i++) EnharmonicNote.fromSemitone(i)
  };

  static int modValue(int value) => nModValue(value, chromaticDivisions);

  static int nModValue(int value, int n) => value % n;

  static int modValueWithZero(int value) =>
      nModValueWithZero(value, chromaticDivisions);

  static int nModValueWithZero(int value, int n) {
    int modValue = value % n;
    return modValue == 0 ? n : modValue;
  }
}
