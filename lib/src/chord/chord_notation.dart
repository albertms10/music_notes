import '../chord_pattern/chord_pattern.dart';
import '../chord_pattern/chord_pattern_notation.dart';
import '../notation_system/notation_system.dart';
import '../note/english_note_notation.dart';
import '../note/note.dart';
import 'chord.dart';

/// A notation system for [Chord], combining a [ChordPatternNotation] symbol
/// with an optional slash bass note (e.g., `C/E`).
///
/// Whenever the lowest note of the [Chord] differs from its root-position
/// root, that lowest note (the bass) is appended after a slash, following
/// the [Slash chord](https://en.wikipedia.org/wiki/Chord_notation#Slash_chords)
/// convention.
///
/// ---
/// See also:
/// * [Chord].
/// * [ChordPattern].
/// * [ChordPatternNotation].
final class ChordNotation extends StringNotationSystem<Chord> {
  /// The [StringNotationSystem] used to format and parse the root and bass
  /// [Note] of this [Chord].
  final StringNotationSystem<Note> noteNotation;

  /// The [StringNotationSystem] for [ChordPattern].
  final StringNotationSystem<ChordPattern> chordPatternNotation;

  /// Creates a new [ChordNotation].
  const ChordNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
    this.chordPatternNotation = const ChordPatternNotation(),
  });

  static const _slash = '/';

  @override
  Chord parse(String source) {
    final parts = source.split(_slash);
    if (parts.length > 2) {
      throw FormatException('Invalid $Chord', source);
    }

    final rootSource = parts.first;
    final rootMatch = noteNotation.regExp?.firstMatch(rootSource);
    if (rootMatch == null || rootMatch.start != 0) {
      throw FormatException('Invalid $Chord', source);
    }

    final root = noteNotation.parseMatch(rootMatch);
    final pattern = chordPatternNotation.parse(
      rootSource.substring(rootMatch.end),
    );
    final rootPositionChord = pattern.on(root);
    if (parts.length == 1) return rootPositionChord;

    final bass = noteNotation.parse(parts[1]);
    final items = rootPositionChord.items;
    final bassIndex = items.indexOf(bass);
    // When the bass is not one of the chord’s own tones, it is added below
    // as a foreign bass note rather than rotating the chord into an
    // inversion (e.g., C/D).
    if (bassIndex == -1) return Chord([bass, ...items]);

    // Rotate so the matching tone becomes the new bass (e.g., C/E).
    return Chord([...items.skip(bassIndex), ...items.take(bassIndex)]);
  }

  @override
  String format(Chord chord) {
    final items = chord.items;
    if (items.length == 1) return noteNotation.format(items.first);

    final bass = chord.root;
    final rootPositionChord = _rootPositionChordOf(chord);
    final rootItems = rootPositionChord.items;
    final root = rootItems.first;

    final symbol =
        '${noteNotation.format(root)}'
        '${rootItems.length < 2 ? '' : chordPatternNotation.format(
                rootPositionChord.pattern,
              )}';
    if (root == bass) return symbol;

    return '$symbol$_slash${noteNotation.format(bass)}';
  }

  /// The root-position [Chord] used to derive the chord symbol for [chord].
  ///
  /// Delegates to [Chord.rootPosition] (which itself relies on
  /// [ChordPattern.inversion]) for genuine inversions (e.g. `C/E`). When
  /// [chord]'s own bass is foreign to its [Chord.pattern], i.e. an added
  /// bass rather than an inverted tone (e.g. `C/D`), [Chord.rootPosition]
  /// throws, and the bass is set aside so the remaining tones can be
  /// formatted on their own instead.
  Chord _rootPositionChordOf(Chord chord) {
    try {
      return chord.rootPosition;
      // ignore: avoid_catching_errors ease
    } on StateError {
      return Chord(chord.items.skip(1).toList(growable: false));
    }
  }
}
