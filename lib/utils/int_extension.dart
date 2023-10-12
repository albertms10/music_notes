/// An int extension.
extension IntExtension on int {
  /// Returns this [int] incremented by [step].
  ///
  /// Example:
  /// ```dart
  /// 1.incrementBy(1) == 2
  /// (-1).incrementBy(1) == -2
  /// 10.incrementBy(-2) == 8
  /// (-10).incrementBy(-2) == -8
  /// ```
  int incrementBy(int step) => (abs() + step) * (isNegative ? -1 : 1);

  /// Returns the modulo [n] of this [int], returning [n] when the modulo would
  /// give 0.
  ///
  /// Example:
  /// ```dart
  /// 9.nonZeroMod(3) == 3
  /// 7.nonZeroMod(7) == 7
  /// 0.nonZeroMod(5) == 5
  /// ```
  int nonZeroMod(int n) {
    final mod = this % n;

    return mod == 0 ? n : mod;
  }
}
