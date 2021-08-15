part of music_notes;

class EnharmonicInterval extends Enharmonic<Interval> {
  EnharmonicInterval(Set<Interval> items) : super(items);

  EnharmonicInterval.fromSemitones(int semitones)
      : this(_fromSemitones(semitones));

  /// Returns the [EnharmonicInterval] from [semitones].
  ///
  /// It is mainly used by [EnharmonicInterval.fromSemitones] constructor.
  static Set<Interval> _fromSemitones(int semitones) {
    final interval = IntervalsValues.fromSemitones(semitones);

    if (interval != null) {
      final intervalBelow =
          IntervalsValues.fromOrdinal(Intervals.values.indexOf(interval));
      final intervalAbove =
          IntervalsValues.fromOrdinal(Intervals.values.indexOf(interval) + 2);

      return {
        if (QualitiesValues.exists(intervalBelow, semitones))
          Interval.fromDesiredSemitones(intervalBelow, semitones),
        Interval.fromDesiredSemitones(interval, semitones),
        if (QualitiesValues.exists(intervalAbove, semitones))
          Interval.fromDesiredSemitones(intervalAbove, semitones),
      };
    }

    final intervalBelow = IntervalsValues.fromSemitones(semitones - 1);
    final intervalAbove = IntervalsValues.fromSemitones(semitones + 1);

    return {
      if (QualitiesValues.exists(intervalBelow, semitones))
        Interval.fromDesiredSemitones(intervalBelow!, semitones),
      if (QualitiesValues.exists(intervalAbove, semitones))
        Interval.fromDesiredSemitones(intervalAbove!, semitones)
    };
  }

  /// Returns the [Interval] from [semitones] and a [preferredQuality].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicInterval.interval(4)
  ///   == const Interval(Intervals.third, Qualities.minor)
  ///
  /// EnharmonicInterval.interval(7)
  ///   == const Interval(Intervals.fourth, Qualities.augmented)
  ///
  /// EnharmonicInterval.interval(7, Qualities.diminished)
  ///   == const Interval(Intervals.fifth, Qualities.diminished)
  /// ```
  static Interval interval(int semitones, [Qualities? preferredQuality]) {
    final enharmonicIntervals =
        EnharmonicInterval.fromSemitones(semitones).items;

    return enharmonicIntervals.firstWhere(
      (interval) => interval.quality == preferredQuality,
      orElse: () => enharmonicIntervals.first,
    );
  }

  /// Returns the number of semitones of the common chromatic pitch
  /// of this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval({
  ///   const Interval(Intervals.fourth, Qualities.augmented),
  ///   const Interval(Intervals.fifth, Qualities.diminished),
  /// }).semitones == 6
  /// ```
  @override
  int get semitones => super.semitones;

  /// Returns a transposed [EnharmonicInterval] by [semitones]
  /// from this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval({
  ///   const Interval(Intervals.sixth, Qualities.major),
  /// }).transposeBy(-3)
  ///   == EnharmonicInterval({
  ///     const Interval(Intervals.fourth, Qualities.perfect),
  ///   })
  /// ```
  @override
  EnharmonicInterval transposeBy(int semitones) =>
      EnharmonicInterval.fromSemitones(this.semitones + semitones);
}
