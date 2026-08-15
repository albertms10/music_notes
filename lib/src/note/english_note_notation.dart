import '../accidental/accidental.dart';
import '../accidental/english_accidental_notation.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../note_name/english_note_name_notation.dart';
import 'note.dart';
import 'note_notation.dart';

/// The English notation system for [Note].
final class EnglishNoteNotation extends NoteNotation {
  /// Creates a new [EnglishNoteNotation].
  const EnglishNoteNotation({
    super.noteNameNotation = const EnglishNoteNameNotation(),
    super.accidentalNotation = const EnglishAccidentalNotation(
      showNatural: false,
    ),
  });

  /// Creates a new symbolic [EnglishNoteNotation].
  const EnglishNoteNotation.symbol({
    super.noteNameNotation = const EnglishNoteNameNotation(),
    super.accidentalNotation = const SymbolAccidentalNotation(
      showNatural: false,
      largerFirst: true,
    ),
  });

  /// Creates a new symbolic [EnglishNoteNotation] using ASCII characters.
  const EnglishNoteNotation.ascii({
    super.noteNameNotation = const EnglishNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation.ascii(
           showNatural: false,
           largerFirst: true,
         ),
       );

  /// The [EnglishNoteNotation] format variant that shows the
  /// [Accidental.natural] accidental.
  static const showNatural = EnglishNoteNotation.symbol(
    accidentalNotation: SymbolAccidentalNotation(largerFirst: true),
  );

  /// Whether to use symbolic representation for [Accidental].
  bool get _isSymbol => accidentalNotation is SymbolAccidentalNotation;

  @override
  RegExp get regExp => RegExp(
    '${noteNameNotation.regExp?.pattern}${_isSymbol ? r'\s*' : r'(?:-|\s*)'}'
    '${accidentalNotation.regExp?.pattern}',
    caseSensitive: false,
  );

  @override
  Note parseMatch(RegExpMatch match) => Note(
    noteNameNotation.parseMatch(match),
    accidentalNotation.parseMatch(match),
  );

  @override
  String format(Note note) {
    final noteName = noteNameNotation.format(note.noteName);
    final accidental = accidentalNotation.format(note.accidental);
    if (accidental.isEmpty) return noteName;

    return '$noteName${_isSymbol ? '' : '-'}$accidental';
  }
}
