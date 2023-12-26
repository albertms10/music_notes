/// An Iterable num extension.
extension IterableNumExtension<T extends num> on Iterable<T> {
  /// Returns the closest number to [target] in this [Iterable].
  ///
  /// Example:
  /// ```dart
  /// const [2, 5, 6, 8, 10].closestTo(7) == 6
  /// ```
  T closestTo(T target) => reduce(
        (closest, number) => (target - number).abs() < (target - closest).abs()
            ? number
            : closest,
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
