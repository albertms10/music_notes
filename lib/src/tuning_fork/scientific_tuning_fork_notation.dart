import '../frequency/frequency.dart';
import '../frequency/frequency_si_notation.dart';
import '../notation_system/notation_system.dart';
import '../pitch/helmholtz_pitch_notation.dart';
import '../pitch/pitch.dart';
import '../pitch/scientific_pitch_notation.dart';
import 'tuning_fork.dart';

/// The scientific [TuningFork] notation formatter.
final class ScientificTuningForkNotation
    extends StringNotationSystem<TuningFork> {
  /// The [StringNotationSystem] for [Pitch].
  final StringNotationSystem<Pitch> pitchNotation;

  /// The [StringNotationSystem] for [Frequency].
  final StringNotationSystem<Frequency> frequencyNotation;

  /// Creates a new [ScientificTuningForkNotation].
  const ScientificTuningForkNotation({
    this.pitchNotation = ScientificPitchNotation.english,
    this.frequencyNotation = const FrequencySINotation(),
  });

  /// The english variant of this [ScientificTuningForkNotation].
  static const english = ScientificTuningForkNotation();

  /// The german variant of this [ScientificTuningForkNotation].
  static const german = ScientificTuningForkNotation(
    pitchNotation: ScientificPitchNotation.german,
  );

  /// The [HelmholtzPitchNotation.english] variant of this
  /// [ScientificTuningForkNotation].
  static const englishHelmholtz = ScientificTuningForkNotation(
    pitchNotation: HelmholtzPitchNotation.english,
  );

  /// The [HelmholtzPitchNotation.german] variant of this
  /// [ScientificTuningForkNotation].
  static const germanHelmholtz = ScientificTuningForkNotation(
    pitchNotation: HelmholtzPitchNotation.german,
  );

  @override
  RegExp get regExp => RegExp(
    '${pitchNotation.regExp?.pattern}\\s*=\\s*'
    '${frequencyNotation.regExp?.pattern}',
    caseSensitive: false,
  );

  @override
  TuningFork parseMatch(RegExpMatch match) => TuningFork(
    pitchNotation.parseMatch(match),
    frequencyNotation.parseMatch(match),
  );

  @override
  String format(TuningFork tuningFork) =>
      '${pitchNotation.format(tuningFork.pitch)}'
      ' = ${frequencyNotation.format(tuningFork.frequency)}';
}
