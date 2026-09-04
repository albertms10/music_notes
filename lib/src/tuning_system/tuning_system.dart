import 'package:meta/meta.dart' show immutable;

import '../cent/cent.dart';
import '../interval/interval.dart';
import '../pitch/pitch.dart';
import '../tuning_fork/tuning_fork.dart';

/// A tuning system representation.
///
/// ---
/// See also:
/// * [Pitch].
@immutable
abstract class TuningSystem {
  /// The [TuningFork] from which this [TuningSystem] is based.
  final TuningFork fork;

  /// Creates a new [TuningSystem].
  const TuningSystem({required this.fork});

  /// The number of [Cent] for the generator at [Interval.P5] in this
  /// [TuningSystem].
  ///
  /// Example:
  /// ```dart
  /// PrimeLimitTuning.threeLimit.generator == const Cent(701.96)
  /// const EqualTemperament.edo12().generator == const Cent(700)
  /// const EqualTemperament.edo19().generator == const Cent(694.74)
  /// ```
  /// ---
  /// ![Temperaments](https://upload.wikimedia.org/wikipedia/commons/4/4c/Rank-2_temperaments_with_the_generator_close_to_a_fifth_and_period_an_octave.jpg)
  Cent get generator;

  /// The ratio from [pitch] in this [TuningSystem].
  ///
  /// Example:
  /// ```dart
  /// final edo12 = EqualTemperament.edo12();
  /// edo12.ratio(Note.b.inOctave(4)) == 1.12
  /// edo12.ratio(Note.d.inOctave(5)) == 1.33
  ///
  /// final pt = PrimeLimitTuning(const [], fork: .c256); // Pythagorean
  /// pt.ratio(Note.d.inOctave(4)) == 9 / 8
  /// pt.ratio(Note.f.inOctave(4)) == 4 / 3
  /// ```
  num ratio(Pitch pitch);

  /// The deviation in [Cent] of [pitch] in this [TuningSystem] from its
  /// 12-tone equal temperament counterpart.
  ///
  /// A positive value means [pitch] is sharper than 12-EDO; a negative
  /// value means it’s flatter. The result always falls within `±600` cents.
  ///
  /// Example:
  /// ```dart
  /// Meantone.quarter.centsOffset(Note.g.inOctave(4)) == const Cent(-3.42)
  /// const EqualTemperament.edo12().centsOffset(Note.g.inOctave(4))
  ///   == const Cent(0)
  /// ```
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
