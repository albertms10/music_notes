part of music_notes;

class EnharmonicInterval {
  final Set<Interval> intervals;

  const EnharmonicInterval(this.intervals)
      : assert(intervals != null && intervals.length > 0);

  @override
  String toString() => '$intervals';
}
