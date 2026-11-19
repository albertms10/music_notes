import 'package:bench_press/bench_press.dart';
import 'package:music_notes/music_notes.dart';

/// `ScalePattern.on()`: builds a full `Scale` via a `fold` of repeated
/// `transposeBy` calls (ascending + descending for asymmetric patterns like
/// melodic minor), so this doubles as a `transposeBy` throughput check.
final class ScalePatternOnBenchmark extends Benchmark {
  ScalePatternOnBenchmark() : super('scale_pattern.on');

  static final _root = Note.g.sharp;

  @override
  void run() => Blackhole.consume(ScalePattern.melodicMinor.on(_root));
}

/// `ChordPattern.inverted`: re-measures every interval from the new bass
/// and re-sorts; representative of voicing and `Chord.rootPosition` work.
final class ChordPatternInvertedBenchmark extends Benchmark {
  ChordPatternInvertedBenchmark() : super('chord_pattern.inverted');

  static final _extendedChord = ChordPattern.majorTriad.add7().add9().add11();

  @override
  void run() => Blackhole.consume(_extendedChord.inverted);
}

/// `ChordPattern.inversion`: searches candidate bass degrees until one
/// matches the observed generic (letter-only) positions.
final class ChordPatternInversionBenchmark extends Benchmark {
  ChordPatternInversionBenchmark() : super('chord_pattern.inversion');

  static final _invertedChord = ChordPattern.majorTriad.add7().inverted;

  @override
  void run() => Blackhole.consume(_invertedChord.inversion);
}

void main(List<String> args) => mainBenchmarkSuite(
  [
    ScalePatternOnBenchmark(),
    ChordPatternInvertedBenchmark(),
    ChordPatternInversionBenchmark(),
  ],
  args,
);
