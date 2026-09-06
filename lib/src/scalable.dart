import 'package:meta/meta.dart' show immutable;

import 'enharmonic.dart';
import 'interval/interval.dart';
import 'notation_system/notation_system.dart';
import 'pitch_class/pitch_class.dart';
import 'respellable.dart';
import 'size/size.dart';
import 'transposable.dart';
import 'tuning_system/equal_temperament.dart';

/// A pitch-like value that can take a position within a scale: something
/// with a chroma ([Enharmonic]), a distance to any other instance
/// ([interval], [difference]), and the ability to move by an [Interval]
/// ([Transposable]) or be renamed without changing pitch ([Respellable]).
///
/// [Note], [Pitch], and [PitchClass] all implement [Scalable], which is
/// what lets `ScalePattern.on` and `ChordPattern.on` build a [Scale] or
/// [Chord] equally well from letter-named notes, octave-positioned
/// pitches, or bare chroma classes.
@immutable
abstract class Scalable<T extends Scalable<T>>
    with Enharmonic<PitchClass>, Respellable<T>
    implements Transposable<T>, Formattable<T> {
  /// Creates a new [Scalable].
  const Scalable();

  /// Transposes [scalable] up by a chromatic [Interval.m2], respelling the
  /// result as simply as possible.
  ///
  /// Repeated calls walk the full chromatic scale one semitone at a time,
  /// which is how [PitchClass.spellings] and friends build up their
  /// enharmonic tables without hardcoding every pitch.
  static T chromaticMotion<T extends Scalable<T>>(T scalable) =>
      scalable.transposeBy(.m2).respelledSimple;

  /// [Comparator] that orders [Scalable]s purely by [semitones], ignoring
  /// spelling, so enharmonically equivalent values (e.g. D♯ and E♭) compare
  /// equal regardless of how they were written.
  static int compareEnharmonically<T extends Scalable<T>>(T a, T b) =>
      a.semitones.compareTo(b.semitones);

  /// The [PitchClass] this value reduces to once octave and spelling are
  /// discarded.
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).toClass() == .c
  /// Note.e.sharp.inOctave(2).toClass() == .f
  /// Note.c.flat.flat.inOctave(5).toClass() == .aSharp
  /// ```
  @override
  PitchClass toClass() => PitchClass(semitones);

  /// The [Interval] spanning this [Scalable] and [other], preserving
  /// direction (ascending if [other] lies above, descending if below).
  Interval interval(T other);

  /// The signed distance in semitones from this [Scalable] to [other],
  /// taking the shorter path around the octave (so it always falls within
  /// `±chromaticDivisions ~/ 2`, unlike a plain subtraction of [semitones]).
  int difference(T other) {
    final diff = other.semitones - semitones;

    return diff.abs() < chromaticDivisions ~/ 2
        ? diff
        : diff - chromaticDivisions * diff.sign;
  }
}

/// Sequence-level operations over an ordered run of [Scalable]s — a melody,
/// scale, or chord voicing — covering the [Interval]s between consecutive
/// members and the classic twelve-tone transformations (inversion,
/// retrograde, numeric set representation).
extension ScalableIterable<T extends Scalable<T>> on Iterable<T> {
  /// The ascending [Interval] from each element to the next, one shorter
  /// than this [Iterable] itself.
  Iterable<Interval> get intervalSteps sync* {
    for (var i = 0; i < length - 1; i++) {
      yield elementAt(i).interval(elementAt(i + 1));
    }
  }

  /// The descending [Interval] from each element back to the previous one,
  /// i.e. [intervalSteps] read in reverse direction.
  Iterable<Interval> get descendingIntervalSteps sync* {
    for (var i = 0; i < length - 1; i++) {
      yield elementAt(i + 1).interval(elementAt(i));
    }
  }

  /// Whether every consecutive pair moves by [Size.second] at most, i.e.
  /// this line proceeds entirely by step with no leaps.
  ///
  /// See [Steps and skips](https://en.wikipedia.org/wiki/Steps_and_skips).
  ///
  /// Example:
  /// ```dart
  /// <Note>[.d, .e, .e.flat, .d].inOctave(4).isStepwise == true
  /// const <Note>[.c, .e, .g, .a].inOctave(3).isStepwise == false
  /// ```
  bool get isStepwise =>
      intervalSteps.every((interval) => interval.size.abs() <= Size.second);

  /// Every element transposed by [interval], preserving order.
  Iterable<T> transposeBy(Interval interval) =>
      map((item) => item.transposeBy(interval));

  /// This collection's twelve-tone [Inversion](https://en.wikipedia.org/wiki/Inversion_(music)):
  /// the [first] element stays fixed while every later one is reflected to
  /// the opposite side of it, turning each ascending step into an
  /// equal-sized descending one and vice versa.
  ///
  /// Combine with [retrograde] for a retrograde inversion.
  ///
  /// Example:
  /// ```dart
  /// <Note>{.b, .a.sharp, .d}.inversion.toSet() == <Note>{.b, .c, .g.sharp}
  /// ```
  Iterable<T> get inversion sync* {
    if (isEmpty) return;
    T last;
    yield last = first;
    for (var i = 1; i < length; i++) {
      yield last = last.transposeBy(elementAt(i).interval(elementAt(i - 1)));
    }
  }

  /// This collection played back to front.
  ///
  /// See [Retrograde](https://en.wikipedia.org/wiki/Retrograde_(music)).
  /// Combine with [inversion] for a retrograde inversion.
  ///
  /// Example:
  /// ```dart
  /// <PitchClass>{.dSharp, .g, .fSharp}).retrograde.toSet()
  ///   == <PitchClass>{.fSharp, .g, .dSharp}
  /// ```
  Iterable<T> get retrograde => toList(growable: false).reversed;

  /// Each element's semitone distance from [reference] (or from [first] if
  /// [reference] is omitted), reduced modulo the octave — the pitch-class
  /// set theory "normal form" numbering used to compare set classes
  /// regardless of transposition.
  ///
  /// Example:
  /// ```dart
  /// <PitchClass>{.b, .aSharp, .d}.numericRepresentation().toSet()
  ///   == const {0, 11, 3}
  ///
  /// <PitchClass>{.b, .aSharp, .d}.numericRepresentation(reference: .g).toSet()
  ///   == const {4, 3, 7}
  /// ```
  Iterable<int> numericRepresentation({T? reference}) => map(
    (scalable) =>
        (reference ?? first).difference(scalable) % chromaticDivisions,
  );

  /// The interval, in semitones, from each element to the next, starting
  /// with a leading `0` for the first — a compact way to describe a
  /// pitch-class set's shape independently of its starting point.
  ///
  /// Example:
  /// ```dart
  /// <PitchClass>{.b, .aSharp, .d, .e}.deltaNumericRepresentation.toList()
  ///   == const [0, -1, 4, 2]
  /// ```
  Iterable<int> get deltaNumericRepresentation sync* {
    if (isEmpty) return;
    yield 0;
    for (var i = 1; i < length; i++) {
      yield elementAt(i - 1).difference(elementAt(i));
    }
  }
}
