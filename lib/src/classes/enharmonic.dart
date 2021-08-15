part of music_notes;

@immutable
abstract class Enharmonic<T extends MusicItem> {
  final Set<T> items;

  Enharmonic(this.items)
      : assert(items.isNotEmpty),
        assert(
          items.every((item) => item.semitones == items.first.semitones),
          '${T}s are not enharmonic.',
        );

  /// Returns the number of semitones of the common chromatic pitch
  /// this [Enharmonic].
  int get semitones => items.first.semitones;

  /// Returns a transposed [EnharmonicInterval] by [semitones]
  /// from this [EnharmonicInterval].
  Enharmonic transposeBy(int semitones);

  @override
  String toString() => '$items';

  @override
  bool operator ==(Object other) =>
      other is Enharmonic<T> && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;
}
