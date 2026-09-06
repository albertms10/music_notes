import '../accidental/accidental.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../notation_system/notation_system.dart';
import '../note_name/english_note_name_notation.dart';
import '../note_name/note_name.dart';
import 'note.dart';

/// The shared shape of every language-specific [Note] notation: a
/// [NoteName] spelling paired with an [Accidental] spelling, combined by
/// each subclass's own `regExp`/`parseMatch`/`format` (letter-plus-suffix
/// for German, letter-plus-symbol for English and Romance, and so on).
abstract class NoteNotation extends StringNotationSystem<Note> {
  /// The notation used to read and write this [Note]'s letter name.
  final StringNotationSystem<NoteName> noteNameNotation;

  /// The notation used to read and write this [Note]'s sharp/flat
  /// alteration.
  final StringNotationSystem<Accidental> accidentalNotation;

  /// Creates a new [NoteNotation] combining [noteNameNotation] and
  /// [accidentalNotation].
  const NoteNotation({
    this.noteNameNotation = const EnglishNoteNameNotation(),
    this.accidentalNotation = const SymbolAccidentalNotation(),
  });
}
