import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/src/harmonic_function/harmonic_function_notation.dart';

import '../chord_pattern/chord_pattern.dart';
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
final class HarmonicFunction implements Formattable<HarmonicFunction> {
  /// The [ScaleDegree] of this [HarmonicFunction].
  final ScaleDegree scaleDegree;

  /// The [ChordPattern] built on top of [scaleDegree].
  final ChordPattern? pattern;

  /// The tonicization of this [HarmonicFunction].
  ///
  /// See [Tonicization](https://en.wikipedia.org/wiki/Tonicization).
  final HarmonicFunction? tonicization;

  /// Creates a new [HarmonicFunction] from [scaleDegree] and [tonicization].
  const HarmonicFunction(this.scaleDegree, {this.pattern, this.tonicization});

  /// A I (tonic) degree [HarmonicFunction].
  static const i = HarmonicFunction(.i);

  /// A II degree [HarmonicFunction].
  static const ii = HarmonicFunction(.ii);

  /// A neapolitan sixth [HarmonicFunction].
  static const neapolitanSixth = HarmonicFunction(
    ScaleDegree(2, accidental: .flat),
    pattern: .new([.m3, .m6]),
  );

  /// A III degree [HarmonicFunction].
  static const iii = HarmonicFunction(.iii);

  /// A IV degree [HarmonicFunction].
  static const iv = HarmonicFunction(.iv);

  /// A dominant V degree [HarmonicFunction].
  static const dominantV = HarmonicFunction(.v, pattern: .majorTriad);

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
    ChordPattern? pattern,
    HarmonicFunction? tonicization,
  }) => HarmonicFunction(
    scaleDegree ?? this.scaleDegree,
    pattern: pattern ?? this.pattern,
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
  String format([
    StringFormatter<HarmonicFunction> formatter =
        const HarmonicFunctionNotation(),
  ]) => formatter.format(this);

  @override
  String toString() =>
      '$runtimeType(scaleDegree: $scaleDegree, pattern: $pattern, '
      'tonicization: $tonicization)';

  /// Appends [harmonicFunction] as the [harmonicFunction] of this
  /// [HarmonicFunction].
  ///
  /// Alias of [on].
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.ii / .iv == HarmonicFunction(.ii, tonicization: .iv)
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
