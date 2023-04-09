part of '../music_notes.dart';

@immutable
abstract class Transposable<T> {
  /// Returns a transposed [T] by [semitones] from this [T].
  T transposeBy(int semitones);

  const Transposable._();
}
