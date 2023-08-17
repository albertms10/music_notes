// ignore_for_file: avoid_print

import 'package:collection/collection.dart';

import 'harmony/chord_pattern_benchmark.dart';
import 'note/positioned_note_benchmark.dart';

void main() {
  print('Running benchmarks...\n');

  const benchmarks = [
    ChordPatternFromIntervalStepsBenchmark.new,
    ChordPatternTransposeByBenchmark.new,
    PositionedNoteParseScientificBenchmark.new,
    PositionedNoteParseHelmholtzBenchmark.new
  ];

  final sortedBenchmarks = benchmarks.map((benchmarkConstructor) {
    final benchmark = benchmarkConstructor();
    final measure = benchmark.measure();
    print('${benchmark.name} done');

    return (name: benchmark.name, measure: measure);
  }).sorted((a, b) => b.measure.compareTo(a.measure));

  print('\n=========================================');
  print(
    sortedBenchmarks
        .map((benchmark) => '${benchmark.name}: ${benchmark.measure} us')
        .join('\n'),
  );
  print('=========================================');
}
