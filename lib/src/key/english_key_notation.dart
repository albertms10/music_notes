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

  /// Creates a new [EnglishKeyNotation].
  const EnglishKeyNotation({
    this.noteNotation = const EnglishNoteNotation(),
    this.tonalModeNotation = const EnglishTonalModeNotation(),
  });

  /// Creates a new symbolic [EnglishKeyNotation].
  const EnglishKeyNotation.symbol({
    this.noteNotation = const EnglishNoteNotation.symbol(),
    this.tonalModeNotation = const EnglishTonalModeNotation(),
  });

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp.pattern}\\s+${tonalModeNotation.regExp.pattern}',
    caseSensitive: false,
  );

  @override
  Key parseMatch(RegExpMatch match) =>
      Key(noteNotation.parseMatch(match), tonalModeNotation.parseMatch(match));

  @override
  String format(Key key) =>
      '${noteNotation.format(key.note)} ${tonalModeNotation.format(key.mode)}';
}
