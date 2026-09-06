import 'package:collection/collection.dart' show IterableEquality;

import 'interval_class/interval_class.dart';
import 'pitch_class/pitch_class.dart';

/// A mixin for pitch-like types that reduce to a chroma class [C] (a
/// [PitchClass] or [IntervalClass]) once octave and spelling are discarded.
///
/// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence):
/// two differently-spelled pitches or intervals that occupy the same
/// position in 12-tone equal temperament (e.g. G♯ and A♭, or a diminished
/// fourth and a major third) share the same [semitones] modulo the octave
/// and therefore the same [C].
mixin Enharmonic<C> {
  /// The number of semitones that place this value within its chroma class.
  int get semitones;

  /// The chroma class [C] (a [PitchClass] or [IntervalClass]) this value
  /// collapses to, discarding octave and spelling.
  C toClass();

  /// Whether this value and [other] collapse to the same [C], i.e. are
  /// enharmonically equivalent.
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.isEnharmonicWith(Note.a.flat) == true
  /// Note.c.isEnharmonicWith(Note.b.sharp) == true
  /// Note.e.isEnharmonicWith(Note.f) == false
  /// ```
  bool isEnharmonicWith(Enharmonic<C> other) => toClass() == other.toClass();
}

/// Enharmonic comparison and reduction across a whole collection at once,
/// e.g. checking whether two differently-spelled chords or scales describe
/// the same sounding pitches.
extension EnharmonicIterable<C> on Iterable<Enharmonic<C>> {
  /// Every element reduced to its chroma class [C], preserving order and
  /// any duplicate chroma classes.
  Iterable<C> toClass() => map((interval) => interval.toClass());

  /// Whether this and [other] reduce, position by position, to the same
  /// sequence of chroma classes.
  ///
  /// Example:
  /// ```dart
  /// <Note>[.c.sharp, .f, .a.flat]
  ///   .isEnharmonicWith(<Note>[.d.flat, .e.sharp, .g.sharp]) == true
  ///
  /// [Note.d.sharp].isEnharmonicWith([Note.a.flat]) == false
  ///
  /// const <Interval>[.m2, .m3, .M2]
  ///   .isEnharmonicWith(const <Interval>[.m2, .A2, .d3]) == true
  ///
  /// const [Interval.m2].isEnharmonicWith(const [Interval.P4]) == false
  /// ```
  bool isEnharmonicWith(Iterable<Enharmonic<C>> other) =>
      IterableEquality<C>().equals(toClass(), other.toClass());
}
