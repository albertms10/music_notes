part of '../../music_notes.dart';

/// A musical chord.
///
/// ---
/// See also:
/// * [ChordPattern].
/// * [Scalable].
/// * [Chordable].
@immutable
class Chord<T extends Scalable<T>>
    with Chordable<Chord<T>>
    implements Transposable<Chord<T>> {
  /// The [Scalable] items this [Chord] is built of.
  final List<T> items;

  /// Creates a new [Chord] from [items].
  const Chord(this.items);

  /// The root [Scalable] of this [Chord].
  T get root => items.first;

  /// Returns the [ChordPattern] for this [Chord].
  ///
  /// The pattern is calculated based on the intervals between the notes
  /// rather than from the root note. This approach helps differentiate
  /// compound intervals (e.g., [Interval.M9]) from simple intervals
  /// (e.g., [Interval.M2]) in chords where distance is not explicit
  /// (so, [Note] based chords rather than [Pitch] based).
  ///
  /// Example:
  /// ```dart
  /// const Chord([Note.a, Note.c, Note.e]).pattern == ChordPattern.minorTriad
  /// const Chord([Note.g, Note.b, Note.d, Note.f, Note.a]).pattern
  ///   == ChordPattern.majorTriad.add7().add9()
  /// ```
  ChordPattern get pattern =>
      ChordPattern.fromIntervalSteps(items.intervalSteps);

  /// Returns the list of modifier [T]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// Note.a.majorTriad.add7().add9().modifiers == const [Note.g, Note.b]
  /// ```
  List<T> get modifiers => items.skip(3).toList();

  /// Returns a new [Chord] with an [ImperfectQuality.diminished] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().diminished
  ///   == Chord([Note.c, Note.e.flat, Note.g.flat, Note.b.flat])
  /// ```
  @override
  Chord<T> get diminished => pattern.diminished.on(root);

  /// Returns a new [Chord] with an [ImperfectQuality.minor] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().minor
  ///   == Chord([Note.c, Note.e.flat, Note.g, Note.b.flat])
  /// ```
  @override
  Chord<T> get minor => pattern.minor.on(root);

  /// Returns a new [Chord] with an [ImperfectQuality.major] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.minorTriad.add7().major
  ///   == Chord([Note.c, Note.e, Note.g, Note.b.flat])
  /// ```
  @override
  Chord<T> get major => pattern.major.on(root);

  /// Returns a new [Chord] with an [ImperfectQuality.augmented] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().augmented
  ///   == Chord([Note.c, Note.e, Note.g.sharp, Note.b.flat])
  /// ```
  @override
  Chord<T> get augmented => pattern.augmented.on(root);

  /// Returns a new [Chord] adding [interval].
  @override
  Chord<T> add(Interval interval, {Set<int>? replaceSizes}) =>
      pattern.add(interval, replaceSizes: replaceSizes).on(root);

  /// Returns a transposed [Chord] by [interval] from this [Chord].
  ///
  /// Example:
  /// ```dart
  /// const Chord([Note.a, Note.c, Note.e]).transposeBy(Interval.m3)
  ///   == const Chord([Note.c, Note.e.flat, Note.g])
  ///
  /// ChordPattern.majorTriad.on(Note.g.inOctave(4))
  ///   .transposeBy(Interval.M3)
  ///     == const Chord([
  ///          Note.b.inOctave(4),
  ///          Note.d.sharp.inOctave(5),
  ///          Note.f.sharp.inOctave(5)
  ///        ])
  /// ```
  @override
  Chord<T> transposeBy(Interval interval) =>
      Chord(items.transposeBy(interval).toList());

  @override
  String toString() => '$root ${pattern.abbreviation} (${items.join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is Chord<T> && ListEquality<T>().equals(items, other.items);

  @override
  int get hashCode => Object.hashAll(items);
}
