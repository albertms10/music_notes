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
        Interval.fromDesiredSemitones(intervalBelow, semitones),
      if (QualitiesValues.exists(intervalAbove, semitones))
        Interval.fromDesiredSemitones(intervalAbove, semitones)
    };
  }

  /// Returns the number of semitones of the common chromatic pitch of [intervals].
  ///
  /// It is used by [semitones] getter.
  static int _itemsSemitones(Set<Interval> intervals) =>
      intervals.first.semitones;

  /// Returns the number of semitones of the common chromatic pitch of this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval({
  ///   const Interval(Intervals.Quarta, Qualities.Augmentada),
  ///   const Interval(Intervals.Quinta, Qualities.Disminuida),
  /// }).semitones == 6
  /// ```
  @override
  int get semitones => _itemsSemitones(intervals);

  /// Returns a transposed [EnharmonicInterval] by [semitones] from this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval({
  ///   const Interval(Intervals.Sexta, Qualities.Major),
  /// }).transposeBy(-3)
  ///   == EnharmonicInterval({
  ///     const Interval(Intervals.Quarta, Qualities.Justa),
  ///   })
  /// ```
  @override
  EnharmonicInterval transposeBy(int semitones) =>
      EnharmonicInterval.fromSemitones(this.semitones + semitones);

  /// Returns the [Interval] from [semitones] and a [preferredQuality].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicInterval.getInterval(4)
  ///   == const Interval(Intervals.Tercera, Qualities.Menor)
  ///
  /// EnharmonicInterval.getInterval(7)
  ///   == const Interval(Intervals.Quarta, Qualities.Augmentada)
  ///
  /// EnharmonicInterval.getInterval(7, Qualities.Disminuida)
  ///   == const Interval(Intervals.Quinta, Qualities.Disminuida)
  /// ```
  static Interval getInterval(int semitones, [Qualities preferredQuality]) {
    final enharmonicIntervals =
        EnharmonicInterval.fromSemitones(semitones).intervals;

    return enharmonicIntervals.firstWhere(
      (interval) => interval.quality == preferredQuality,
      orElse: () => enharmonicIntervals.first,
    );
  }
}
