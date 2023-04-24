part of '../../music_notes.dart';

/// Further description of an [Interval] size that distinguishes intervals of
/// the same size but with different numbers of half steps.
@immutable
abstract class Quality implements MusicItem {
  /// Delta semitones from the [Interval].
  @override
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
        size.isPerfect ? PerfectQuality.new : ImperfectQuality.new;

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
  int compareTo(covariant Quality other) => compareMultiple([
        () => semitones.compareTo(other.semitones),
        () => '$runtimeType'.compareTo('${other.runtimeType}'),
      ]);
}

class PerfectQuality extends Quality {
  /// Delta semitones from the [Interval], starting at 0 for the [perfect]
  /// quality.
  @override
  int get semitones;

  /// Creates a new [PerfectQuality] from [semitones].
  const PerfectQuality(super.semitones);

  static const PerfectQuality doubleDiminished = PerfectQuality(-2);
  static const PerfectQuality diminished = PerfectQuality(-1);
  static const PerfectQuality perfect = PerfectQuality(0);
  static const PerfectQuality augmented = PerfectQuality(1);
  static const PerfectQuality doubleAugmented = PerfectQuality(2);

  @override
  String? get abbreviation => const {
        -2: 'dd',
        -1: 'd',
        0: 'P',
        1: 'A',
        2: 'AA',
      }[semitones];

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

class ImperfectQuality extends Quality {
  /// Delta semitones from the [Interval], starting at 0 for the [minor]
  /// quality.
  @override
  int get semitones;

  /// Creates a new [ImperfectQuality] from [semitones].
  const ImperfectQuality(super.semitones);

  static const ImperfectQuality doubleDiminished = ImperfectQuality(-2);
  static const ImperfectQuality diminished = ImperfectQuality(-1);
  static const ImperfectQuality minor = ImperfectQuality(0);
  static const ImperfectQuality major = ImperfectQuality(1);
  static const ImperfectQuality augmented = ImperfectQuality(2);
  static const ImperfectQuality doubleAugmented = ImperfectQuality(3);

  @override
  String? get abbreviation => const {
        -2: 'dd',
        -1: 'd',
        0: 'm',
        1: 'M',
        2: 'A',
        3: 'AA',
      }[semitones];

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
