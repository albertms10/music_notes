import 'package:music_notes/utils.dart';

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

  /// Whether to show the [Key.mode] in the formatted string.
  final bool _showMode;

  /// Creates a new [GermanKeyNotation].
  const GermanKeyNotation({
    this.noteNotation = const GermanNoteNotation(),
    this.tonalModeNotation = const GermanTonalModeNotation(),
  }) : _showMode = true;

  /// Creates a new [GermanKeyNotation] without showing the mode.
  const GermanKeyNotation.short({
    this.noteNotation = const GermanNoteNotation(),
    this.tonalModeNotation = const GermanTonalModeNotation(),
  }) : _showMode = false;

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp.pattern}(:?-${tonalModeNotation.regExp.pattern})?',
    caseSensitive: false,
  );

  @override
  Key parseMatch(RegExpMatch match) {
    final note = noteNotation.parseMatch(match);
    if (match.namedGroup('mode') != null) {
      return Key(note, tonalModeNotation.parseMatch(match));
    }

    return Key(
      note,
      match.namedGroup('noteName')![0].isUpperCase ? .major : .minor,
    );
  }

  @override
  String format(Key key) {
    final note = noteNotation.format(key.note);
    final casedNote = switch (key.mode) {
      .major => note,
      .minor => note.toLowerCase(),
    };
    if (!_showMode) return casedNote;

    final mode = tonalModeNotation.format(key.mode);

    return '$casedNote-$mode';
  }
}
