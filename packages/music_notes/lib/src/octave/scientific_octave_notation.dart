import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import 'octave.dart';

/// The scientific notation system for [Octave], e.g. `4`, `-1`.
///
/// This is the canonical numeric notation every other [Octave] notation
/// system is ultimately expressed in terms of.
final class ScientificOctaveNotation extends StringNotationSystem<Octave> {
  /// Creates a new [ScientificOctaveNotation].
  const ScientificOctaveNotation();

  static final _regExp = RegExp(r'(?<octave>[-−]?\d+)');

  @override
  RegExp get regExp => _regExp;

  @override
  Octave parseMatch(RegExpMatch match) =>
      Octave(.parse(match.namedGroup('octave')!.toAscii()));

  @override
  String format(Octave octave) => '${octave.number}';
}
