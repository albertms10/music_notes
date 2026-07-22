import '../notation_system/notation_system.dart';
import 'quality.dart';

/// A notation system for [PerfectQuality].
final class PerfectQualityNotation
    extends StringNotationSystem<PerfectQuality> {
  /// The symbol for a diminished [PerfectQuality].
  final String diminishedSymbol;

  /// The symbol for a [PerfectQuality].
  final String perfectSymbol;

  /// The symbol for an augmented [PerfectQuality].
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

/// A notation system for [ImperfectQuality].
final class ImperfectQualityNotation
    extends StringNotationSystem<ImperfectQuality> {
  /// The symbol for a diminished [ImperfectQuality].
  final String diminishedSymbol;

  /// The symbol for an augmented [ImperfectQuality].
  final String augmentedSymbol;

  /// The symbol for a minor [ImperfectQuality].
  final String minorSymbol;

  /// The symbol for a major [ImperfectQuality].
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
