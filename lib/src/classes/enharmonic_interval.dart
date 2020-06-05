part of music_notes;

class EnharmonicInterval {
  final Set<Interval> intervals;

  EnharmonicInterval(this.intervals)
      : assert(intervals != null && intervals.length > 0),
        assert(
          intervals.every(
            (interval) => interval.semitones == intervalsSemitones(intervals),
          ),
          "The intervals are not enharmonic",
        );

  /// Returns the semitones of the common chromatic pitch of [intervals].
  ///
  /// Example:
  /// ```dart
  /// intervalsSemitones({
  ///   const Interval(Intervals.Quarta, Qualities.Augmentada),
  ///   const Interval(Intervals.Quinta, Qualities.Disminuida),
  /// }) == 6
  /// ```
  static int intervalsSemitones(Set<Interval> intervals) =>
      intervals.toList()[0].semitones;

  /// Returns the value of the common chromatic pitch of this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval({
  ///   const Interval(Intervals.Quarta, Qualities.Augmentada),
  ///   const Interval(Intervals.Quinta, Qualities.Disminuida),
  /// }).semitones == 6
  /// ```
  int get semitones => intervalsSemitones(intervals);

  @override
  String toString() => '$intervals';

  @override
  bool operator ==(other) =>
      other is EnharmonicInterval && this.semitones == other.semitones;
}
