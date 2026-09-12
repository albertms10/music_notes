import '../accidental/accidental.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../notation_system/notation_system.dart';
import '../note_name/english_note_name_notation.dart';
import '../note_name/note_name.dart';
import 'note.dart';

/// The abstract [StringNotationSystem] for [Note].
abstract class NoteNotation extends StringNotationSystem<Note> {
  /// The [NoteName] notation system used to format the [Note.noteName].
  final StringNotationSystem<NoteName> noteNameNotation;

  /// The [Accidental] notation system used to format the [Note.accidental].
  final StringNotationSystem<Accidental> accidentalNotation;

  /// Creates a new [NoteNotation].
  const NoteNotation({
    this.noteNameNotation = const EnglishNoteNameNotation(),
    this.accidentalNotation = const SymbolAccidentalNotation(),
  });
}
