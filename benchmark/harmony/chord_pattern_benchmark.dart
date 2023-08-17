import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:music_notes/music_notes.dart';

sealed class ChordPatternBenchmark extends BenchmarkBase {
  const ChordPatternBenchmark(String method) : super('ChordPattern.$method');
}

class ChordPatternTransposeByBenchmark extends ChordPatternBenchmark {
  ChordPatternTransposeByBenchmark() : super('transposeBy()');

  late final Chord<Note> chord;

  @override
  void setup() {
    chord =
        ChordPattern.majorTriad.add7().add9().add11().add13().on(Note.c.sharp);
  }

  @override
  void run() => chord.transposeBy(Interval.m2);
}

class ChordPatternFromIntervalStepsBenchmark extends ChordPatternBenchmark {
  const ChordPatternFromIntervalStepsBenchmark() : super('fromIntervalSteps()');

  @override
  void run() => ChordPattern.fromIntervalSteps(const [
        Interval.m3,
        Interval.M3,
        Interval.m3,
        Interval.M3,
        Interval.m3,
        Interval.m3,
      ]);
}
