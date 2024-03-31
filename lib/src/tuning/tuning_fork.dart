import 'package:meta/meta.dart' show immutable;

import '../note/frequency.dart';
import '../note/note.dart';
import '../note/pitch.dart';

/// The representation of a tuning fork.
@immutable
class TuningFork {
  /// The reference [Pitch] of this tuning fork.
  final Pitch pitch;

  /// The reference [Frequency] of this tuning fork.
  final Frequency frequency;

  /// Creates a new [TuningFork] from [pitch] and [frequency].
  const TuningFork(this.pitch, this.frequency);

  /// The [A440 (pitch standard)](https://en.wikipedia.org/wiki/A440_(pitch_standard))
  /// tuning fork.
  static const a440 = TuningFork(Pitch.reference, Frequency.reference);

  /// The A432 tuning fork.
  static const a432 = TuningFork(Pitch.reference, Frequency(432));

  /// The A415 tuning fork.
  static const a415 = TuningFork(Pitch.reference, Frequency(415));

  /// The C256 tuning fork.
  static const c256 = TuningFork(Pitch(Note.c, octave: 4), Frequency(256));

  /// The string representation of this [TuningFork] based on [system].
  ///
  /// Example:
  /// ```dart
  /// TuningFork.a440.toString() == 'A440'
  /// TuningFork.a432.toString(system: TuningForkNotation.scientific)
  ///   == 'A4 = 432 Hz'
  /// ```
  @override
  String toString({TuningForkNotation system = TuningForkNotation.compact}) =>
      system.tuningFork(this);

  @override
  bool operator ==(Object other) =>
      other is TuningFork &&
      other.pitch == pitch &&
      other.frequency == frequency;

  @override
  int get hashCode => Object.hash(pitch, frequency);
}

/// The abstraction for [TuningFork] notation systems.
@immutable
abstract class TuningForkNotation {
  /// Creates a new [TuningForkNotation].
  const TuningForkNotation();

  /// The compact [TuningForkNotation] system.
  static const compact = CompactTuningForkNotation();

  /// The scientific [TuningForkNotation] system.
  static const scientific = ScientificTuningForkNotation();

  /// The string representation for [tuningFork].
  String tuningFork(TuningFork tuningFork);
}

/// The compact [TuningFork] notation system.
final class CompactTuningForkNotation extends TuningForkNotation {
  /// The reference octave.
  final int referenceOctave;

  /// Creates a new [CompactTuningForkNotation].
  const CompactTuningForkNotation({
    this.referenceOctave = Pitch.referenceOctave,
  });

  @override
  String tuningFork(TuningFork tuningFork) {
    final pitch = tuningFork.pitch.octave == referenceOctave
        ? '${tuningFork.pitch.note}'
        : '${tuningFork.pitch} ';

    return '$pitch${tuningFork.frequency}';
  }
}

/// The scientific [TuningFork] notation system.
final class ScientificTuningForkNotation extends TuningForkNotation {
  /// Creates a new [ScientificTuningForkNotation].
  const ScientificTuningForkNotation();

  @override
  String tuningFork(TuningFork tuningFork) =>
      '${tuningFork.pitch} = ${tuningFork.frequency.format()}';
}
