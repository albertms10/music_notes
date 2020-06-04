part of music_notes;

class Interval {
  final Intervals interval;
  final Qualities quality;
  final bool descending;

  const Interval(this.interval, this.quality, {this.descending = false})
      : assert(interval != null),
        assert(quality != null);

  Interval.fromDelta(Intervals interval, int delta)
      : this(
          interval,
          interval.isPerfect
              ? QualitiesValues.perfectQualitiesDeltas.toList()[delta]
              : QualitiesValues.qualitiesDeltas.toList()[delta],
        );

  int get semitones =>
      (IntervalsValues.intervalsQualitiesIndex[interval] +
          (interval.isPerfect
                  ? QualitiesValues.perfectQualitiesDeltas
                  : QualitiesValues.qualitiesDeltas)
              .toList()
              .indexOf(quality) -
          1) *
      (descending ? -1 : 1);

  @override
  String toString() => '${interval.toText()} ${quality.toText()}';

  @override
  bool operator ==(other) =>
      other is Interval &&
      this.interval == other.interval &&
      this.quality == other.quality;
}
