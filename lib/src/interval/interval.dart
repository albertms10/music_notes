part of '../../music_notes.dart';

@immutable
class Interval implements MusicItem {
  final int interval;
  final Quality quality;
  final bool descending;

  const Interval._(this.interval, this.quality, {this.descending = false});

  const Interval.perfect(
    this.interval,
    PerfectQuality this.quality, {
    this.descending = false,
  }) : assert(
          (interval + interval ~/ 8) % 4 == 0 ||
              (interval + interval ~/ 8) % 4 == 1,
          'Interval must be perfect',
        );

  const Interval.imperfect(
    this.interval,
    ImperfectQuality this.quality, {
    this.descending = false,
  }) : assert(
          (interval + interval ~/ 8) % 4 != 0 &&
              (interval + interval ~/ 8) % 4 != 1,
          'Interval must be imperfect',
        );

  Interval.fromDelta(int interval, int delta)
      : this._(interval, qualityFromDelta(interval, delta));

  Interval.fromDesiredSemitones(int interval, int semitones)
      : this._(
          interval,
          qualityFromDelta(interval, semitones - interval.semitones),
        );

  static const Map<int, Quality Function(int)> intervalToQuality = {
    1: PerfectQuality.new,
    2: ImperfectQuality.new,
    3: ImperfectQuality.new,
    4: PerfectQuality.new,
  };

  static Quality qualityFromDelta(int interval, int delta) {
    final simplifiedInterval = interval.simplified;
    final baseInterval = simplifiedInterval > 4
        ? simplifiedInterval.inverted
        : simplifiedInterval;
    final qualityConstructor = intervalToQuality[baseInterval]!;

    return qualityConstructor(delta);
  }

  /// Returns the number of semitones of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval.imperfect(2, ImperfectQuality.major).semitones == 2
  ///
  /// const Interval.perfect(5, PerfectQuality.diminished).semitones
  ///   == const Interval.perfect(4, PerfectQuality.augmented).semitones
  ///   == 6
  /// ```
  @override
  int get semitones =>
      (interval.semitones + quality.semitones) * (descending ? -1 : 1);

  /// Returns the inverted of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval.imperfect(3, ImperfectQuality.minor).inverted
  ///   == const Interval.imperfect(6, ImperfectQuality.major)
  ///
  /// const Interval.perfect(1, PerfectQuality.perfect).inverted
  ///   == const Interval.perfect(8, PerfectQuality.perfect)
  /// ```
  Interval get inverted => Interval._(interval.inverted, quality.inverted);

  @override
  String toString() => '${quality.abbreviation}$interval';

  @override
  bool operator ==(Object other) =>
      other is Interval &&
      interval == other.interval &&
      quality == other.quality;

  @override
  int get hashCode => hash2(interval, quality);

  @override
  int compareTo(covariant Interval other) => compareMultiple([
        () => interval.compareTo(other.interval),
        () => semitones.compareTo(other.semitones),
      ]);
}
