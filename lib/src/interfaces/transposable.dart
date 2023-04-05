part of '../../music_notes.dart';

abstract class Transposable<T> {
  /// Returns a transposed [T] by [semitones] from this [T].
  T transposeBy(int semitones);

  const Transposable._();
}
