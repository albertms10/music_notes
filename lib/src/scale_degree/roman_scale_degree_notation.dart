import 'package:music_notes/utils.dart';

import '../accidental/accidental.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../notation_system/notation_system.dart';
import '../quality/quality.dart';
import 'scale_degree.dart';

/// The roman [ScaleDegree] notation formatter.
final class RomanScaleDegreeNotation extends StringNotationSystem<ScaleDegree> {
  /// The [StringNotationSystem] for [Accidental].
  final StringNotationSystem<Accidental> accidentalNotation;

  /// Creates a new [RomanScaleDegreeNotation].
  const RomanScaleDegreeNotation({
    this.accidentalNotation = const SymbolAccidentalNotation(),
  });

  static const _romanNumerals = ['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii'];

  static const _inversions = ['6', '64'];

  static final _regExp = RegExp(
    '(?<accidental>[${SymbolAccidentalNotation.symbols.join()}]*)'
    '(?<romanNumeral>${_romanNumerals.join('|')})'
    '(?<inversion>${_inversions.join('|')})?\$',
    caseSensitive: false,
  );

  /// The roman numeral of a [ScaleDegree].
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.i.romanNumeral == 'I'
  /// ScaleDegree.vii.romanNumeral == 'VII'
  /// ScaleDegree.neapolitanSixth.romanNumeral == 'II'
  /// ```
  String _romanNumeral(ScaleDegree scaleDegree) =>
      _romanNumerals.elementAtOrNull(scaleDegree.ordinal - 1)?.toUpperCase() ??
      '${scaleDegree.ordinal}';

  @override
  RegExp get regExp => _regExp;

  @override
  ScaleDegree parseMatch(RegExpMatch match) {
    final accidentalPart = match.namedGroup('accidental')!;
    final accidental = accidentalPart.isNotEmpty
        ? Accidental.parse(accidentalPart, chain: [accidentalNotation])
        : Accidental.natural;
    final numeral = match.namedGroup('romanNumeral')!;

    return ScaleDegree(
      _romanNumerals.indexOf(numeral.toLowerCase()) + 1,
      inversion: _inversions.indexOf(match.namedGroup('inversion') ?? '') + 1,
      quality: numeral.isUpperCase ? .major : .minor,
      semitonesDelta: accidental.semitones,
    );
  }

  @override
  String format(ScaleDegree scaleDegree) {
    final buffer = StringBuffer()
      ..writeAll([
        if (scaleDegree.semitonesDelta != 0)
          accidentalNotation.format(Accidental(scaleDegree.semitonesDelta)),
        if (scaleDegree.quality case ImperfectQuality(
          :final semitones,
        ) when semitones <= 0)
          _romanNumeral(scaleDegree).toLowerCase()
        else
          _romanNumeral(scaleDegree),
        if (scaleDegree.inversion != 0)
          _inversions.elementAtOrNull(scaleDegree.inversion - 1) ?? '',
      ]);

    return buffer.toString();
  }
}
