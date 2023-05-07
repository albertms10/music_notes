part of '../music_notes.dart';

@immutable
// ignore: one_member_abstracts
abstract class Transposable<T> {
  /// Returns a transposed [T] by [interval] from this [T].
  Transposable<T> transposeBy(Interval interval);
}
