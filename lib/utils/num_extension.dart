extension NumExtension on num {
  /// Returns a delta string representation of this [num].
  ///
  /// Example:
  /// ```dart
  /// 1.1.toDeltaString() == '+1.1'
  /// 0.toDeltaString() == '+0'
  /// (-5).toDeltaString() == '-5'
  /// ```
  String toDeltaString() => isNegative ? '$this' : '+$this';
}
