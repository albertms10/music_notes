import 'package:music_notes/utils.dart';

import '../cent/cent.dart';
import '../pitch/pitch.dart';
import 'just_intonation.dart';

/// A general Meantone temperament tuning system.
/// Can handle any fraction of the syntonic comma (m/n).
class MeantoneTuning extends JustIntonation {
  /// The comma ratio.
  final Rational rational;

  /// Creates a new [MeantoneTuning] tuning system.
  const MeantoneTuning(this.rational, {super.fork = .c256});

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
      -Cent.fromRatio(JustIntonation.syntonicCommaRatio) * rational.toDouble();

  @override
  num get fifthRatio =>
      Cent(JustIntonation.generatorCents + _perFifthAdjustment).ratio;

  @override
  Cent get generator => .fromRatio(ratio(fork.pitch.transposeBy(.P5)));

  /// Return the cents offset relative to equal temperament
  num centsOffset(Pitch pitch) {
    final equalCents = Cent(
      fork.pitch.interval(pitch).semitones * Cent.divisionsPerSemitone,
    );
    final actualCents = Cent.fromRatio(ratio(pitch));

    return _normalizeCents(Cent(actualCents - equalCents));
  }

  num _normalizeCents(Cent cents) {
    var normalized = cents % Cent.octave;
    if (normalized > Cent.octave / 2) normalized -= Cent.octave;
    if (normalized < -Cent.octave / 2) normalized += Cent.octave;

    return normalized;
  }
}
