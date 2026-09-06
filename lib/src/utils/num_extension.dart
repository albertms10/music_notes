/// Typographically correct number formatting for the deviations this
/// library reports constantly — cents offsets, fifths distances, interval
/// deltas — using the Unicode minus (`−`, U+2212) instead of a hyphen and
/// a plus-minus sign (`±`) for an exact zero, the way printed music theory
/// literature does.
extension NumExtension on num {
  /// The ASCII plus sign, used to prefix positive deltas.
  static const plusSign = '+';

  /// The Unicode minus sign (U+2212), used instead of a hyphen-minus to
  /// prefix negative deltas.
  static const minusSign = '−';

  /// The Unicode plus-minus sign (±), used to mark an exact-zero delta as
  /// neither sharp nor flat, neither ahead nor behind.
  static const plusMinusSign = '±';

  String _formatted([int? fractionDigits]) => fractionDigits == null
      ? abs().toString()
      : abs().toStringAsFixed(fractionDigits);

  /// This [num] formatted as a signed deviation: always prefixed with
  /// [plusSign] when positive, [minusSign] (or a hyphen, if [useAscii])
  /// when negative, and [plusMinusSign] for an exact zero — the format
  /// [Cent] offsets and [KeySignature] fifths distances are printed in.
  ///
  /// `-0.0` is treated the same as `0.0` (so, considered positive/neutral).
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

  /// This [num] rendered plainly, but with a negative value prefixed by
  /// [minusSign] rather than a hyphen — unlike [toDeltaString], a
  /// non-negative value gets no sign at all, as used for octave numbers
  /// in [ScientificPitchNotation] (e.g. `G♯−1`, not `G♯+−1`).
  ///
  /// `-0.0` is treated the same as `0.0` (so, considered non-negative).
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

  /// This value's sign, except zero (and `-0.0`) reports as `1` rather than
  /// `0`.
  ///
  /// [IntExtension.incrementBy] and similar magnitude-preserving
  /// operations rely on this to keep a direction to move in even when
  /// starting from zero, which plain [sign] cannot provide.
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
