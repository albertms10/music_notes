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

  /// Returns a new [HarmonicFunction] relating this [HarmonicFunction] to
  /// [other].
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
