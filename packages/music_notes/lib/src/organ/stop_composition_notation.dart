import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../note/german_note_notation.dart';
import '../pitch/helmholtz_pitch_notation.dart';
import '../pitch/pitch.dart';
import 'pipe_row.dart';

/// The notation system for [List<PipeRow>].
final class StopCompositionNotation
    extends StringNotationSystem<List<PipeRow>> {
  /// The notation system for [PipeRow.breakpoint].
  final StringNotationSystem<Pitch> pitchNotation;

  /// The leading function for each row format.
  final String Function(int index, PipeRow row)? leading;

  /// Creates a new [StopCompositionNotation].
  const StopCompositionNotation({
    this.pitchNotation = const HelmholtzPitchNotation.ascii(
      noteNotation: GermanNoteNotation(),
    ),
    this.leading,
  });

  static const _prime = '′';
  static const _primeAscii = "'";

  static final _separatorRegExp = RegExp(
    '\\s*[$_prime$_primeAscii,]\\s*',
  );

  @override
  RegExp get regExp => RegExp(
    '^'
    r'[ \t]*(?:\r?\n[ \t]*)*'
    '(?:'
    '${pitchNotation.regExp?.pattern}'
    r'[ \t]+.+?[ \t]*'
    r'(?:\r?\n[ \t]*)*'
    ')+'
    r'$',
    caseSensitive: false,
  );

  @override
  List<PipeRow> parseMatch(RegExpMatch match) => [
    for (final line in match.group(0)!.split(RegExp(r'\r?\n|\r')))
      if (line.trim().isNotEmpty) _parseRow(line.trim()),
  ];

  PipeRow _parseRow(String source) {
    final match = RegExp(
      '^${pitchNotation.regExp?.pattern}'
      r'\s+(?<feet>.+)$',
      caseSensitive: false,
    ).firstMatch(source.trim());

    if (match == null) {
      throw FormatException('Invalid PipeRow: $source');
    }

    return PipeRow(
      pitchNotation.parseMatch(match),
      match
          .namedGroup('feet')!
          .split(_separatorRegExp)
          .whereNot((f) => f.isEmpty)
          .map(Rational.parse)
          .toList(),
    );
  }

  @override
  String format(List<PipeRow> composition) {
    if (composition.isEmpty) return '';

    final rows = [
      for (var i = 0; i < composition.length; i++)
        (
          leading: leading?.call(i, composition[i]),
          breakpoint: pitchNotation.format(composition[i].breakpoint),
          ranks: composition[i].ranks,
        ),
    ];

    // Sort each row by descending pipe length.
    final sortedRanks = [
      for (final row in rows) [...row.ranks]..sort((a, b) => b.compareTo(a)),
    ];

    // Determine how many columns are needed for each rank length.
    final multiplicities = <Rational, int>{};

    for (final ranks in sortedRanks) {
      final counts = <Rational, int>{};

      for (final rank in ranks) {
        counts.update(
          rank,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }

      for (final entry in counts.entries) {
        final current = multiplicities[entry.key] ?? 0;
        if (entry.value > current) {
          multiplicities[entry.key] = entry.value;
        }
      }
    }

    // Create the actual columns, ordered by descending pipe length.
    final columns = [
      for (final entry in multiplicities.entries)
        for (var i = 0; i < entry.value; i++) entry.key,
    ]..sort((a, b) => b.compareTo(a));

    // Map each rank length to its column indices.
    final columnIndices = <Rational, List<int>>{};

    for (var i = 0; i < columns.length; i++) {
      columnIndices.putIfAbsent(columns[i], () => []).add(i);
    }

    // Place each row's ranks into their corresponding columns.
    final cells = <List<String?>>[];

    for (final ranks in sortedRanks) {
      final row = List<String?>.filled(columns.length, null);
      final used = <Rational, int>{};

      for (final rank in ranks) {
        final occurrence = used[rank] ?? 0;
        final column = columnIndices[rank]![occurrence];

        row[column] = '$rank$_prime';
        used[rank] = occurrence + 1;
      }

      cells.add(row);
    }

    final breakpointWidth = rows
        .map((row) => row.breakpoint.length)
        .fold<int>(
          0,
          (width, length) => width > length ? width : length,
        );

    final leadingWidth = rows
        .map((row) => row.leading?.length ?? 0)
        .fold<int>(
          0,
          (width, length) => width > length ? width : length,
        );

    final columnWidths = [
      for (var column = 0; column < columns.length; column++)
        cells
            .map((row) => row[column]?.length ?? 0)
            .fold<int>(
              0,
              (width, length) => width > length ? width : length,
            ),
    ];

    return [
      for (var row = 0; row < rows.length; row++)
        [
          if (rows[row].leading != null)
            rows[row].leading!.padRight(leadingWidth),
          rows[row].breakpoint.padRight(breakpointWidth),
          for (var column = 0; column < columns.length; column++)
            cells[row][column]?.padLeft(columnWidths[column]) ??
                ''.padLeft(columnWidths[column]),
        ].join('  ').trimRight(),
    ].join('\n');
  }
}
