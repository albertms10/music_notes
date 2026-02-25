import 'package:meta/meta.dart' show immutable;

import '../interval/interval.dart';
import 'cent.dart';
import 'tuning_system.dart';

/// A representation of a just tuning.
///
/// See [Just intonation](https://en.wikipedia.org/wiki/Just_intonation).
///
/// ---
/// See also:
/// * [TuningSystem].
@immutable
abstract class JustIntonation extends TuningSystem {
  /// Creates a new [JustIntonation] from [fork].
  const JustIntonation({super.fork = .c256});

  /// The ratio of an ascending [Interval.P5].
  static const ascendingFifthRatio = 3 / 2;

  /// The ratio of an ascending [Interval.P4].
  static const ascendingFourthRatio = 4 / 3;

  /// See [Syntonic comma](https://en.wikipedia.org/wiki/Syntonic_comma)
  /// (a.k.a. Didymean comma).
  static const syntonicCommaRatio = (81 / 64) / (5 / 4);

  /// The number of [Cent] for the generator at [Interval.P5].
  ///
  /// ---
  /// * See [TuningSystem.generator].
  static final generatorCents = Cent.fromRatio(ascendingFifthRatio);

  @override
  Cent get generator => generatorCents;
}
