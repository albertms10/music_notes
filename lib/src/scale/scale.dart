part of '../../music_notes.dart';

class Scale<T extends Scalable<T>> implements Transposable<Scale<T>> {
  /// The [Scalable<T>] degrees that define this [Scale<T>].
  final List<T> degrees;

  /// The descending [Scalable<T>] degrees that define this [Scale<T>] (if
  /// different).
  final List<T>? _descendingDegrees;

  /// Creates a new [Scale<T>] instance from [degrees].
  const Scale(this.degrees, [this._descendingDegrees]);

  /// The descending [Scalable<T>] degrees that define this [Scale<T>].
  List<T> get descendingDegrees =>
      _descendingDegrees ?? degrees.reversed.toList();

  /// Returns the [ScalePattern] of this [Scale<T>].
  ///
  /// Example:
  /// ```dart
  /// const Scale([Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///   Note.c]) == ScalePattern.major
  /// ```
  ScalePattern get pattern =>
      ScalePattern(degrees.intervals, _descendingDegrees?.descendingIntervals);

  /// Returns the reversed of this [Scale<T>].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.aeolian.on(Note.a).reversed
  ///   == Scale([Note.a, Note.g, Note.f, Note.e, Note.d, Note.c, Note.b,
  ///        Note.a])
  /// ```
  Scale<T> get reversed =>
      Scale(descendingDegrees, _descendingDegrees != null ? degrees : null);

  /// Returns the [Chord<T>] for each [ScaleDegree] of this [Scale<T>].
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
      [for (var i = 1; i < degrees.length; i++) degreeChord(ScaleDegree(i))];

  /// Returns the [T] for the [scaleDegree] of this [Scale<T>].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.degree(ScaleDegree.ii.lowered) == Note.d.flat
  /// Note.c.minor.scale.degree(ScaleDegree.v) == Note.g
  /// Note.a.flat.major.scale.degree(ScaleDegree.vi) == Note.f
  /// ```
  T degree(ScaleDegree scaleDegree) {
    final scalable = degrees[scaleDegree.ordinal - 1];
    if (scaleDegree.semitonesDelta == 0) return scalable;

    return scalable.transposeBy(
      Interval.perfect(
        1,
        PerfectQuality(scaleDegree.semitonesDelta.abs()),
      ).descending(isDescending: scaleDegree.semitonesDelta.isNegative),
    );
  }

  /// Returns the [Chord<T>] for the [scaleDegree] of this [Scale<T>].
  ///
  /// Example:
  /// ```dart
  /// Note.g.major.scale.degreeChord(ScaleDegree.vi) == Note.b.minorTriad
  /// Note.d.minor.scale.degreeChord(ScaleDegree.ii) == Note.d.diminishedTriad
  /// ```
  Chord<T> degreeChord(ScaleDegree scaleDegree) =>
      pattern.degreePattern(scaleDegree).on(degree(scaleDegree));

  /// Returns the [Chord<T>] for the [harmonicFunction] of this [Scale<T>].
  ///
  /// Example:
  /// ```dart
  /// Note.g.major.scale.functionChord(ScaleDegree.v / ScaleDegree.v)
  ///   == Note.a.majorTriad
  /// Note.b.flat.minor.scale.functionChord(ScaleDegree.ii / ScaleDegree.v)
  ///   == Note.g.minorTriad
  /// ```
  Chord<T> functionChord(HarmonicFunction harmonicFunction) =>
      harmonicFunction.scaleDegrees
          .skip(1)
          .toList()
          .reversed
          .fold(
            this,
            (scale, scaleDegree) => ScalePattern.fromChordPattern(
              scale.pattern.degreePattern(scaleDegree),
            ).on(scale.degree(scaleDegree)),
          )
          .degreeChord(harmonicFunction.scaleDegrees.first);

  /// Returns this [Scale<T>] transposed by [interval].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.transposeBy(Interval.m3) == Note.e.flat.major.scale
  /// ```
  @override
  Scale<T> transposeBy(Interval interval) => Scale(
        degrees.transposeBy(interval),
        _descendingDegrees?.transposeBy(interval),
      );

  @override
  String toString() => '${degrees.first} ${pattern.name} (${degrees.join(' ')}'
      '${_descendingDegrees != null ? ', '
          '${_descendingDegrees!.join(' ')}' : ''})';

  @override
  bool operator ==(Object other) =>
      other is Scale<T> &&
      ListEquality<T>().equals(degrees, other.degrees) &&
      ListEquality<T>().equals(_descendingDegrees, other._descendingDegrees);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(degrees),
        _descendingDegrees != null ? Object.hashAll(_descendingDegrees!) : null,
      );
}

extension<T extends Scalable<T>> on List<T> {
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
