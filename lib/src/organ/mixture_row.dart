import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../pitch/pitch.dart';

/// One row of the mixture disposition, transcribed directly from the
/// source table: the breakpoint key and the ranks' foot-lengths
/// (ascending pitch) starting at that key.
@immutable
final class MixtureRow {
  /// The breakpoint [Pitch].
  final Pitch breakpoint;

  /// The list of ranks with [Rational] height.
  final List<Rational> rankFeet;

  /// Creates a new [MixtureRow].
  const MixtureRow(this.breakpoint, this.rankFeet);

  /// The reference pipe height in feet.
  static const referenceHeight = Rational.fromMixed(8);

  /// Parses [source] as a [MixtureRow].
  ///
  /// An example valid source:
  ///
  ///     C2 1 1/3, 1, 2/3
  ///     C3 2 2/3, 2, 1 1/3, 1
  ///     C4 4, 2 2/3, 2, 1 1/3
  ///     C5 5 1/3, 4, 2 2/3, 2
  factory MixtureRow.parse(String source) {
    final trimmed = source.trim();
    final gap = trimmed.indexOf(' ');
    final breakpoint = Pitch.parse(trimmed.substring(0, gap));
    final rankFeet = trimmed
        .substring(gap + 1)
        .split(',')
        .map((token) => _parseFeet(token.trim()))
        .toList();

    return MixtureRow(breakpoint, rankFeet);
  }

  // Rational.parse's grammar requires a leading whole-number part
  // ("1 1/3" parses fine), so a bare fraction like "2/3" is normalized
  // to "0 2/3" first.
  static Rational _parseFeet(String token) => .parse(
    token.contains('/') && !token.contains(' ') ? '0 $token' : token,
  );

  /// The [Interval] ranks that conform this [MixtureRow].
  List<Interval> get ranks => rankFeet
      .map((feet) => Interval.fromRatio((referenceHeight * feet).toDouble()))
      .toList();
}

/// A mixture disposition extension.
extension MixtureDisposition on List<MixtureRow> {
  /// Parses [source] into [MixtureRow]s.
  static List<MixtureRow> parse(String source) => [
    for (final line in source.trim().split('\n'))
      if (line.trim().isNotEmpty) .parse(line),
  ];

  /// The disposition row that applies to [key]: the highest breakpoint
  /// at or below it.
  MixtureRow rowFor(Pitch key) => where(
    (row) => row.breakpoint.compareTo(key) <= 0,
  ).reduce((a, b) => a.breakpoint.compareTo(b.breakpoint) > 0 ? a : b);
}
