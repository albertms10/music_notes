// To allow major (M) and minor (m) static constant names.
// ignore_for_file: constant_identifier_names

import 'dart:collection' show SplayTreeSet;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../comparators.dart';
import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../pitch_class/pitch_class.dart';
import '../quality/quality.dart';
import '../size/size.dart';
import '../tuning_system/equal_temperament.dart';

/// A distance between two [PitchClass]es reduced to its simplest measure:
/// the fewest semitones apart they can be, ignoring both direction and
/// spelling. Where an [Interval] like an augmented fourth and a
/// diminished fifth are distinct spellings of the same distance, both
/// collapse to the identical [IntervalClass.tritone].
///
/// Because "up 8 semitones" and "down 4 semitones" reach the same pair
/// of pitch classes, [semitones] is always folded into `[0, 6]` — the
/// largest possible [IntervalClass] is the [tritone] itself, since any
/// wider raw distance `n` is equivalent to `chromaticDivisions - n`.
///
/// See [Interval class](https://en.wikipedia.org/wiki/Interval_class).
///
/// ---
/// See also:
/// * [Interval].
@immutable
final class IntervalClass
    with Comparators<IntervalClass>
    implements Comparable<IntervalClass>, Formattable<IntervalClass> {
  /// This [IntervalClass]'s distance in semitones, always folded into
  /// `[0, chromaticDivisions ~/ 2]`.
  final int semitones;

  /// Creates an [IntervalClass] by folding [semitones] to its shortest
  /// equivalent distance, in `[0, chromaticDivisions ~/ 2]`.
  const IntervalClass(int semitones)
    : semitones = (semitones % chromaticDivisions) > (chromaticDivisions ~/ 2)
          ? chromaticDivisions - (semitones % chromaticDivisions)
          : semitones % chromaticDivisions;

  /// 0 semitones apart: a unison or, equivalently, an octave
  /// ([Interval.P1]/[Interval.P8]).
  static const P1 = IntervalClass(0);

  /// 1 semitone apart: a minor second or major seventh
  /// ([Interval.m2]/[Interval.M7]).
  static const m2 = IntervalClass(1);

  /// 2 semitones apart: a major second or minor seventh
  /// ([Interval.M2]/[Interval.m7]).
  static const M2 = IntervalClass(2);

  /// 3 semitones apart: a minor third or major sixth
  /// ([Interval.m3]/[Interval.M6]).
  static const m3 = IntervalClass(3);

  /// 4 semitones apart: a major third or minor sixth
  /// ([Interval.M3]/[Interval.m6]).
  static const M3 = IntervalClass(4);

  /// 5 semitones apart: a perfect fourth or perfect fifth
  /// ([Interval.P4]/[Interval.P5]).
  static const P4 = IntervalClass(5);

  /// 6 semitones apart, exactly half an octave: the largest possible
  /// [IntervalClass], equally an augmented fourth or diminished fifth
  /// ([Interval.A4]/[Interval.d5]).
  static const tritone = IntervalClass(6);

  /// Every [Interval] spelling that reduces to this [IntervalClass],
  /// widened by up to [distance] extra diminished/augmented steps beyond
  /// the closest match(es) (e.g. `distance: 1` also includes a
  /// doubly-diminished or doubly-augmented alternative spelling).
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

  /// The [Interval] spelling of this [IntervalClass] that best matches
  /// [preferredQuality] (falling back to the plainest spelling overall,
  /// by smallest [Quality] deviation, if no spelling has exactly that
  /// quality or none is given).
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

  /// This [IntervalClass] and [other] stacked together and re-folded to
  /// the shortest equivalent distance.
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.m3 + IntervalClass.m3 == .tritone
  /// IntervalClass.tritone + IntervalClass.M2 == .M3
  /// IntervalClass.M3 + IntervalClass.P4 == .m3
  /// ```
  IntervalClass operator +(IntervalClass other) =>
      IntervalClass(semitones + other.semitones);

  /// This [IntervalClass] with [other] taken back out, re-folded to the
  /// shortest equivalent distance.
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.P4 - IntervalClass.m3 == .M2
  /// IntervalClass.m3 - IntervalClass.tritone == .m3
  /// IntervalClass.P1 - IntervalClass.m2 == .m2
  /// ```
  IntervalClass operator -(IntervalClass other) =>
      IntervalClass(semitones - other.semitones);

  /// This [IntervalClass] scaled by [factor] and re-folded to the
  /// shortest equivalent distance — the operation behind
  /// [PitchClass.operator *]'s circle-of-fourths/fifths transforms.
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.P4 * -1 == .P4
  /// IntervalClass.M2 * 0 == .P1
  /// IntervalClass.m3 * 2 == .tritone
  /// ```
  IntervalClass operator *(int factor) => IntervalClass(semitones * factor);

  /// The string representation of this [IntervalClass]: every
  /// [spellings] result joined between braces, e.g. `{A4|d5}` for the
  /// tritone.
  ///
  /// Example:
  /// ```dart
  /// IntervalClass.M2.format() == '{M2|d3}'
  /// IntervalClass.P4.format() == '{P4}'
  /// IntervalClass.tritone.format() == '{A4|d5}'
  /// ```
  @override
  String format() =>
      '{${spellings().map((interval) => interval.format()).join('|')}}';

  @override
  String toString() => '$runtimeType(semitones: $semitones)';

  @override
  bool operator ==(Object other) =>
      other is IntervalClass && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(IntervalClass other) => semitones.compareTo(other.semitones);
}
