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
  /// Note.a.major.scale.degreeChords == [
  ///   Note.a.majorTriad,
  ///   Note.b.minorTriad,
  ///   Note.c.sharp.minorTriad,
  ///   Note.d.majorTriad,
  ///   Note.e.majorTriad,
  ///   Note.f.sharp.minorTriad,
  ///   Note.g.sharp.diminishedTriad,
  /// ]
  /// ```
  List<Chord<T>> get degreeChords =>
      [for (var i = 1; i < items.length; i++) degreeChord(ScaleDegree(i))];

  /// Returns the [T] for the [scaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.degree(ScaleDegree.ii.lowered) == Note.d.flat
  /// Note.c.minor.scale.degree(ScaleDegree.v) == Note.g
  /// Note.a.flat.major.scale.degree(ScaleDegree.vi) == Note.f
  /// ```
  T degree(ScaleDegree scaleDegree) {
    final scalable = items[scaleDegree.degree - 1];
    if (scaleDegree.semitonesDelta == 0) return scalable;

    return scalable.transposeBy(
      Interval.perfect(
        1,
        PerfectQuality(scaleDegree.semitonesDelta.abs()),
      ).descending(isDescending: scaleDegree.semitonesDelta.isNegative),
    );
  }

  /// Returns the [Chord] for the [scaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.g.major.scale.degreeChord(ScaleDegree.vi) == Note.b.minorTriad
  /// Note.d.minor.scale.degreeChord(ScaleDegree.ii) == Note.d.diminishedTriad
  /// ```
  Chord<T> degreeChord(ScaleDegree scaleDegree) =>
      pattern.degreePattern(scaleDegree).on(degree(scaleDegree));

  /// Returns this [Scale] transposed by [interval].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.transposeBy(Interval.minorThird)
  ///   == Note.e.flat.major.scale
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
