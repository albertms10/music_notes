import 'package:bench_press/bench_press.dart';
import 'package:music_notes/music_notes.dart';

final _pitch = Note.e.inOctave(5);

final BenchmarkGroup tuningSystemRatioGroup = BenchmarkGroup(
  'TuningSystem.ratio',
  [
    BenchmarkVariant(
      'equal_temperament',
      () => Blackhole.consume(const EqualTemperament.edo12().ratio(_pitch)),
      isBaseline: true,
    ),
    BenchmarkVariant(
      'pythagorean',
      () => Blackhole.consume(const PythagoreanTuning().ratio(_pitch)),
    ),
    BenchmarkVariant(
      'quarter_comma_meantone',
      () => Blackhole.consume(MeantoneTuning.quarter.ratio(_pitch)),
    ),
    BenchmarkVariant(
      'five_limit',
      () => Blackhole.consume(const FiveLimitTuning().ratio(_pitch)),
    ),
  ],
);

void main(List<String> args) =>
    mainBenchmarkSuite([tuningSystemRatioGroup], args);
