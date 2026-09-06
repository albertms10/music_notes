import '../accidental/romance_accidental_notation.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../note_name/romance_note_name_notation.dart';
import 'note.dart';
import 'note_notation.dart';

/// The Romance (solfège) notation for [Note]: a solfège syllable (see
/// [RomanceNoteNameNotation]) followed by its accidental, either written
/// out (`Do diesis`, the default) or as a symbol (`Do♯`, via
/// [RomanceNoteNotation.symbol] or [RomanceNoteNotation.ascii]).
final class RomanceNoteNotation extends NoteNotation {
  /// Creates a new [RomanceNoteNotation] that writes accidentals out as
  /// words (`Re bemolle`).
  const RomanceNoteNotation({
    super.noteNameNotation = const RomanceNoteNameNotation(),
    super.accidentalNotation = const RomanceAccidentalNotation(
      showNatural: false,
    ),
  });

  /// Creates a new [RomanceNoteNotation] that writes accidentals as
  /// Unicode symbols (`Re♭`).
  const RomanceNoteNotation.symbol({
    super.noteNameNotation = const RomanceNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation(showNatural: false),
       );

  /// Creates a new [RomanceNoteNotation] that writes accidentals as ASCII
  /// stand-in symbols (`Reb`) instead of Unicode glyphs.
  const RomanceNoteNotation.ascii({
    super.noteNameNotation = const RomanceNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation.ascii(
           showNatural: false,
         ),
       );

  /// The symbolic [RomanceNoteNotation] variant that spells out a natural
  /// [Note] with an explicit ♮ (e.g. `Fa♮`) instead of omitting the symbol.
  static const showNatural = RomanceNoteNotation(
    accidentalNotation: SymbolAccidentalNotation(),
  );

  /// Whether [accidentalNotation] renders accidentals as symbols (♯/♭)
  /// rather than words, which changes whether a space separates the
  /// syllable from the accidental.
  bool get _isSymbol => accidentalNotation is SymbolAccidentalNotation;

  @override
  RegExp get regExp => RegExp(
    '${noteNameNotation.regExp?.pattern}\\s*'
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

    return '$noteName${_isSymbol ? '' : ' '}$accidental';
  }
}
