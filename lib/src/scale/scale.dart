import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../chord/chord.dart';
import '../chord_pattern/chord_pattern.dart';
import '../enharmonic.dart';
import '../harmonic_function/harmonic_function.dart';
import '../interval/interval.dart';
import '../scalable.dart';
import '../scale_degree/scale_degree.dart';
import '../scale_pattern/scale_pattern.dart';
import '../size/size.dart';
import '../transposable.dart';

/// A set of musical notes ordered by fundamental frequency or pitch.
///
/// See [Scale (music)](https://en.wikipedia.org/wiki/Scale_(music)).
///
/// ---
/// See also:
/// * [ScalePattern].
/// * [ScaleDegree].
@immutable
final class Scale<T extends Scalable<T>> implements Transposable<Scale<T>> {
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
  /// const Scale<Note>([.c, .d, .e, .f, .g, .a, .b, .c]) == .major
  /// ```
  ScalePattern get pattern => ScalePattern(
    _degrees.intervalSteps.toList(growable: false),
    _descendingDegrees?.descendingIntervalSteps.toList(growable: false),
  );

  /// The reversed of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.aeolian.on(Note.a).reversed
  ///   == Scale<Note>([.a, .g, .f, .e, .d, .c, .b, .a])
  /// ```
  Scale<T> get reversed =>
      Scale(descendingDegrees, _descendingDegrees != null ? _degrees : null);

  /// The [Chord] for each [ScaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.a.major.scale.degreeChords() == [
  ///   Note.a.majorTriad,
  ///   Note.b.minorTriad,
  ///   Note.c.sharp.minorTriad,
  ///   Note.d.majorTriad,
  ///   Note.e.majorTriad,
  ///   Note.f.sharp.minorTriad,
  ///   Note.g.sharp.diminishedTriad,
  /// ]
  /// ```
  List<Chord<T>> degreeChords({Set<Size> shape = Size.triad}) => [
    for (var i = 1; i < _degrees.length; i++)
      degreeChord(ScaleDegree(i), shape: shape),
  ];

  /// The [T] for the [scaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.degree(.ii.lowered) == .d.flat
  /// Note.c.minor.scale.degree(.v) == .g
  /// Note.a.flat.major.scale.degree(.vi) == .f
  /// ```
  T degree(ScaleDegree scaleDegree) {
    final ScaleDegree(:ordinal, :accidental) = scaleDegree;
    final scalable = _degrees[ordinal - 1];
    if (accidental.isNatural) return scalable;

    return scalable.transposeBy(
      .perfect(
        .unison,
        .new(accidental.semitones.abs()),
      ).withDescending(accidental.isFlat),
    );
  }

  /// The [Chord] for the [scaleDegree] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.g.major.scale.degreeChord(.vi) == Note.b.minorTriad
  /// Note.d.minor.scale.degreeChord(.ii) == Note.d.diminishedTriad
  /// Note.c.major.scale.degreeChord(.ii.lowered) == Note.d.flat.majorTriad
  /// ```
  Chord<T> degreeChord(
    ScaleDegree scaleDegree, {
    Set<Size> shape = Size.triad,
  }) =>
      // TODO(albertms10): find a better way of handling altered scale degrees.
      (scaleDegree.isLowered
              ? ChordPattern.majorTriad
              : pattern.degreePattern(scaleDegree, shape: shape))
          .on(degree(scaleDegree));

  /// The [Chord] for the [harmonicFunction] of this [Scale].
  ///
  /// Example:
  /// ```dart
  /// Note.g.major.scale.functionChord(HarmonicFunction.dominantV / .dominantV)
  ///   == Note.a.majorTriad
  /// Note.b.flat.minor.scale.functionChord(HarmonicFunction.ii / .dominantV)
  ///   == Note.g.minorTriad
  /// ```
  Chord<T> functionChord(HarmonicFunction harmonicFunction) => scaleOf(
    harmonicFunction.tonicization,
  ).degreeChord(harmonicFunction.scaleDegree);

  /// Returns the tonal scale established by [harmonicFunction] relative to this
  /// [Scale].
  ///
  /// The tonicization chain is resolved recursively, with each harmonic
  /// function establishing a new tonal context from its
  /// [HarmonicFunction.scaleDegree].
  /// If [harmonicFunction] is `null`, this scale is returned unchanged.
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.scaleOf(.v) == Note.g.major.scale
  /// Note.f.minor.scale.scaleOf(.iii) == Note.a.flat.major.scale
  /// ```
  Scale<T> scaleOf(HarmonicFunction? harmonicFunction) {
    if (harmonicFunction == null) return this;

    final HarmonicFunction(:scaleDegree, :pattern, :tonicization) =
        harmonicFunction;
    final scale = scaleOf(tonicization);

    return ScalePattern.fromChordPattern(
      pattern ?? scale.pattern.degreePattern(scaleDegree),
    ).on(scale.degree(scaleDegree));
  }

  /// Whether this [Scale] is enharmonically equivalent to [other].
  ///
  /// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence).
  ///
  /// Example:
  /// ```dart
  /// const Scale<Note>([.c, .d, .f, .g])
  ///   .isEnharmonicWith(Scale<Note>([.b.sharp, .d, .e.sharp, .g])) == true
  /// ```
  bool isEnharmonicWith(Scale<T> other) =>
      _degrees.isEnharmonicWith(other._degrees) &&
      (_descendingDegrees ?? const []).isEnharmonicWith(
        other._descendingDegrees ?? const [],
      );

  /// Transposes this [Scale] by [interval].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale.transposeBy(.m3) == Note.e.flat.major.scale
  /// Note.f.sharp.minor.scale.transposeBy(-Interval.A4) == Note.c.minor.scale
  /// ```
  @override
  Scale<T> transposeBy(Interval interval) => Scale(
    _degrees.transposeBy(interval).toList(growable: false),
    _descendingDegrees?.transposeBy(interval).toList(growable: false),
  );

  @override
  String toString() {
    final scale = _degrees.map((s) => s.format()).join(' ');
    final descendingScale = _descendingDegrees != null
        ? ', ${_descendingDegrees.map((s) => s.format()).join(' ')}'
        : '';

    return '${_degrees.first.format()} ${pattern.name} '
        '($scale$descendingScale)';
  }

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
