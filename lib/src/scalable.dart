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

  /// Returns the [Interval] between this [Scalable] and [other].
  Interval interval(T other);

  /// Returns the difference in semitones between this [Scalable] and [other].
  int difference(T other) {
    final diff = other.semitones - semitones;

    return diff.abs() < chromaticDivisions ~/ 2
        ? diff
        : diff - chromaticDivisions * diff.sign;
  }
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

  /// Returns the [PitchClass] representation of this [ScalableIterable].
  Iterable<PitchClass> toClass() => map((scalable) => scalable.toClass());

  /// Transposes this [Iterable] by [interval].
  Iterable<T> transposeBy(Interval interval) =>
      map((item) => item.transposeBy(interval));

  /// Returns the inverse of this [ScalableIterable].
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

  /// Returns the retrograde of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {PitchClass.dSharp, PitchClass.g, PitchClass.fSharp}.retrograde.toSet()
  ///   == {PitchClass.fSharp, PitchClass.g, PitchClass.dSharp}
  /// ```
  Iterable<T> get retrograde => toList().reversed;

  /// Returns the numeric representation of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// {PitchClass.b, PitchClass.aSharp, PitchClass.d}
  ///   .numericRepresentation.toSet() == const {0, 11, 3}
  /// ```
  Iterable<int> get numericRepresentation => map(
        (pitchClass) => first.difference(pitchClass) % chromaticDivisions,
      );

  /// Returns the delta numeric representation of this [ScalableIterable].
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
  /// Returns the [PitchClass] representation of this [IntervalIterable].
  Iterable<IntervalClass> toClass() => map((interval) => interval.toClass());
}
