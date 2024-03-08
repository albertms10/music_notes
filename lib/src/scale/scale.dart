import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../class_mixin.dart';
import '../harmony/chord.dart';
import '../harmony/harmonic_function.dart';
import '../interval/interval.dart';
import '../interval/quality.dart';
import '../interval/size.dart';
import '../scalable.dart';
import '../transposable.dart';
import 'scale_degree.dart';
import 'scale_pattern.dart';

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
  final List<T> _degrees;

  /// The [Scalable] degrees that define this [Scale].
  List<T> get degrees => UnmodifiableListView(_degrees);

  /// The descending [Scalable] degrees that define this [Scale].
  /// If null, the result is the same as calling `_degrees.reversed`.
  final List<T>? _descendingDegrees;

  /// The descending [Scalable] degrees that define this [Scale].
  List<T> get descendingDegrees =>
      UnmodifiableListView(_descendingDegrees ?? _degrees.reversed);

  /// Creates a new [Scale] instance from [_degrees] and optional
  /// [_descendingDegrees].
  const Scale(this._degrees, [this._descendingDegrees]);

  /// The length of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.minorPentatonic.on(Note.f).length == 5
  /// ScalePattern.major.on(Note.e).length == 7
  /// ScalePattern.octatonic.on(Note.d.flat).length == 8
  /// ScalePattern.chromatic.on(Note.c).length == 12
  /// ```
  int get length => _degrees.length - 1;

  /// The [ScalePattern] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// const Scale([Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///   Note.c]) == ScalePattern.major
  /// ```
  ScalePattern get pattern => ScalePattern(
        _degrees.intervalSteps.toList(),
        _descendingDegrees?.descendingIntervalSteps.toList(),
      );

  /// The reversed of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.aeolian.on(Note.a).reversed
  ///   == Scale([Note.a, Note.g, Note.f, Note.e, Note.d, Note.c, Note.b,
  ///        Note.a])
  /// ```
  Scale<T> get reversed =>
      Scale(descendingDegrees, _descendingDegrees != null ? _degrees : null);

  /// The [Chord] for each [ScaleDegree] of this [Scale].
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
  List<Chord<T>> get degreeChords => [
        for (var i = 1; i < _degrees.length; i++) degreeChord(ScaleDegree(i)),
      ];

  /// The [T] for the [scaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.degree(ScaleDegree.ii.lowered) == Note.d.flat
  /// Note.c.minor.scale.degree(ScaleDegree.v) == Note.g
  /// Note.a.flat.major.scale.degree(ScaleDegree.vi) == Note.f
  /// ```
  T degree(ScaleDegree scaleDegree) {
    final scalable = _degrees[scaleDegree.ordinal - 1];
    if (scaleDegree.semitonesDelta == 0) return scalable;

    return scalable.transposeBy(
      Interval.perfect(
        Size.unison,
        PerfectQuality(scaleDegree.semitonesDelta.abs()),
      ).descending(isDescending: scaleDegree.semitonesDelta.isNegative),
    );
  }

  /// The [Chord] for the [scaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.g.major.scale.degreeChord(ScaleDegree.vi) == Note.b.minorTriad
  /// Note.d.minor.scale.degreeChord(ScaleDegree.ii) == Note.d.diminishedTriad
  /// ```
  Chord<T> degreeChord(ScaleDegree scaleDegree) =>
      pattern.degreePattern(scaleDegree).on(degree(scaleDegree));

  /// The [Chord] for the [harmonicFunction] of this [Scale].
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

  /// Whether this [Scale] is enharmonically equivalent to [other].
  ///
  /// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence).
  ///
  /// Example:
  /// ```dart
  /// const Scale([Note.c, Note.d, Note.f, Note.g])
  ///   .isEnharmonicWith(Scale([Note.b.sharp, Note.d, Note.e.sharp, Note.g]))
  ///     == true
  /// ```
  bool isEnharmonicWith(Scale<T> other) =>
      _degrees.isEnharmonicWith(other._degrees) &&
      (_descendingDegrees ?? const [])
          .isEnharmonicWith(other._descendingDegrees ?? const []);

  /// Transposes this [Scale] by [interval].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.transposeBy(Interval.m3) == Note.e.flat.major.scale
  /// Note.f.sharp.minor.scale.transposeBy(-Interval.A4) == Note.c.minor.scale
  /// ```
  @override
  Scale<T> transposeBy(Interval interval) => Scale(
        _degrees.transposeBy(interval).toList(),
        _descendingDegrees?.transposeBy(interval).toList(),
      );

  @override
  String toString() =>
      '${_degrees.first} ${pattern.name} (${_degrees.join(' ')}'
      '${_descendingDegrees != null ? ', '
          '${_descendingDegrees.join(' ')}' : ''})';

  @override
  bool operator ==(Object other) =>
      other is Scale<T> &&
      ListEquality<T>().equals(_degrees, other._degrees) &&
      ListEquality<T>().equals(_descendingDegrees, other._descendingDegrees);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(_degrees),
        _descendingDegrees != null ? Object.hashAll(_descendingDegrees) : null,
      );
}
