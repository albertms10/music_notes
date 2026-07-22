import '../frequency/frequency.dart';
import '../frequency/frequency_si_notation.dart';
import '../notation_system/notation_system.dart';
import '../note/english_note_notation.dart';
import '../note/note.dart';
import '../pitch/pitch.dart';
import 'tuning_fork.dart';

/// The [StringNotationSystem] for compact [TuningFork].
final class CompactTuningForkNotation extends StringNotationSystem<TuningFork> {
  /// The [StringNotationSystem] for [Note].
  final StringNotationSystem<Note> noteNotation;

  /// The [StringNotationSystem] for [Frequency].
  final StringNotationSystem<Frequency> frequencyNotation;

  /// The reference octave.
  final int referenceOctave;

  /// Creates a new [CompactTuningForkNotation].
  const CompactTuningForkNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
    this.frequencyNotation = const FrequencySINotation(),
    this.referenceOctave = Pitch.referenceOctave,
  });

  @override
  RegExp get regExp => RegExp(
    '(?!.*=)${noteNotation.regExp?.pattern}'
    '(?<octave>-?\\d\\s+)?\\s*${frequencyNotation.regExp?.pattern}',
    caseSensitive: false,
  );

  @override
  TuningFork parseMatch(RegExpMatch match) {
    final octavePart = match.namedGroup('octave');
    final octave = octavePart != null ? int.parse(octavePart) : referenceOctave;

    return TuningFork(
      noteNotation.parseMatch(match).inOctave(octave),
      frequencyNotation.parseMatch(match),
    );
  }

  @override
  String format(TuningFork tuningFork) {
    final pitch = tuningFork.pitch.octave == referenceOctave
        ? tuningFork.pitch.note.format()
        : '${tuningFork.pitch.format()} ';

    return '$pitch${tuningFork.frequency}';
  }
}
