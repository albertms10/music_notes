part of music_notes;

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
    final qualitiesList = QualitiesValues.intervalQualitiesSet(interval);

    return qualitiesList.firstWhere(
      (quality) => qualitiesList.toList().indexOf(quality) == delta,
      orElse: () => delta < 0 ? qualitiesList.first : qualitiesList.last,
    );
  }

  /// Returns the number of semitones of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval(Intervals.Segona, Qualities.Major).semitones == 2
  ///
  /// const Interval(Intervals.Quinta, Qualities.Disminuida).semitones
  ///   == const Interval(Intervals.Quarta, Qualities.Augmentada).semitones
  ///   == 6
  /// ```
  @override
  int get semitones =>
      (interval.semitones +
          QualitiesValues.intervalQualitiesSet(interval)
              .toList()
              .indexOf(quality) -
          1) *
      (descending ? -1 : 1);

  /// Returns the inverted of this [Interval].
  ///
  /// Examples:
  /// ```dart
  /// const Interval(Intervals.Tercera, Qualities.Menor).inverted
  ///   == const Interval(Intervals.Sexta, Qualities.Major)
  ///
  /// const Interval(Intervals.Unison, Qualities.Justa).inverted
  ///   == const Interval(Intervals.Octava, Qualities.Justa)
  /// ```
  Interval get inverted => Interval(interval.inverted, quality.inverted);

  @override
  String toString() => '${interval.toText()} ${quality.toText()}';

  @override
  bool operator ==(other) =>
      other is Interval &&
      interval == other.interval &&
      quality == other.quality;

  @override
  int get hashCode => hash2(interval, quality);
}
