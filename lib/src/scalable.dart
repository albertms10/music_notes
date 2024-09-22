import 'enharmonic.dart';
import 'interval/interval.dart';
import 'music.dart';
import 'note/pitch_class.dart';
import 'respellable.dart';
import 'transposable.dart';

/// An interface for items that can form scales.
abstract class Scalable<T extends Scalable<T>>
    with Enharmonic<PitchClass>, Respellable<T>
    implements Transposable<T> {
  /// Creates a new [Scalable].
  const Scalable();

  /// Predicate to transpose this [Scalable] by ascending chromatic motion.
  static T chromaticMotion<T extends Scalable<T>>(T scalable) =>
      scalable.transposeBy(Interval.m2).respelledSimple;

  /// Enharmonic [Comparator] for [Scalable].
  static int compareEnharmonically<T extends Scalable<T>>(T a, T b) =>
      a.semitones.compareTo(b.semitones);

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

  /// The inversion of this [ScalableIterable].
  ///
  /// See [Inversion](https://en.wikipedia.org/wiki/Inversion_(music)) and
  /// [Retrograde inversion](https://en.wikipedia.org/wiki/Retrograde_inversion)
  /// for a combination of both [retrograde] and [inversion].
  ///
  /// Example:
  /// ```dart
  /// ({Note.b, Note.a.sharp, Note.d}).inversion.toSet()
  ///   == {Note.b, Note.c, Note.g.sharp}
  /// ```
  Iterable<T> get inversion sync* {
    if (isEmpty) return;
    yield first;
    var last = first;
    for (var i = 1; i < length; i++) {
      yield last = last.transposeBy(elementAt(i).interval(elementAt(i - 1)));
    }
  }

  /// The retrograde of this [ScalableIterable].
  ///
  /// See [Retrograde](https://en.wikipedia.org/wiki/Retrograde_(music)) and
  /// [Retrograde inversion](https://en.wikipedia.org/wiki/Retrograde_inversion)
  /// for a combination of both [retrograde] and [inversion].
  ///
  /// Example:
  /// ```dart
  /// ({PitchClass.dSharp, PitchClass.g, PitchClass.fSharp}).retrograde.toSet()
  ///   == {PitchClass.fSharp, PitchClass.g, PitchClass.dSharp}
  /// ```
  Iterable<T> get retrograde => toList(growable: false).reversed;

  /// The numeric representation of this [ScalableIterable] from [reference].
  /// The [first] element is used as the reference if none is provided.
  ///
  /// Example:
  /// ```dart
  /// ({PitchClass.b, PitchClass.aSharp, PitchClass.d})
  ///   .numericRepresentation().toSet() == const {0, 11, 3}
  ///
  /// ({PitchClass.b, PitchClass.aSharp, PitchClass.d})
  ///   .numericRepresentation(reference: PitchClass.g).toSet()
  ///     == const {4, 3, 7}
  /// ```
  Iterable<int> numericRepresentation({T? reference}) => map(
        (scalable) =>
            (reference ?? first).difference(scalable) % chromaticDivisions,
      );

  /// The delta numeric representation of this [ScalableIterable].
  ///
  /// Example:
  /// ```dart
  /// ({PitchClass.b, PitchClass.aSharp, PitchClass.d, PitchClass.e})
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
