mixin Music {
  static int chromaticDivisions = 12;

  static int modValue(int value) =>
      value == chromaticDivisions ? value : value % chromaticDivisions;
}
