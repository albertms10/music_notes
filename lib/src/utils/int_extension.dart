/// An int extension.
extension IntExtension on int {
  /// This [int] incremented by [step].
  ///
  /// Example:
  /// ```dart
  /// 1.incrementBy(1) == 2
  /// (-1).incrementBy(1) == -2
  /// 10.incrementBy(-2) == 8
  /// (-10).incrementBy(-2) == -8
  /// ```
  int incrementBy(int step) => (abs() + step) * nonZeroSign;

  /// The modulo [n] of this [int], returning [n] when the modulo would give 0.
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

  /// The sign of this integer.
  ///
  /// Like [sign] except that it returns 1 for zero (considering it positive).
  ///
  /// Example:
  /// ```dart
  /// 5.nonZeroSign == 1
  /// 0.nonZeroSign == 1
  /// (-2).nonZeroSign == -1
  /// ```
  int get nonZeroSign => isNegative ? -1 : 1;
}
