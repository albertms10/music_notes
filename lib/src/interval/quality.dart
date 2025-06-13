import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../notation_system.dart';
import 'interval.dart';

/// Further description of an [Interval] size that distinguishes intervals of
/// the same size but with different numbers of half steps.
///
/// ---
/// See also:
/// * [Interval].
/// * [PerfectQuality].
/// * [ImperfectQuality].
@immutable
sealed class Quality implements Comparable<Quality> {
  /// Delta semitones from the [Interval].
  final int semitones;

  /// Creates a new [Quality] from [semitones].
  const Quality(this.semitones);

  /// The inversion of this [Quality].
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  Quality get inversion;

  /// Whether this [Quality] is dissonant.
  bool get isDissonant;

  @override
  bool operator ==(Object other) =>
      other is Quality && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Quality other) => compareMultiple([
    () => semitones.compareTo(other.semitones),
    () {
      if (this is PerfectQuality && other is ImperfectQuality) {
        return 1;
      }
      if (this is ImperfectQuality && other is PerfectQuality) {
        return -1;
      }
      return 0;
    },
  ]);
}

/// Quality corresponding to an [Interval.perfect].
final class PerfectQuality extends Quality {
  /// Delta semitones from the [Interval], starting at 0 for the [perfect]
  /// quality.
  @override
  int get semitones;

  /// Creates a new [PerfectQuality] from [semitones].
  const PerfectQuality(super.semitones);

  /// A triply diminished [PerfectQuality].
  static const triplyDiminished = PerfectQuality(-3);

  /// A doubly diminished [PerfectQuality].
  static const doublyDiminished = PerfectQuality(-2);

  /// A diminished [PerfectQuality].
  static const diminished = PerfectQuality(-1);

  /// A perfect [PerfectQuality].
  static const perfect = PerfectQuality(0);

  /// An augmented [PerfectQuality].
  static const augmented = PerfectQuality(1);

  /// A doubly augmented [PerfectQuality].
  static const doublyAugmented = PerfectQuality(2);

  /// A triply augmented [PerfectQuality].
  static const triplyAugmented = PerfectQuality(3);

  /// Parse [source] as a [PerfectQuality] and return its value.
  ///
  /// If the [source] string does not contain a valid [PerfectQuality], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.parse('P') == PerfectQuality.perfect
  /// PerfectQuality.parse('dd') == PerfectQuality.doublyDiminished
  /// PerfectQuality.parse('z') // throws a FormatException
  /// ```
  factory PerfectQuality.parse(
    String source, {
    List<Parser<PerfectQuality>> chain = const [PerfectQualityNotation()],
  }) => chain.parse(source);

  /// The inversion of this [PerfectQuality].
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.perfect.inversion == PerfectQuality.perfect
  /// PerfectQuality.augmented.inversion == PerfectQuality.diminished
  /// ```
  @override
  PerfectQuality get inversion => PerfectQuality(-semitones);

  /// Whether this [PerfectQuality] is dissonant.
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.perfect.isDissonant == false
  /// PerfectQuality.diminished.isDissonant == true
  /// PerfectQuality.augmented.isDissonant == true
  /// ```
  @override
  bool get isDissonant => semitones != 0;

  /// The string representation of this [PerfectQuality] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.perfect.toString() == 'P'
  /// PerfectQuality.diminished.toString() == 'd'
  /// PerfectQuality.doublyAugmented.toString() == 'AA'
  /// ```
  @override
  String toString({
    Formatter<PerfectQuality> formatter = const PerfectQualityNotation(),
  }) => formatter.format(this);

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is PerfectQuality;
}

/// Quality corresponding to an [Interval.imperfect].
final class ImperfectQuality extends Quality {
  /// Delta semitones from the [Interval], starting at 0 for the [minor]
  /// quality.
  @override
  int get semitones;

  /// Creates a new [ImperfectQuality] from [semitones].
  const ImperfectQuality(super.semitones);

  /// A triply diminished [ImperfectQuality].
  static const triplyDiminished = ImperfectQuality(-3);

  /// A doubly diminished [ImperfectQuality].
  static const doublyDiminished = ImperfectQuality(-2);

  /// A diminished [ImperfectQuality].
  static const diminished = ImperfectQuality(-1);

  /// A minor [ImperfectQuality].
  static const minor = ImperfectQuality(0);

  /// A major [ImperfectQuality].
  static const major = ImperfectQuality(1);

  /// An augmented [ImperfectQuality].
  static const augmented = ImperfectQuality(2);

  /// A doubly augmented [ImperfectQuality].
  static const doublyAugmented = ImperfectQuality(3);

