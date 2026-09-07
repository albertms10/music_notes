import '../accidental/english_accidental_notation.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../note_name/english_note_name_notation.dart';
import 'note.dart';
import 'note_notation.dart';

/// The English notation for [Note]: a letter name (see
/// [EnglishNoteNameNotation]) followed by its accidental, either written
/// out (`C-sharp`, the default) or as a symbol (`C♯`, via
/// [EnglishNoteNotation.symbol] or [EnglishNoteNotation.ascii]).
final class EnglishNoteNotation extends NoteNotation {
  /// Creates a new [EnglishNoteNotation] that writes accidentals out as
  /// words (`D-flat`).
  const EnglishNoteNotation({
    super.noteNameNotation = const EnglishNoteNameNotation(),
    super.accidentalNotation = const EnglishAccidentalNotation(
      showNatural: false,
    ),
  });

  /// Creates a new [EnglishNoteNotation] that writes accidentals as
  /// Unicode symbols (`D♭`).
  const EnglishNoteNotation.symbol({
    super.noteNameNotation = const EnglishNoteNameNotation(),
    super.accidentalNotation = const SymbolAccidentalNotation(
      showNatural: false,
      largerFirst: true,
    ),
  });

  /// Creates a new [EnglishNoteNotation] that writes accidentals as ASCII
  /// stand-in symbols (`Db`) instead of Unicode glyphs.
  const EnglishNoteNotation.ascii({
    super.noteNameNotation = const EnglishNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation.ascii(
           showNatural: false,
           largerFirst: true,
         ),
       );

  /// The symbolic [EnglishNoteNotation] variant that spells out a natural
  /// [Note] with an explicit ♮ (e.g. `F♮`) instead of omitting the symbol.
  static const showNatural = EnglishNoteNotation.symbol(
    accidentalNotation: SymbolAccidentalNotation(largerFirst: true),
  );

  /// Whether [accidentalNotation] renders accidentals as symbols (♯/♭)
  /// rather than words, which changes whether a hyphen separates the
  /// letter name from the accidental.
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
