import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../note/english_note_notation.dart';
import '../note/german_note_notation.dart';
import '../note/note.dart';
import '../note/romance_note_notation.dart';
import 'pitch.dart';

/// The scientific notation system for [Pitch].
///
/// See [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation).
final class ScientificPitchNotation extends StringNotationSystem<Pitch> {
  /// The [StringNotationSystem] used to format the [Pitch.note].
  final StringNotationSystem<Note> noteNotation;

  /// Whether to use ASCII characters instead of Unicode characters.
  final bool _useAscii;

  /// Creates a new [ScientificPitchNotation].
  const ScientificPitchNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
  }) : _useAscii = false;

  /// Creates a new [ScientificPitchNotation] using ASCII characters.
  const ScientificPitchNotation.ascii({
    this.noteNotation = const EnglishNoteNotation.ascii(),
  }) : _useAscii = true;

  /// The [EnglishNoteNotation] variant of this [ScientificPitchNotation].
  static const english = ScientificPitchNotation();

  /// The [GermanNoteNotation] variant of this [ScientificPitchNotation].
  static const german = ScientificPitchNotation(
    noteNotation: GermanNoteNotation(),
  );

  /// The [RomanceNoteNotation] variant of this [ScientificPitchNotation].
  static const romance = ScientificPitchNotation(
    noteNotation: RomanceNoteNotation.symbol(),
  );

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp?.pattern}'
    '(?<octave>[-${NumExtension.minusSign}]?\\d+)',
    caseSensitive: false,
  );

  @override
  Pitch parseMatch(RegExpMatch match) => Pitch(
    noteNotation.parseMatch(match),
    octave: .parse(match.namedGroup('octave')!.toAscii()),
  );

  @override
  String format(Pitch pitch) =>
      '${noteNotation.format(pitch.note)}'
      '${_useAscii ? pitch.octave : pitch.octave.toNegativeUnicode()}';
}
