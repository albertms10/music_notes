part of music_notes;

class EnharmonicInterval extends Enharmonic<Interval> {
  final Set<Interval> intervals;

  EnharmonicInterval(this.intervals) : super(intervals);

  EnharmonicInterval.fromSemitones(int semitones)
      : this(_fromSemitones(semitones));

  /// Returns the [EnharmonicInterval] from [semitones].
  ///
  /// It is mainly used by [EnharmonicInterval.fromSemitones] constructor.
  static Set<Interval> _fromSemitones(int semitones) {
    final interval = IntervalsValues.fromSemitones(semitones);

    if (interval != null) {
      var intervalBelow =
          IntervalsValues.fromOrdinal(Intervals.values.indexOf(interval));
      var intervalAbove =
          IntervalsValues.fromOrdinal(Intervals.values.indexOf(interval) + 2);

      return {
        if (QualitiesValues.exists(intervalBelow, semitones))
          Interval.fromDesiredSemitones(intervalBelow, semitones),
        Interval.fromDesiredSemitones(interval, semitones),
        if (QualitiesValues.exists(intervalAbove, semitones))
          Interval.fromDesiredSemitones(intervalAbove, semitones),
      };
    }

    var intervalBelow = IntervalsValues.fromSemitones(semitones - 1);
    var intervalAbove = IntervalsValues.fromSemitones(semitones + 1);

    return {
      if (QualitiesValues.exists(intervalBelow, semitones))
        Interval.fromDesiredSemitones(intervalBelow, semitones),
      if (QualitiesValues.exists(intervalAbove, semitones))
        Interval.fromDesiredSemitones(intervalAbove, semitones)
    };
  }

  /// Returns the number of semitones of the common chromatic pitch of [intervals].
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

  /// Returns the number of semitones of the common chromatic pitch of this [EnharmonicInterval].
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
