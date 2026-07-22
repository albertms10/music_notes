import '../mode/mode.dart';
import '../notation_system/notation_system.dart';
import '../note/german_note_notation.dart';
import 'key.dart';

/// The German notation system for [Key].
final class GermanKeyNotation extends StringNotationSystem<Key> {
  /// The [GermanNoteNotation] used to format the [Key.note].
  final GermanNoteNotation noteNotation;

  /// The [GermanTonalModeNotation] used to format the [Key.mode].
  final GermanTonalModeNotation tonalModeNotation;

  /// Creates a new [GermanKeyNotation].
  const GermanKeyNotation({
    this.noteNotation = const GermanNoteNotation(),
    this.tonalModeNotation = const GermanTonalModeNotation(),
  });

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp.pattern}-${tonalModeNotation.regExp.pattern}',
    caseSensitive: false,
  );

  @override
  Key parseMatch(RegExpMatch match) =>
      Key(noteNotation.parseMatch(match), tonalModeNotation.parseMatch(match));

  @override
  String format(Key key) {
    final note = noteNotation.format(key.note);
    final mode = tonalModeNotation.format(key.mode);
    final casedNote = switch (key.mode) {
      .major => note,
      .minor => note.toLowerCase(),
    };

    return '$casedNote-$mode';
  }
}
