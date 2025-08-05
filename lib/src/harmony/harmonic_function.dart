import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../interval/quality.dart';
import '../scale/scale.dart';
import '../scale/scale_degree.dart';

/// A harmonic function.
///
/// ---
/// See also:
/// * [Scale].
/// * [ScaleDegree].
@immutable
class HarmonicFunction {
  final List<ScaleDegree> _scaleDegrees;

  /// The scale degrees that define this [HarmonicFunction].
  List<ScaleDegree> get scaleDegrees => UnmodifiableListView(_scaleDegrees);

  /// Creates a new [HarmonicFunction] from [_scaleDegrees].
  const HarmonicFunction(this._scaleDegrees);

  /// A I (tonic) degree [HarmonicFunction].
  static const i = HarmonicFunction([ScaleDegree.i]);

  /// A II degree [HarmonicFunction].
  static const ii = HarmonicFunction([ScaleDegree.ii]);

  /// A neapolitan sixth [HarmonicFunction].
  static const neapolitanSixth = HarmonicFunction([
    ScaleDegree.neapolitanSixth,
  ]);

  /// A III degree [HarmonicFunction].
  static const iii = HarmonicFunction([ScaleDegree.iii]);

  /// A IV degree [HarmonicFunction].
  static const iv = HarmonicFunction([ScaleDegree.iv]);

  /// A dominant V degree [HarmonicFunction].
  static const dominantV = HarmonicFunction([
    ScaleDegree(5, quality: ImperfectQuality.major),
  ]);

  /// A VI degree [HarmonicFunction].
  static const vi = HarmonicFunction([ScaleDegree.vi]);

  /// A VII degree [HarmonicFunction].
  static const vii = HarmonicFunction([ScaleDegree.vii]);

  /// The string representation of this [HarmonicFunction] based on [formatter].
  ///
  /// See [ScaleDegreeNotation] for all formatter implementations.
  ///
  /// Example:
  /// ```dart
  /// (HarmonicFunction.ii / HarmonicFunction.dominantV).toString() == 'II/V'
  /// (HarmonicFunction.neapolitanSixth / HarmonicFunction.iv).toString()
  ///   == '♭II6/IV'
  /// ```
  @override
  String toString({
    ScaleDegreeNotation formatter = ScaleDegreeNotation.standard,
  }) => _scaleDegrees
      .map((scaleDegree) => scaleDegree.toString(formatter: formatter))
      .join('/');

  /// Returns a new [HarmonicFunction] relating this [HarmonicFunction] to
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.dominantV /
  ///   HarmonicFunction.dominantV /
  ///   HarmonicFunction.dominantV
  ///   == HarmonicFunction([
  ///        ScaleDegree.v.major, ScaleDegree.v.major, ScaleDegree.v.major,
  ///      ])
  /// ```
  HarmonicFunction operator /(HarmonicFunction other) =>
      HarmonicFunction([..._scaleDegrees, ...other._scaleDegrees]);

  @override
  bool operator ==(Object other) =>
      other is HarmonicFunction &&
      const ListEquality<ScaleDegree>().equals(
        _scaleDegrees,
        other._scaleDegrees,
      );

  @override
  int get hashCode => Object.hashAll(_scaleDegrees);
}
