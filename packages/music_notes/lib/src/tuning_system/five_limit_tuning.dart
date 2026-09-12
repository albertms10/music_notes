import 'package:music_notes/utils.dart';

import '../note/note.dart';
import '../pitch/pitch.dart';
import 'just_intonation.dart';

/// A representation of the five-limit tuning system.
///
/// Unlike [JustIntonation]’s default single-generator chain of fifths (used
/// by e.g. `PythagoreanTuning`), five-limit tuning builds each pitch class
/// from products of the ascending fifth (3/2) *and* the ascending major
/// third (5/4) (e.g., ratios whose prime factors are limited to 2, 3, and
/// 5), following the classic Ptolemaic/just intonation diatonic and
/// chromatic scale.
///
/// Because the number of fifths and thirds needed to reach a given note is
/// not derivable from [NoteCircleOfFifths.fifthsDistanceWith] alone
/// (e.g. E is a single ascending major third from C, not four ascending
/// fifths), this tuning system is defined via an explicit lookup table for the
/// 12 standard chromatic notes rather than a generic chain-building algorithm.
///
/// Enharmonically-equivalent spellings intentionally have different
/// ratios (e.g., C♯ (135/128) and D♭ (16/15)), reflecting the fact that,
/// unlike in 12-tone equal temperament, they are not the same pitch in a
/// just intonation system.
///
/// See [Five-limit tuning](https://en.wikipedia.org/wiki/Five-limit_tuning).
class FiveLimitTuning extends JustIntonation {
  /// Creates a new [FiveLimitTuning] from [fork].
  const FiveLimitTuning({super.fork});

  /// The 5-limit ratio (relative to [Note.c]) of each of the 12 standard
  /// chromatic notes, expressed as products of the ascending fifth (3/2)
  /// and ascending major third (5/4).
  static final pitchClassRatios = <Note, Rational>{
    .c: const Rational(1),
    .c.sharp: const Rational(135, 128),
    .d.flat: const Rational(16, 15),
    .d: const Rational(9, 8),
    .d.sharp: const Rational(75, 64),
    .e.flat: const Rational(6, 5),
    .e: const Rational(5, 4),
    .f: const Rational(4, 3),
    .f.sharp: const Rational(45, 32),
    .g.flat: const Rational(64, 45),
    .g: const Rational(3, 2),
    .g.sharp: const Rational(25, 16),
    .a.flat: const Rational(8, 5),
    .a: const Rational(5, 3),
    .a.sharp: const Rational(225, 128),
    .b.flat: const Rational(16, 9),
    .b: const Rational(15, 8),
  };

  @override
  num ratio(Pitch pitch) {
    final pitchClassRatio =
        pitchClassRatios[pitch.note] ??
        (throw UnsupportedError(
          'FiveLimitTuning does not define a ratio for ${pitch.note}. '
          'Only the 12 standard chromatic notes (natural notes and single '
          'sharps/flats) are supported.',
        ));

    return octaveAdjustedRatio(pitch, pitchClassRatio.toDouble());
  }
}
