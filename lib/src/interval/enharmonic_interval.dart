part of '../../music_notes.dart';

class EnharmonicInterval extends Enharmonic<Interval> {
  const EnharmonicInterval(super.semitones);

  static const perfectUnison = EnharmonicInterval(1);
  static const minorSecond = EnharmonicInterval(2);
  static const majorSecond = EnharmonicInterval(3);
  static const minorThird = EnharmonicInterval(4);
  static const majorThird = EnharmonicInterval(5);
  static const perfectFourth = EnharmonicInterval(6);
  static const tritone = EnharmonicInterval(7);
  static const perfectFifth = EnharmonicInterval(8);
  static const minorSixth = EnharmonicInterval(9);
  static const majorSixth = EnharmonicInterval(10);
  static const minorSeventh = EnharmonicInterval(11);
  static const majorSeventh = EnharmonicInterval(12);

  @override
  Set<Interval> get items {
    final interval = IntIntervalExtension.fromSemitones(semitones - 1);

    if (interval != null) {
      final intervalBelow = interval == 1 ? 1 : interval - 1;
      final intervalAbove = interval + 1;

      return SplayTreeSet<Interval>.of({
        Interval.fromSemitones(intervalBelow, semitones - 1),
        Interval.fromSemitones(interval, semitones - 1),
        Interval.fromSemitones(intervalAbove, semitones - 1),
      });
    }

    final intervalBelow = IntIntervalExtension.fromSemitones(semitones - 2);
    final intervalAbove = IntIntervalExtension.fromSemitones(semitones);

    return SplayTreeSet<Interval>.of({
      Interval.fromSemitones(intervalBelow!, semitones - 1),
      Interval.fromSemitones(intervalAbove!, semitones - 1),
    });
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
