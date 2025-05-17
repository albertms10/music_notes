/// An abstract representation of a formatter for [T].
///
/// The [format] and [parse] methods are designed to be [inverses](https://en.wikipedia.org/wiki/Inverse_function)
/// of each other:
/// the output of [format] should be a valid argument for [parse], and
/// `parse(format(value))` should return a value equal to the original value.
abstract class Formatter<T> {
  /// Creates a new formatter.
  const Formatter();

  /// Formats this [T].
  ///
  /// The output of this method should be accepted by [parse] to reconstruct
  /// the original value.
  String format(T value);

  /// Parses [source] as [T].
  ///
  /// The input [source] should typically be produced by [format], ensuring
  /// that `parse(format(value)) == value`.
  T parse(String source);
}
