/// An Iterable extension.
extension IterableExtension<E> on Iterable<E> {
  /// Returns the closest element [E] to [target].
  ///
  /// Example:
  /// ```dart
  /// const [2, 5, 6, 8, 10].closestTo(7) == 6
  ///
  /// [Note.c, Note.e, Note.f.sharp, Note.a]
  ///     .closestTo(Note.g, (a, b) => b.semitones - a.semitones)
  ///   == Note.f.sharp
  /// ```
  E closestTo(E target, [num Function(E a, E b)? difference]) => reduce(
        (closest, element) {
          if (difference == null && closest is! num) {
            throw ArgumentError(
              'Provide difference when elements are not num',
              'difference',
            );
          }
          difference ??= (a, b) => (b as num) - (a as num);
          return difference!(element, target).abs() <
                  difference!(closest, target).abs()
              ? element
              : closest;
        },
      );
}

/// Compares multiple comparators.
int compareMultiple(List<int Function()> comparators) {
  assert(comparators.length > 1, 'Provide more than one comparator');
  late int compareValue;
  for (final comparator in comparators) {
    compareValue = comparator();
    if (compareValue != 0) break;
  }

  return compareValue;
}
