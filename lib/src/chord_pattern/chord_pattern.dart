import 'package:collection/collection.dart'
    show
        IterableComparableExtension,
        IterableExtension,
        ListEquality,
        UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../chord/chord.dart';
import '../chordable.dart';
import '../interval/interval.dart';
import '../notation_system/notation_system.dart';
import '../quality/quality.dart';
import '../scalable.dart';
import '../size/size.dart';
import 'chord_pattern_notation.dart';

/// A musical chord pattern.
///
/// ---
/// See also:
/// * [Chord].
/// * [Interval].
@immutable
final class ChordPattern
    with Chordable<ChordPattern>
    implements Formattable<ChordPattern> {
  final List<Interval> _intervals;

  /// The intervals from the root note.
  List<Interval> get intervals => UnmodifiableListView(_intervals);

  /// Creates a new [ChordPattern] from [_intervals].
  const ChordPattern(this._intervals);

  /// A diminished triad [ChordPattern].
  static const diminishedTriad = ChordPattern([.m3, .d5]);

  /// A minor triad [ChordPattern].
  static const minorTriad = ChordPattern([.m3, .P5]);

  /// A major triad [ChordPattern].
  static const majorTriad = ChordPattern([.M3, .P5]);

  /// An augmented triad [ChordPattern].
  static const augmentedTriad = ChordPattern([.M3, .A5]);

  /// Creates a new [ChordPattern] from [intervalSteps].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.fromIntervalSteps([.m3, .M3]) == .minorTriad
  /// ChordPattern.fromIntervalSteps([.M3, .M3]) == .augmentedTriad
  /// ```
  factory ChordPattern.fromIntervalSteps(Iterable<Interval> intervalSteps) =>
      ChordPattern(
        intervalSteps.skip(1).fold([
          intervalSteps.first,
        ], (steps, interval) => [...steps, interval + steps.last]),
      );

  /// Creates a new [ChordPattern] from the given [quality].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.fromQuality(.augmented) == .augmentedTriad
  /// ChordPattern.fromQuality(.minor) == .minorTriad
  /// ```
  factory ChordPattern.fromQuality(ImperfectQuality quality) =>
      switch (quality) {
        .diminished => diminishedTriad,
        .minor => minorTriad,
        .major => majorTriad,
        .augmented => augmentedTriad,
        _ => majorTriad,
      };

  /// The chain of [StringParser]s used to parse a [ChordPattern].
  static const parsers = [ChordPatternNotation()];

  /// Parse [source] as a [ChordPattern] and return its value.
  ///
  /// If the [source] string does not contain a valid [ChordPattern], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.parse('maj7') == .majorTriad.add7(.major)
  /// ChordPattern.parse('z') // throws a FormatException
  /// ```
  factory ChordPattern.parse(
    String source, {
    List<StringParser<ChordPattern>> chain = parsers,
  }) => chain.parse(source);

  /// The [Chord] built on top of [scalable].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.on(Note.c) == const Chord<Note>([.c, .e, .g])
  /// ```
  Chord<T> on<T extends Scalable<T>>(T scalable) => Chord(
    _intervals.fold(
      [scalable],
      (chordItems, interval) => [...chordItems, scalable.transposeBy(interval)],
    ),
  );

  /// The [Chord] built under [scalable].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.under(Note.c)
  ///   == const Chord<Note>([.f, .a.flat, .c])
  /// ```
  Chord<T> under<T extends Scalable<T>>(T scalable) => Chord(
    _intervals
        .fold(
          [scalable],
          (chordItems, interval) => [
            ...chordItems,
            scalable.transposeBy(-interval),
          ],
        )
        .reversed
        .toList(growable: false),
  );

  /// The root triad of this [ChordPattern].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().rootTriad == .majorTriad
  /// ```
  ChordPattern get rootTriad => ChordPattern(_intervals.sublist(0, 2));

  /// Whether this [ChordPattern] is [ImperfectQuality.diminished].
  bool get isDiminished => rootTriad == diminishedTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.minor].
  bool get isMinor => rootTriad == minorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.major].
  bool get isMajor => rootTriad == majorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.augmented].
  bool get isAugmented => rootTriad == augmentedTriad;

  /// The modifier [Interval]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().modifiers
  ///   == const <Interval>[.m7, .M9]
  /// ```
  List<Interval> get modifiers => _intervals.sublist(2);

  /// The total number of notes in this [ChordPattern], including the root.
  int get _noteCount => _intervals.length + 1;

  /// [_intervals] sorted in ascending order.
  ///
  /// [ChordPattern]s built through the provided factories and [add] are
  /// always kept sorted, but nothing prevents constructing one directly
  /// from a literal in an arbitrary order (e.g. mirroring an open-position
  /// keyboard disposition). Every inversion-related member reads from this
  /// getter rather than [_intervals] so the result is unaffected by how
  /// the pattern was built.
  List<Interval> get _sortedIntervals => _intervals.sorted();

  /// Whether [_sortedIntervals] forms an uninterrupted stack of thirds
  /// above the root — 3rd, 5th, 7th, 9th, 11th, 13th, and so on — meaning
  /// this [ChordPattern] is in root position.
  bool get isRootPosition => _sortedIntervals.indexed.every(
    (entry) => entry.$2.size == Size.third + 2 * entry.$1,
  );

  /// This [ChordPattern] rotated to its next inversion: the lowest
  /// [Interval] is moved above the octave (becoming the new top note) and
  /// every remaining [Interval] is re-expressed from that new bass.
  ///
  /// This is derived solely from the interval content of [_sortedIntervals]
  /// — nothing about the resulting shape is hardcoded — so it holds for
  /// triads, seventh chords, and extended (9th/11th/13th) chords alike.
  ///
  /// See [Inversion § Chords](https://en.wikipedia.org/wiki/Inversion_(music)#Chords).
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.inverted == const ChordPattern([.m3, .m6])
  /// ChordPattern.majorTriad.inverted.inverted
  ///   == const ChordPattern([.P4, .M6])
  /// ChordPattern.majorTriad.add7().inverted
  ///   == const ChordPattern([.m3, .d5, .m6])
  /// ```
  ChordPattern get inverted {
    final sorted = _sortedIntervals;
    if (sorted.isEmpty) return this;

    // The closest note to the root becomes the new bass: every other note
    // is re-measured from it, and the old root reappears above the octave.
    final newBass = sorted.first;

    // Re-sorted because, for extended chords, a compound interval (e.g. a
    // 9th) can end up smaller than `P8 - newBass` once re-measured from the
    // new bass, so simple append order no longer guarantees ascending order.
    return ChordPattern(
      [
        for (final interval in sorted.skip(1)) interval - newBass,
        Interval.P8 - newBass,
      ]..sort(),
    );
  }

  /// The inversion number of this [ChordPattern], calculated on demand from
  /// [intervals] rather than kept as separate state.
  ///
  /// `0` is root position. `1` is the first inversion (the original root
  /// is now the topmost note), `2` is the second inversion, and so on up
  /// to `_noteCount - 1`.
  ///
  /// The result is obtained by repeatedly applying [inverted] until an
  /// uninterrupted stack of thirds — i.e. root position, see
  /// [isRootPosition] — is reached, then working back from how many
  /// rotations that took. Since chord inversion is only a meaningful
  /// concept for chords stacked in thirds, calling this on a non-tertian
  /// [ChordPattern] (e.g. quartal or added-tone chords) throws a
  /// [StateError].
  ///
  /// Example:
  /// ```dart
  /// const ChordPattern([.m3, .P5]).inversion == 0
  /// ChordPattern.majorTriad.inverted.inversion == 1
  /// ChordPattern.majorTriad.inverted.inverted.inversion == 2
  /// ```
  int get inversion {
    final noteCount = _noteCount;
    if (noteCount <= 1) return 0;

    var pattern = this;
    for (var rotations = 0; rotations < noteCount; rotations++) {
      if (pattern.isRootPosition) return (noteCount - rotations) % noteCount;
      pattern = pattern.inverted;
    }

    throw StateError(
      'Cannot determine the inversion of a non-tertian ChordPattern '
      '(intervals are not stacked in thirds): $this',
    );
  }

  /// This [ChordPattern] with an [ImperfectQuality.diminished] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().diminished
  ///   == const ChordPattern([.m3, .d5, .m7])
  /// ```
  @override
  ChordPattern get diminished =>
      ChordPattern([...diminishedTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.minor] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().minor
  ///   == const ChordPattern([.m3, .P5, .m7])
  /// ```
  @override
  ChordPattern get minor =>
      ChordPattern([...minorTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.major] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.minorTriad.add7().major
  ///   == const ChordPattern([.M3, .P5, .m7])
  /// ```
  @override
  ChordPattern get major =>
      ChordPattern([...majorTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.augmented] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().augmented
  ///   == const ChordPattern([.M3, .A5, .m7])
  /// ```
  @override
  ChordPattern get augmented =>
      ChordPattern([...augmentedTriad._intervals, ...modifiers]);

  /// Returns this [ChordPattern] adding [interval].
  @override
  ChordPattern add(Interval interval, {Set<Size>? replaceSizes}) {
    final sizesToReplace = [interval.size, ...?replaceSizes];
    final filteredIntervals = _intervals.whereNot(
      (chordInterval) => sizesToReplace.contains(chordInterval.size),
    );

    return ChordPattern([...filteredIntervals, interval]..sort());
  }

  /// Returns the [Interval] from [intervals] at the given [size], if any.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.at(.third) == .M3
  /// ChordPattern.diminishedTriad.at(.fifth) == .d5
  /// ChordPattern.minorTriad.add7().at(.seventh) == .m7
  /// ChordPattern.augmentedTriad.at(.ninth) == null
  /// ```
  Interval? at(Size size) =>
      intervals.firstWhereOrNull((interval) => interval.size == size);

  @override
  String format([
    StringFormatter<ChordPattern> formatter = const ChordPatternNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(intervals: ${intervals.prettyToString()})';

  @override
  bool operator ==(Object other) =>
      other is ChordPattern &&
      const ListEquality<Interval>().equals(_intervals, other._intervals);

  @override
  int get hashCode => Object.hashAll(_intervals);
}
