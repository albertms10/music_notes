int compareMultiple(Iterable<int Function()> comparables) {
  assert(comparables.length > 2, 'Provide more than two comparables');
  late int compareValue;
  for (final comparable in comparables) {
    compareValue = comparable();
    if (compareValue != 0) break;
  }

  return compareValue;
}
