/// A string extension.
extension StringExtension on String {
  /// Whether this [String] is upper-cased.
  ///
  /// Example:
  /// ```dart
  /// 'ABC'.isUpperCase == true
  /// 'xyz'.isUpperCase == false
  /// 'John'.isUpperCase == false
  /// ```
  bool get isUpperCase => toUpperCase() == this;

  /// Converts the first letter of the string to uppercase and the rest to
  /// lowercase.
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
}
