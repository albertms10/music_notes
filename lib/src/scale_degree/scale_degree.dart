import 'package:meta/meta.dart' show immutable;

import '../notation_system/notation_system.dart';
import '../scale/scale.dart';
import 'roman_scale_degree_notation.dart';

/// A scale degree.
///
/// ---
/// See also:
/// * [Scale].
@immutable
class ScaleDegree implements Comparable<ScaleDegree>, Formattable<ScaleDegree> {
  /// The ordinal that identifies this [ScaleDegree].
  final int ordinal;

  /// Creates a new [ScaleDegree].
  const ScaleDegree(this.ordinal)
    : assert(ordinal > 0, 'Ordinal must be greater than zero.');

  /// The I (tonic) [ScaleDegree].
  static const i = ScaleDegree(1);

  /// The II [ScaleDegree].
  static const ii = ScaleDegree(2);

  /// The III [ScaleDegree].
  static const iii = ScaleDegree(3);

  /// The IV [ScaleDegree].
  static const iv = ScaleDegree(4);

  /// The V [ScaleDegree].
  static const v = ScaleDegree(5);

  /// The VI [ScaleDegree].
  static const vi = ScaleDegree(6);

  /// The VII [ScaleDegree].
  static const vii = ScaleDegree(7);

  /// The chain of [StringParser]s used to parse a [ScaleDegree].
  static const parsers = [RomanScaleDegreeNotation()];

  /// Parse [source] as a [ScaleDegree] and return its value.
  ///
  /// If the [source] string does not contain a valid [ScaleDegree], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.parse('I') == .i
  /// ScaleDegree.parse('ii') == .ii
  /// ScaleDegree.parse('vi') == .vi
  /// ScaleDegree.parse('z') // throws a FormatException
  /// ```
  factory ScaleDegree.parse(
    String source, {
    List<StringParser<ScaleDegree>> chain = parsers,
  }) => chain.parse(source);

  /// The string representation of this [ScaleDegree] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.iii.format() == 'III'
  /// ```
  @override
  String format([
    StringFormatter<ScaleDegree> formatter = const RomanScaleDegreeNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(ordinal: $ordinal)';

  @override
  bool operator ==(Object other) =>
      other is ScaleDegree && ordinal == other.ordinal;

  @override
  int get hashCode => ordinal.hashCode;

  @override
  int compareTo(ScaleDegree other) => ordinal.compareTo(other.ordinal);
}
