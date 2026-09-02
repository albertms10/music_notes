import 'package:collection/collection.dart' show ListEquality;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/src/pitch/helmholtz_pitch_notation.dart';
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../note/german_note_notation.dart';
import '../pitch/pitch.dart';
import 'pipe_row_notation.dart';

/// One row of pipes, taking a breakpoint key and the ranks' foot-lengths
/// (ascending pitch) starting at that key into account.
@immutable
final class PipeRow implements Formattable<PipeRow> {
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

  /// The disposition for a single rank of 4 feet.
  static const fourFeet = PipeRow(referenceBreakpoint, [.fromMixed(4)]);

  /// The disposition for a single rank of 8 feet.
  static const eightFeet = PipeRow(referenceBreakpoint, [.fromMixed(8)]);

  /// The disposition for a single rank of 16 feet.
  static const sixteenFeet = PipeRow(referenceBreakpoint, [.fromMixed(16)]);

  /// The chain of [StringParser]s used to parse a [PipeRow].
  static const parsers = [
    PipeRowNotation(),
    PipeRowNotation(pitchNotation: HelmholtzPitchNotation.german),
    PipeRowNotation(
      pitchNotation: HelmholtzPitchNotation.ascii(
        noteNotation: GermanNoteNotation(),
      ),
    ),
  ];

  /// Parses [source] as a [PipeRow].
  ///
  /// An example valid source:
  ///
  ///     C2 1 1/3, 1, 2/3
  ///     C3 2 2/3, 2, 1 1/3, 1
  ///     C4 4, 2 2/3, 2, 1 1/3
  ///     C5 5 1/3, 4, 2 2/3, 2
  factory PipeRow.parse(
    String source, {
    List<StringParser<PipeRow>> chain = parsers,
  }) => chain.parse(source);

  /// The [Interval] ranks that conform this [PipeRow].
  List<Interval> get rankIntervals => ranks
      .map((feet) => Interval.fromRatio((referenceHeight / feet).toDouble()))
      .toList();

  /// Formats this [PipeRow].
  @override
  String format([
    StringFormatter<PipeRow> formatter = const PipeRowNotation(),
  ]) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is PipeRow &&
      breakpoint == other.breakpoint &&
      const ListEquality<Rational>().equals(ranks, other.ranks);

  @override
  int get hashCode => Object.hash(breakpoint, .hashAll(ranks));
}

/// A stop disposition extension.
extension StopDisposition on List<PipeRow> {
  /// Parses [source] into [PipeRow]s.
  static List<PipeRow> parse(String source) => [
    for (final line in source.trim().split('\n'))
      if (line.trim().isNotEmpty) .parse(line),
  ];

  /// Formats this list of [PipeRow].
  String format() => map((disposition) => disposition.format()).join('\n');

  /// The disposition row that applies to [key]: the highest breakpoint
  /// at or below it.
  PipeRow rowFor(Pitch key) => where(
    (row) => row.breakpoint.compareTo(key) <= 0,
  ).reduce((a, b) => a.breakpoint.compareTo(b.breakpoint) > 0 ? a : b);
}
