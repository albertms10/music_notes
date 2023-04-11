part of '../../music_notes.dart';

@immutable
abstract class Quality implements MusicItem {
  /// Delta semitones from the [Interval].
  @override
  final int semitones;

  const Quality(this.semitones);

  String? get name;

  Quality get inverted;

  @override
  String toString() => '$name (${semitones.toDeltaString()})';

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
  String? get name => const {
        -2: 'doubleDiminished',
        -1: 'diminished',
        0: 'perfect',
        1: 'augmented',
        2: 'doubleAugmented',
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
  String? get name => const {
        -2: 'doubleDiminished',
        -1: 'diminished',
        0: 'minor',
        1: 'major',
        2: 'augmented',
        3: 'doubleAugmented',
      }[semitones];

  @override
  ImperfectQuality get inverted => ImperfectQuality(-semitones + 1);

  @override
  // Overridden hashCode already present in the super class.
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is ImperfectQuality;
}
