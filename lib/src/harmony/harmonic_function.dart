import 'package:collection/collection.dart' show ListEquality;
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
  /// The scale degrees that define this [HarmonicFunction].
  final List<ScaleDegree> scaleDegrees;

  /// Creates a new [HarmonicFunction] from [scaleDegrees].
  const HarmonicFunction(this.scaleDegrees);

  /// A I (tonic) degree [HarmonicFunction].
  static const i = HarmonicFunction([ScaleDegree.i]);

  /// A II degree [HarmonicFunction].
  static const ii = HarmonicFunction([ScaleDegree.ii]);

  /// A neapolitan sixth [HarmonicFunction].
  static const neapolitanSixth =
      HarmonicFunction([ScaleDegree.neapolitanSixth]);

  /// A III degree [HarmonicFunction].
  static const iii = HarmonicFunction([ScaleDegree.iii]);

  /// A IV degree [HarmonicFunction].
  static const iv = HarmonicFunction([ScaleDegree.iv]);

  /// A dominant V degree [HarmonicFunction].
  static const dominantV =
      HarmonicFunction([ScaleDegree(5, quality: ImperfectQuality.major)]);

  /// A VI degree [HarmonicFunction].
  static const vi = HarmonicFunction([ScaleDegree.vi]);

  /// A VII degree [HarmonicFunction].
  static const vii = HarmonicFunction([ScaleDegree.vii]);

  @override
  String toString() => scaleDegrees.join('/');

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
      HarmonicFunction([...scaleDegrees, ...other.scaleDegrees]);

  @override
  bool operator ==(Object other) =>
      other is HarmonicFunction &&
      const ListEquality<ScaleDegree>()
          .equals(scaleDegrees, other.scaleDegrees);

  @override
  int get hashCode => Object.hashAll(scaleDegrees);
}
