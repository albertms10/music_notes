import '../quality/quality_notation.dart';
import 'interval.dart';
import 'standard_interval_notation.dart';

/// The German notation for [Interval]: [StandardIntervalNotation]'s same
/// letter-plus-size shape, but with German quality letters — `r`
/// (rein/perfect), `k`/`g` (klein/groß, minor/major), `v`
/// (vermindert/übermäßig's diminished half), `ü` (übermäßig/augmented) —
/// in place of the English `P`/`m`/`M`/`d`/`A`.
final class GermanIntervalNotation extends StandardIntervalNotation {
  /// Creates a new [GermanIntervalNotation].
  const GermanIntervalNotation({
    super.perfectQualityNotation = const PerfectQualityNotation(
      diminishedSymbol: 'v',
      perfectSymbol: 'r',
      augmentedSymbol: 'ü',
    ),
    super.imperfectQualityNotation = const ImperfectQualityNotation(
      diminishedSymbol: 'v',
      minorSymbol: 'k',
      majorSymbol: 'g',
      augmentedSymbol: 'ü',
    ),
  });

  @override
  RegExp get regExp =>
      // TODO(albertms10): use `qualityNotation.regExp.pattern` when duplicated
      //  named capture groups are supported.
      //  See https://github.com/dart-lang/sdk/issues/61337.
      RegExp('(?<quality>v+|r|k|g|ü+?)\\s*${sizeNotation.regExp.pattern}');
}
