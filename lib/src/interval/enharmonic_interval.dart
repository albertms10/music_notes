part of '../../music_notes.dart';

class EnharmonicInterval extends Enharmonic<Interval> {
  const EnharmonicInterval(super.semitones);

  static const perfectUnison = EnharmonicInterval(0);
  static const minorSecond = EnharmonicInterval(1);
  static const majorSecond = EnharmonicInterval(2);
  static const minorThird = EnharmonicInterval(3);
  static const majorThird = EnharmonicInterval(4);
  static const perfectFourth = EnharmonicInterval(5);
  static const tritone = EnharmonicInterval(6);
  static const perfectFifth = EnharmonicInterval(7);
  static const minorSixth = EnharmonicInterval(8);
  static const majorSixth = EnharmonicInterval(9);
  static const minorSeventh = EnharmonicInterval(10);
  static const majorSeventh = EnharmonicInterval(11);
  static const perfectOctave = EnharmonicInterval(12);

  @override
  Set<Interval> get items {
    final interval = IntIntervalExtension.fromSemitones(semitones);

    if (interval != null) {
      final intervalBelow = interval == 1 ? 1 : interval - 1;
      final intervalAbove = interval + 1;

      return SplayTreeSet<Interval>.of({
        Interval.fromSemitones(intervalBelow, semitones),
        Interval.fromSemitones(interval, semitones),
        Interval.fromSemitones(intervalAbove, semitones),
      });
    }

    final intervalBelow = IntIntervalExtension.fromSemitones(semitones - 1);
    final intervalAbove = IntIntervalExtension.fromSemitones(semitones + 1);

    return SplayTreeSet<Interval>.of({
      Interval.fromSemitones(intervalBelow!, semitones),
      Interval.fromSemitones(intervalAbove!, semitones),
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
