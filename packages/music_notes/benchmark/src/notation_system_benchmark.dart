import 'package:bench_press/bench_press.dart';
import 'package:music_notes/music_notes.dart';

/// `EnglishNoteNotation.regExp` builds a fresh `RegExp` on every access
/// (it's a getter, not a cached `static final` like most other notation
/// systems), so `.parse()` pays a regex-compile cost on every single call.
/// This is the clearest regression risk among the notation systems and the
/// main reason this file exists.
final class NoteNotationParseBenchmark extends Benchmark {
  NoteNotationParseBenchmark() : super('english_note_notation.parse');

  static const _notation = EnglishNoteNotation();

  @override
  void run() => Blackhole.consume(_notation.parse('F-sharp'));
}

final class NoteNotationFormatBenchmark extends Benchmark {
  NoteNotationFormatBenchmark() : super('english_note_notation.format');

  static const _notation = EnglishNoteNotation();
  static final _note = Note.f.sharp;

  @override
  void run() => Blackhole.consume(_notation.format(_note));
}

/// `ScientificPitchNotation.parse()`: composes the note-notation regex
/// with an octave group; exercised on every default `Pitch.parse()` call.
final class ScientificPitchNotationParseBenchmark extends Benchmark {
  ScientificPitchNotationParseBenchmark()
    : super('scientific_pitch_notation.parse');

  static const _notation = ScientificPitchNotation.english;

  @override
  void run() => Blackhole.consume(_notation.parse('G♯-1'));
}

/// `StandardIntervalNotation.parse()`: the default `Interval.parse()` path.
final class IntervalNotationParseBenchmark extends Benchmark {
  IntervalNotationParseBenchmark()
    : super('standard_interval_notation.parse');

  static const _notation = StandardIntervalNotation();

  @override
  void run() => Blackhole.consume(_notation.parse('M9'));
}

void main(List<String> args) => mainBenchmarkSuite(
  [
    NoteNotationParseBenchmark(),
    NoteNotationFormatBenchmark(),
    ScientificPitchNotationParseBenchmark(),
    IntervalNotationParseBenchmark(),
  ],
  args,
);
