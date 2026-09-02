import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../pitch/pitch.dart';
import '../pitch/scientific_pitch_notation.dart';
import 'pipe_row.dart';

/// The notation system for [PipeRow].
final class PipeRowNotation extends StringNotationSystem<PipeRow> {
  /// The [NotationSystem] for [PipeRow.breakpoint].
  final StringNotationSystem<Pitch> pitchNotation;

  /// Creates a new [PipeRowNotation].
  const PipeRowNotation({
    this.pitchNotation = ScientificPitchNotation.english,
  });

  static const _prime = '′';
  static const _primeAscii = "'";
  static final _separatorRegExp = RegExp('\\s*[$_prime$_primeAscii,]\\s*');

  @override
  RegExp get regExp => RegExp(
    '${pitchNotation.regExp?.pattern}\\s+(?<feet>.+)',
    caseSensitive: false,
  );

  @override
  PipeRow parseMatch(RegExpMatch match) => PipeRow(
    pitchNotation.parseMatch(match),
    match
        .namedGroup('feet')!
        .split(_separatorRegExp)
        .whereNot((f) => f.isEmpty)
        .map(Rational.parse)
        .toList(),
  );

  @override
  String format(PipeRow disposition) =>
      '${disposition.breakpoint.format()} ${disposition.ranks.join(', ')}';
}
