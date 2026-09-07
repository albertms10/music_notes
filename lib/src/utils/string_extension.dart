import 'num_extension.dart';

/// String helpers for casing decisions and notation clean-up, mostly in
/// support of parsers and formatters that mix letter case with meaning
/// (e.g. distinguishing a bass-register `H` from a treble-register `h` in
/// [GermanNoteNameNotation]) or need to strip typographic symbols back to
/// plain ASCII before calling [num.parse].
extension StringExtension on String {
  /// Whether every cased character in this [String] is uppercase (an empty
  /// string counts as uppercase, vacuously).
  ///
  /// Example:
  /// ```dart
  /// 'ABC'.isUpperCase == true
  /// 'xyz'.isUpperCase == false
  /// 'John'.isUpperCase == false
  /// ```
  bool get isUpperCase => toUpperCase() == this;

  /// This [String] with its first letter capitalized and every other
  /// letter lowercased, as in the "Major"/"Minor" of
  /// [GermanTonalModeNotation]'s formatted output.
  ///
  /// Example:
  /// ```dart
  /// 'hello world'.toUpperFirst() == 'Hello world'
  /// 'HELLO WORLD'.toUpperFirst() == 'Hello world'
  /// ```
  String toUpperFirst() {
    if (isEmpty) return this;

    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// This [String] with [NumExtension.minusSign] and
  /// [NumExtension.plusMinusSign] rewritten as plain ASCII `-` and `+`, so
  /// the result can be handed to [num.parse] (which doesn't recognize the
  /// Unicode symbols this library uses when formatting negative and
  /// delta values).
  ///
  /// Example:
  /// ```dart
  /// '1'.toAscii() == '1'
  /// '−5'.toAscii() == '-5'
  /// ```
  // ignore: unnecessary_this for improved code formatting.
  String toAscii() => this
      .replaceFirst(NumExtension.minusSign, '-')
      .replaceFirst(NumExtension.plusMinusSign, '+');
}
