import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/enums/qualities.dart';

class Interval {
  final Intervals interval;
  final Qualities quality;

  Interval(this.interval, this.quality)
      : assert(interval != null),
        assert(quality != null);
}
