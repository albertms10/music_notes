import '../accidental/accidental.dart';
import '../accidental/romance_accidental_notation.dart';
import '../accidental/symbol_accidental_notation.dart';
import '../note_name/romance_note_name_notation.dart';
import 'note.dart';
import 'note_notation.dart';

/// The Romance alphabetic notation system for [Note].
final class RomanceNoteNotation extends NoteNotation {
  /// Creates a new [RomanceNoteNotation].
  const RomanceNoteNotation({
    super.noteNameNotation = const RomanceNoteNameNotation(),
    super.accidentalNotation = const RomanceAccidentalNotation(
      showNatural: false,
    ),
  });

  /// Creates a new symbolic [RomanceNoteNotation].
  const RomanceNoteNotation.symbol({
    super.noteNameNotation = const RomanceNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation(showNatural: false),
       );

  /// Creates a new symbolic [RomanceNoteNotation] using ASCII characters.
  const RomanceNoteNotation.ascii({
    super.noteNameNotation = const RomanceNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation.ascii(
           showNatural: false,
         ),
       );

  /// The [RomanceNoteNotation] format variant that shows the
  /// [Accidental.natural] accidental.
  static const showNatural = RomanceNoteNotation(
    accidentalNotation: SymbolAccidentalNotation(),
  );

  /// Whether to use symbolic representation for [Accidental].
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
