/// A num extension.
extension NumExtension on num {
  /// The delta string representation of this [num]
  /// (showing always the positive sign).
  ///
  /// Example:
  /// ```dart
  /// 1.1.toDeltaString() == '+1.1'
  /// 0.toDeltaString() == '+0'
  /// (-5).toDeltaString() == '-5'
  /// ```
  String toDeltaString() => isNegative ? '$this' : '+$this';

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
