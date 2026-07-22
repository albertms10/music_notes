import '../notation_system/notation_system.dart';
import '../note/english_note_notation.dart';
import '../note/note.dart';
import 'pitch_class.dart';

/// The [StringNotationSystem] for enharmonic spellings [PitchClass].
///
/// See [Tonal counterparts](https://en.wikipedia.org/wiki/Pitch_class#Other_ways_to_label_pitch_classes).
final class EnharmonicSpellingsPitchClassNotation
    extends StringNotationSystem<PitchClass> {
  /// The [StringNotationSystem] for [Note].
  final StringNotationSystem<Note> noteNotation;

  /// Creates a new [EnharmonicSpellingsPitchClassNotation].
  const EnharmonicSpellingsPitchClassNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
  });

  @override
  RegExp get regExp => RegExp(
    r'(?:\{|\|)'
    '${noteNotation.regExp?.pattern}'
    r'(?:\|.*|\})',
    caseSensitive: false,
  );

  @override
  PitchClass parseMatch(RegExpMatch match) {
    final Note(:semitones) = noteNotation.parseMatch(match);

    return PitchClass(semitones);
  }

  @override
  String format(PitchClass pitchClass) =>
      '{${pitchClass.spellings().map((note) => note.format()).join('|')}}';
}
