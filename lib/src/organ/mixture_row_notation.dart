import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../pitch/pitch.dart';
import '../pitch/scientific_pitch_notation.dart';
import 'mixture_row.dart';

/// The notation system for [MixtureRow].
final class MixtureRowNotation extends StringNotationSystem<MixtureRow> {
  /// The [NotationSystem] for [MixtureRow.breakpoint].
  final StringNotationSystem<Pitch> pitchNotation;

  /// Creates a new [MixtureRowNotation].
  const MixtureRowNotation({
    this.pitchNotation = ScientificPitchNotation.english,
  });

  static final _separatorRegExp = RegExp(r'\s*,\s*');

  @override
  RegExp get regExp => RegExp(
    '${pitchNotation.regExp?.pattern}\\s+(?:<feet>.+)',
    caseSensitive: false,
  );

  @override
  MixtureRow parseMatch(RegExpMatch match) => MixtureRow(
    pitchNotation.parseMatch(match),
    match
        .namedGroup('feet')!
        .split(_separatorRegExp)
        .map(Rational.parse)
        .toList(),
  );

  @override
  String format(MixtureRow mixtureRow) =>
      '${mixtureRow.breakpoint.format()} ${mixtureRow.rankFeet.join(', ')}';
}
