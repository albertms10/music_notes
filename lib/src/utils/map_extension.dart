/// An extension on [Map].
extension MapExtension<K, V> on Map<K, V> {
  /// Returns the record entries of this [Map].
  ///
  /// It allows for a stable hash code implementation without using [MapEntry].
  ///
  /// Example:
  /// ```dart
  /// const planets = {1: 'Mercury', 2: 'Venus', 3: 'Earth', 4: 'Mars'};
  /// planets.recordEntries.toList()
  ///   == const [(1, 'Mercury'), (2, 'Venus'), (3, 'Earth'), (4, 'Mars')]
  /// ```
  Iterable<(K key, V value)> get recordEntries =>
      entries.map((e) => (e.key, e.value));
}
