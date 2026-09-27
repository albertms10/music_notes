/// Adds comparison operators to a comparable class with a total order.
mixin Comparators<T> implements Comparable<T> {
  /// Whether this [T] is numerically smaller than [other].
  bool operator <(T other) => compareTo(other) < 0;

  /// Whether this [T] is numerically smaller than or equal to [other].
  bool operator <=(T other) => compareTo(other) <= 0;

  /// Whether this [T] is numerically greater than [other].
  bool operator >(T other) => compareTo(other) > 0;

  /// Whether this [T] is numerically greater than or equal to [other].
  bool operator >=(T other) => compareTo(other) >= 0;
}
