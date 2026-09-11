import 'package:collection/collection.dart' show ListEquality;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../pitch/helmholtz_pitch_notation.dart';
import '../pitch/pitch.dart';
import '../pitch/scientific_pitch_notation.dart';
import 'stop_composition_notation.dart';

/// One row of pipes, taking a breakpoint key and the ranks' foot-lengths
/// (ascending pitch) starting at that key into account.
@immutable
final class PipeRow {
  /// The breakpoint [Pitch].
  final Pitch breakpoint;

  /// The list of ranks with [Rational] height.
  final List<Rational> ranks;

  /// Creates a new [PipeRow].
  const PipeRow(this.breakpoint, this.ranks);

  /// The reference pipe height in feet.
  static const referenceHeight = Rational.fromMixed(8);

  /// The reference breakpoint for a [PipeRow].
  static const referenceBreakpoint = Pitch(.c, octave: 2);

  /// The composition for a single rank of 4 feet.
  static const fourFeet = PipeRow(referenceBreakpoint, [.fromMixed(4)]);

  /// The composition for a single rank of 8 feet.
  static const eightFeet = PipeRow(referenceBreakpoint, [.fromMixed(8)]);

  /// The composition for a single rank of 16 feet.
  static const sixteenFeet = PipeRow(referenceBreakpoint, [.fromMixed(16)]);

  /// The [Interval] ranks that conform this [PipeRow].
  List<Interval> get rankIntervals => ranks
      .map((feet) => Interval.fromRatio((referenceHeight / feet).toDouble()))
      .toList();

  @override
  bool operator ==(Object other) =>
      other is PipeRow &&
      breakpoint == other.breakpoint &&
      const ListEquality<Rational>().equals(ranks, other.ranks);

  @override
  int get hashCode => Object.hash(breakpoint, .hashAll(ranks));
}

/// A stop composition extension.
extension StopComposition on List<PipeRow> {
  /// The chain of [StringParser]s used to parse a [PipeRow].
  static const parsers = [
    StopCompositionNotation(),
    StopCompositionNotation(pitchNotation: HelmholtzPitchNotation.german),
    StopCompositionNotation(pitchNotation: ScientificPitchNotation.english),
  ];

  /// Parses [source] as a list of [PipeRow].
  ///
  /// An example valid source:
  ///
  ///     C2 1 1/3, 1, 2/3
  ///     C3 2 2/3, 2, 1 1/3, 1
  ///     C4 4, 2 2/3, 2, 1 1/3
  ///     C5 5 1/3, 4, 2 2/3, 2
  static List<PipeRow> parse(
    String source, {
    List<StringParser<List<PipeRow>>> chain = parsers,
  }) => chain.parse(source);

  /// The pipe row that applies to [key]: the highest breakpoint
  /// at or below it.
  PipeRow? rowFor(Pitch key) {
    final rows = where(
      (row) => row.breakpoint.compareTo(key) <= 0,
    );
    if (rows.isEmpty) return null;

    return rows.reduce(
      (a, b) => a.breakpoint.compareTo(b.breakpoint) > 0 ? a : b,
    );
  }

  /// Formats this list of [PipeRow]s as an aligned rank table.
  ///
  /// Ranks with the same pipe length share columns across rows. If a pipe
  /// length occurs more than once in a row, multiple columns are allocated for
  /// that length.
  String format([
    StringFormatter<List<PipeRow>> formatter = const StopCompositionNotation(),
  ]) => formatter.format(this);
}
