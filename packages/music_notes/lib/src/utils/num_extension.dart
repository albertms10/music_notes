/// A num extension.
extension NumExtension on num {
  /// The plus sign.
  static const plusSign = '+';

  /// The Unicode minus sign.
  static const minusSign = '−';

  /// The Unicode plus-minus sign.
  static const plusMinusSign = '±';

  String _formatted([int? fractionDigits]) => fractionDigits == null
      ? abs().toString()
      : abs().toStringAsFixed(fractionDigits);

  /// The delta string representation of this [num]
  /// (showing always the positive sign).
  ///
  /// -0.0 is treated the same as 0.0 (so, considered positive).
  ///
  /// Example:
  /// ```dart
  /// 1.1.toDeltaString() == '+1.1'
  /// 0.toDeltaString() == '±0'
  /// (-5).toDeltaString() == '−5'
  /// (-5).toDeltaString(useAscii: true) == '-5'
  /// (-10.27).toDeltaString(fractionDigits: 1) == '−10.3'
  /// ```
  String toDeltaString({bool useAscii = false, int? fractionDigits}) {
    final formatted = _formatted(fractionDigits);
    if (this < 0) return useAscii ? '-$formatted' : '$minusSign$formatted';
    if (!useAscii && double.tryParse(formatted)?.abs() == 0) {
      return '$plusMinusSign$formatted';
    }

    return '$plusSign$formatted';
  }

  /// The negative Unicode representation of this [num].
  ///
  /// -0.0 is treated the same as 0.0 (so, considered positive).
  ///
  /// Example:
  /// ```dart
  /// 1.1.toNegativeUnicode() == '1.1'
  /// 0.toNegativeUnicode() == '0'
  /// (-5).toNegativeUnicode() == '−5'
  /// (-10.27).toNegativeUnicode(1) == '−10.3'
  /// ```
  String toNegativeUnicode([int? fractionDigits]) => this < 0
      ? '$minusSign${_formatted(fractionDigits)}'
      : _formatted(fractionDigits);

  /// The sign of this integer.
  ///
  /// Like [sign] except that it returns 1 for zero (considering it positive).
  ///
  /// -0.0 is treated the same as 0.0 (so, considered positive), returning 1.
  ///
  /// Example:
  /// ```dart
  /// 5.nonZeroSign == 1
  /// 0.nonZeroSign == 1
  /// (-0.0).nonZeroSign == 1
  /// (-2).nonZeroSign == -1
  /// ```
  int get nonZeroSign => this < 0 ? -1 : 1;
}
