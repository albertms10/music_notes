import 'interval/interval.dart';

/// An interface for items that can be transposed.
abstract interface class Transposable<T> {
  /// Transposes this [T] by [interval].
  T transposeBy(Interval interval);
}
