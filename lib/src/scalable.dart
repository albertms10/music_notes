import 'package:collection/collection.dart' show IterableEquality;

import 'interval/interval.dart';
import 'interval/interval_class.dart';
import 'music.dart';
import 'note/pitch_class.dart';
import 'transposable.dart';

/// A interface for items that can form scales.
abstract class Scalable<T extends Scalable<T>> implements Transposable<T> {
  /// Creates a new [Scalable].
  const Scalable();

  /// The number of semitones that define this [Scalable].
  int get semitones;

  /// Creates a new [PitchClass] from [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).toClass() == PitchClass.c
  /// Note.e.sharp.inOctave(2).toClass() == PitchClass.f
  /// Note.c.flat.flat.inOctave(5).toClass() == PitchClass.aSharp
  /// ```
  PitchClass toClass() => PitchClass(semitones);

  /// The [Interval] between this [Scalable] and [other].
  Interval interval(T other);

  /// The difference in semitones between this [Scalable] and [other].
  int difference(T other) {
    final diff = other.semitones - semitones;

    return diff.abs() < chromaticDivisions ~/ 2
        ? diff
        : diff - chromaticDivisions * diff.sign;
  }
}

/// A Scalable iterable.
extension ScalableIterable<T extends Scalable<T>> on Iterable<T> {
  /// The [Interval]s between [T]s in this [Iterable].
  Iterable<Interval> get intervalSteps sync* {
    for (var i = 0; i < length - 1; i++) {
      yield elementAt(i).interval(elementAt(i + 1));
    }
  }

  /// The descending [Interval]s between [T]s this [Iterable].
  Iterable<Interval> get descendingIntervalSteps sync* {
    for (var i = 0; i < length - 1; i++) {
      yield elementAt(i + 1).interval(elementAt(i));
    }
  }

  /// The [PitchClass] representation of this [ScalableIterable].
  Iterable<PitchClass> toClass() => map((scalable) => scalable.toClass());

  /// Whether this [Iterable] is enharmonically equivalent to [other].
  ///
  /// Example:
  /// ```dart
  /// [Note.c.sharp, Note.f, Note.a.flat]
  ///   .isEnharmonicWith([Note.d.flat, Note.e.sharp, Note.g.sharp])
  ///     == true
  ///
  /// [Note.d.sharp].isEnharmonicWith([Note.a.flat]) == false
  /// ```
  bool isEnharmonicWith(Iterable<T> other) =>
      const IterableEquality<PitchClass>().equals(toClass(), other.toClass());

  /// Transposes this [Iterable] by [interval].
  Iterable<T> transposeBy(Interval interval) =>
      map((item) => item.transposeBy(interval));

  /// The inverse of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {Note.b, Note.a.sharp, Note.d}.inverse.toSet()
  ///   == {Note.b, Note.c, Note.g.sharp}
  /// ```
  Iterable<T> get inverse sync* {
    if (isEmpty) return;
    yield first;
    var last = first;
    for (var i = 1; i < length; i++) {
      yield last = last.transposeBy(elementAt(i).interval(elementAt(i - 1)));
    }
  }

  /// The retrograde of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {PitchClass.dSharp, PitchClass.g, PitchClass.fSharp}.retrograde.toSet()
  ///   == {PitchClass.fSharp, PitchClass.g, PitchClass.dSharp}
  /// ```
  Iterable<T> get retrograde => toList().reversed;

  /// The numeric representation of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {PitchClass.b, PitchClass.aSharp, PitchClass.d}
  ///   .numericRepresentation.toSet() == const {0, 11, 3}
  /// ```
  Iterable<int> get numericRepresentation => map(
        (pitchClass) => first.difference(pitchClass) % chromaticDivisions,
      );

  /// The delta numeric representation of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {PitchClass.b, PitchClass.aSharp, PitchClass.d, PitchClass.e}
  ///   .deltaNumericRepresentation.toList() == const [0, -1, 4, 2]
  /// ```
  Iterable<int> get deltaNumericRepresentation sync* {
    if (isEmpty) return;
    yield 0;
    for (var i = 1; i < length; i++) {
      yield elementAt(i - 1).difference(elementAt(i));
    }
  }
}

/// An Interval iterable.
extension IntervalIterable<T extends Interval> on Iterable<T> {
  /// The [PitchClass] representation of this [IntervalIterable].
  Iterable<IntervalClass> toClass() => map((interval) => interval.toClass());

  /// Whether this [Iterable] is enharmonically equivalent to [other].
  ///
  /// Example:
  /// ```dart
  /// const [Interval.m2, Interval.m3, Interval.M2]
  ///   .isEnharmonicWith(const [Interval.m2, Interval.A2, Interval.d3])
  ///     == true
  ///
  /// const [Interval.m2].isEnharmonicWith(const [Interval.P4]) == false
  /// ```
  bool isEnharmonicWith(Iterable<T> other) =>
      const IterableEquality<IntervalClass>()
          .equals(toClass(), other.toClass());
}
