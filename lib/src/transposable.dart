part of '../music_notes.dart';

@immutable
// ignore: one_member_abstracts
abstract class Transposable<T extends Transposable<T>> {
  /// Returns a transposed [T] by [interval] from this [T].
  T transposeBy(Interval interval);
}