  /// A triply augmented [ImperfectQuality].
  static const triplyAugmented = ImperfectQuality(4);

  /// Parse [source] as a [ImperfectQuality] and return its value.
  ///
  /// If the [source] string does not contain a valid [ImperfectQuality], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.parse('m') == ImperfectQuality.minor
  /// ImperfectQuality.parse('A') == ImperfectQuality.augmented
  /// ImperfectQuality.parse('z') // throws a FormatException
  /// ```
  factory ImperfectQuality.parse(
    String source, {
    List<Parser<ImperfectQuality>> chain = const [ImperfectQualityNotation()],
  }) => chain.parse(source);

  /// The inversion of this [ImperfectQuality].
  ///
  /// See [Inversion § Intervals](https://en.wikipedia.org/wiki/Inversion_(music)#Intervals).
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.minor.inversion == ImperfectQuality.major
  /// ImperfectQuality.augmented.inversion == ImperfectQuality.diminished
  /// ```
  @override
  ImperfectQuality get inversion => ImperfectQuality(1 - semitones);

  /// Whether this [ImperfectQuality] is dissonant.
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.major.isDissonant == false
  /// ImperfectQuality.minor.isDissonant == false
  /// ImperfectQuality.diminished.isDissonant == true
  /// ImperfectQuality.augmented.isDissonant == true
  /// ```
  @override
  bool get isDissonant {
    if (this case major || minor) return false;

    return true;
  }

  /// The string representation of this [ImperfectQuality] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.minor.toString() == 'm'
  /// ImperfectQuality.major.toString() == 'M'
  /// ImperfectQuality.triplyDiminished.toString() == 'ddd'
  /// ```
  @override
  String toString({
    Formatter<ImperfectQuality> formatter = const ImperfectQualityNotation(),
  }) => formatter.format(this);

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is ImperfectQuality;
}

/// A notation system for [PerfectQuality].
final class PerfectQualityNotation extends NotationSystem<PerfectQuality> {
  /// Creates a new [PerfectQualityNotation].
  const PerfectQualityNotation();

  /// The symbol for a diminished [PerfectQuality].
  static const _diminishedSymbol = 'd';

  /// The symbol for a [PerfectQuality].
  static const _perfectSymbol = 'P';

  /// The symbol for an augmented [PerfectQuality].
  static const _augmentedSymbol = 'A';

  static final _regExp = RegExp(
    '^($_diminishedSymbol+|$_perfectSymbol|$_augmentedSymbol+)\$',
  );

  @override
  String format(PerfectQuality quality) => switch (quality.semitones) {
    < 0 => _diminishedSymbol * quality.semitones.abs(),
    0 => _perfectSymbol,
    _ => _augmentedSymbol * quality.semitones,
  };

  @override
  PerfectQuality parse(String source) {
    if (!_regExp.hasMatch(source)) {
      throw FormatException('Invalid PerfectQuality', source);
    }

    return switch (source[0]) {
      _diminishedSymbol => PerfectQuality(-source.length),
      _perfectSymbol => PerfectQuality.perfect,
      _ /* _augmentedSymbol */ => PerfectQuality(source.length),
    };
  }
}

/// A notation system for [ImperfectQuality].
final class ImperfectQualityNotation extends NotationSystem<ImperfectQuality> {
  /// Creates a new [ImperfectQualityNotation].
  const ImperfectQualityNotation();

  /// The symbol for a diminished [ImperfectQuality].
  static const _diminishedSymbol = 'd';

  /// The symbol for an augmented [ImperfectQuality].
  static const _augmentedSymbol = 'A';

  /// The symbol for a minor [ImperfectQuality].
  static const _minorSymbol = 'm';

  /// The symbol for a major [ImperfectQuality].
  static const _majorSymbol = 'M';

  static final _regExp = RegExp(
    '^($_diminishedSymbol+|$_minorSymbol|$_majorSymbol|$_augmentedSymbol+)\$',
  );

  @override
  String format(ImperfectQuality quality) => switch (quality.semitones) {
    < 0 => _diminishedSymbol * quality.semitones.abs(),
    0 => _minorSymbol,
    1 => _majorSymbol,
    _ => _augmentedSymbol * (quality.semitones - 1),
  };

  @override
  ImperfectQuality parse(String source) {
    if (!_regExp.hasMatch(source)) {
      throw FormatException('Invalid ImperfectQuality', source);
    }

    return switch (source[0]) {
      _diminishedSymbol => ImperfectQuality(-source.length),
      _minorSymbol => ImperfectQuality.minor,
      _majorSymbol => ImperfectQuality.major,
      _ /* _augmentedSymbol */ => ImperfectQuality(source.length + 1),
    };
  }
}
