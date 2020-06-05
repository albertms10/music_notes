part of music_notes;

abstract class Enharmonic<T extends MusicItem> {
  final Set<T> items;

  Enharmonic(this.items)
      : assert(items != null && items.length > 0),
        assert(
          items.every(
            (item) => item.semitones == itemsSemitones(items),
          ),
          "${T}s are not enharmonic.",
        );

  /// Returns the number of semitones of the common chromatic pitch of [semitones].
  static int itemsSemitones(Set semitones) => semitones.toList()[0].semitones;

  /// Returns the number of semitones of the common chromatic pitch this [Enharmonic].
  int get semitones => itemsSemitones(items);

  @override
  String toString() => '$items';

  @override
  bool operator ==(other) =>
      other is Enharmonic<T> && this.semitones == other.semitones;
}
