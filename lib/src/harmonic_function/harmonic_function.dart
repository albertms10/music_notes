import 'package:meta/meta.dart' show immutable;

import '../accidental/accidental.dart';
import '../accidental/symbol_accidental_notation.dart';
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

  /// The chromatic alteration of this this [ScaleDegree].
  final Accidental accidental;

  /// The tonicization of this [HarmonicFunction].
  ///
  /// See [Tonicization](https://en.wikipedia.org/wiki/Tonicization).
  final HarmonicFunction? tonicization;

  /// Creates a new [HarmonicFunction] from [scaleDegree] and [tonicization].
  const HarmonicFunction(
    this.scaleDegree, {
    this.accidental = .natural,
    this.tonicization,
  });

  /// A I (tonic) degree [HarmonicFunction].
  static const i = HarmonicFunction(.i);

  /// A II degree [HarmonicFunction].
  static const ii = HarmonicFunction(.ii);

  /// A neapolitan sixth [HarmonicFunction].
  static const neapolitanSixth = HarmonicFunction(
    ScaleDegree(2, quality: .major, inversion: 1),
    accidental: .flat,
  );

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

  /// Whether this [HarmonicFunction] is raised.
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.ii.raised.isRaised == true
  /// HarmonicFunction.neapolitanSixth.isRaised == false
  /// ```
  bool get isRaised => accidental.isSharp;

  /// Whether this [HarmonicFunction] is lowered.
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.vi.isLowered == false
  /// HarmonicFunction.neapolitanSixth.isLowered == true
  /// ```
  // using < 0 instead of isNegative to avoid -0 being treated as negative
  bool get isLowered => accidental.isFlat;

  /// This [HarmonicFunction] raised by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.vi.raised
  ///   == const HarmonicFunction(.iv, accidental: .sharp)
  /// ```
  HarmonicFunction get raised => copyWith(accidental: accidental + 1);

  /// This [HarmonicFunction] lowered by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.ii.lowered
  ///   == const HarmonicFunction(.ii, accidental: .flat)
  /// ```
  HarmonicFunction get lowered => copyWith(accidental: accidental - 1);

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
    Accidental? accidental,
    HarmonicFunction? tonicization,
  }) => HarmonicFunction(
    scaleDegree ?? this.scaleDegree,
    accidental: accidental ?? this.accidental,
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
      '${accidental.format(const SymbolAccidentalNotation(showNatural: false))}'
      '${scaleDegree.format()}'
      '${tonicization == null ? '' : '/${tonicization?.format()}'}';

  @override
  String toString() =>
      '$runtimeType(scaleDegree: $scaleDegree, accidental: $accidental, '
      'tonicization: $tonicization)';

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
