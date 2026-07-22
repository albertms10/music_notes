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

  /// Creates a new [RomanceKeyNotation].
  const RomanceKeyNotation({
    this.noteNotation = const RomanceNoteNotation(),
    this.tonalModeNotation = const RomanceTonalModeNotation(),
  });

  /// Creates a new symbolic [RomanceKeyNotation].
  const RomanceKeyNotation.symbol({
    this.noteNotation = const RomanceNoteNotation.symbol(),
    this.tonalModeNotation = const RomanceTonalModeNotation(),
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
