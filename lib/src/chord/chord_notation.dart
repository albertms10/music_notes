import '../chord_pattern/chord_pattern.dart';
import '../chord_pattern/chord_pattern_notation.dart';
import '../notation_system/notation_system.dart';
import '../scalable.dart';
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
final class ChordNotation<T extends Scalable<T>>
    extends StringNotationSystem<Chord<T>> {
  /// The [StringNotationSystem] used to format and parse the root and bass
  /// [T] of this [Chord].
  final StringNotationSystem<T> scalableNotation;

  /// The [StringNotationSystem] for [ChordPattern].
  final StringNotationSystem<ChordPattern> chordPatternNotation;

  /// Creates a new [ChordNotation].
  const ChordNotation({
    required this.scalableNotation,
    this.chordPatternNotation = const ChordPatternNotation(),
  });

  static const _slash = '/';

  @override
  Chord<T> parse(String source) {
    final parts = source.split(_slash);
    if (parts.length > 2) {
      throw FormatException('Invalid ${Chord<T>}', source);
    }

    final rootSource = parts.first;
    final rootMatch = scalableNotation.regExp?.firstMatch(rootSource);
    if (rootMatch == null || rootMatch.start != 0) {
      throw FormatException('Invalid ${Chord<T>}', source);
    }

    final root = scalableNotation.parseMatch(rootMatch);
    final pattern = chordPatternNotation.parse(
      rootSource.substring(rootMatch.end),
    );
    final rootPositionChord = pattern.on(root);
    if (parts.length == 1) return rootPositionChord;

    final bass = scalableNotation.parse(parts[1]);
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
  String format(Chord<T> chord) {
    final items = chord.items;
    if (items.length == 1) return scalableNotation.format(items.first);

    final bass = chord.root;
    final rootPositionChord = _rootPositionChordOf(chord);
    final rootItems = rootPositionChord.items;
    final root = rootItems.first;

    final symbol =
        '${scalableNotation.format(root)}'
        '${rootItems.length < 2 ? '' : chordPatternNotation.format(
                rootPositionChord.pattern,
              )}';
    if (root == bass) return symbol;

    return '$symbol$_slash${scalableNotation.format(bass)}';
  }

  /// The root-position [Chord] used to derive the chord symbol for [chord].
  ///
  /// Delegates to [Chord.rootPosition] (which itself relies on
  /// [ChordPattern.inversion]) for genuine inversions (e.g. `C/E`). When
  /// [chord]'s own bass is foreign to its [Chord.pattern], i.e. an added
  /// bass rather than an inverted tone (e.g. `C/D`), [Chord.rootPosition]
  /// throws, and the bass is set aside so the remaining tones can be
  /// formatted on their own instead.
  Chord<T> _rootPositionChordOf(Chord<T> chord) {
    try {
      return chord.rootPosition;
    } on StateError {
      return Chord(chord.items.skip(1).toList(growable: false));
    }
  }
}
