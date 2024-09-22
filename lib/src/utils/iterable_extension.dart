import '../scalable.dart';
import 'range_extension.dart';

/// An Iterable extension.
extension IterableExtension<E> on Iterable<E> {
  /// The closest element [E] to [target].
  ///
  /// Example:
  /// ```dart
  /// const [2, 5, 6, 8, 10].closestTo(7) == 6
  ///
  /// [Note.c, Note.e, Note.f.sharp, Note.a]
  ///     .closestTo(Note.g, (a, b) => b.semitones - a.semitones)
  ///   == Note.f.sharp
  /// ```
  E closestTo(E target, [num Function(E a, E b)? difference]) =>
      reduce((closest, element) {
        if (difference == null && closest is! num) {
          throw ArgumentError.value(
            difference,
            'difference',
            'Provide difference when elements are not num',
          );
        }

        difference ??= (a, b) => (b as num) - (a as num);

        return difference!(element, target).abs() <
                difference!(closest, target).abs()
            ? element
            : closest;
      });

  Iterable<Range<E>> _compact({
    required E Function(E current) nextValue,
    required int Function(E a, E b) compare,
    bool inclusive = false,
  }) {
    if (isEmpty) return const Iterable.empty();

    var start = first;
    late E b;

    final ranges = <Range<E>>{};
    if (length > 1) {
      for (var i = 0; i < length - 1; i++) {
        final a = elementAt(i);
        b = elementAt(i + 1);

        final nextA = nextValue(a);
        if (compare(nextA, b) != 0) {
          ranges.add((from: start, to: inclusive ? nextA : a));
          start = b;
        }
      }
    } else {
      b = first;
    }

    return (ranges..add((from: start, to: inclusive ? nextValue(b) : b)))
        .toList();
  }

  /// Returns a list of consecutive values of this [Iterable]
  /// compacted as tuples. Consecutive values are obtained
  /// based on [nextValue] and [compare].
  ///
  /// Examples:
  /// ```dart
  /// const numbers = [1, 2, 3, 4, 5, 8];
  /// numbers.compact() == [(from: 1, to: 5), (from: 8, to: 8)]
  /// numbers.compact(inclusive: true) == [(from: 1, to: 6), (from: 8, to: 9)]
  /// ```
  /// ---
  /// See also:
  /// * [RangeExtension.explode] for the inverse operation.
  Iterable<Range<E>> compact({
    required E Function(E current) nextValue,
    required int Function(E a, E b) compare,
    bool inclusive = false,
  }) =>
      _compact(nextValue: nextValue, compare: compare, inclusive: inclusive);
}

/// A Scalable Iterable extension.
extension ScalableIterableExtension<E extends Scalable<E>> on Iterable<E> {
  /// Compacts this [Iterable] into a collection of [Range]s, based on
  /// [nextValue], [compare] and [inclusive].
  ///
  /// Example:
  /// ```dart
  /// final notes = [Note.c, Note.d.flat, Note.d, Note.e.flat, Note.g];
  /// notes.compact() == [
  ///   (from: Note.c, to: Note.e.flat),
  ///   (from: Note.g, to: Note.g),
  /// ]
  /// notes.compact(inclusive: true) == [
  ///   (from: Note.c, to: Note.e),
  ///   (from: Note.g, to: Note.a.flat),
  /// ]
  /// ```
  /// ---
  /// See also:
  /// * [RangeExtension.explode] for the inverse operation.
  Iterable<Range<E>> compact({
    E Function(E current)? nextValue,
    int Function(E a, E b)? compare,
    bool inclusive = false,
  }) =>
      _compact(
        nextValue: nextValue ?? Scalable.chromaticMotion,
        compare: compare ?? Scalable.compareEnharmonically,
        inclusive: inclusive,
      );
}

/// Compares multiple comparators.
int compareMultiple(List<int Function()> comparators) {
  assert(comparators.length > 1, 'Provide more than one comparator.');
  late int compareValue;
  for (final comparator in comparators) {
    compareValue = comparator();
    if (compareValue != 0) break;
  }

  return compareValue;
}
