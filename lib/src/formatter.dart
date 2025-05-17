import 'package:meta/meta.dart' show mustBeOverridden;

/// An abstract representation of a formatter for [T].
abstract class Formatter<T> {
  /// Creates a new formatter.
  const Formatter();

  /// Formats this [T].
  @mustBeOverridden
  String format(T value);

  /// Parses [source] as [T].
  @mustBeOverridden
  T parse(String source);
}
