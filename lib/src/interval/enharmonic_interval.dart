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
    final semitones = this.semitones.abs();
    final interval = IntIntervalExtension.fromSemitones(semitones);

    if (interval != null) {
      return SplayTreeSet<Interval>.of({
        if (interval > 1) Interval.fromSemitones(interval - 1, semitones),
        Interval.fromSemitones(interval, semitones),
        Interval.fromSemitones(interval + 1, semitones),
      });
    }

    final intervalBelow = IntIntervalExtension.fromSemitones(semitones - 1);
    final intervalAbove = IntIntervalExtension.fromSemitones(semitones + 1);

    return SplayTreeSet<Interval>.of({
      Interval.fromSemitones(intervalBelow!, semitones),
      Interval.fromSemitones(intervalAbove!, semitones),
    });
  }

  /// Adds [other] to this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.tritone + EnharmonicInterval.minorSecond
  ///   == EnharmonicInterval.perfectFifth
  ///
  /// EnharmonicInterval.majorThird + EnharmonicInterval.minorSixth
  ///   == EnharmonicInterval.perfectOctave
  /// ```
  EnharmonicInterval operator +(EnharmonicInterval other) =>
      EnharmonicInterval(semitones + other.semitones);

  /// Subtracts [other] from this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.perfectFourth - EnharmonicInterval.minorThird
  ///   == EnharmonicInterval.majorSecond
  ///
  /// EnharmonicInterval.minorThird - EnharmonicInterval.tritone
  ///   == const EnharmonicInterval(-3)
  /// ```
  EnharmonicInterval operator -(EnharmonicInterval other) =>
      EnharmonicInterval(semitones - other.semitones);
}
