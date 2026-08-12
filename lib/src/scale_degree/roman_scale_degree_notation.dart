import '../accidental/accidental.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../notation_system/notation_system.dart';
import 'scale_degree.dart';

/// The roman [ScaleDegree] notation formatter.
final class RomanScaleDegreeNotation extends StringNotationSystem<ScaleDegree> {
  /// The [StringNotationSystem] for [Accidental].
  final StringNotationSystem<Accidental> accidentalNotation;

  /// Whether to use uppercase for roman numerals.
  final bool useUppercase;

  /// Creates a new [RomanScaleDegreeNotation].
  const RomanScaleDegreeNotation({
    this.accidentalNotation = const SymbolAccidentalNotation(),
    this.useUppercase = true,
  });

  static const _romanNumerals = ['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii'];

  static final _regExp = RegExp(
    '(?<romanNumeral>${_romanNumerals.join('|')})\$',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  ScaleDegree parseMatch(RegExpMatch match) => ScaleDegree(
    _romanNumerals.indexOf(match.namedGroup('romanNumeral')!.toLowerCase()) + 1,
  );

  @override
  String format(ScaleDegree scaleDegree) {
    final numeral = _romanNumerals.elementAtOrNull(scaleDegree.ordinal - 1);

    if (numeral == null) return '${scaleDegree.ordinal}';

    return useUppercase ? numeral.toUpperCase() : numeral;
  }
}
