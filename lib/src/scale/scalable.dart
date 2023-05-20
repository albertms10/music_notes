part of '../../music_notes.dart';

abstract interface class Scalable<T> implements Transposable<T> {
  @override
  T transposeBy(Interval interval);

  /// Returns the interval between this [T] and [other].
  Interval interval(T other);
}
