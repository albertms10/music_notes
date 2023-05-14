part of '../music_notes.dart';

@immutable
// ignore: one_member_abstracts
abstract interface class Transposable<T> {
  /// Returns a transposed [T] by [interval] from this [T].
  T transposeBy(Interval interval);
}
