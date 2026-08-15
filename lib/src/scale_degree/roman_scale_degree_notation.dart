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
    this.accidentalNotation = const SymbolAccidentalNotation(
      showNatural: false,
    ),
    this.useUppercase = true,
  });

  static const _romanNumerals = ['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii'];

  /// Whether to use symbolic representation for [Accidental].
  bool get _isSymbol => accidentalNotation is SymbolAccidentalNotation;

  @override
  RegExp get regExp => RegExp(
    '${accidentalNotation.regExp?.pattern}'
    '${_isSymbol ? '' : r'\s+'}'
    '(?<romanNumeral>${_romanNumerals.join('|')})\$',
    caseSensitive: false,
  );

  @override
  ScaleDegree parseMatch(RegExpMatch match) => ScaleDegree(
    _romanNumerals.indexOf(match.namedGroup('romanNumeral')!.toLowerCase()) + 1,
    accidental: accidentalNotation.parseMatch(match),
  );

  @override
  String format(ScaleDegree scaleDegree) {
    final ScaleDegree(:ordinal, :accidental) = scaleDegree;
    final numeral = _romanNumerals.elementAtOrNull(ordinal - 1);
    final buffer = StringBuffer()
      ..writeAll([
        accidentalNotation.format(accidental),
        if (!_isSymbol) ' ',
        if (numeral == null)
          ordinal
        else
          useUppercase ? numeral.toUpperCase() : numeral,
      ]);

    return buffer.toString();
  }
}
