part of '../../music_notes.dart';

class HarmonicFunction {
  final List<ScaleDegree> scaleDegrees;

  /// Creates a new [HarmonicFunction] from [scaleDegrees].
  const HarmonicFunction(this.scaleDegrees);

  static const tonic = HarmonicFunction([ScaleDegree.i]);
  static const ii = HarmonicFunction([ScaleDegree.ii]);
  static const neapolitanSixth =
      HarmonicFunction([ScaleDegree.neapolitanSixth]);
  static const iii = HarmonicFunction([ScaleDegree.iii]);
  static const iv = HarmonicFunction([ScaleDegree.iv]);
  static const dominantV =
      HarmonicFunction([ScaleDegree(5, quality: ImperfectQuality.major)]);
  static const vi = HarmonicFunction([ScaleDegree.vi]);
  static const vii = HarmonicFunction([ScaleDegree.vii]);

  @override
  String toString() => scaleDegrees.join('/');

  /// Returns the [HarmonicFunction] relating this [HarmonicFunction] to
  /// [harmonicFunction].
  ///
  /// Example:
  /// ```dart
  /// HarmonicFunction.dominant /
  ///   HarmonicFunction.dominant /
  ///   HarmonicFunction.dominant
  ///   == HarmonicFunction([
  ///        ScaleDegree.v.major, ScaleDegree.v.major, ScaleDegree.v.major,
  ///      ])
  /// ```
  HarmonicFunction operator /(HarmonicFunction harmonicFunction) =>
      HarmonicFunction([...scaleDegrees, ...harmonicFunction.scaleDegrees]);
}
