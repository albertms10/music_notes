int compareMultiple(Iterable<int Function()> comparables) {
  assert(comparables.length > 1, 'Provide more than one comparable');
  late int compareValue;
  for (final comparable in comparables) {
    compareValue = comparable();
    if (compareValue != 0) break;
  }

  return compareValue;
}
