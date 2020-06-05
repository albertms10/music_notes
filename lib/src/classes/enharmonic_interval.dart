part of music_notes;

class EnharmonicInterval extends Enharmonic<Interval> {
  final Set<Interval> intervals;

  EnharmonicInterval(this.intervals) : super(intervals);

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
      intervals.toList()[0].value;

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
}
