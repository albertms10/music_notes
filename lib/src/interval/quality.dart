part of '../../music_notes.dart';

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

  static const _diminishedSymbol = 'd';
  static const _augmentedSymbol = 'A';

  /// The symbol of this [Quality].
  String get symbol;

  /// Returns the inverted version of this [Quality].
  Quality get inverted;

  @override
  String toString() => '$symbol (${semitones.toDeltaString()})';

  @override
  bool operator ==(Object other) =>
      other is Quality && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Quality other) => compareMultiple([
        () => semitones.compareTo(other.semitones),
        // ignore: no_runtimetype_tostring
        () => '$runtimeType'.compareTo('${other.runtimeType}'),
      ]);
}

/// Quality corresponding to an [Interval.perfect].
class PerfectQuality extends Quality {
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

  static const _perfectSymbol = 'P';

  static final _regExp = RegExp(
    '^(${Quality._diminishedSymbol}+|$_perfectSymbol|'
    '${Quality._augmentedSymbol}+)\$',
  );

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
  factory PerfectQuality.parse(String source) {
    if (!_regExp.hasMatch(source)) {
      throw FormatException('Invalid PerfectQuality', source);
    }

    return switch (source[0]) {
      Quality._diminishedSymbol => PerfectQuality(-source.length),
      _perfectSymbol => PerfectQuality.perfect,
      _ /* _augmentedSymbol */ => PerfectQuality(source.length),
    };
  }

  @override
  String get symbol => switch (semitones) {
        < 0 => Quality._diminishedSymbol * semitones.abs(),
        0 => _perfectSymbol,
        _ => Quality._augmentedSymbol * semitones,
      };

  /// Returns the inverted version of this [PerfectQuality].
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.perfect.inverted == PerfectQuality.perfect
  /// PerfectQuality.augmented.inverted == PerfectQuality.diminished
  /// ```
  @override
  PerfectQuality get inverted => PerfectQuality(-semitones);

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is PerfectQuality;
}

/// Quality corresponding to an [Interval.imperfect].
class ImperfectQuality extends Quality {
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

  static const _minorSymbol = 'm';
  static const _majorSymbol = 'M';

  static final _regExp = RegExp(
    '^(${Quality._diminishedSymbol}+|$_minorSymbol|$_majorSymbol|'
    '${Quality._augmentedSymbol}+)\$',
  );

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
  factory ImperfectQuality.parse(String source) {
    if (!_regExp.hasMatch(source)) {
      throw FormatException('Invalid PerfectQuality', source);
    }

    return switch (source[0]) {
      Quality._diminishedSymbol => ImperfectQuality(-source.length),
      _minorSymbol => ImperfectQuality.minor,
      _majorSymbol => ImperfectQuality.major,
      _ /* _augmentedSymbol */ => ImperfectQuality(source.length + 1),
    };
  }

  @override
  String get symbol => switch (semitones) {
        < 0 => Quality._diminishedSymbol * semitones.abs(),
        0 => _minorSymbol,
        1 => _majorSymbol,
        _ => Quality._augmentedSymbol * (semitones - 1),
      };

  /// Returns the inverted version of this [ImperfectQuality].
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.minor.inverted == ImperfectQuality.major
  /// ImperfectQuality.augmented.inverted == ImperfectQuality.diminished
  /// ```
  @override
  ImperfectQuality get inverted => ImperfectQuality(1 - semitones);

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is ImperfectQuality;
}
