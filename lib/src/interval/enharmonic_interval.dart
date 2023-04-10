part of '../../music_notes.dart';

class EnharmonicInterval extends Enharmonic<Interval> {
  const EnharmonicInterval(super.semitones);

  @override
  Set<Interval> get items {
    final interval = Intervals.fromSemitones(semitones);

    if (interval != null) {
      final intervalBelow = Intervals.fromOrdinal(interval.ordinal - 1);
      final intervalAbove = Intervals.fromOrdinal(interval.ordinal + 1);

      return SplayTreeSet.of({
        if (Qualities.exists(intervalBelow, semitones))
          Interval.fromDesiredSemitones(intervalBelow, semitones),
        Interval.fromDesiredSemitones(interval, semitones),
        if (Qualities.exists(intervalAbove, semitones))
          Interval.fromDesiredSemitones(intervalAbove, semitones),
      });
    }

    final intervalBelow = Intervals.fromSemitones(semitones - 1);
    final intervalAbove = Intervals.fromSemitones(semitones + 1);

    return SplayTreeSet<Interval>.of({
      if (Qualities.exists(intervalBelow, semitones))
        Interval.fromDesiredSemitones(intervalBelow!, semitones),
      if (Qualities.exists(intervalAbove, semitones))
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
    final enharmonicIntervals = EnharmonicInterval(semitones).items;

    return enharmonicIntervals.firstWhereOrNull(
          (interval) => interval.quality == preferredQuality,
        ) ??
        enharmonicIntervals.first;
  }

  /// Returns a transposed [EnharmonicInterval] by [semitones]
  /// from this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval(6).transposeBy(-3) == EnharmonicInterval(3)
  /// EnharmonicInterval(8).transposeBy(6) == EnharmonicInterval(2)
  /// ```
  @override
  EnharmonicInterval transposeBy(int semitones) =>
      EnharmonicInterval((this.semitones + semitones).chromaticModExcludeZero);
}
