import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/enums/qualities.dart';
import 'package:music_notes_relations/model/enums/enums_to_string.dart';

class Interval {
  final Intervals interval;
  final Qualities quality;

  Interval(this.interval, this.quality)
      : assert(interval != null),
        assert(quality != null);

  @override
  String toString() => '${interval.toText()} ${quality.toText()}';
}
