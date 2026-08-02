import 'package:music_notes/utils.dart';

import '../mode/mode.dart';
import '../notation_system/notation_system.dart';
import '../note/english_note_notation.dart';
import 'key.dart';

/// The English notation system for [Key].
final class EnglishKeyNotation extends StringNotationSystem<Key> {
  /// The [EnglishNoteNotation] used to format the [Key.note].
  final EnglishNoteNotation noteNotation;

  /// The [EnglishTonalModeNotation] used to format the [Key.mode].
  final EnglishTonalModeNotation tonalModeNotation;

  /// Whether to show the [Key.mode] in the formatted string.
  final bool showMode;

  /// Creates a new [EnglishKeyNotation].
  const EnglishKeyNotation({
    this.noteNotation = const EnglishNoteNotation(),
    this.tonalModeNotation = const EnglishTonalModeNotation(),
    this.showMode = true,
  });

  /// Creates a new symbolic [EnglishKeyNotation].
  const EnglishKeyNotation.symbol({
    this.noteNotation = const EnglishNoteNotation.symbol(),
    this.tonalModeNotation = const EnglishTonalModeNotation(),
    this.showMode = true,
  });

  /// Creates a new symbolic [EnglishKeyNotation] using ASCII characters.
  const EnglishKeyNotation.ascii({
    this.noteNotation = const EnglishNoteNotation.ascii(),
    this.tonalModeNotation = const EnglishTonalModeNotation(),
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
