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
  /// Example:
  /// ```dart
  /// const Chord([Note.a, Note.c, Note.e]).pattern == ChordPattern.minorTriad
  /// const Chord([Note.g, Note.b, Note.d, Note.f]).pattern
  ///   == ChordPattern.majorTriad.add7()
  /// ```
  ChordPattern get pattern => ChordPattern([
        // We skip the root of the chord.
        for (final scalable in items.skip(1)) root.interval(scalable),
      ]);

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
