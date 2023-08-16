// ignore_for_file: constant_identifier_names

part of '../../music_notes.dart';

/// The shortest distance in pitch class space between two unordered
/// [PitchClass]es.
///
/// The largest [IntervalClass] is [IntervalClass.tritone] (6) since any greater
/// interval `n` may be reduced to `chromaticDivisions - n`.
///
/// See [Interval class](https://en.wikipedia.org/wiki/Interval_class).
@immutable
final class IntervalClass implements Comparable<IntervalClass> {
  /// The distance in semitones that defines this [IntervalClass].
  final int semitones;

  /// Creates an [IntervalClass] from [semitones].
  const IntervalClass(int semitones)
      : semitones = (semitones % chromaticDivisions) > (chromaticDivisions ~/ 2)
            ? chromaticDivisions - (semitones % chromaticDivisions)
            : semitones % chromaticDivisions;

  /// A distance of 0 semitones [IntervalClass], which corresponds to
  /// [Interval.P1] or [Interval.P8].
  static const P1 = IntervalClass(0);

  /// A distance of 1 semitones [IntervalClass], which corresponds to
  /// [Interval.m2] or [Interval.M7].
  static const m2 = IntervalClass(1);

  /// A distance of 2 semitones [IntervalClass], which corresponds to
  /// [Interval.M2] or [Interval.m7].
  static const M2 = IntervalClass(2);

  /// A distance of 3 semitones [IntervalClass], which corresponds to
  /// [Interval.m3] or [Interval.M6].
  static const m3 = IntervalClass(3);

  /// A distance of 4 semitones [IntervalClass], which corresponds to
  /// [Interval.M3] or [Interval.m6].
  static const M3 = IntervalClass(4);

  /// A distance of 5 semitones [IntervalClass], which corresponds to
  /// [Interval.P4] or [Interval.P5].
  static const P4 = IntervalClass(5);

  /// A distance of 6 semitones [IntervalClass], which corresponds to
  /// [Interval.A4] or [Interval.d5].
  static const tritone = IntervalClass(6);

  /// Returns the different spellings at [distance] sharing the same number of
  /// [semitones].
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

  /// Adds [other] to this [IntervalClass].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.m3 + IntervalClass.m3 == IntervalClass.tritone
  /// IntervalClass.tritone + IntervalClass.M2 == IntervalClass.M3
  /// IntervalClass.M3 + IntervalClass.P4 == IntervalClass.m3
  /// ```
  IntervalClass operator +(IntervalClass other) =>
      IntervalClass(semitones + other.semitones);

  /// Subtracts [other] from this [IntervalClass].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.P4 - IntervalClass.m3 == IntervalClass.M2
  /// IntervalClass.m3 - IntervalClass.tritone == IntervalClass.m3
  /// IntervalClass.P1 - IntervalClass.m2 == IntervalClass.m2
  /// ```
  IntervalClass operator -(IntervalClass other) =>
      IntervalClass(semitones - other.semitones);

  /// Multiplies this [IntervalClass] by [factor].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.P4 * -1 == IntervalClass.P4
  /// IntervalClass.M2 * 0 == IntervalClass.P1
  /// IntervalClass.m3 * 2 == IntervalClass.tritone
  /// ```
  IntervalClass operator *(int factor) => IntervalClass(semitones * factor);

  @override
  String toString() => '{${spellings().join('|')}}';

  @override
  bool operator ==(Object other) =>
      other is IntervalClass && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(IntervalClass other) => semitones.compareTo(other.semitones);
}
