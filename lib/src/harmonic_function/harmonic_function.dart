import 'package:meta/meta.dart' show immutable;

import '../notation_system/notation_system.dart';
import '../scale/scale.dart';
import '../scale_degree/scale_degree.dart';

/// A harmonic function.
///
/// ---
/// See also:
/// * [Scale].
/// * [ScaleDegree].
@immutable
class HarmonicFunction implements Formattable<HarmonicFunction> {
  /// The [ScaleDegree] of this [HarmonicFunction].
  final ScaleDegree scaleDegree;

  /// The tonicization of this [HarmonicFunction].
  ///
  /// See [Tonicization](https://en.wikipedia.org/wiki/Tonicization).
  final HarmonicFunction? tonicization;

  /// Creates a new [HarmonicFunction] from [scaleDegree] and [tonicization].
  const HarmonicFunction(this.scaleDegree, {this.tonicization});

  /// A I (tonic) degree [HarmonicFunction].
  static const i = HarmonicFunction(.i);

  /// A II degree [HarmonicFunction].
  static const ii = HarmonicFunction(.ii);

  /// A neapolitan sixth [HarmonicFunction].
  static const neapolitanSixth = HarmonicFunction(.neapolitanSixth);

  /// A III degree [HarmonicFunction].
  static const iii = HarmonicFunction(.iii);

  /// A IV degree [HarmonicFunction].
  static const iv = HarmonicFunction(.iv);

  /// A dominant V degree [HarmonicFunction].
  static const dominantV = HarmonicFunction(ScaleDegree(5, quality: .major));

  /// A VI degree [HarmonicFunction].
  static const vi = HarmonicFunction(.vi);

  /// A VII degree [HarmonicFunction].
  static const vii = HarmonicFunction(.vii);

  /// Appends [harmonicFunction] as the [tonicization] of this
  /// [HarmonicFunction].
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.v.on(.ii) == HarmonicFunction(.v, tonicization: .ii)
  /// ```
  HarmonicFunction on(HarmonicFunction harmonicFunction) => tonicization == null
      ? copyWith(tonicization: harmonicFunction)
      : copyWith(tonicization: tonicization!.on(harmonicFunction));

  /// Creates a new [HarmonicFunction] from this one by updating individual
  /// properties.
  HarmonicFunction copyWith({
    ScaleDegree? scaleDegree,
    HarmonicFunction? tonicization,
  }) => HarmonicFunction(
    scaleDegree ?? this.scaleDegree,
    tonicization: tonicization ?? this.tonicization,
  );

  /// The string representation of this [HarmonicFunction].
  ///
  /// Example:
  /// ```dart
  /// (HarmonicFunction.ii / .dominantV).format() == 'II/V'
  /// (HarmonicFunction.neapolitanSixth / .iv).format() == '♭II6/IV'
  /// ```
  @override
  String format() =>
      '${scaleDegree.format()}'
      '${tonicization == null ? '' : '/${tonicization?.format()}'}';

  @override
  String toString() =>
      '$runtimeType(scaleDegree: $scaleDegree, tonicization: $tonicization)';

  /// Appends [harmonicFunction] as the [harmonicFunction] of this
  /// [HarmonicFunction].
  ///
  /// Alias of [on].
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.dominantV / .dominantV / .dominantV
  ///   == HarmonicFunction([.v.major, .v.major, .v.major])
  /// ```
  HarmonicFunction operator /(HarmonicFunction harmonicFunction) =>
      on(harmonicFunction);

  @override
  bool operator ==(Object other) =>
      other is HarmonicFunction &&
      scaleDegree == other.scaleDegree &&
      tonicization == other.tonicization;

  @override
  int get hashCode => Object.hash(scaleDegree, tonicization);
}
