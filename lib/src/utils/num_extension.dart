/// A num extension.
extension NumExtension on num {
  /// The plus sign.
  static const plusSign = '+';

  /// The Unicode minus sign.
  static const minusSign = '−';

  /// The delta string representation of this [num]
  /// (showing always the positive sign).
  ///
  /// Example:
  /// ```dart
  /// 1.1.toDeltaString() == '+1.1'
  /// 0.toDeltaString() == '+0'
  /// (-5).toDeltaString() == '-5'
  /// ```
  String toDeltaString({bool useAscii = false}) => isNegative
      ? (useAscii ? '$this' : toNegativeUnicode())
      : '$plusSign$this';

  /// The negative Unicode representation of this [num].
  ///
  /// Example:
  /// ```dart
  /// 1.1.toNegativeUnicode() == '1.1'
  /// 0.toNegativeUnicode() == '0'
  /// (-5).toNegativeUnicode() == '−5'
  /// ```
  String toNegativeUnicode() => isNegative ? '$minusSign${-this}' : '$this';

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
