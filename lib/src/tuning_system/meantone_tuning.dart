import 'package:music_notes/utils.dart';

import '../cent/cent.dart';
import 'just_intonation.dart';

/// A general Meantone temperament tuning system.
/// Can handle any fraction of the syntonic comma (m/n).
class MeantoneTuning extends JustIntonation {
  /// The fraction of the syntonic comma tempered out of each fifth.
  final Rational commaFraction;

  /// Creates a new [MeantoneTuning] tuning system.
  const MeantoneTuning(this.commaFraction, {super.fork = .c256});

  /// Meantone tuning with fifth-comma temperament (1/5).
  static const fifth = MeantoneTuning(Rational(1, 5));

  /// Meantone tuning with two-sevenths-comma temperament (2/7).
  static const twoSevenths = MeantoneTuning(Rational(2, 7));

  /// Meantone tuning with quarter-comma temperament (1/4).
  static const quarter = MeantoneTuning(Rational(1, 4));

  /// Meantone tuning with third-comma temperament (1/3).
  static const third = MeantoneTuning(Rational(1, 3));

  /// Meantone tuning with half-comma temperament (1/2).
  static const half = MeantoneTuning(Rational(1, 2));

  /// Fifth adjustment in cents: -(m / n) * comma
  double get _perFifthAdjustment =>
      -Cent.fromRatio(JustIntonation.syntonicCommaRatio) *
      commaFraction.toDouble();

  @override
  num get fifthRatio =>
      Cent(JustIntonation.generatorCents + _perFifthAdjustment).ratio;

  @override
  Cent get generator => .fromRatio(ratio(fork.pitch.transposeBy(.P5)));
}
