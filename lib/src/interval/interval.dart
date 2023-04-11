part of '../../music_notes.dart';

@immutable
class Interval implements MusicItem {
  final Intervals interval;
  final Quality quality;
  final bool descending;

  const Interval(this.interval, this.quality, {this.descending = false});

  Interval.fromDelta(Intervals interval, int delta)
      : this(interval, qualityFromDelta(interval, delta));

  Interval.fromDesiredSemitones(Intervals interval, int semitones)
      : this(
          interval,
          qualityFromDelta(interval, semitones - interval.semitones),
        );

  static const Map<int, Quality Function(int)> intervalToQuality = {
    1: PerfectQuality.new,
    2: ImperfectQuality.new,
    3: ImperfectQuality.new,
    4: PerfectQuality.new,
  };

  static Quality qualityFromDelta(Intervals interval, int delta) {
    final simplifiedInterval = interval.simplified;
    final baseInterval = simplifiedInterval.ordinal > 4
        ? simplifiedInterval.inverted
        : simplifiedInterval;
    final qualityConstructor = intervalToQuality[baseInterval.ordinal]!;

    return qualityConstructor(delta);
  }

  /// Returns the number of semitones of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval(Intervals.second, ImperfectQuality.major).semitones == 2
  ///
  /// const Interval(Intervals.fifth, PerfectQuality.diminished).semitones
  ///   == const Interval(Intervals.fourth, PerfectQuality.augmented).semitones
  ///   == 6
  /// ```
  @override
  int get semitones =>
      (interval.semitones + quality.semitones) * (descending ? -1 : 1);

  /// Returns the inverted of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval(Intervals.third, ImperfectQuality.minor).inverted
  ///   == const Interval(Intervals.sixth, ImperfectQuality.major)
  ///
  /// const Interval(Intervals.unison, PerfectQuality.perfect).inverted
  ///   == const Interval(Intervals.octave, PerfectQuality.perfect)
  /// ```
  Interval get inverted => Interval(interval.inverted, quality.inverted);

  @override
  String toString() => '${quality.name} ${interval.name}';

  @override
  bool operator ==(Object other) =>
      other is Interval &&
      interval == other.interval &&
      quality == other.quality;

  @override
  int get hashCode => hash2(interval, quality);

  @override
  int compareTo(covariant Interval other) => compareMultiple([
        () => interval.ordinal.compareTo(other.interval.ordinal),
        () => semitones.compareTo(other.semitones),
      ]);
}
