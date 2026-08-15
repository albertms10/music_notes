import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/src/note_name/english_note_name_notation.dart';

import '../accidental/abc_accidental_notation.dart';
import '../accidental/accidental.dart';
import '../notation_system/notation_system.dart';
import '../note/note.dart';
import '../note_name/note_name.dart';
import 'pitch.dart';

/// The ABC music notation system for [Pitch], e.g. `C`, `^F,`, `_e'`.
///
/// ABC notation is a text-based format for Western folk and traditional
/// music (see the [ABC standard](https://abcnotation.com/wiki/abc:standard:v2.1)).
///
/// Octave 4 (containing middle C) is written with a bare uppercase
/// letter (`C`); octave 5 with a bare lowercase letter (`c`). Each comma
/// after an uppercase letter lowers it by an octave; each apostrophe after
/// a lowercase letter raises it by an octave:
///
///     C,,, C,, C, C  D  E  F  G  A  B  c  d  e  f  g  a  b  c' c'' c'''
///     C1   C2  C3 C4 D4 E4 F4 G4 A4 B4 C5 D5 E5 F5 G5 A5 B5 C6 C7  C8
///
/// Accidentals are prefixed immediately before the letter: `^` (sharp),
/// `_` (flat), `^^` (double sharp), `__` (double flat), and `=` (explicit
/// natural, only emitted when [AbcAccidentalNotation.showNatural] is `true`).
///
/// ---
/// See also:
/// * [Pitch].
/// * [Note].
/// * [AbcAccidentalNotation].
@immutable
final class AbcPitchNotation extends StringNotationSystem<Pitch> {
  /// The [AbcAccidentalNotation] for [Accidental].
  final AbcAccidentalNotation accidentalNotation;

  /// The [StringNotationSystem] for [NoteName].
  final StringNotationSystem<NoteName> noteNameNotation;

  /// The octave of a bare, unmarked uppercase letter (e.g. `C` == C4).
  static const _baseUppercaseOctave = 4;

  /// The octave of a bare, unmarked lowercase letter (e.g. `c` == C5).
  static const _baseLowercaseOctave = 5;

  /// Creates a new [AbcPitchNotation].
  const AbcPitchNotation({
    this.accidentalNotation = const AbcAccidentalNotation(showNatural: false),
    this.noteNameNotation = const EnglishNoteNameNotation(),
  });

  /// An [AbcPitchNotation] that always writes `=` for natural pitches.
  const AbcPitchNotation.showNatural({
    this.noteNameNotation = const EnglishNoteNameNotation(),
  }) : accidentalNotation = const AbcAccidentalNotation();

  static const _primeSymbol = "'";
  static const _subPrimeSymbol = ',';

  @override
  RegExp? get regExp => RegExp(
    '${accidentalNotation.regExp.pattern}'
    '${noteNameNotation.regExp?.pattern}'
    '(?<primes>[$_primeSymbol$_subPrimeSymbol]*)\$',
    caseSensitive: false,
  );

  @override
  String format(Pitch pitch) {
    final Pitch(:note, :octave) = pitch;
    final isLowercase = octave >= _baseLowercaseOctave;
    final letter = isLowercase
        ? note.noteName.name.toLowerCase()
        : note.noteName.name.toUpperCase();
    final octaveMarks = isLowercase
        ? _primeSymbol * (octave - _baseLowercaseOctave)
        : _subPrimeSymbol * (_baseUppercaseOctave - octave);

    return '${accidentalNotation.format(note.accidental)}'
        '$letter$octaveMarks';
  }

  /// Example:
  /// ```dart
  /// const AbcPitchNotation().parse('C') == Note.c.inOctave(4)
  /// const AbcPitchNotation().parse('g') == Note.g.inOctave(5)
  /// const AbcPitchNotation().parse('^F,') == Note.f.sharp.inOctave(3)
  /// const AbcPitchNotation().parse("_e'") == Note.e.flat.inOctave(6)
  /// const AbcPitchNotation().parse('H') // throws a FormatException
  /// ```
  @override
  Pitch parseMatch(RegExpMatch match) {
    final noteName = match.namedGroup('noteName')!;
    final primes = match.namedGroup('primes') ?? '';
    final isLowercase = noteName == noteName.toLowerCase();
    final octaveDelta = primes
        .split('')
        .fold<int>(
          0,
          (delta, mark) => delta + (mark == "'" ? 1 : -1),
        );
    final octave =
        (isLowercase ? _baseLowercaseOctave : _baseUppercaseOctave) +
        octaveDelta;

    return Note(
      noteNameNotation.parseMatch(match),
      accidentalNotation.parseMatch(match),
    ).inOctave(octave);
  }
}
