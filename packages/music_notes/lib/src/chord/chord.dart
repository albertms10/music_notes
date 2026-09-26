import 'package:collection/collection.dart'
    show IterableExtension, ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../chord_pattern/chord_pattern.dart';
import '../chordable.dart';
import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../note/note.dart';
import '../pitch/pitch.dart';
import '../quality/quality.dart';
import '../scalable.dart';
import '../size/size.dart';
import '../transposable.dart';
import 'chord_notation.dart';

/// A musical chord.
///
/// ---
/// See also:
/// * [ChordPattern].
/// * [Scalable].
/// * [Chordable].
@immutable
final class Chord
    with Chordable<Chord>
    implements Transposable<Chord>, Formattable<Chord> {
  final List<Note> _items;

  /// The [Scalable] items this [Chord] is built of.
  List<Note> get items => UnmodifiableListView(_items);

  /// Creates a new [Chord] from [_items].
  const Chord(this._items);

  /// The chain of [StringParser]s used to parse a [Chord].
  static const parsers = [ChordNotation()];

  /// Parse [source] as a [ChordPattern] and return its value.
  ///
  /// If the [source] string does not contain a valid [ChordPattern], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Chord.parse('Cmaj7') == ChordPattern.majorTriad.add7(.major).on(.c)
  /// Chord.parse('z') // throws a FormatException
  /// ```
  factory Chord.parse(
    String source, {
    List<StringParser<Chord>> chain = parsers,
  }) => chain.parse(source);

  /// Creates a new [Chord] from a list of [Pitch]es.
  factory Chord.fromPitches(List<Pitch> pitches) =>
      Chord(pitches.map((pitch) => pitch.note).toSet().toList());

  /// The root [Scalable] of this [Chord].
  Note get root => _items.first;

  /// The [ChordPattern] for this [Chord].
  ///
  /// Example:
  /// ```dart
  /// const Chord([.a, .c, .e]).pattern == .minorTriad
  /// const Chord([.g, .b, .d, .f, .a]).pattern == .majorTriad.add7().add9()
  /// ```
  ChordPattern get pattern =>
      // The pattern is calculated based on the intervals between the notes
      // rather than from the root note. This approach helps differentiate
      // compound intervals (e.g., [Interval.M9]) from simple intervals
      // (e.g., [Interval.M2]) in chords where distance is not explicit
      // (so, [Note] based chords rather than [Pitch] based).
      .fromIntervalSteps(_items.intervalSteps);

  /// Whether [pattern] is in root position.
  ///
  /// See [ChordPattern.isRootPosition].
  ///
  /// Example:
  /// ```dart
  /// const Chord([.c, .e, .g, .b]).isRootPosition == true
  /// const Chord([.e, .g, .c]).isRootPosition == false
  /// ```
  bool get isRootPosition => pattern.isRootPosition;

  /// This [Chord] rotated to its next inversion: [root] moves above the
  /// other notes, becoming the new top note.
  ///
  /// See [ChordPattern.inverted].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.on(.c).inverted == const Chord([.e, .g, .c])
  /// const Chord([.e, .g, .c]).inverted == const Chord([.g, .c, .e])
  /// ```
  Chord get inverted =>
      _items.length < 2 ? this : Chord([..._items.skip(1), _items.first]);

  /// The inversion number of this [Chord], derived from [pattern] rather
  /// than kept as separate state.
  ///
  /// See [ChordPattern.inversion].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.on(.c).inversion == 0
  /// const Chord([.e, .g, .c]).inversion == 1
  /// const Chord([.g, .c, .e]).inversion == 2
  /// ```
  int get inversion => pattern.inversion;

  /// This [Chord] rewritten in root position.
  ///
  /// [Chord] does not store which of its [items] is the harmonic root
  /// separately from [items] itself, so this works it out from the given
  /// order: [items] is expected to be a closed, uninterrupted stack of
  /// thirds (starting on any chord tone and continuing upward through the
  /// rest, as you would read off a keyboard or a printed chord) but not
  /// necessarily starting on the root itself.
  ///
  /// [pattern] already reflects this: it treats [Chord.root] (i.e.
  /// [items].first) as if it were the bass. For a chord spanning no more
  /// than an octave in root position (triads, seventh chords), the rest of
  /// [items] then simply continues upward in the same closed order as a
  /// fresh root-position voicing would, so [ChordPattern.inverted] and
  /// [ChordPattern.inversion] alone are enough to find the rotation point.
  ///
  /// For a chord spanning more than an octave in root position (9th chords
  /// and above), closed order stops matching scale-degree order once
  /// [ChordPattern.inversion] is reached: an upper extension can sit
  /// closer to the bass than a lower degree does once octave-shifted (see
  /// [ChordPattern.inverted]'s documentation), so which [items] entry is
  /// the true root can no longer be read off its position in the list.
  /// Instead, every entry's generic (letter-only) position relative to the
  /// bass is compared against the position [ChordPattern.inversion]
  /// implies for each scale degree, which recovers each entry's true
  /// degree regardless of where closed order happened to place it; sorting
  /// by degree then reconstructs true root position, and [ChordPattern] is
  /// recalculated from that corrected order rather than reused, so it
  /// reflects the real compound intervals of the reconstructed voicing.
  ///
  /// [items] spanning all 7 note names (13th chords and beyond) cannot be
  /// resolved this way unless already in root position, for the same
  /// reason [ChordPattern.inversion] can't: see its documentation. Doubled
  /// notes, open (non-contiguous) dispositions, and non-tertian chords are
  /// also not supported: for those, and for a 13th chord or beyond not
  /// already in root position, this throws a [StateError].
  ///
  /// Example:
  /// ```dart
  /// const Chord([.e, .g, .c]).rootPosition
  ///   == ChordPattern.majorTriad.on(.c)
  /// const Chord([.g, .b, .c, .e]).rootPosition
  ///   == ChordPattern.majorTriad.add7(.major).on(.c)
  /// Note.f.augmentedTriad.add7().add9().inverted.rootPosition
  ///   == Note.f.augmentedTriad.add7().add9()
  /// ```
  Chord get rootPosition {
    final noteCount = _items.length;
    if (noteCount <= 1 || pattern.isRootPosition) return this;

    // A chord spanning all 7 note names can only be resolved trivially
    // (the `isRootPosition` check above); see [ChordPattern.inversion].
    if (noteCount > 6) {
      throw StateError(
        'Cannot determine the root position of a $noteCount-note Chord '
        'that is not already in root position: $this',
      );
    }

    final bass = _items.first;

    // Try every possible scale degree for the bass in turn. For each
    // candidate, every other item's generic position above the bass
    // (mod 7) pins down which degree it must be if that candidate is
    // right; a valid candidate is the one for which those degrees land
    // on every one of 0..noteCount - 1 exactly once.
    for (var k = 1; k < noteCount; k++) {
      final degreesByItem = <Note, int>{};
      var isConsistent = true;

      for (final item in _items) {
        final position = (bass.interval(item).size - 1) % 7;
        final degree = (k + 4 * position) % 7;
        if (degree >= noteCount || degreesByItem.containsValue(degree)) {
          isConsistent = false;
          break;
        }
        degreesByItem[item] = degree;
      }
      if (!isConsistent) continue;

      final sortedItems = _items.sortedBy((item) => degreesByItem[item]!);

      return Chord(sortedItems).pattern.on(sortedItems.first);
    }

    throw StateError(
      'Cannot determine the root position of a non-tertian Chord: $this',
    );
  }

  /// The modifier [Note]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// Note.a.majorTriad.add7().add9().modifiers == const <Note>[.g, .b]
  /// ```
  List<Note> get modifiers => _items.skip(3).toList(growable: false);

  /// This [Chord] with an [ImperfectQuality.diminished] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().diminished
  ///   == Chord([.c, .e.flat, .g.flat, .b.flat])
  /// ```
  @override
  Chord get diminished => pattern.diminished.on(root);

  /// This [Chord] with an [ImperfectQuality.minor] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().minor == Chord([.c, .e.flat, .g, .b.flat])
  /// ```
  @override
  Chord get minor => pattern.minor.on(root);

  /// This [Chord] with an [ImperfectQuality.major] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.minorTriad.add7().major == Chord([.c, .e, .g, .b.flat])
  /// ```
  @override
  Chord get major => pattern.major.on(root);

  /// This [Chord] with an [ImperfectQuality.augmented] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().augmented == Chord([.c, .e, .g.sharp, .b.flat])
  /// ```
  @override
  Chord get augmented => pattern.augmented.on(root);

  /// Returns this [Chord] adding [interval].
  @override
  Chord add(Interval interval, {Set<Size>? replaceSizes}) =>
      pattern.add(interval, replaceSizes: replaceSizes).on(root);

  /// Transposes this [Chord] by [interval].
  ///
  /// Example:
  /// ```dart
  /// const Chord([.a, .c, .e]).transposeBy(.m3) == Chord([.c, .e.flat, .g])
  /// ```
  @override
  Chord transposeBy(Interval interval) =>
      Chord(_items.transposeBy(interval).toList(growable: false));

  /// Realizes this [Chord] as an ascending [List<Pitch>], one entry per
  /// [voices] index (0-based, into [items]).
  ///
  /// The first voice is anchored at [octave]. Each subsequent voice sits
  /// at the nearest occurrence of its requested note strictly above the
  /// previous one, so a repeated index doubles that tone an octave up,
  /// never in unison.
  ///
  /// Example:
  /// ```dart
  /// const Chord([.c, .e, .g]).toVoicing([0, 0, 1, 2, 0], octave: 2)
  ///   == [Note.c.inOctave(2), Note.c.inOctave(3), Note.e.inOctave(3),
  ///       Note.g.inOctave(3), Note.c.inOctave(4)]
  /// ```
  List<Pitch> toVoicing(List<int> voices, {int octave = 4}) =>
      voices.map((i) => _items[i]).toList().toStacked(octave: octave);

  /// Returns a list of [Pitch]es from [items] based on [octave].
  List<Pitch> toPitches({int octave = 4}) => _items.toStacked(octave: octave);

  /// The string representation of this [Chord] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// Chord([.e, .g, .c]).format() == 'C/E'
  /// ```
  @override
  String format([StringFormatter<Chord> formatter = const ChordNotation()]) =>
      formatter.format(this);

  @override
  String toString() => '$runtimeType(items: ${_items.prettyToString()})';

  @override
  bool operator ==(Object other) =>
      other is Chord && const ListEquality<Note>().equals(_items, other._items);

  @override
  int get hashCode => Object.hashAll(_items);
}
