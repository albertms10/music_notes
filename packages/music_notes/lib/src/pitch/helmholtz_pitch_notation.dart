import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../note/english_note_notation.dart';
import '../note/german_note_notation.dart';
import '../note/note.dart';
import '../note/note_notation.dart';
import '../note/romance_note_notation.dart';
import '../octave/helmholtz_octave_notation.dart';
import '../octave/octave.dart';
import 'pitch.dart';

/// The Helmholtz [Pitch] notation formatter.
///
/// See [Helmholtz's pitch notation](https://en.wikipedia.org/wiki/Helmholtz_pitch_notation).
final class HelmholtzPitchNotation extends StringNotationSystem<Pitch> {
  /// The [Note] formatter for [Pitch.note].
  final NoteNotation noteNotation;

  /// Whether to use numbers instead of prime symbols.
  final bool useNumbers;

  /// Whether to use ASCII characters instead of Unicode characters.
  final bool useAscii;

  /// Creates a new [HelmholtzPitchNotation].
  const HelmholtzPitchNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
    this.useNumbers = false,
    this.useAscii = false,
  });

  /// Creates a new [HelmholtzPitchNotation] using ASCII characters.
  const HelmholtzPitchNotation.ascii({
    this.noteNotation = const EnglishNoteNotation.ascii(),
    this.useNumbers = false,
  }) : useAscii = true;

  /// Creates a new [HelmholtzPitchNotation] using numbers instead of prime
  /// symbols.
  const HelmholtzPitchNotation.numbered({
    this.noteNotation = const GermanNoteNotation(),
    this.useAscii = false,
  }) : useNumbers = true;

  /// The [EnglishNoteNotation] variant of this [HelmholtzPitchNotation].
  static const english = HelmholtzPitchNotation();

  /// The [GermanNoteNotation] variant of this [HelmholtzPitchNotation].
  static const german = HelmholtzPitchNotation(
    noteNotation: GermanNoteNotation(),
  );

  /// The [RomanceNoteNotation] variant of this [HelmholtzPitchNotation].
  static const romance = HelmholtzPitchNotation(
    noteNotation: RomanceNoteNotation.symbol(),
  );

  /// The [HelmholtzOctaveNotation] for [isBass], sharing this
  /// [HelmholtzPitchNotation]'s [useNumbers] and [useAscii] settings.
  ///
  /// [isBass] only affects [StringNotationSystem.parseMatch] and
  /// [StringNotationSystem.format]; [StringNotationSystem.regExp] is the
  /// same regardless, so any [isBass] value can be used to build [regExp].
  HelmholtzOctaveNotation _octaveNotation({required bool isBass}) =>
      HelmholtzOctaveNotation(
        isBass: isBass,
        useNumbers: useNumbers,
        useAscii: useAscii,
      );

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp?.pattern}'
    '${_octaveNotation(isBass: false).regExp.pattern}',
    caseSensitive: false,
  );

  @override
  Pitch parseMatch(RegExpMatch match) {
    final noteName = match.namedGroup('noteName')!;
    final isBass = noteName[0].isUpperCase;

    return Pitch(
      noteNotation.parseMatch(match),
      octave: _octaveNotation(isBass: isBass).parseMatch(match),
    );
  }

  @override
  String format(Pitch pitch) {
    final isBass = pitch.octave < HelmholtzOctaveNotation.middle;
    final note = noteNotation.format(pitch.note);

    return '${isBass ? note : note.toLowerCase()}'
        '${_octaveNotation(isBass: isBass).format(Octave(pitch.octave))}';
  }
}
