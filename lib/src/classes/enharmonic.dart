part of music_notes;

abstract class Enharmonic<T extends MusicItem> {
  final Set<T> items;

  Enharmonic(this.items)
      : assert(items != null && items.isNotEmpty),
        assert(
          items.every(
            (item) => item.semitones == _itemsSemitones(items),
          ),
          '${T}s are not enharmonic.',
        );

  /// Returns the number of semitones of the common chromatic pitch of [items].
  ///
  /// It is used by [semitones] getter.
  static int _itemsSemitones(Set items) => items.first.semitones;

  /// Returns the number of semitones of the common chromatic pitch this [Enharmonic].
  int get semitones => _itemsSemitones(items);

  /// Returns a transposed [EnharmonicInterval] by [semitones] from this [EnharmonicInterval].
  Enharmonic transposeBy(int semitones);

  @override
  String toString() => '$items';

  @override
  bool operator ==(other) =>
      other is Enharmonic<T> && semitones == other.semitones;
}
