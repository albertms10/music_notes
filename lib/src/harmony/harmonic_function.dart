import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

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
  static const i = HarmonicFunction([.i]);

  /// A II degree [HarmonicFunction].
  static const ii = HarmonicFunction([.ii]);

  /// A neapolitan sixth [HarmonicFunction].
  static const neapolitanSixth = HarmonicFunction([.neapolitanSixth]);

  /// A III degree [HarmonicFunction].
  static const iii = HarmonicFunction([.iii]);

  /// A IV degree [HarmonicFunction].
  static const iv = HarmonicFunction([.iv]);

  /// A dominant V degree [HarmonicFunction].
  static const dominantV = HarmonicFunction([ScaleDegree(5, quality: .major)]);

  /// A VI degree [HarmonicFunction].
  static const vi = HarmonicFunction([.vi]);

  /// A VII degree [HarmonicFunction].
  static const vii = HarmonicFunction([.vii]);

  /// The string representation of this [HarmonicFunction].
  ///
  /// Example:
  /// ```dart
  /// (HarmonicFunction.ii / .dominantV).toString() == 'II/V'
  /// (HarmonicFunction.neapolitanSixth / .iv).toString()
  ///   == '♭II6/IV'
  /// ```
  @override
  String toString() => _scaleDegrees.join('/');

  /// Returns a new [HarmonicFunction] relating this [HarmonicFunction] to
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.dominantV / .dominantV / .dominantV
  ///   == HarmonicFunction([.v.major, .v.major, .v.major])
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
