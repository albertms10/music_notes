part of '../music_notes.dart';

@immutable
abstract class Enharmonic<T extends MusicItem>
    implements MusicItem, Transposable<Enharmonic> {
  /// The number of semitones of the common chromatic pitch of this
  /// [Enharmonic].
  @override
  final int semitones;

  /// Creates a new [Enharmonic].
  const Enharmonic(this.semitones);

  /// Returns the items sharing the same [semitones].
  Set<T> get items;

  /// Returns a transposed [Enharmonic] by [semitones] from this [Enharmonic].
  @override
  Enharmonic transposeBy(int semitones);

  @override
  String toString() => '$semitones $items';

  @override
  bool operator ==(Object other) =>
      other is Enharmonic<T> && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(covariant Enharmonic other) =>
      semitones.compareTo(other.semitones);
}
