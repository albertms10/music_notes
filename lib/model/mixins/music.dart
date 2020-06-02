mixin Music {
  static int modValue(int value) => value == 12 ? value : value % 12;
}