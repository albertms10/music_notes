part of music_notes;

class EnharmonicInterval {
  final Set<Interval> intervals;

  EnharmonicInterval(this.intervals) : assert(intervals.isNotEmpty);

  @override
  String toString() => '$intervals';
}
