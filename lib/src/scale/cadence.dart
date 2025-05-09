import 'package:meta/meta.dart' show immutable;

import '../interval/quality.dart';
import '../key/mode.dart';
import 'scale_degree.dart';

/// See [Cadence](https://en.wikipedia.org/wiki/Cadence).
@immutable
abstract class Cadence {
  /// Creates a new [Cadence].
  const Cadence();

  /// The [PerfectCadence].
  static const perfect = PerfectCadence();

  /// The [ImperfectCadence].
  static const imperfect = ImperfectCadence();

  /// The [PhrygianCadence].
  static const phrygian = PhrygianCadence();

  /// The [LydianCadence].
  static const lydian = LydianCadence();

  /// The [PlagalCadence].
  static const plagal = PlagalCadence();

  /// The [InterruptedCadence].
  static const interrupted = InterruptedCadence();

  static const chain = [
    PerfectCadence.new,
    PhrygianCadence.new,
    LydianCadence.new,
    ImperfectCadence.new,
    PlagalCadence.new,
    InterruptedCadence.new,
  ];

  /// Returns whether [sequence] conforms this [Cadence].
  bool check(List<ScaleDegree> sequence, {TonalMode mode = TonalMode.major});
}

/// Dominant to tonic, also known as authentic cadence.
/// E.g., [ScaleDegree.v] → [ScaleDegree.i].
class PerfectCadence extends Cadence {
  /// Creates a new [PerfectCadence].
  const PerfectCadence();

  @override
  bool check(List<ScaleDegree> sequence, {TonalMode mode = TonalMode.major}) =>
      switch ((sequence[sequence.length - 2], sequence.last)) {
        (
          ScaleDegree(ordinal: 5 || 7, :final quality),
          ScaleDegree(ordinal: 1)
        ) =>
          switch (mode) {
            TonalMode.major
                when quality == null || quality == ImperfectQuality.major =>
              true,
            TonalMode.minor when quality == ImperfectQuality.major => true,
            _ => false,
          },
        _ => false
      };
}

/// Leading to dominant, also known as half cadence.
/// E.g., [ScaleDegree.i] → [ScaleDegree.v].
class ImperfectCadence extends Cadence {
  /// Creates a new [ImperfectCadence].
  const ImperfectCadence();

  @override
  bool check(List<ScaleDegree> sequence, {TonalMode mode = TonalMode.major}) =>
      switch ((sequence[sequence.length - 2], sequence.last)) {
        (
          ScaleDegree(ordinal: 1 || 2 || 4 || 6),
          ScaleDegree(ordinal: 5, :final quality),
        ) =>
          switch (mode) {
            TonalMode.major
                when quality == null || quality == ImperfectQuality.major =>
              true,
            TonalMode.minor when quality == ImperfectQuality.major => true,
            _ => false,
          },
        _ => false,
      };
}

/// E.g., [ScaleDegree.vi] → [ScaleDegree.v].
class PhrygianCadence extends ImperfectCadence {
  /// Creates a new [PhrygianCadence].
  const PhrygianCadence();
}

/// See [Lydian cadence](https://en.wikipedia.org/wiki/Lydian_cadence).
///
/// ![Lydian cadence](https://upload.wikimedia.org/wikipedia/commons/5/5e/Lydian_cadence.png)
class LydianCadence extends ImperfectCadence {
  /// Creates a new [LydianCadence].
  const LydianCadence();
}

/// Subdominant to tonic. E.g., [ScaleDegree.iv] → [ScaleDegree.i].
class PlagalCadence extends Cadence {
  /// Creates a new [PlagalCadence].
  const PlagalCadence();
}

/// Dominant to submediant, also known as deceptive cadence.
/// E.g., [ScaleDegree.v] → [ScaleDegree.vi].
class InterruptedCadence extends Cadence {
  /// Creates a new [InterruptedCadence].
  const InterruptedCadence();
}
