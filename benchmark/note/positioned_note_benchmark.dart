import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:music_notes/music_notes.dart';

sealed class PositionedNoteBenchmark extends BenchmarkBase {
  const PositionedNoteBenchmark(String method)
      : super('PositionedNote.$method');
}

class PositionedNoteParseScientificBenchmark extends PositionedNoteBenchmark {
  const PositionedNoteParseScientificBenchmark() : super('parse(scientific)');

  @override
  void run() => PositionedNote.parse('Ab5');
}

class PositionedNoteParseHelmholtzBenchmark extends PositionedNoteBenchmark {
  const PositionedNoteParseHelmholtzBenchmark() : super('parse(Helmholtz)');

  @override
  void run() => PositionedNote.parse('C,,');
}
