// To allow major (M) and minor (m) static constant names.

import '../notation_system/notation_system.dart';
import '../quality/quality.dart';
import '../quality/quality_notation.dart';
import '../size/size_notation.dart';
import 'interval.dart';

/// A standard notation system for [Interval].
class StandardIntervalNotation extends StringNotationSystem<Interval> {
  /// The [SizeNotation].
  final SizeNotation sizeNotation;

  /// The [PerfectQualityNotation].
  final PerfectQualityNotation perfectQualityNotation;

  /// The [ImperfectQualityNotation].
  final ImperfectQualityNotation imperfectQualityNotation;

  /// Creates a new [StandardIntervalNotation].
  const StandardIntervalNotation({
    this.sizeNotation = const SizeNotation(),
    this.perfectQualityNotation = const PerfectQualityNotation(),
    this.imperfectQualityNotation = const ImperfectQualityNotation(),
  });

  @override
  RegExp get regExp =>
      // TODO(albertms10): use `qualityNotation.regExp.pattern` when duplicated
      //  named capture groups are supported.
      //  See https://github.com/dart-lang/sdk/issues/61337.
      RegExp('(?<quality>d+|P|m|M|A+?)\\s*${sizeNotation.regExp.pattern}');

  @override
  Interval parseMatch(RegExpMatch match) {
    final size = sizeNotation.parseMatch(match);
    // ignore: omit_local_variable_types False positive (?)
    final StringParser<Quality> parser = size.isPerfect
        ? perfectQualityNotation
        : imperfectQualityNotation;

    final quality = match.namedGroup('quality')!;
    if (!parser.matches(quality)) {
      throw FormatException('Invalid Quality', quality, 0);
    }

    return switch (parser.parseMatch(match)) {
      final PerfectQuality quality => .perfect(size, quality),
      final ImperfectQuality quality => .imperfect(size, quality),
    };
  }

  @override
  String format(Interval interval) {
    final quality = switch (interval.quality) {
      final PerfectQuality quality => perfectQualityNotation.format(quality),
      final ImperfectQuality quality => imperfectQualityNotation.format(
        quality,
      ),
    };
    final naming = '$quality${sizeNotation.format(interval.size)}';
    if (!interval.isCompound) return naming;

    return '$naming ($quality${sizeNotation.format(interval.simple.size)})';
  }
}
