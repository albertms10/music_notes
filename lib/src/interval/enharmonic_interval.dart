// ignore_for_file: constant_identifier_names

part of '../../music_notes.dart';

/// An enharmonic interval.
@immutable
final class EnharmonicInterval extends Enharmonic<Interval> {
  /// Creates an [EnharmonicInterval] from [semitones].
  const EnharmonicInterval(super.semitones);

  /// A distance of 0 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.P1].
  static const P1 = EnharmonicInterval(0);

  /// A distance of 1 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.m2].
  static const m2 = EnharmonicInterval(1);

  /// A distance of 2 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.M2].
  static const M2 = EnharmonicInterval(2);

  /// A distance of 3 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.m3].
  static const m3 = EnharmonicInterval(3);

  /// A distance of 4 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.M3].
  static const M3 = EnharmonicInterval(4);

  /// A distance of 5 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.P4].
  static const P4 = EnharmonicInterval(5);

  /// A distance of 6 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.A4] or [Interval.d5].
  static const tritone = EnharmonicInterval(6);

  /// A distance of 7 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.P5].
  static const P5 = EnharmonicInterval(7);

  /// A distance of 8 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.m6].
  static const m6 = EnharmonicInterval(8);

  /// A distance of 9 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.M6].
  static const M6 = EnharmonicInterval(9);

  /// A distance of 10 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.m7].
  static const m7 = EnharmonicInterval(10);

  /// A distance of 11 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.M7].
  static const M7 = EnharmonicInterval(11);

  /// A distance of 12 semitones [EnharmonicInterval], which corresponds to
  /// [Interval.P8].
  static const P8 = EnharmonicInterval(12);

  @override
  Set<Interval> spellings({int distance = 0}) {
    assert(distance >= 0, 'Distance must be greater or equal than zero.');
    final size = Interval.sizeFromSemitones(semitones);

    if (size != null) {
      return SplayTreeSet<Interval>.of({
        Interval.fromSemitones(size, semitones),
        for (var i = 1; i <= distance; i++) ...[
          if (size.incrementBy(-i) != 0)
            Interval.fromSemitones(size.incrementBy(-i), semitones),
          Interval.fromSemitones(size.incrementBy(i), semitones),
        ],
      });
    }

    final distanceClamp = distance == 0 ? 1 : distance;

    return SplayTreeSet<Interval>.of({
      for (var i = 1; i <= distanceClamp; i++) ...[
        Interval.fromSemitones(
          Interval.sizeFromSemitones(semitones.incrementBy(-i))!,
          semitones,
        ),
        Interval.fromSemitones(
          Interval.sizeFromSemitones(semitones.incrementBy(i))!,
          semitones,
        ),
      ],
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
}
