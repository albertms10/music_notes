import 'package:music_notes_relations/model/interval.dart';

class EnharmonicInterval {
  final List<Interval> intervals;

  EnharmonicInterval(this.intervals) : assert(intervals.isNotEmpty);

  @override
  String toString() => '$intervals';
}
