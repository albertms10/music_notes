part of '../../music_notes.dart';

/// A set of musical notes ordered by fundamental frequency or pitch.
///
/// See [Scale (music)](https://en.wikipedia.org/wiki/Scale_(music)).
///
/// ---
/// See also:
/// * [ScalePattern].
/// * [ScaleDegree].
@immutable
class Scale<T extends Scalable<T>> implements Transposable<Scale<T>> {
  /// The [Scalable] degrees that define this [Scale].
  final List<T> degrees;

  /// The descending [Scalable] degrees that define this [Scale] (if different).
  final List<T>? _descendingDegrees;

  /// Creates a new [Scale] instance from [degrees].
  const Scale(this.degrees, [this._descendingDegrees]);

  /// The descending [Scalable] degrees that define this [Scale].
  List<T> get descendingDegrees =>
      _descendingDegrees ?? degrees.reversed.toList();

  /// Returns the [ScalePattern] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// const Scale([Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///   Note.c]) == ScalePattern.major
  /// ```
  ScalePattern get pattern => ScalePattern(
        degrees.intervalSteps.toList(),
        _descendingDegrees?.descendingIntervalSteps.toList(),
      );

  /// Returns the reversed of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.aeolian.on(Note.a).reversed
  ///   == Scale([Note.a, Note.g, Note.f, Note.e, Note.d, Note.c, Note.b,
  ///        Note.a])
  /// ```
  Scale<T> get reversed =>
      Scale(descendingDegrees, _descendingDegrees != null ? degrees : null);

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
      [for (var i = 1; i < degrees.length; i++) degreeChord(ScaleDegree(i))];

  /// Returns the [T] for the [scaleDegree] of this [Scale].
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
        Size.unison,
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

  /// Returns the [Chord] for the [harmonicFunction] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.g.major.scale.functionChord(
  ///   HarmonicFunction.dominantV / HarmonicFunction.dominantV,
  /// ) == Note.a.majorTriad
  /// Note.b.flat.minor.scale.functionChord(
  ///   HarmonicFunction.ii / HarmonicFunction.dominantV,
  /// ) == Note.g.minorTriad
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

  /// Returns this [Scale] transposed by [interval].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.transposeBy(Interval.m3) == Note.e.flat.major.scale
  /// Note.f.sharp.minor.scale.transposeBy(-Interval.A4) == Note.c.minor.scale
  /// ```
  @override
  Scale<T> transposeBy(Interval interval) => Scale(
        degrees.transposeBy(interval).toList(),
        _descendingDegrees?.transposeBy(interval).toList(),
      );

  @override
  String toString() => '${degrees.first} ${pattern.name} (${degrees.join(' ')}'
      '${_descendingDegrees != null ? ', '
          '${_descendingDegrees.join(' ')}' : ''})';

  @override
  bool operator ==(Object other) =>
      other is Scale<T> &&
      ListEquality<T>().equals(degrees, other.degrees) &&
      ListEquality<T>().equals(_descendingDegrees, other._descendingDegrees);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(degrees),
        _descendingDegrees != null ? Object.hashAll(_descendingDegrees) : null,
      );
}
