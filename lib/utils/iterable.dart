/// Compares multiple comparators.
int compareMultiple(Iterable<int Function()> comparators) {
  assert(comparators.length > 1, 'Provide more than one comparator');
  late int compareValue;
  for (final comparable in comparators) {
    compareValue = comparable();
    if (compareValue != 0) break;
  }

  return compareValue;
}
