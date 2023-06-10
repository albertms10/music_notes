part of '../../music_notes.dart';

class Chord<T extends Scalable<T>> implements Transposable<Chord<T>> {
  /// The [Scalable<T>] items this [Chord] is built of.
  final List<T> items;

  /// Creates a new [Chord] from [items].
  const Chord(this.items);

  /// The root [Scalable<T>] of this [Chord].
  T get root => items.first;

  /// Returns the [ChordPattern] for this [Chord].
  ///
  /// The pattern is calculated based on the intervals between the notes rather
  /// than from the root note. This approach helps differentiate compound
  /// intervals (e.g., [Interval.majorNinth]) from simple intervals (e.g.,
  /// [Interval.majorSecond]) in chords where distance is not explicit (e.g.,
  /// [Note] based chords rather than [PositionedNote] based).
  ///
  /// Example:
  /// ```dart
  /// const Chord([Note.a, Note.c, Note.e]).pattern == ChordPattern.minorTriad
  /// const Chord([Note.g, Note.b, Note.d, Note.f, Note.a]).pattern
  ///   == ChordPattern.majorTriad.add7().add9()
  /// ```
  ChordPattern get pattern => ChordPattern.intervalSteps(items.intervals);

  /// Returns a transposed [Chord] by [interval] from this [Chord].
  ///
  /// Example:
  /// ```dart
  /// const Chord([Note.a, Note.c, Note.e]).transposeBy(Interval.minorThird)
  ///   == const Chord([Note.c, Note.e.flat, Note.g])
  ///
  /// ChordPattern.majorTriad.on(Note.g.inOctave(4))
  ///   .transposeBy(Interval.majorThird)
  ///     == const Chord([
  ///       Note.b.inOctave(4),
  ///       Note.d.sharp.inOctave(5),
  ///       Note.f.sharp.inOctave(5)
  ///     ])
  /// ```
  @override
  Chord<T> transposeBy(Interval interval) =>
      Chord(items.map((item) => item.transposeBy(interval)).toList());

  @override
  String toString() => '$root ${pattern.abbreviation} (${items.join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is Chord<T> && ListEquality<T>().equals(items, other.items);

  @override
  int get hashCode => Object.hashAll(items);
}
