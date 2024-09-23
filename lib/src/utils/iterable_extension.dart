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

  /// Compacts this [Iterable] into a list of [Range]s based on [nextValue]
  /// and [compare].
  ///
  /// Examples:
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
  }) =>
      _compact(nextValue: nextValue, compare: compare);
}

/// A Scalable Iterable extension.
extension ScalableIterableExtension<E extends Scalable<E>> on Iterable<E> {
  /// Compacts this [Iterable] into a list of [Range]s based on [nextValue]
  /// and [compare].
  ///
  /// Example:
  /// ```dart
  /// [Note.c, Note.d.flat, Note.d, Note.e.flat, Note.g].compact().toList() == [
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
  }) =>
      _compact(
        nextValue: nextValue ?? Scalable.chromaticMotion,
        compare: compare ?? Scalable.compareEnharmonically,
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
