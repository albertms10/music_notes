part of '../../music_notes.dart';

class EnharmonicInterval extends Enharmonic<Interval> {
  const EnharmonicInterval(super.semitones);

  @override
  Set<Interval> get items {
    final interval = Intervals.fromSemitones(semitones - 1);

    if (interval != null) {
      final intervalBelow = interval == Intervals.unison
          ? Intervals.unison
          : Intervals.fromOrdinal(interval.ordinal - 1);
      final intervalAbove = Intervals.fromOrdinal(interval.ordinal + 1);

      return SplayTreeSet<Interval>.of({
        Interval.fromDesiredSemitones(intervalBelow, semitones - 1),
        Interval.fromDesiredSemitones(interval, semitones - 1),
        Interval.fromDesiredSemitones(intervalAbove, semitones - 1),
      });
    }

    final intervalBelow = Intervals.fromSemitones(semitones - 2);
    final intervalAbove = Intervals.fromSemitones(semitones);

    return SplayTreeSet<Interval>.of({
      Interval.fromDesiredSemitones(intervalBelow!, semitones - 1),
      Interval.fromDesiredSemitones(intervalAbove!, semitones - 1),
    });
  }

  /// Returns the [Interval] from [semitones] and a [preferredQuality].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicInterval.intervalFromSemitones(4)
  ///   == const Interval(Intervals.third, ImperfectQuality.minor)
  ///
  /// EnharmonicInterval.intervalFromSemitones(7)
  ///   == const Interval(Intervals.fourth, PerfectQuality.augmented)
  ///
  /// EnharmonicInterval.intervalFromSemitones(7, PerfectQuality.diminished)
  ///   == const Interval(Intervals.fifth, PerfectQuality.diminished)
  /// ```
  static Interval intervalFromSemitones(
    int semitones, [
    Quality? preferredQuality,
  ]) {
    final intervals = EnharmonicInterval(semitones).items;

    return intervals.firstWhereOrNull(
          (interval) => interval.quality == preferredQuality,
        ) ??
        // Find the Interval with the smaller Quality delta semitones.
        intervals
            .sorted(
              (a, b) => a.quality.semitones
                  .abs()
                  .compareTo(b.quality.semitones.abs()),
            )
            .first;
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
