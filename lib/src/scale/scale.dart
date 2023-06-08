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

  /// Returns the reversed of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.aeolian.on(Note.a).reversed
  ///   == Scale([Note.a, Note.g, Note.f, Note.e, Note.d, Note.c, Note.b,
  ///        Note.a])
  /// ```
  Scale<T> get reversed =>
      Scale(descendingItems, _descendingItems != null ? items : null);

  /// Returns the [Chord] for each [ScaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.on(Note.a).degrees == [
  ///   Note.a.majorTriad,
  ///   Note.b.minorTriad,
  ///   Note.c.sharp.minorTriad,
  ///   Note.d.majorTriad,
  ///   Note.e.majorTriad,
  ///   Note.f.sharp.minorTriad,
  ///   Note.g.sharp.diminishedTriad,
  /// ]
  /// ```
  List<Chord<T>> get degrees =>
      [for (var i = 1; i < items.length; i++) degree(ScaleDegree(i))];

  /// Returns the [Chord] for the [scaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.on(Note.g).degree(ScaleDegree.vi)
  ///   == Note.b.minorTriad
  /// ScalePattern.naturalMinor.on(Note.d).degree(ScaleDegree.ii)
  ///   == Note.d.diminishedTriad
  /// ```
  Chord<T> degree(ScaleDegree scaleDegree) =>
      pattern.degreePattern(scaleDegree).on(items[scaleDegree.degree - 1]);

  /// Returns this [Scale] transposed by [interval].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.on(Note.c).transposeBy(Interval.minorThird)
  ///   == ScalePattern.major.on(Note.e.flat)
  /// ```
  @override
  Scale<T> transposeBy(Interval interval) => Scale(
        items.transposeBy(interval),
        _descendingItems?.transposeBy(interval),
      );

  @override
  String toString() => '${items.first} ${pattern.name} (${items.join(' ')}'
      '${_descendingItems != null ? ', ${_descendingItems!.join(' ')}' : ''})';

  @override
  bool operator ==(Object other) =>
      other is Scale<T> &&
      ListEquality<T>().equals(items, other.items) &&
      ListEquality<T>().equals(_descendingItems, other._descendingItems);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(items),
        _descendingItems != null ? Object.hashAll(_descendingItems!) : null,
      );
}

extension _ListScalableExtension<T extends Scalable<T>> on List<T> {
  /// Returns the [Interval] list between this [List<Scalable<T>>].
  List<Interval> get intervals =>
      [for (var i = 0; i < length - 1; i++) this[i].interval(this[i + 1])];

  /// Returns the descending [Interval] list between this [List<Scalable<T>>].
  List<Interval> get descendingIntervals =>
      [for (var i = 0; i < length - 1; i++) this[i + 1].interval(this[i])];

  /// Returns this [List<Scalable<T>>] transposed by [interval].
  List<T> transposeBy(Interval interval) =>
      [for (final item in this) item.transposeBy(interval)];
}
