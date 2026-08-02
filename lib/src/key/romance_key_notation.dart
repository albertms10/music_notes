import 'package:music_notes/utils.dart';

import '../mode/mode.dart';
import '../notation_system/notation_system.dart';
import '../note/romance_note_notation.dart';
import 'key.dart';

/// The Romance notation system for [Key].
final class RomanceKeyNotation extends StringNotationSystem<Key> {
  /// The [RomanceNoteNotation] used to format the [Key.note].
  final RomanceNoteNotation noteNotation;

  /// The [RomanceTonalModeNotation] used to format the [Key.mode].
  final RomanceTonalModeNotation tonalModeNotation;

  /// Whether to show the [Key.mode] in the formatted string.
  final bool showMode;

  /// Creates a new [RomanceKeyNotation].
  const RomanceKeyNotation({
    this.noteNotation = const RomanceNoteNotation(),
    this.tonalModeNotation = const RomanceTonalModeNotation(),
    this.showMode = true,
  });

  /// Creates a new symbolic [RomanceKeyNotation].
  const RomanceKeyNotation.symbol({
    this.noteNotation = const RomanceNoteNotation.symbol(),
    this.tonalModeNotation = const RomanceTonalModeNotation(),
    this.showMode = true,
  });

  /// Creates a new symbolic [RomanceKeyNotation] using ASCII characters.
  const RomanceKeyNotation.ascii({
    this.noteNotation = const RomanceNoteNotation.ascii(),
    this.tonalModeNotation = const RomanceTonalModeNotation(),
    this.showMode = true,
  });

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp.pattern}(?:\\s+${tonalModeNotation.regExp.pattern})'
    '${showMode ? '' : '?'}',
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
    if (showMode) return '$note ${tonalModeNotation.format(key.mode)}';

    return switch (key.mode) {
      .major => note,
      .minor => note.toLowerCase(),
    };
  }
}
