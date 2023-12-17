/// An Iterable num extension.
extension IterableNumExtension<E> on Iterable<E> {
  /// Returns the closest element to [target] in this [Iterable].
  ///
  /// Example:
  /// ```dart
  /// const [2, 5, 6, 8, 10].closestTo(7) == 6
  /// ```
  E closestTo(E target, [num Function(E element)? toNum]) => reduce(
        (closestElement, element) {
          if (toNum == null && closestElement is! num) {
            throw ArgumentError(
              'Provide toNum when elements are not num',
              'toNum',
            );
          }
          final currentNum = toNum?.call(element) ?? element as num;
          final closest = toNum?.call(closestElement) ?? closestElement as num;
          final targetNum = toNum?.call(target) ?? target as num;
          return (targetNum - currentNum).abs() < (targetNum - closest).abs()
              ? element
              : closestElement;
        },
      );
}

/// Compares multiple comparators.
int compareMultiple(Iterable<int Function()> comparators) {
  assert(comparators.length > 1, 'Provide more than one comparator');
  late int compareValue;
  for (final comparator in comparators) {
    compareValue = comparator();
    if (compareValue != 0) break;
  }

  return compareValue;
}
