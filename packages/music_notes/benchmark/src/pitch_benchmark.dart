import 'package:bench_press/bench_press.dart';
import 'package:music_notes/music_notes.dart';

/// `Pitch.transposeBy()`: same accidental arithmetic as `Note.transposeBy`,
/// plus the octave recalculation via `_semitonesWithoutAccidental`. Uses a
/// compound perfect interval (P15+) to cross multiple octave boundaries.
final class PitchTransposeByBenchmark extends Benchmark {
  PitchTransposeByBenchmark() : super('pitch.transposeBy');

  static final _pitch = Note.b.inOctave(3);
  static const _interval = Interval.perfect(Size(22));

  @override
  void run() => Blackhole.consume(_pitch.transposeBy(_interval));
}

/// `Pitch.interval()`: ordinal-delta interval derivation across octaves;
/// underlies `TuningSystem.centsOffset` and `Pitch.nearestAbove/Below`.
final class PitchIntervalBenchmark extends Benchmark {
  PitchIntervalBenchmark() : super('pitch.interval');

  static final _from = Note.c.inOctave(2);
  static final _to = Note.f.sharp.inOctave(6);

  @override
  void run() => Blackhole.consume(_from.interval(_to));
}

void main(List<String> args) => mainBenchmarkSuite(
  [PitchTransposeByBenchmark(), PitchIntervalBenchmark()],
  args,
);
