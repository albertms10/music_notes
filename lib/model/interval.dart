import 'package:music_notes_relations/model/enums/enums_to_string.dart';
import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/enums/qualities.dart';

class Interval {
  final Intervals interval;
  final Qualities quality;

  Interval(this.interval, this.quality)
      : assert(interval != null),
        assert(quality != null),
        assert(
          interval.isPerfect
              ? (quality != Qualities.Major || quality != Qualities.Menor)
              : quality != Qualities.Justa,
        );

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
