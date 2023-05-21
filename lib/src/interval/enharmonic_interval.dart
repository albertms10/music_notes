part of '../../music_notes.dart';

final class EnharmonicInterval extends Enharmonic<Interval> {
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
  Set<Interval> get spellings {
    final semitonesAbs = semitones.abs();
    final sign = semitones.isNegative ? -1 : 1;
    final size = IntervalSizeExtension.fromSemitones(semitonesAbs);

    if (size != null) {
      return SplayTreeSet<Interval>.of({
        if (size > 1) Interval.fromSemitones((size - 1) * sign, semitones),
        Interval.fromSemitones(size * sign, semitones),
        Interval.fromSemitones((size + 1) * sign, semitones),
      });
    }

    final sizeBelow = IntervalSizeExtension.fromSemitones(semitonesAbs - 1);
    final sizeAbove = IntervalSizeExtension.fromSemitones(semitonesAbs + 1);

    return SplayTreeSet<Interval>.of({
      Interval.fromSemitones(sizeBelow! * sign, semitones),
      Interval.fromSemitones(sizeAbove! * sign, semitones),
    });
  }

  /// Whether this [Interval] is descending.
  ///
  /// Example:
  /// ```dart
  /// Interval.majorSecond.isDescending == false
  /// (-Interval.perfectFourth).isDescending == true
  /// Interval.diminishedUnison.isDescending == false
  /// ```
  bool get isDescending => semitones.isNegative;

  /// Returns a copy of this [Interval] based on [isDescending].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.minorSecond.descending()
  ///   == -EnharmonicIntervalInterval.minorSecond
  /// EnharmonicInterval.majorThird.descending(isDescending: false)
  ///   == EnharmonicIntervalInterval.majorThird
  /// (-EnharmonicIntervalInterval.perfectFifth).descending()
  ///   == -EnharmonicIntervalInterval.perfectFifth
  /// (-EnharmonicIntervalInterval.majorSeventh).descending(isDescending: false)
  ///   == EnharmonicIntervalInterval.majorSeventh
  /// ```
  EnharmonicInterval descending({bool isDescending = true}) =>
      this.isDescending != isDescending ? -this : EnharmonicInterval(semitones);

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

  /// The negation of this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// -EnharmonicInterval.minorThird == const EnharmonicInterval(-3)
  /// -EnharmonicInterval.perfectUnison == EnharmonicInterval.perfectUnison
  /// -const EnharmonicInterval(-7) == EnharmonicInterval.perfectFifth
  /// ```
  EnharmonicInterval operator -() => EnharmonicInterval(-semitones);

  /// Multiplies this [EnharmonicInterval] by [factor].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.perfectFourth * -1 == -EnharmonicInterval.perfectFourth
  /// EnharmonicInterval.majorSixth * 0 == EnharmonicInterval.perfectUnison
  /// EnharmonicInterval.minorThird * 2 == EnharmonicInterval.tritone
  /// ```
  EnharmonicInterval operator *(int factor) =>
      EnharmonicInterval(semitones * factor);

  @override
  String toString() {
    final descendingAbbreviation = isDescending ? 'desc ' : '';

    return '$descendingAbbreviation${semitones.abs()} $spellings';
  }
}
