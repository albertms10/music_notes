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
}
