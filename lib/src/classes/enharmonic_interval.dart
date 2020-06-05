part of music_notes;

class EnharmonicInterval {
  final Set<Interval> intervals;

  const EnharmonicInterval(this.intervals)
      : assert(intervals != null && intervals.length > 0);

  int get semitones => intervals.toList()[0].semitones;

  @override
  String toString() => '$intervals';

  @override
  bool operator ==(other) =>
      other is EnharmonicInterval && this.semitones == other.semitones;
}
