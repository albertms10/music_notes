import '../accidental/german_accidental_notation.dart';
import '../note_name/german_note_name_notation.dart';
import 'note.dart';
import 'note_notation.dart';

/// The German alphabetic notation system for [Note].
///
/// See [Versetzungszeichen](https://de.wikipedia.org/wiki/Versetzungszeichen).
final class GermanNoteNotation extends NoteNotation {
  /// Creates a new [GermanNoteNotation].
  const GermanNoteNotation({
    super.noteNameNotation = const GermanNoteNameNotation(),
    super.accidentalNotation = const GermanAccidentalNotation(),
  });

  @override
  RegExp get regExp => RegExp(
    '${noteNameNotation.regExp?.pattern}${accidentalNotation.regExp?.pattern}',
    caseSensitive: false,
  );

  @override
  Note parseMatch(RegExpMatch match) {
    final noteName = match.namedGroup('noteName')!;
    final textualAccidental = match.namedGroup('accidental') ?? '';
    final accidental = accidentalNotation.parseMatch(match);
    switch (noteName.toLowerCase()) {
      case 'b' when accidental.isSharp:
        throw FormatException('Invalid Note', match);
      case 'b':
        return Note(.b, accidental - 1);
      case 'h' when accidental.isFlat:
        throw FormatException('Invalid Note', match);
      case 'a' || 'e':
        if (textualAccidental.startsWith('e')) {
          throw FormatException('Invalid Note', match);
        }
      case _ when textualAccidental.startsWith('s'):
        throw FormatException('Invalid Note', match);
    }

    return Note(noteNameNotation.parseMatch(match), accidental);
  }

  @override
  String format(Note note) => switch (note) {
    Note(noteName: .b, accidental: .flat) => 'B',

    Note(noteName: .a || .e, :final accidental) && Note(:final noteName)
        when accidental.isFlat =>
      noteNameNotation.format(noteName) +
          accidentalNotation.format(accidental).substring(1),

    Note(:final noteName, :final accidental) =>
      noteNameNotation.format(noteName) + accidentalNotation.format(accidental),
  };
}
