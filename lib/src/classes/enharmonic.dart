part of music_notes;

abstract class Enharmonic<T extends MusicItem> {
  final Set<T> items;

  Enharmonic(this.items)
      : assert(items != null && items.length > 0),
        assert(
          items.every(
            (item) => item.value == itemsValue(items),
          ),
          "The items are not enharmonic",
        );

  /// Returns the value of the common chromatic pitch of [items].
  static int itemsValue(Set items) => items.toList()[0].value;

  /// Returns the value of the common chromatic pitch this [Enharmonic].
  int get value => itemsValue(items);

  @override
  String toString() => '$items';

  @override
  bool operator ==(other) =>
      other is Enharmonic<T> && this.value == other.value;
}
