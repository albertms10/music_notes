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
              : true,
        );

  Interval.fromDelta(Intervals interval, int delta)
      : this(
          interval,
          interval.isPerfect
              ? (delta == 1
                  ? Qualities.Augmentada
                  : delta == 0
                      ? Qualities.Justa
                      : delta == -1 ? Qualities.Disminuida : null)
              : (delta == 0
                  ? Qualities.Major
                  : delta == -1 ? Qualities.Menor : null),
        );

  @override
  String toString() => '${interval.toText()} ${quality.toText()}';
}
