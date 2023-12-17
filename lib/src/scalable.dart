part of '../music_notes.dart';

/// A interface for items that can form scales.
abstract interface class Scalable<T> implements Transposable<T> {
  /// Returns the [Interval] between this [T] and [other].
  Interval interval(T other);

  /// Returns the difference in semitones between this [T] and [other].
  int difference(T other);
}

/// A Scalable iterable.
extension ScalableIterable<T extends Scalable<T>> on Iterable<T> {
  /// Returns the [Interval]s between [T]s in this [Iterable].
  Iterable<Interval> get intervalSteps sync* {
    for (var i = 0; i < length - 1; i++) {
      yield elementAt(i).interval(elementAt(i + 1));
    }
  }

  /// Returns the descending [Interval]s between [T]s this [Iterable].
  Iterable<Interval> get descendingIntervalSteps sync* {
    for (var i = 0; i < length - 1; i++) {
      yield elementAt(i + 1).interval(elementAt(i));
    }
  }

  /// Transposes this [Iterable] by [interval].
  Iterable<T> transposeBy(Interval interval) =>
      map((item) => item.transposeBy(interval));

  /// The inverse of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {PitchClass.b, PitchClass.aSharp, PitchClass.d}.inverse.toSet()
  ///   == {PitchClass.b, PitchClass.c, PitchClass.gSharp}
  /// ```
  Iterable<T> get inverse sync* {
    if (isEmpty) return;
    yield first;
    var last = first;
    for (var i = 1; i < length; i++) {
      final transposed =
          last.transposeBy(elementAt(i).interval(elementAt(i - 1)));
      last = transposed;
      yield transposed;
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
  ///   .numericRepresentation.toSet() == {0, 11, 3}
  /// ```
  Iterable<int> get numericRepresentation => map(
        (pitchClass) => first.difference(pitchClass) % chromaticDivisions,
      );

  /// The delta numeric representation of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {PitchClass.b, PitchClass.aSharp, PitchClass.d}
  ///   .deltaNumericRepresentation.toList() == []
  /// ```
  Iterable<int> get deltaNumericRepresentation sync* {
    yield 0;
    for (var i = 1; i < length; i++) {
      yield elementAt(i).difference(elementAt(i - 1));
    }
  }
}
