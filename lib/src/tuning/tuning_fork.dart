import 'package:meta/meta.dart' show immutable;

import '../notation_system.dart';
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

  static const _parsers = [
    CompactTuningForkNotation(),
    ScientificTuningForkNotation(),
  ];

  /// Parse [source] as a [TuningFork] and return its value.
  ///
  /// If the [source] string does not contain a valid [TuningFork], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// TuningFork.parse('A440') == TuningFork.a440
  /// TuningFork.parse('C = 256') == TuningFork.c256
  /// TuningFork.parse('z') // throws a FormatException
  /// ```
  factory TuningFork.parse(
    String source, {
    List<Parser<TuningFork>> chain = _parsers,
  }) => chain.parse(source);

  /// The string representation of this [TuningFork] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// TuningFork.a440.toString() == 'A440'
  /// TuningFork.a432.toString(formatter: ScientificTuningForkNotation())
  ///   == 'A4 = 432 Hz'
  /// ```
  @override
  String toString({
    Formatter<TuningFork> formatter = const CompactTuningForkNotation(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is TuningFork &&
      other.pitch == pitch &&
      other.frequency == frequency;

  @override
  int get hashCode => Object.hash(pitch, frequency);
}

/// The [NotationSystem] for compact [TuningFork].
final class CompactTuningForkNotation extends NotationSystem<TuningFork> {
  /// The [NotationSystem] for [Note].
  final NotationSystem<Note> noteNotation;

  /// The reference octave.
  final int referenceOctave;

  /// Creates a new [CompactTuningForkNotation].
  const CompactTuningForkNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
    this.referenceOctave = Pitch.referenceOctave,
  });

  @override
  String format(TuningFork tuningFork) {
    final pitch = tuningFork.pitch.octave == referenceOctave
        ? '${tuningFork.pitch.note}'
        : '${tuningFork.pitch} ';

    return '$pitch${tuningFork.frequency}';
  }

  @override
  RegExp get regExp => RegExp(
    '(?!.*=)${noteNotation.regExp?.pattern}'
    r'(?<octave>-?\d\s+)?\s*(?<frequency>\d+(\.\d+)?)'
    '(\\s*${Frequency.hertzUnitSymbol})?',
    caseSensitive: false,
  );

  @override
  TuningFork parseMatch(RegExpMatch match) {
    final octavePart = match.namedGroup('octave');
    final octave = octavePart != null ? int.parse(octavePart) : referenceOctave;

    return TuningFork(
      noteNotation.parseMatch(match).inOctave(octave),
      Frequency(double.parse(match.namedGroup('frequency')!)),
    );
  }
}

/// The scientific [TuningFork] notation formatter.
final class ScientificTuningForkNotation extends NotationSystem<TuningFork> {
  /// The [NotationSystem] for [Pitch].
  final NotationSystem<Pitch> pitchNotation;

  /// Creates a new [ScientificTuningForkNotation].
  const ScientificTuningForkNotation({
    this.pitchNotation = ScientificPitchNotation.english,
  });

  @override
  String format(TuningFork tuningFork) =>
      '${pitchNotation.format(tuningFork.pitch)}'
      ' = ${tuningFork.frequency.format()}';

  @override
  RegExp get regExp => RegExp(
    '${pitchNotation.regExp?.pattern}'
    r'\s*=\s*(?<frequency>\d+(\.\d+)?)'
    '(?:\\s*${Frequency.hertzUnitSymbol})?',
    caseSensitive: false,
  );

  @override
  TuningFork parseMatch(RegExpMatch match) => TuningFork(
    pitchNotation.parseMatch(match),
    Frequency(double.parse(match.namedGroup('frequency')!)),
  );
}
