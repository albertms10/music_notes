// ignore_for_file: constant_identifier_names

part of '../../music_notes.dart';

@immutable
final class EnharmonicInterval extends Enharmonic<Interval> {
  const EnharmonicInterval(super.semitones);

  static const P1 = EnharmonicInterval(0);
  static const m2 = EnharmonicInterval(1);
  static const M2 = EnharmonicInterval(2);
  static const m3 = EnharmonicInterval(3);
  static const M3 = EnharmonicInterval(4);
  static const P4 = EnharmonicInterval(5);
  static const tritone = EnharmonicInterval(6);
  static const P5 = EnharmonicInterval(7);
  static const m6 = EnharmonicInterval(8);
  static const M6 = EnharmonicInterval(9);
  static const m7 = EnharmonicInterval(10);
  static const M7 = EnharmonicInterval(11);
  static const P8 = EnharmonicInterval(12);

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
  /// EnharmonicInterval.M2.isDescending == false
  /// (-EnharmonicInterval.P4).isDescending == true
  /// ```
  bool get isDescending => semitones.isNegative;

  /// Returns a copy of this [Interval] based on [isDescending].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.m2.descending()
  ///   == -EnharmonicIntervalInterval.m2
  /// EnharmonicInterval.M3.descending(isDescending: false)
  ///   == EnharmonicIntervalInterval.M3
  /// (-EnharmonicIntervalInterval.P5).descending()
  ///   == -EnharmonicIntervalInterval.P5
  /// (-EnharmonicIntervalInterval.M7).descending(isDescending: false)
  ///   == EnharmonicIntervalInterval.M7
  /// ```
  EnharmonicInterval descending({bool isDescending = true}) =>
      this.isDescending != isDescending ? -this : EnharmonicInterval(semitones);

  /// Adds [other] to this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.tritone + EnharmonicInterval.m2
  ///   == EnharmonicInterval.P5
  ///
  /// EnharmonicInterval.M3 + EnharmonicInterval.m6 == EnharmonicInterval.P8
  /// ```
  EnharmonicInterval operator +(EnharmonicInterval other) =>
      EnharmonicInterval(semitones + other.semitones);

  /// Subtracts [other] from this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.P4 - EnharmonicInterval.m3 == EnharmonicInterval.M2
  ///
  /// EnharmonicInterval.m3 - EnharmonicInterval.tritone
  ///   == const EnharmonicInterval(-3)
  /// ```
  EnharmonicInterval operator -(EnharmonicInterval other) =>
      EnharmonicInterval(semitones - other.semitones);

  /// The negation of this [EnharmonicInterval].
  ///
  /// Example:
  /// ```dart
  /// -EnharmonicInterval.m3 == const EnharmonicInterval(-3)
  /// -EnharmonicInterval.P1 == EnharmonicInterval.P1
  /// -const EnharmonicInterval(-7) == EnharmonicInterval.P5
  /// ```
  EnharmonicInterval operator -() => EnharmonicInterval(-semitones);

  /// Multiplies this [EnharmonicInterval] by [factor].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicInterval.P4 * -1 == -EnharmonicInterval.P4
  /// EnharmonicInterval.M6 * 0 == EnharmonicInterval.P1
  /// EnharmonicInterval.m3 * 2 == EnharmonicInterval.tritone
  /// ```
  EnharmonicInterval operator *(int factor) =>
      EnharmonicInterval(semitones * factor);

  @override
  String toString() {
    final descendingAbbreviation = isDescending ? 'desc ' : '';

    return '$descendingAbbreviation${semitones.abs()} $spellings';
  }
}
