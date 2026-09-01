import 'package:collection/collection.dart' show ListEquality;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../pitch/pitch.dart';
import 'mixture_row_notation.dart';

/// One row of the mixture disposition, transcribed directly from the
/// source table: the breakpoint key and the ranks' foot-lengths
/// (ascending pitch) starting at that key.
@immutable
final class MixtureRow implements Formattable<MixtureRow> {
  /// The breakpoint [Pitch].
  final Pitch breakpoint;

  /// The list of ranks with [Rational] height.
  final List<Rational> rankFeet;

  /// Creates a new [MixtureRow].
  const MixtureRow(this.breakpoint, this.rankFeet);

  /// The reference pipe height in feet.
  static const referenceHeight = Rational.fromMixed(8);

  /// The chain of [StringParser]s used to parse a [MixtureRow].
  static const parsers = [MixtureRowNotation()];

  /// Parses [source] as a [MixtureRow].
  ///
  /// An example valid source:
  ///
  ///     C2 1 1/3, 1, 2/3
  ///     C3 2 2/3, 2, 1 1/3, 1
  ///     C4 4, 2 2/3, 2, 1 1/3
  ///     C5 5 1/3, 4, 2 2/3, 2
  factory MixtureRow.parse(
    String source, {
    List<StringParser<MixtureRow>> chain = parsers,
  }) => chain.parse(source);

  /// The [Interval] ranks that conform this [MixtureRow].
  List<Interval> get ranks => rankFeet
      .map((feet) => Interval.fromRatio((referenceHeight / feet).toDouble()))
      .toList();

  /// Formats this [MixtureRow].
  @override
  String format([
    StringFormatter<MixtureRow> formatter = const MixtureRowNotation(),
  ]) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is MixtureRow &&
      breakpoint == other.breakpoint &&
      const ListEquality<Rational>().equals(rankFeet, other.rankFeet);

  @override
  int get hashCode => Object.hash(breakpoint, .hashAll(rankFeet));
}

/// A mixture disposition extension.
extension MixtureDisposition on List<MixtureRow> {
  /// Parses [source] into [MixtureRow]s.
  static List<MixtureRow> parse(String source) => [
    for (final line in source.trim().split('\n'))
      if (line.trim().isNotEmpty) .parse(line),
  ];

  /// Formats this list of [MixtureRow].
  String format() => map((mixtureRow) => mixtureRow.format()).join('\n');

  /// The disposition row that applies to [key]: the highest breakpoint
  /// at or below it.
  MixtureRow rowFor(Pitch key) => where(
    (row) => row.breakpoint.compareTo(key) <= 0,
  ).reduce((a, b) => a.breakpoint.compareTo(b.breakpoint) > 0 ? a : b);
}
