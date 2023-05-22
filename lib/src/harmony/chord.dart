part of '../../music_notes.dart';

class Chord<T extends Scalable<T>> {
  /// The [Scalable<T>] items this [Chord] is built of.
  final List<T> items;

  /// Creates a new [Chord] from [items].
  const Chord(this.items);

  /// The root [Scalable<T>] of this [Chord].
  T get root => items.first;

  /// Returns the [ChordPattern] for this [Chord].
  ChordPattern get pattern => ChordPattern([
        // We skip the root of the chord.
        for (final scalable in items.skip(1)) root.interval(scalable),
      ]);

  @override
  bool operator ==(Object other) =>
      other is Chord<T> && ListEquality<T>().equals(items, other.items);

  @override
  int get hashCode => Object.hashAll(items);
}
