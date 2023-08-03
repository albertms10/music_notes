part of '../../music_notes.dart';

/// Further description of an [Interval] size that distinguishes intervals of
/// the same size but with different numbers of half steps.
@immutable
sealed class Quality implements Comparable<Quality> {
  /// Delta semitones from the [Interval].
  final int semitones;

  /// Creates a new [Quality] from [semitones].
  const Quality(this.semitones);

  /// Creates a new [PerfectQuality] or [ImperfectQuality] from interval [size].
  ///
  /// Example:
  /// ```dart
  /// Quality.fromInterval(5, 0) == PerfectQuality.perfect
  /// Quality.fromInterval(3, 1) == ImperfectQuality.major
  /// Quality.fromInterval(6, 0) == ImperfectQuality.minor
  /// ```
  factory Quality.fromInterval(int size, int semitones) {
    final qualityConstructor =
        size._isPerfect ? PerfectQuality.new : ImperfectQuality.new;

    return qualityConstructor(semitones);
  }

  /// The textual abbreviation of this [Quality].
  String? get abbreviation;

  /// Returns the inverted version of this [Quality].
  Quality get inverted;

  @override
  String toString() => '$abbreviation (${semitones.toDeltaString()})';

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
  static const PerfectQuality triplyDiminished = PerfectQuality(-3);

  /// A doubly diminished [PerfectQuality].
  static const PerfectQuality doublyDiminished = PerfectQuality(-2);

  /// A diminished [PerfectQuality].
  static const PerfectQuality diminished = PerfectQuality(-1);

  /// A perfect [PerfectQuality].
  static const PerfectQuality perfect = PerfectQuality(0);

  /// An augmented [PerfectQuality].
  static const PerfectQuality augmented = PerfectQuality(1);

  /// A doubly augmented [PerfectQuality].
  static const PerfectQuality doublyAugmented = PerfectQuality(2);

  /// A triply augmented [PerfectQuality].
  static const PerfectQuality triplyAugmented = PerfectQuality(3);

  /// Parse [source] as a [PerfectQuality] and return its value.
  ///
  /// If the [source] string does not contain a valid [PerfectQuality], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// PerfectQuality.parse('P') == PerfectQuality.perfect
  /// PerfectQuality.parse('AA') == PerfectQuality.doublyAugmented
  /// PerfectQuality.parse('z') // throws a FormatException
  /// ```
  factory PerfectQuality.parse(String source) {
    final qualityParts = source.split('');

    return switch (qualityParts.first) {
      'A' => PerfectQuality(qualityParts.length),
      'P' => PerfectQuality.perfect,
      'd' => PerfectQuality(-qualityParts.length),
      _ => throw FormatException('Invalid perfect Interval', source),
    };
  }

  @override
  String? get abbreviation => switch (semitones) {
        -3 => 'ddd',
        -2 => 'dd',
        -1 => 'd',
        0 => 'P',
        1 => 'A',
        2 => 'AA',
        3 => 'AAA',
        _ => null,
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
  static const ImperfectQuality triplyDiminished = ImperfectQuality(-3);

  /// A doubly diminished [ImperfectQuality].
  static const ImperfectQuality doublyDiminished = ImperfectQuality(-2);

  /// A diminished [ImperfectQuality].
  static const ImperfectQuality diminished = ImperfectQuality(-1);

  /// A minor [ImperfectQuality].
  static const ImperfectQuality minor = ImperfectQuality(0);

  /// A major [ImperfectQuality].
  static const ImperfectQuality major = ImperfectQuality(1);

  /// An augmented [ImperfectQuality].
  static const ImperfectQuality augmented = ImperfectQuality(2);

  /// A doubly augmented [ImperfectQuality].
  static const ImperfectQuality doublyAugmented = ImperfectQuality(3);

  /// A triply augmented [ImperfectQuality].
  static const ImperfectQuality triplyAugmented = ImperfectQuality(4);

  /// Parse [source] as a [ImperfectQuality] and return its value.
  ///
  /// If the [source] string does not contain a valid [ImperfectQuality], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.parse('M') == ImperfectQuality.major
  /// ImperfectQuality.parse('d') == ImperfectQuality.diminished
  /// ImperfectQuality.parse('z') // throws a FormatException
  /// ```
  factory ImperfectQuality.parse(String source) {
    final qualityParts = source.split('');

    return switch (qualityParts.first) {
      'd' => ImperfectQuality(-qualityParts.length),
      'm' => ImperfectQuality.minor,
      'M' => ImperfectQuality.major,
      'A' => ImperfectQuality(qualityParts.length + 1),
      _ => throw FormatException('Invalid imperfect Interval', source),
    };
  }

  @override
  String? get abbreviation => switch (semitones) {
        -3 => 'ddd',
        -2 => 'dd',
        -1 => 'd',
        0 => 'm',
        1 => 'M',
        2 => 'A',
        3 => 'AA',
        4 => 'AAA',
        _ => null,
      };

  /// Returns the inverted version of this [ImperfectQuality].
  ///
  /// Example:
  /// ```dart
  /// ImperfectQuality.minor.inverted == ImperfectQuality.major
  /// ImperfectQuality.augmented.inverted == ImperfectQuality.diminished
  /// ```
  @override
  ImperfectQuality get inverted => ImperfectQuality(-semitones + 1);

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is ImperfectQuality;
}
