import 'package:music_notes/music_notes.dart';
import 'package:music_notes/utils.dart';

/// A general Meantone temperament tuning system.
/// Can handle any fraction of the syntonic comma (m/n).
class Meantone extends JustIntonation {
  /// The comma ratio.
  final Rational rational;

  /// Creates a new [Meantone] tuning system.
  const Meantone(this.rational, {super.fork = .c256});

  /// Meantone tuning with fifth-comma temperament (1/5).
  static const fifth = Meantone(Rational(1, 5));

  /// Meantone tuning with two-sevenths-comma temperament (2/7).
  static const twoSevenths = Meantone(Rational(2, 7));

  /// Meantone tuning with quarter-comma temperament (1/4).
  static const quarter = Meantone(Rational(1, 4));

  /// Meantone tuning with third-comma temperament (1/3).
  static const third = Meantone(Rational(1, 3));

  /// Meantone tuning with half-comma temperament (1/2).
  static const half = Meantone(Rational(1, 2));

  /// Return the cents offset relative to equal temperament
  num centsOffset(Pitch pitch) {
    final equalCents =
        fork.pitch.interval(pitch).semitones * Cent.divisionsPerSemitone;
    final actualCents = Cent.fromRatio(ratio(pitch)).value;

    return actualCents - equalCents;
  }

  /// Fifth adjustment in cents: -(m / n) * comma
  double get _perFifthAdjustment =>
      -JustIntonation.syntonicComma * rational.toDouble();

  @override
  num ratio(Pitch pitch) => Cent(
    fork.pitch.note.fifthsDistanceWith(pitch.note) *
        (JustIntonation.generatorCents + _perFifthAdjustment),
  ).ratio;

  @override
  Cent get generator => .fromRatio(ratio(fork.pitch.transposeBy(.P5)));
}
