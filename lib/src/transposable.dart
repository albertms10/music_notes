import 'interval/interval.dart';

/// An interface for items that can be transposed.
// ignore: one_member_abstracts
abstract interface class Transposable<T> {
  /// Transposes this [T] by [interval].
  T transposeBy(Interval interval);
}
