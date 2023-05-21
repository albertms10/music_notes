part of '../../music_notes.dart';

class Scale<T extends Scalable<T>> implements Transposable<Scale<T>> {
  /// The [Scalable] items that define this [Scale].
  final List<T> items;

  /// The descending [Scalable] items that define this [Scale] (if different).
  final List<T>? _descendingItems;

  /// Creates a new [Scale] instance from [items].
  const Scale(this.items, [this._descendingItems]);

  /// The descending [Scalable] items that define this [Scale].
  List<T> get descendingItems => _descendingItems ?? items.reversed.toList();

  /// Returns the [ScalePattern] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// const Scale([Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///   Note.c]) == ScalePattern.major
  /// ```
  ScalePattern get pattern =>
      ScalePattern(items.intervals, _descendingItems?.descendingIntervals);

  /// Returns the reversed scale of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.melodicMinor.from(Note.d, isDescending: true)
  ///   == ScalePattern.naturalMinor.from(Note.d).reversed
  /// ```
  Scale<T> get reversed => Scale(descendingItems, items);

  @override
  Scale<T> transposeBy(Interval interval) =>
      Scale([for (final item in items) item.transposeBy(interval)]);

  @override
  String toString() => '${items.first} ${pattern.name} (${items.join(' ')}'
      '${_descendingItems != null ? ', ${_descendingItems!.join(' ')}' : ''})';

  @override
  bool operator ==(Object other) =>
      other is Scale<T> &&
      ListEquality<T>().equals(items, other.items) &&
      ListEquality<T>().equals(descendingItems, other.descendingItems);

  @override
  int get hashCode => Object.hashAll(items);
}

extension _ListScalableExtension<T extends Scalable<T>> on List<T> {
  /// Returns the [Interval] list between this [List<Scalable<T>>].
  List<Interval> get intervals =>
      [for (var i = 0; i < length - 1; i++) this[i].interval(this[i + 1])];

  /// Returns the descending [Interval] list between this [List<Scalable<T>>].
  List<Interval> get descendingIntervals =>
      [for (var i = 0; i < length - 1; i++) this[i + 1].interval(this[i])];
}
