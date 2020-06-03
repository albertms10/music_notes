part of music_notes;

class Interval {
  final Intervals interval;
  final Qualities quality;

  const Interval(this.interval, this.quality)
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
      IntervalsValues.intervalsQualitiesIndex[interval] +
      (interval.isPerfect
              ? QualitiesValues.perfectQualitiesDeltas
              : QualitiesValues.qualitiesDeltas)
          .toList()
          .indexOf(quality) -
      1;

  @override
  String toString() => '${interval.toText()} ${quality.toText()}';

  @override
  bool operator ==(other) =>
      other is Interval &&
      this.interval == other.interval &&
      this.quality == other.quality;
}
