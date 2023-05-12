part of '../music_notes.dart';

@immutable
abstract interface class MusicItem implements Comparable<MusicItem> {
  /// The number of semitones that correspond to this [MusicItem].
  int get semitones;
}
