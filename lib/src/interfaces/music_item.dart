part of music_notes;

abstract class MusicItem {
  /// Returns the number of semitones that correspond to this [MusicItem].
  int get semitones;

  const MusicItem._();
}
