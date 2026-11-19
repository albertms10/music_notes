import 'dart:math' as math;

import 'package:music_notes/utils.dart';

import '../cent/cent.dart';
import '../note_name/note_name.dart';
import '../pitch/pitch.dart';
import 'tuning_system.dart';

/// Number of chromatic octave divisions in [EqualTemperament.edo12].
const int chromaticDivisions = 12;

/// A representation of an equal temperament tuning formatter.
///
/// See [Equal temperament](https://en.wikipedia.org/wiki/Equal_temperament).
///
/// ---
/// See also:
/// * [TuningSystem].
final class EqualTemperament extends TuningSystem {
  /// The number of equal divisions of the octave.
  final int edo;

  /// Creates a new [EqualTemperament] from [edo] and [fork].
  const EqualTemperament(this.edo, {super.fork = .a440})
    : assert(edo > 0, 'edo must be positive');

  /// The standard 12-EDO system.
  const EqualTemperament.edo12({super.fork = .a440}) : edo = chromaticDivisions;

  /// The cents for each division step in this [EqualTemperament].
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().cents.toList()
  ///   == const [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100]
  ///       as List<Cent>
  /// ```
  Iterable<Cent> get cents =>
      .generate(edo, (i) => .fromRatio(ratioFromSemitones(i)));

  /// Nearest integer `edo` steps approximating a just fifth (3/2) —
  /// the single generator that `.steps` and `.generator` both now
  /// derive from, instead of two separately-tuned approximations.
  static int fifthSteps(int edo) =>
      (edo * (math.log(3 / 2) / math.ln2)).round();

  /// This [edo]'s step position for [name], via the circle of fifths.s
  int stepsFor(NoteName name) {
    // [NoteName.values] is in diatonic order, so consecutive notes advance
    // by two positions around the circle of fifths.
    final fifthsIndex = (name.index * 2) % 7;
    final signedFifthsIndex = fifthsIndex == 6 ? -1 : fifthsIndex;

    return (signedFifthsIndex * fifthSteps(edo)) % edo;
  }

  /// The diatonic gaps between consecutive letters (e.g. `[2,2,1,2,2,2,1]`
  /// at edo=12) — derived, not hardcoded, by walking NoteName.values
  /// sorted by their `stepsFor` position and diffing neighbors.
  List<int> get steps {
    final ordered = NoteName.values.map(stepsFor).toList()..sort();

    return [
      for (var i = 0; i < ordered.length; i++)
        (ordered[(i + 1) % ordered.length] - ordered[i]) % edo,
    ];
  }

  @override
  Cent get generator => Cent(fifthSteps(edo) * (Cent.octave / edo));

  /// The ratio from [semitones] steps of this [EqualTemperament].
  ///
  /// [semitones] is already counted in this [EqualTemperament.edo] steps,
  /// so no grid conversion or validation is needed.
  ///
  /// See [Twelfth root of two](https://en.wikipedia.org/wiki/Twelfth_root_of_two).
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().ratioFromSemitones(1) == 1.059463
  /// const EqualTemperament.edo19().ratioFromSemitones(1) == 1.037155
  /// ```
  num ratioFromSemitones(int semitones) => math.pow(2, semitones / edo);

  /// The ratio for an exact offset in 12-EDO-relative semitones (e.g. an
  /// Accidental's or Interval's `.semitones`).
  ///
  /// Converts onto this edo's own grid, then delegates to [ratioFromSemitones].
  /// Throws when [semitones] has no exact step here.
  num ratioFromRationalSemitones(Rational semitones) {
    final edoSteps = semitones * Rational(edo, chromaticDivisions);
    assert(
      edoSteps == Rational(edoSteps.toInt()),
      '$semitones has no exact step in $edo-EDO; round explicitly first.',
    );

    return ratioFromSemitones(edoSteps.toInt());
  }

  @override
  num ratio(Pitch pitch) =>
      ratioFromRationalSemitones(Rational(fork.pitch.difference(pitch)));

  /// Universal, always-defined: round the 12-EDO nominal directly onto
  /// this edo's grid. No generator, so it can't fail to produce *a*
  /// mapping — only, for exotic EDOs, a musically awkward one.
  int nominalStepFor(NoteName name) => (name.semitones * edo / 12).round();

  @override
  String toString() => 'EDO $edo (${steps.join(' ')}) at ${fork.format()}';

  @override
  bool operator ==(Object other) =>
      other is EqualTemperament && edo == other.edo && fork == other.fork;

  @override
  int get hashCode => Object.hash(edo, fork);
}
