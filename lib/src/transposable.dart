part of '../music_notes.dart';

@immutable
// ignore: one_member_abstracts
abstract class Transposable<T> {
  /// Returns a transposed [T] by [semitones] from this [T].
  T transposeBy(int semitones);
}
