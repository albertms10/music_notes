import '../notation_system/notation_system.dart';
import 'english_note_name_notation.dart';
import 'note_name.dart';

/// The German notation system for [NoteName].
final class GermanNoteNameNotation extends StringNotationSystem<NoteName> {
  /// Creates a new [GermanNoteNameNotation].
  const GermanNoteNameNotation();

  static const _altB = 'h';

  static final _noteNames = ([
    ...NoteName.values.map(const EnglishNoteNameNotation().format),
    _altB.toUpperCase(),
  ]..sort()).join();

  static final _regExp = RegExp(
    '(?<noteName>[$_noteNames])',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('noteName')!.toLowerCase()) {
        _altB => .b,
        final name => .values.byName(name),
      };

  @override
  String format(NoteName noteName) => switch (noteName) {
    .b => _altB,
    NoteName(:final name) => name,
  }.toUpperCase();
}
