part of '../music_notes.dart';

@immutable
abstract interface class Enharmonic<T> implements Comparable<Enharmonic<T>> {
  /// The number of semitones of the common chromatic pitch of this
  /// [Enharmonic<T>].
  final int semitones;

  /// Creates a new [Enharmonic<T>].
  const Enharmonic(this.semitones);

  /// Returns the different spellings at [distance] sharing the same number of
  /// [semitones].
  Set<T> spellings({int distance});

  @override
  String toString() => '$semitones ${spellings()}';

  @override
  bool operator ==(Object other) =>
      other is Enharmonic<T> && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Enharmonic<T> other) => semitones.compareTo(other.semitones);
}
