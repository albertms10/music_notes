import 'package:music_notes/music_notes.dart';

/// See [Cadence](https://en.wikipedia.org/wiki/Cadence).
enum Cadence {
  /// Dominant to tonic, also known as authentic cadence.
  /// E.g., [ScaleDegree.v] → [ScaleDegree.i].
  perfect,

  /// Leading to dominant, also known as half cadence.
  /// E.g., [ScaleDegree.i] → [ScaleDegree.v].
  imperfect,

  /// Subdominant to tonic. E.g., [ScaleDegree.iv] → [ScaleDegree.i].
  plagal,

  /// Dominant to submediant, also known as deceptive cadence.
  /// E.g., [ScaleDegree.v] → [ScaleDegree.vi].
  interrupted;

  /// Returns the associated [Cadence] for the given [from] and [to] sequence.
  ///
  /// Example:
  /// ```dart
  /// Cadence.fromScaleDegrees(from: ScaleDegree.v, to: ScaleDegree.i)
  ///   == Cadence.perfect
  /// Cadence.fromScaleDegrees(from: ScaleDegree.ii, to: ScaleDegree.iv) == null
  /// ```
  static Cadence? fromScaleDegrees({
    required ScaleDegree from,
    required ScaleDegree to,
  }) =>
      switch ((from, to)) {
        (
          ScaleDegree(ordinal: 5, quality: ImperfectQuality.major),
          ScaleDegree.i
        ) =>
          perfect,
        (
          ScaleDegree(ordinal: 1 || 2 || 4 || 6),
          ScaleDegree(ordinal: 5, quality: ImperfectQuality.major)
        ) =>
          imperfect,
        (ScaleDegree(ordinal: 2 || 4), ScaleDegree.i) => plagal,
        (
          ScaleDegree(ordinal: 5, quality: ImperfectQuality.major),
          ScaleDegree(ordinal: 6)
        ) =>
          interrupted,
        _ => null,
      };
}
