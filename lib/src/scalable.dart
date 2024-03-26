// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'enharmonic.dart';
import 'interval/interval.dart';
import 'music.dart';
import 'note/pitch_class.dart';
import 'transposable.dart';

/// A interface for items that can form scales.
abstract class Scalable<T extends Scalable<T>>
    with Enharmonic<PitchClass>
    implements Transposable<T> {
  /// Creates a new [Scalable].
  const Scalable();

  /// Creates a new [PitchClass] from [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).toClass() == PitchClass.c
  /// Note.e.sharp.inOctave(2).toClass() == PitchClass.f
  /// Note.c.flat.flat.inOctave(5).toClass() == PitchClass.aSharp
  /// ```
  @override
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
