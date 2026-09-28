import '../notation_system/notation_system.dart';
import 'note_name.dart';

/// The English notation system for [NoteName].
///
/// ![EnglishNoteNameNotation](https://raw.githubusercontent.com/albertms10/music_notes/v0.29.0/packages/music_notes/doc/diagrams/EnglishNoteNameNotation.svg)
final class EnglishNoteNameNotation extends StringNotationSystem<NoteName> {
  /// Creates a new [EnglishNoteNameNotation].
  const EnglishNoteNameNotation();

  static final _noteNames =
      (NoteName.values
              .map(const EnglishNoteNameNotation().format)
              .toList(growable: false)
            ..sort())
          .join();

  static final _regExp = RegExp(
    '(?<noteName>[$_noteNames])',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) =>
      .values.byName(match.namedGroup('noteName')!.toLowerCase());

  @override
  String format(NoteName noteName) => noteName.name.toUpperCase();
}
