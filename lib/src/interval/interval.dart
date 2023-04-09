part of '../../music_notes.dart';

@immutable
class Interval implements MusicItem {
  final Intervals interval;
  final Qualities quality;
  final bool descending;

  const Interval(this.interval, this.quality, {this.descending = false});

  Interval.fromDelta(Intervals interval, int delta)
      : this(interval, qualityFromDelta(interval, delta));

  Interval.fromDesiredSemitones(Intervals interval, int semitones)
      : this(
          interval,
          qualityFromDelta(interval, semitones - interval.semitones),
        );

  static Qualities qualityFromDelta(Intervals interval, int delta) {
    final qualitiesList = Qualities.intervalQualities(interval);

    return qualitiesList.firstWhereOrNull(
          (quality) => qualitiesList.toList().indexOf(quality) == delta,
        ) ??
        (delta < 0 ? qualitiesList.first : qualitiesList.last);
  }

  /// Returns the number of semitones of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval(Intervals.second, Qualities.major).semitones == 2
  ///
  /// const Interval(Intervals.fifth, Qualities.diminished).semitones
  ///   == const Interval(Intervals.fourth, Qualities.augmented).semitones
  ///   == 6
  /// ```
  @override
  int get semitones =>
      (interval.semitones +
          Qualities.intervalQualities(interval).toList().indexOf(quality) -
          1) *
      (descending ? -1 : 1);

  /// Returns the inverted of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval(Intervals.third, Qualities.minor).inverted
  ///   == const Interval(Intervals.sixth, Qualities.major)
  ///
  /// const Interval(Intervals.unison, Qualities.perfect).inverted
  ///   == const Interval(Intervals.octave, Qualities.perfect)
  /// ```
  Interval get inverted => Interval(interval.inverted, quality.inverted);

  @override
  String toString() => '$quality ${interval.name}';

  @override
  bool operator ==(Object other) =>
      other is Interval &&
      interval == other.interval &&
      quality == other.quality;

  @override
  int get hashCode => hash2(interval, quality);

  @override
  int compareTo(covariant Interval other) => compareMultiple([
        () => semitones.compareTo(other.semitones),
        () => interval.semitones.compareTo(other.interval.semitones),
        () => quality.value.compareTo(other.quality.value),
      ]);
}
