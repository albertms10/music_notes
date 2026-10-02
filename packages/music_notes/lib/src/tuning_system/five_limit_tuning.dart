import '../note/note.dart';
import '../pitch/pitch.dart';
import 'just_intonation.dart';

/// A single point on the 5-limit lattice: `fifths` ascending fifths and
/// `thirds` ascending major thirds (either may be negative for the
/// descending direction), together with the pitch-class `ratio` (always
/// within `[1, 2)`) that combination produces.
///
/// `isCanonical` marks the specific path [FiveLimitTuning.ratio] actually
/// uses for a given note.
/// ---
/// See [FiveLimitTuning.pathsTo].
typedef FiveLimitPath = ({
  int fifths,
  int thirds,
  num ratio,
  bool isCanonical,
});

/// A representation of the five-limit tuning system.
///
/// Unlike [JustIntonation]’s default single-generator chain of fifths (used
/// by e.g. `PythagoreanTuning`), five-limit tuning builds each pitch class
/// from a two-dimensional lattice of ascending fifths (3/2) *and* ascending
/// major thirds (5/4) (e.g., ratios whose prime factors are limited to 2, 3,
/// and 5), following the classic Ptolemaic/just intonation diatonic and
/// chromatic scale.
///
/// A standard [Note] spelling only pins down a single coordinate: its
/// three-limit (Pythagorean) fifths distance from the fork, via
/// [NoteCircleOfFifths.fifthsDistanceWith]. Because four ascending fifths and
/// one ascending major third differ only by the
/// [JustIntonation.syntonicCommaRatio], that single fifths distance can be
/// re-expressed as *infinitely many* different (fifths, thirds)
/// coordinate pairs on the lattice, the choice of which one to use is a
/// genuine convention, not something derivable from the note name alone.
/// [pathsTo] enumerates these alternatives explicitly.
///
/// This implementation resolves the ambiguity by picking the pair with the
/// fewest remaining fifths, e.g., the number of ascending major thirds
/// nearest to `fifthsDistance / 4` (ties rounding towards zero). This
/// reproduces the conventional 12-tone “asymmetric” 5-limit scale, and
/// extends to *any* [Note], including double-sharps/flats and other spellings
/// outside the 12 standard pitch classes.
///
/// See [Five-limit tuning](https://en.wikipedia.org/wiki/Five-limit_tuning).
class FiveLimitTuning extends JustIntonation {
  /// Creates a new [FiveLimitTuning] from [fork].
  const FiveLimitTuning({super.fork});

  /// The ratio of an ascending major third.
  static const ascendingMajorThirdRatio = 5 / 4;

  @override
  num ratio(Pitch pitch) {
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);
    final thirds = _nearestThirdsCount(distance);

    return octaveAdjustedRatio(
      pitch,
      pitchClassRatioFrom(fifths: distance - 4 * thirds, thirds: thirds),
    );
  }

  /// The pitch-class ratio (within `[1, 2)`) reached by [fifths] ascending
  /// fifths and [thirds] ascending major thirds, independent of any
  /// particular [Note] spelling.
  ///
  /// This is the building block behind [ratio] and [pathsTo]: rather than
  /// resolving which (fifths, thirds) pair best represents a note, it lets
  /// you choose the lattice coordinates directly.
  num pitchClassRatioFrom({required int fifths, required int thirds}) =>
      foldIntoOctave(
        chainRatio(fifths, fifthRatio) *
            chainRatio(thirds, ascendingMajorThirdRatio),
      );

  /// Every (fifths, thirds) lattice coordinate (within [maxThirds] thirds of
  /// zero) that reaches the same pitch class as [pitch]’s note, e.g., every
  /// pair satisfying `fifths + 4 * thirds == distance`, where `distance` is
  /// [NoteCircleOfFifths.fifthsDistanceWith] the fork.
  ///
  /// Each entry’s `FiveLimitPath.ratio` is generally different: moving from
  /// one path to its neighbor (one more third, four fewer fifths) divides
  /// the ratio by exactly [JustIntonation.syntonicCommaRatio], except where
  /// that step also crosses an octave fold, which additionally doubles or
  /// halves it. The single path with `FiveLimitPath.isCanonical` set is the
  /// one [ratio] actually uses.
  ///
  /// Example:
  /// ```dart
  /// // F♯ (distance 6): the conventional path (1 third, 2 fifths, 45/32)
  /// // sits alongside its “juster” but fifths-heavier neighbor (2 thirds,
  /// // -2 fifths, 25/18).
  /// const FiveLimitTuning().pathsTo(Note.f.sharp.inOctave(4));
  /// ```
  List<FiveLimitPath> pathsTo(Pitch pitch, {int maxThirds = 3}) {
    final distance = fork.pitch.note.fifthsDistanceWith(pitch.note);
    final canonicalThirds = _nearestThirdsCount(distance);

    return [
      for (var thirds = -maxThirds; thirds <= maxThirds; thirds++)
        (
          fifths: distance - 4 * thirds,
          thirds: thirds,
          ratio: pitchClassRatioFrom(
            fifths: distance - 4 * thirds,
            thirds: thirds,
          ),
          isCanonical: thirds == canonicalThirds,
        ),
    ];
  }

  /// The number of ascending major thirds (each standing in for four
  /// ascending fifths, up to the syntonic comma) that best approximates
  /// [fifthsDistance] while minimizing the number of fifths left over.
  ///
  /// Equivalent to `(fifthsDistance / 4).round()`, with ties (an exact
  /// `.5`) broken towards zero.
  static int _nearestThirdsCount(int fifthsDistance) {
    final quotient = fifthsDistance ~/ 4;
    final remainder = fifthsDistance - quotient * 4;

    return remainder.abs() * 2 > 4 ? quotient + remainder.sign : quotient;
  }
}
