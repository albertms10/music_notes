import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
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

  /// This [Chord] rewritten in root position, undoing [inversion] while
  /// preserving its pitch-class content.
  ///
  /// Throws a [StateError] when [pattern] is not stacked in thirds (see
  /// [ChordPattern.inversion]) which is the case, for instance, when this
  /// [Chord] carries a bass note that is foreign to its own [pattern]
  /// (e.g. a C major chord with an added D bass).
  ///
  /// Example:
  /// ```dart
  /// const Chord([.e, .g, .c]).rootPosition == ChordPattern.majorTriad.on(.c)
  /// ```
  Chord get rootPosition {
    final rotations = (_items.length - inversion) % _items.length;

    return Chord([..._items.skip(rotations), ..._items.take(rotations)]);
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
