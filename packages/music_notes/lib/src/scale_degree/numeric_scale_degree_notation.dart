import '../accidental/accidental.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../notation_system/notation_system.dart';
import 'roman_scale_degree_notation.dart';
import 'scale_degree.dart';
import 'solfege_scale_degree_notation.dart';

/// The conventional numeric (caret) notation system for [ScaleDegree],
/// e.g. 1̂, ♯4̂, ♭7̂.
///
/// This is the "scale-degree caret" notation used throughout pedagogical
/// and popular-music theory writing (Aldwell/Schachter, Laitz, Kostka),
/// where a scale degree is written as an Arabic numeral with a caret drawn
/// above it, as opposed to the Roman-numeral chord-analysis convention
/// provided by [RomanScaleDegreeNotation].
///
/// Unlike Roman numerals, the numeral's case carries no meaning here, since
/// a bare scale degree (unlike a triad) has no inherent major/minor
/// quality; only [ScaleDegree.accidental] alters it, exactly as in
/// [RomanScaleDegreeNotation].
///
/// ---
/// See also:
/// * [ScaleDegree].
/// * [RomanScaleDegreeNotation].
/// * [SolfegeScaleDegreeNotation].
final class NumericScaleDegreeNotation
    extends StringNotationSystem<ScaleDegree> {
  /// The [StringNotationSystem] for [Accidental].
  final StringNotationSystem<Accidental> accidentalNotation;

  /// The combining circumflex accent (U+0302) drawn over the last digit of
  /// the ordinal to render the caret, e.g. `4` + `_caret` → `4̂`.
  static const _caretSymbol = '\u0302';
  static const _caretSymbolAscii = '^';

  /// Whether to draw the caret above the ordinal.
  ///
  /// Combining diacritics don't render reliably in every font or terminal.
  /// Set this to `false` or use [NumericScaleDegreeNotation.plain] to
  /// fall back to bare digits, as in the Nashville Number System.
  final bool showCaret;

  /// Whether to use ASCII symbols instead of Unicode symbols.
  final bool useAscii;

  /// Creates a new [NumericScaleDegreeNotation].
  const NumericScaleDegreeNotation({
    this.accidentalNotation = const SymbolAccidentalNotation(
      showNatural: false,
    ),
    this.showCaret = true,
    this.useAscii = false,
  });

  /// Creates a new [NumericScaleDegreeNotation] using ASCII symbols.
  const NumericScaleDegreeNotation.ascii({
    this.accidentalNotation = const SymbolAccidentalNotation.ascii(
      showNatural: false,
    ),
  }) : showCaret = true,
       useAscii = true;

  /// Creates a new [NumericScaleDegreeNotation] without the caret diacritic.
  const NumericScaleDegreeNotation.plain({
    this.accidentalNotation = const SymbolAccidentalNotation(
      showNatural: false,
    ),
  }) : showCaret = false,
       useAscii = false;

  /// Whether to use symbolic representation for [Accidental].
  bool get _isSymbol => accidentalNotation is SymbolAccidentalNotation;

  @override
  RegExp get regExp => RegExp(
    '${accidentalNotation.regExp?.pattern}'
    '${_isSymbol ? '' : r'\s+'}'
    '(?<ordinal>[1-9][0-9]*)'
    '${showCaret ? '[${useAscii ? _caretSymbolAscii : _caretSymbol}]' : ''}\$',
    caseSensitive: false,
    unicode: true,
  );

  @override
  ScaleDegree parseMatch(RegExpMatch match) => ScaleDegree(
    int.parse(match.namedGroup('ordinal')!),
    accidental: accidentalNotation.parseMatch(match),
  );

  @override
  String format(ScaleDegree scaleDegree) =>
      '${accidentalNotation.format(scaleDegree.accidental)}'
      '${_isSymbol ? '' : ' '}'
      '${scaleDegree.ordinal}${showCaret
          ? useAscii
                ? _caretSymbolAscii
                : _caretSymbol
          : ''}';
}
