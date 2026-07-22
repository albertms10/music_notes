import 'package:meta/meta.dart' show immutable;

import '../frequency/frequency.dart';
import '../notation_system/notation_system.dart';
import '../pitch/pitch.dart';
import 'compact_tuning_fork_notation.dart';
import 'scientific_tuning_fork_notation.dart';

/// The representation of a tuning fork.
@immutable
class TuningFork implements Formattable<TuningFork> {
  /// The reference [Pitch] of this tuning fork.
  final Pitch pitch;

  /// The reference [Frequency] of this tuning fork.
  final Frequency frequency;

  /// Creates a new [TuningFork] from [pitch] and [frequency].
  const TuningFork(this.pitch, this.frequency);

  /// The [A440 (pitch standard)](https://en.wikipedia.org/wiki/A440_(pitch_standard))
  /// tuning fork.
  static const a440 = TuningFork(.reference, .reference);

  /// The A432 tuning fork.
  static const a432 = TuningFork(.reference, Frequency(432));

  /// The A415 tuning fork.
  static const a415 = TuningFork(.reference, Frequency(415));

  /// The C256 tuning fork.
  static const c256 = TuningFork(Pitch(.c, octave: 4), Frequency(256));

  /// The chain of [StringParser]s used to parse a [TuningFork].
  static const parsers = [
    CompactTuningForkNotation(),
    ScientificTuningForkNotation.english,
    ScientificTuningForkNotation.englishHelmholtz,
    ScientificTuningForkNotation.german,
    ScientificTuningForkNotation.germanHelmholtz,
  ];

  /// Parse [source] as a [TuningFork] and return its value.
  ///
  /// If the [source] string does not contain a valid [TuningFork], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// TuningFork.parse('A440') == .a440
  /// TuningFork.parse('C = 256') == .c256
  /// TuningFork.parse('z') // throws a FormatException
  /// ```
  factory TuningFork.parse(
    String source, {
    List<StringParser<TuningFork>> chain = parsers,
  }) => chain.parse(source);

  /// The string representation of this [TuningFork] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// TuningFork.a440.format() == 'A440'
  /// TuningFork.a432.format(ScientificTuningForkNotation.english)
  ///   == 'A4 = 432 Hz'
  /// ```
  @override
  String format([
    StringFormatter<TuningFork> formatter = const CompactTuningForkNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(pitch: $pitch, frequency: $frequency)';

  @override
  bool operator ==(Object other) =>
      other is TuningFork &&
      other.pitch == pitch &&
      other.frequency == frequency;

  @override
  int get hashCode => Object.hash(pitch, frequency);
}
