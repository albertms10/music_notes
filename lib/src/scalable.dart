part of '../music_notes.dart';

/// A interface for items that can form scales.
abstract interface class Scalable<T> implements Transposable<T> {
  @override
  T transposeBy(Interval interval);

  /// Returns the [Interval] between this [T] and [other].
  Interval interval(T other);
}

extension _ScalableIterable<T extends Scalable<T>> on Iterable<T> {
  /// Returns the [Interval]s between [T]s in this [Iterable<T>].
  List<Interval> get _intervals => [
        for (var i = 0; i < length - 1; i++)
          elementAt(i).interval(elementAt(i + 1)),
      ];

  /// Returns the descending [Interval]s between [T]s this [Iterable<T>].
  List<Interval> get _descendingIntervals => [
        for (var i = 0; i < length - 1; i++)
          elementAt(i + 1).interval(elementAt(i)),
      ];

  /// Returns this [Iterable<T>] transposed by [interval].
  List<T> _transposeBy(Interval interval) =>
      [for (final item in this) item.transposeBy(interval)];
}
