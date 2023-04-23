part of '../music_notes.dart';

@immutable
abstract class Enharmonic<T extends MusicItem> implements MusicItem {
  /// The number of semitones of the common chromatic pitch of this
  /// [Enharmonic].
  @override
  final int semitones;

  /// Creates a new [Enharmonic].
  const Enharmonic(this.semitones);

  /// Returns the items sharing the same [semitones].
  Set<T> get items;

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
