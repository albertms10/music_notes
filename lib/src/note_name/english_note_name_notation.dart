import '../notation_system/notation_system.dart';
import 'note_name.dart';

/// The English notation system for [NoteName].
final class EnglishNoteNameNotation extends StringNotationSystem<NoteName> {
  /// Creates a new [EnglishNoteNameNotation].
  const EnglishNoteNameNotation();

  static final _noteNames =
      (NoteName.values
              .map(const EnglishNoteNameNotation().format)
              .toList(growable: false)
            ..sort())
          .join();

  static final _pattern = '(?<noteName>[$_noteNames])';

  @override
  String get pattern => _pattern;

  @override
  NoteName parseMatch(RegExpMatch match) =>
      .values.byName(match.namedGroup('noteName')!.toLowerCase());

  @override
  String format(NoteName noteName) => noteName.name.toUpperCase();
}
