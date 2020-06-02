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

  @override
  String toString() => '${interval.toText()} ${quality.toText()}';
}
