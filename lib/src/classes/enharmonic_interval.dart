part of '../../music_notes.dart';

class EnharmonicInterval extends Enharmonic<Interval> {
  EnharmonicInterval(super.items);

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

      return SplayTreeSet.from({
        if (QualitiesValues.exists(intervalBelow, semitones))
          Interval.fromDesiredSemitones(intervalBelow, semitones),
        Interval.fromDesiredSemitones(interval, semitones),
        if (QualitiesValues.exists(intervalAbove, semitones))
          Interval.fromDesiredSemitones(intervalAbove, semitones),
      });
    }

    final intervalBelow = IntervalsValues.fromSemitones(semitones - 1);
    final intervalAbove = IntervalsValues.fromSemitones(semitones + 1);

    return SplayTreeSet<Interval>.from({
      if (QualitiesValues.exists(intervalBelow, semitones))
        Interval.fromDesiredSemitones(intervalBelow!, semitones),
      if (QualitiesValues.exists(intervalAbove, semitones))
        Interval.fromDesiredSemitones(intervalAbove!, semitones),
    });
  }

  /// Returns the [Interval] from [semitones] and a [preferredQuality].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicInterval.intervalFromSemitones(4)
  ///   == const Interval(Intervals.third, Qualities.minor)
  ///
  /// EnharmonicInterval.intervalFromSemitones(7)
  ///   == const Interval(Intervals.fourth, Qualities.augmented)
  ///
  /// EnharmonicInterval.intervalFromSemitones(7, Qualities.diminished)
  ///   == const Interval(Intervals.fifth, Qualities.diminished)
  /// ```
  static Interval intervalFromSemitones(
    int semitones, [
    Qualities? preferredQuality,
  ]) {
    final enharmonicIntervals =
        EnharmonicInterval.fromSemitones(semitones).items;

    return enharmonicIntervals.firstWhereOrNull(
          (interval) => interval.quality == preferredQuality,
        ) ??
        enharmonicIntervals.first;
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
