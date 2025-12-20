// To allow major (M) and minor (m) static constant names.
// ignore_for_file: constant_identifier_names

import 'dart:collection' show SplayTreeSet;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../comparators.dart';
import '../note/pitch_class.dart';
import '../tuning/equal_temperament.dart';
import 'interval.dart';
import 'quality.dart';
import 'size.dart';

/// The shortest distance in pitch class space between two unordered
/// [PitchClass]es.
///
/// The largest [IntervalClass] is the [tritone] (6 semitones) since any greater
/// interval `n` may be reduced to `chromaticDivisions - n`.
///
/// See [Interval class](https://en.wikipedia.org/wiki/Interval_class).
///
/// ---
/// See also:
/// * [Interval].
@immutable
final class IntervalClass
    with Comparators<IntervalClass>
    implements Comparable<IntervalClass> {
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

  /// The [Interval] spellings at [distance] sharing the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.m2.spellings() == {Interval.m2}
  /// IntervalClass.tritone.spellings() == <Interval>{.A4, .d5}
  /// IntervalClass.m3.spellings(distance: 1) == <Interval>{
  ///     .A2,
  ///     .m3,
  ///     const .perfect(.fourth, .doublyDiminished)
  ///   }
  /// ```
  Set<Interval> spellings({int distance = 0}) {
    assert(distance >= 0, 'Distance must be greater or equal than zero.');
    final size = Size.fromSemitones(semitones);

    if (size != null) {
      return SplayTreeSet<Interval>.of({
        .fromSizeAndSemitones(size, semitones),
        for (var i = 1; i <= distance; i++) ...[
          if (size.incrementBy(-i) != 0)
            .fromSizeAndSemitones(Size(size.incrementBy(-i)), semitones),
          .fromSizeAndSemitones(Size(size.incrementBy(i)), semitones),
        ],
      });
    }

    final distanceClamp = distance == 0 ? 1 : distance;

    return SplayTreeSet<Interval>.of({
      for (var i = 1; i <= distanceClamp; i++) ...[
        .fromSizeAndSemitones(
          .fromSemitones(semitones.incrementBy(-i))!,
          semitones,
        ),
        .fromSizeAndSemitones(
          .fromSemitones(semitones.incrementBy(i))!,
          semitones,
        ),
      ],
    });
  }

  /// The [Interval] that matches with [preferredQuality] from this
  /// [IntervalClass].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.m3.resolveClosestSpelling() == .m3
  /// IntervalClass.tritone.resolveClosestSpelling() == .A4
  /// IntervalClass.tritone.resolveClosestSpelling(PerfectQuality.diminished)
  ///   == .d5
  /// ```
  Interval resolveClosestSpelling([Quality? preferredQuality]) {
    if (preferredQuality != null) {
      final interval = spellings(
        distance: 1,
      ).firstWhereOrNull((interval) => interval.quality == preferredQuality);
      if (interval != null) return interval;
    }

    // Find the Interval with the smaller Quality delta semitones.
    return spellings()
        .sorted(
          (a, b) =>
              a.quality.semitones.abs().compareTo(b.quality.semitones.abs()),
        )
        .first;
  }

  /// Adds [other] to this [IntervalClass].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.m3 + IntervalClass.m3 == .tritone
  /// IntervalClass.tritone + IntervalClass.M2 == .M3
  /// IntervalClass.M3 + IntervalClass.P4 == .m3
  /// ```
  IntervalClass operator +(IntervalClass other) =>
      IntervalClass(semitones + other.semitones);

  /// Subtracts [other] from this [IntervalClass].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.P4 - IntervalClass.m3 == .M2
  /// IntervalClass.m3 - IntervalClass.tritone == .m3
  /// IntervalClass.P1 - IntervalClass.m2 == .m2
  /// ```
  IntervalClass operator -(IntervalClass other) =>
      IntervalClass(semitones - other.semitones);

  /// Multiplies this [IntervalClass] by [factor].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.P4 * -1 == .P4
  /// IntervalClass.M2 * 0 == .P1
  /// IntervalClass.m3 * 2 == .tritone
  /// ```
  IntervalClass operator *(int factor) => IntervalClass(semitones * factor);

  /// The string representation of this [IntervalClass].
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.M2.toString() == '{M2|d3}'
  /// IntervalClass.P4.toString() == '{P4}'
  /// IntervalClass.tritone.toString() == '{A4|d5}'
  /// ```
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
