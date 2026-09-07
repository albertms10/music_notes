import '../notation_system/notation_system.dart';
import 'quality.dart';

/// The standard letter notation for [PerfectQuality]: `d` repeated per
/// diminished degree, `P` for perfect, `A` repeated per augmented degree
/// (e.g. `dd` for doubly diminished) — the letters that follow a [Size]
/// in a full [Interval] symbol like `P5` or `A4`.
final class PerfectQualityNotation
    extends StringNotationSystem<PerfectQuality> {
  /// The letter repeated once per diminished degree (`d` by default).
  final String diminishedSymbol;

  /// The letter written for a perfect quality (`P` by default).
  final String perfectSymbol;

  /// The letter repeated once per augmented degree (`A` by default).
  final String augmentedSymbol;

  /// Creates a new [PerfectQualityNotation].
  const PerfectQualityNotation({
    this.diminishedSymbol = 'd',
    this.perfectSymbol = 'P',
    this.augmentedSymbol = 'A',
  });

  @override
  RegExp get regExp => RegExp(
    '(?<quality>$diminishedSymbol+|$perfectSymbol|$augmentedSymbol+)',
  );

  @override
  String format(PerfectQuality quality) => switch (quality.semitones) {
    < 0 && final semitones => diminishedSymbol * semitones.abs(),
    0 => perfectSymbol,
    final semitones => augmentedSymbol * semitones,
  };

  @override
  PerfectQuality parseMatch(RegExpMatch match) {
    final quality = match.namedGroup('quality')!;
    final firstChar = quality[0];

    if (firstChar == diminishedSymbol) return PerfectQuality(-quality.length);
    if (firstChar == augmentedSymbol) return PerfectQuality(quality.length);

    return .perfect;
  }
}

/// The standard letter notation for [ImperfectQuality]: `d` repeated per
/// diminished degree, `m` for minor, `M` for major, `A` repeated per
/// augmented degree (e.g. `AA` for doubly augmented) — the letters that
/// follow a [Size] in a full [Interval] symbol like `m3` or `M6`.
final class ImperfectQualityNotation
    extends StringNotationSystem<ImperfectQuality> {
  /// The letter repeated once per diminished degree (`d` by default).
  final String diminishedSymbol;

  /// The letter repeated once per augmented degree (`A` by default).
  final String augmentedSymbol;

  /// The letter written for a minor quality (`m` by default).
  final String minorSymbol;

  /// The letter written for a major quality (`M` by default).
  final String majorSymbol;

  /// Creates a new [ImperfectQualityNotation].
  const ImperfectQualityNotation({
    this.diminishedSymbol = 'd',
    this.minorSymbol = 'm',
    this.majorSymbol = 'M',
    this.augmentedSymbol = 'A',
  });

  @override
  RegExp get regExp => RegExp(
    '(?<quality>$diminishedSymbol+|$minorSymbol|$majorSymbol'
    '|$augmentedSymbol+)',
  );

  @override
  ImperfectQuality parseMatch(RegExpMatch match) {
    final quality = match.namedGroup('quality')!;
    final firstChar = quality[0];

    if (firstChar == diminishedSymbol) return ImperfectQuality(-quality.length);
    if (firstChar == minorSymbol) return .minor;
    if (firstChar == majorSymbol) return .major;

    return ImperfectQuality(quality.length + 1);
  }

  @override
  String format(ImperfectQuality quality) => switch (quality.semitones) {
    < 0 && final semitones => diminishedSymbol * semitones.abs(),
    0 => minorSymbol,
    1 => majorSymbol,
    final semitones => augmentedSymbol * (semitones - 1),
  };
}
