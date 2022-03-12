part of music_notes;

@immutable
abstract class Enharmonic<T extends MusicItem>
    implements Transposable<Enharmonic>, Comparable<Enharmonic> {
  final Set<T> items;

  Enharmonic(this.items)
      : assert(items.isNotEmpty, 'Provide a non-empty items collection'),
        assert(
          items.every((item) => item.semitones == items.first.semitones),
          '${T}s must have the same number of semitones.',
        );

  /// Returns the number of semitones of the common chromatic pitch
  /// this [Enharmonic].
  int get semitones => items.first.semitones;

  /// Returns a transposed [Enharmonic] by [semitones] from this [Enharmonic].
  @override
  Enharmonic transposeBy(int semitones);

  @override
  String toString() => '$items';

  @override
  bool operator ==(Object other) =>
      other is Enharmonic<T> && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(covariant Enharmonic other) =>
      semitones.compareTo(other.semitones);
}
