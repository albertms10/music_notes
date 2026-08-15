import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../accidental/accidental.dart';
import '../notation_system/notation_system.dart';
import '../scale/scale.dart';
import 'numeric_scale_degree_notation.dart';
import 'roman_scale_degree_notation.dart';

/// A scale degree.
///
/// ---
/// See also:
/// * [Scale].
@immutable
final class ScaleDegree
    implements Comparable<ScaleDegree>, Formattable<ScaleDegree> {
  /// The ordinal that identifies this [ScaleDegree].
  final int ordinal;

  /// The chromatic alteration of this this [ScaleDegree].
  final Accidental accidental;

  /// Creates a new [ScaleDegree].
  const ScaleDegree(this.ordinal, {this.accidental = .natural})
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
  static const parsers = [
    RomanScaleDegreeNotation(),
    NumericScaleDegreeNotation(),
    NumericScaleDegreeNotation.ascii(),
    NumericScaleDegreeNotation.plain(),
  ];

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
  ///
  /// const chain = <NumericScaleDegreeNotation>[.new(), .plain()];
  /// ScaleDegree.parse('1̂', chain: chain) == ScaleDegree.i
  /// ScaleDegree.parse('♯4̂', chain: chain) == ScaleDegree.iv.raised
  /// ScaleDegree.parse('♭7', chain: chain) == ScaleDegree.vii.lowered
  /// ScaleDegree.parse('0', chain: chain) // throws a FormatException
  /// ```
  factory ScaleDegree.parse(
    String source, {
    List<StringParser<ScaleDegree>> chain = parsers,
  }) => chain.parse(source);

  /// Whether this [ScaleDegree] is raised.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.raised.isRaised == true
  /// ScaleDegree.neapolitanSixth.isRaised == false
  /// ```
  bool get isRaised => accidental.isSharp;

  /// Whether this [ScaleDegree] is lowered.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vi.isLowered == false
  /// ScaleDegree.neapolitanSixth.isLowered == true
  /// ```
  // using < 0 instead of isNegative to avoid -0 being treated as negative
  bool get isLowered => accidental.isFlat;

  /// This [ScaleDegree] raised by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vi.raised == const ScaleDegree(6, accidental: .sharp)
  /// ```
  ScaleDegree get raised => ScaleDegree(ordinal, accidental: accidental + 1);

  /// This [ScaleDegree] lowered by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.lowered == const ScaleDegree(2, accidental: .flat)
  /// ```
  ScaleDegree get lowered => ScaleDegree(ordinal, accidental: accidental - 1);

  /// The string representation of this [ScaleDegree] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.iii.format() == 'III'
  /// ScaleDegree.iv.raised.format() == '♯IV'
  /// ScaleDegree.vii.lowered.format() == '♭VII'
  ///
  /// const numeric = NumericScaleDegreeNotation();
  /// ScaleDegree.iii.format(numeric) == '3̂'
  /// ScaleDegree.iv.raised.format(numeric) == '♯4̂'
  /// ScaleDegree.vii.lowered.format(numeric) == '♭7̂'
  /// ```
  @override
  String format([
    StringFormatter<ScaleDegree> formatter = const RomanScaleDegreeNotation(),
  ]) => formatter.format(this);

  @override
  String toString() =>
      '$runtimeType(ordinal: $ordinal, accidental: $accidental)';

  @override
  bool operator ==(Object other) =>
      other is ScaleDegree &&
      ordinal == other.ordinal &&
      accidental == other.accidental;

  @override
  int get hashCode => Object.hash(ordinal, accidental);

  @override
  int compareTo(ScaleDegree other) => compareMultiple([
    () => ordinal.compareTo(other.ordinal),
    () => accidental.compareTo(other.accidental),
  ]);
}
