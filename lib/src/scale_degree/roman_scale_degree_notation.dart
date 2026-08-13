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

  static final _regExp = RegExp(
    '(?<accidental>[${SymbolAccidentalNotation.symbols.join()}]*)'
    '(?<romanNumeral>${_romanNumerals.join('|')})\$',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  ScaleDegree parseMatch(RegExpMatch match) {
    final accidental = match.namedGroup('accidental')!;
    final romanNumeral = match.namedGroup('romanNumeral')!;

    return ScaleDegree(
      _romanNumerals.indexOf(romanNumeral.toLowerCase()) + 1,
      accidental: accidental.isNotEmpty
          ? .parse(accidental, chain: [accidentalNotation])
          : .natural,
    );
  }

  @override
  String format(ScaleDegree scaleDegree) {
    final ScaleDegree(:ordinal, :accidental) = scaleDegree;
    final numeral = _romanNumerals.elementAtOrNull(ordinal - 1);
    final buffer = StringBuffer()
      ..writeAll([
        accidentalNotation.format(accidental),
        if (numeral == null)
          ordinal
        else
          useUppercase ? numeral.toUpperCase() : numeral,
      ]);

    return buffer.toString();
  }
}
