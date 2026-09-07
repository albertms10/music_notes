import '../range.dart';
import '../scalable.dart';
import 'range_extension.dart';

/// Nearest-match and run-length compression helpers for general
/// collections, generalized over an explicit [difference] function so the
/// same algorithm serves plain numbers, dates, or musical [Scalable]s alike
/// (see [NumIterableExtension] and [ScalableIterableExtension] for the
/// specialized entry points).
extension IterableExtension<E> on Iterable<E> {
  E _closestTo(E target, num Function(E a, E b) difference) => reduce(
    (closest, element) =>
        difference(element, target).abs() < difference(closest, target).abs()
        ? element
        : closest,
  );

  /// The element of this [Iterable] with the smallest [difference] from
  /// [target] (ties favor whichever element [reduce] encounters first).
  ///
  /// Example:
  /// ```dart
  /// const [5].closestTo(1) == 5
  /// const [2, 5, 6, 8, 10].closestTo(7) == 6
  /// ```
  E closestTo(E target, num Function(E a, E b) difference) =>
      _closestTo(target, difference);

  Iterable<Range<E>> _compact({
    required E Function(E current) nextValue,
    required Comparator<E> compare,
  }) sync* {
    if (isEmpty) return;

    var start = first;
    for (var i = 1; i < length; i++) {
      final a = elementAt(i - 1);
      final b = elementAt(i);
      final nextA = nextValue(a);

      if (compare(nextA, b) != 0) {
        yield (from: start, to: nextA);
        start = b;
      }
    }

    yield (from: start, to: nextValue(last));
  }

  /// Collapses consecutive runs of this [Iterable] into [Range]s,
  /// treating [a] and [b] as adjacent whenever `compare(nextValue(a), b)`
  /// is zero — the inverse of [RangeExtension.explode], and the operation
  /// behind rendering a scattered set of pitches as compact spans (e.g.
  /// summarizing a chromatic run as "C–E♭" instead of every note in it).
  ///
  /// Example:
  /// ```dart
  /// const [1, 2, 3, 4, 5, 8].compact(
  ///   nextValue: (current) => current + 1,
  ///   compare: Comparable.compare,
  /// ).toList() == const [(from: 1, to: 6), (from: 8, to: 9)]
  /// ```
  /// ---
  /// See also:
  /// * [RangeExtension.explode] for the inverse operation.
  Iterable<Range<E>> compact({
    required E Function(E current) nextValue,
    required Comparator<E> compare,
  }) => _compact(nextValue: nextValue, compare: compare);

  /// This [Iterable] rendered one element per line, indented — the layout
  /// used by verbose `toString()` overrides throughout this library (e.g.
  /// [Chord.toString] listing its notes).
  String prettyToString() => '[\n\t${join(',\n\t')}\n]';
}

/// [IterableExtension.closestTo] specialized for plain numeric types,
/// where "closest" simply means the smallest absolute difference.
extension NumIterableExtension<E extends num> on Iterable<E> {
  static num _difference(num a, num b) => b - a;

  /// The element of this [Iterable] numerically nearest to [target].
  ///
  /// Example:
  /// ```dart
  /// const [5].closestTo(1) == 5
  /// const [-5, 5].closestTo(0) == -5
  /// const [2, 5, 6, 8, 10].closestTo(7) == 6
  /// ```
  E closestTo(E target, [num Function(E a, E b) difference = _difference]) =>
      _closestTo(target, difference);
}

/// [IterableExtension.closestTo] and [IterableExtension.compact]
/// specialized for [Scalable] values, where distance defaults to
/// [Scalable.semitones] and adjacency to [Scalable.chromaticMotion] and
/// [Scalable.compareEnharmonically] — the pitch-aware "nearest note" and
/// "collapse into ranges" behind [Frequency.closestPitch] and compact key
/// signature reporting.
extension ScalableIterableExtension<E extends Scalable<E>> on Iterable<E> {
  static num _difference<E extends Scalable<E>>(E a, E b) =>
      b.semitones - a.semitones;

  /// The element of this [Iterable] closest in pitch to [target], by
  /// [Scalable.semitones] unless a custom [difference] is supplied.
  ///
  /// Example:
  /// ```dart
  /// <Note>[.c, .e, .f.sharp, .a].closestTo(.g) == .f.sharp
  /// ```
  E closestTo(E target, [num Function(E a, E b)? difference]) =>
      _closestTo(target, difference ?? _difference);

  /// Collapses consecutive chromatic runs of this [Iterable] into
  /// [Range]s, by default stepping chromatically upward
  /// ([Scalable.chromaticMotion]) and comparing enharmonically
  /// ([Scalable.compareEnharmonically]).
  ///
  /// Example:
  /// ```dart
  /// <Note>[.c, .d.flat, .d, .e.flat, .g].compact().toList() == [
  ///   (from: Note.c, to: Note.e),
  ///   (from: Note.g, to: Note.a.flat),
  /// ]
  /// ```
  /// ---
  /// See also:
  /// * [RangeExtension.explode] for the inverse operation.
  Iterable<Range<E>> compact({
    E Function(E current)? nextValue,
    Comparator<E>? compare,
  }) => _compact(
    nextValue: nextValue ?? Scalable.chromaticMotion,
    compare: compare ?? Scalable.compareEnharmonically,
  );
}

/// Evaluates [comparators] in order, returning the first non-zero result
/// (or the last result, if all compare equal) — how multi-key `compareTo`
/// overrides in this library (e.g. sorting [Key]s by note, then by mode)
/// avoid deeply nested `if` chains.
int compareMultiple(List<int Function()> comparators) {
  assert(comparators.length > 1, 'Provide more than one comparator.');
  late int compareValue;
  for (final comparator in comparators) {
    compareValue = comparator();
    if (compareValue != 0) break;
  }

  return compareValue;
}
