part of '../../music_notes.dart';

@immutable
abstract class Quality implements MusicItem {
  /// Delta semitones from the [Interval].
  @override
  final int semitones;

  const Quality(this.semitones);

  String? get abbreviation;

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

  @override
  ImperfectQuality get inverted => ImperfectQuality(-semitones + 1);

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is ImperfectQuality;
}
