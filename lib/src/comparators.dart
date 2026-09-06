import 'interval/interval.dart';
import 'key_signature/key_signature.dart';
import 'pitch/pitch.dart';

/// Derives the four relational operators (`<`, `<=`, `>`, `>=`) from
/// [Comparable.compareTo], the way `num` and `String` do natively.
///
/// Mixing this in on a [Comparable] class means implementing [compareTo]
/// once is enough to also get ordering operators for free, e.g. sorting a
/// hand of [Interval]s or picking the higher of two [Pitch]es with `<` and
/// `>` instead of spelling out `compareTo` comparisons everywhere.
///
/// ---
/// See also:
/// * [Interval], [Pitch], and [KeySignature], which all mix this in.
mixin Comparators<T> implements Comparable<T> {
  /// Whether this [T] sorts strictly before [other].
  bool operator <(T other) => compareTo(other) < 0;

  /// Whether this [T] sorts at or before [other].
  bool operator <=(T other) => compareTo(other) <= 0;

  /// Whether this [T] sorts strictly after [other].
  bool operator >(T other) => compareTo(other) > 0;

  /// Whether this [T] sorts at or after [other].
  bool operator >=(T other) => compareTo(other) >= 0;
}
