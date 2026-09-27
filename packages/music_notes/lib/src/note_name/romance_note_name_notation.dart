import '../notation_system/notation_system.dart';
import 'note_name.dart';

/// The Romance notation system for [NoteName].
final class RomanceNoteNameNotation extends StringNotationSystem<NoteName> {
  /// Creates a new [RomanceNoteNameNotation].
  const RomanceNoteNameNotation();

  static final _noteNames = <NoteName, String>{
    .c: 'Do',
    .d: 'Re',
    .e: 'Mi',
    .f: 'Fa',
    .g: 'Sol',
    .a: 'La',
    .b: 'Si',
  };

  static final _regExp = RegExp(
    '(?<noteName>${_noteNames.values.join('|')})',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) {
    final name = match.namedGroup('noteName')!.toLowerCase();

    return _noteNames.entries
        .firstWhere((entry) => entry.value.toLowerCase() == name)
        .key;
  }

  @override
  String format(NoteName noteName) => _noteNames[noteName]!;
}
