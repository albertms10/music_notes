import 'package:bench_press/bench_press.dart';
import 'package:music_notes/music_notes.dart';

/// `Note.transposeBy()`: the accidental/octave-mod arithmetic exercised on
/// every scale degree and chord tone construction. Compound size (M13)
/// forces the octave-wrap branch, not just the simple case.
final class NoteTransposeByBenchmark extends Benchmark {
  NoteTransposeByBenchmark() : super('note.transposeBy');

  static final _note = Note.c.sharp;

  @override
  void run() => Blackhole.consume(_note.transposeBy(Interval.M13));
}

/// `Note.interval()`: the size/semitone lookup that underlies
/// `ChordPattern.fromIntervalSteps` and `Scale.pattern`. Chosen with a
/// double-flat operand so `intervalSize`/`difference` both do real work.
final class NoteIntervalBenchmark extends Benchmark {
  NoteIntervalBenchmark() : super('note.interval');

  static final _other = Note.a.flat.flat;

  @override
  void run() => Blackhole.consume(Note.c.interval(_other));
}

void main(List<String> args) => mainBenchmarkSuite(
  [NoteTransposeByBenchmark(), NoteIntervalBenchmark()],
  args,
);
