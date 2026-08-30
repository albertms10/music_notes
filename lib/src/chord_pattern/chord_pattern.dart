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
import '../note/note.dart';
import '../quality/quality.dart';
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

  /// The [Chord] built on top of [note].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.on(.c) == const Chord([.c, .e, .g])
  /// ```
  Chord on(Note note) => Chord(
    _intervals.fold(
      [note],
      (chordItems, interval) => [...chordItems, note.transposeBy(interval)],
    ),
  );

  /// The [Chord] built under [note].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.under(.c) == const Chord([.f, .a.flat, .c])
  /// ```
  Chord under(Note note) => Chord(
    _intervals
        .fold(
          [note],
          (chordItems, interval) => [
            ...chordItems,
            note.transposeBy(-interval),
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
  /// above the root (e.g., 3rd, 5th, 7th, 9th, 11th, 13th, and so on) meaning
  /// this [ChordPattern] is in root position.
  ///
  /// Unlike [inversion], this never throws: it is a plain structural
  /// check, so it is also used as [inversion]'s fast, unambiguous path.
  bool get isRootPosition => _sortedIntervals.indexed.every(
    (entry) => entry.$2.size == Size.third + 2 * entry.$1,
  );

  /// This [ChordPattern] rotated to its next inversion: the lowest
  /// [Interval] is moved above the octave (becoming the new top note) and
  /// every remaining [Interval] is re-expressed from that new bass.
  ///
  /// This is derived solely from the interval content of [_sortedIntervals]
  /// — nothing about the resulting shape is hardcoded — so a single
  /// rotation is correct for triads, seventh chords, and extended
  /// (9th/11th/13th) chords alike.
  ///
  /// Chaining this repeatedly reflects what physically happens when you
  /// keep moving the lowest note of a voicing above the rest: it always
  /// promotes whichever note is currently closest to the bass. For a
  /// chord that spans no more than an octave in root position (triads,
  /// seventh chords), that is exactly the next scale degree each time, so
  /// chaining [inverted] cycles through every degree and back to root
  /// after as many steps as this [ChordPattern] has notes. For a chord
  /// that spans more than an octave in root position (9th chords and
  /// above), an upper extension can sit closer to the bass than the
  /// octave-doubled root does — F-A-C♯-E♭-G, for instance, revisits F
  /// before ever reaching G — so repeated [inverted] calls are not
  /// guaranteed to visit every degree before returning to root. Use
  /// [inversion] to identify a specific inversion directly instead of
  /// chaining [inverted] to search for one.
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
  /// [intervals] rather than kept as separate, hardcodable state.
  ///
  /// `0` is root position. `1` is the first inversion (the original root
  /// is now the topmost note), `2` is the second inversion, and so on up
  /// to `_noteCount - 1`.
  ///
  /// This does not chain [inverted] in search of root position — that
  /// approach breaks down for extended chords, as explained in
  /// [inverted]'s documentation. Instead, each interval's generic
  /// (letter-only) position above the bass is compared, modulo the 7 note
  /// names, against what every possible bass degree would produce: in
  /// root position, the degree at index `i` sits `2 * i` generic steps
  /// above the root, so from a bass at degree `k`, degree `i` sits
  /// `(2 * (i - k)) % 7` steps above the bass. Only the true `k` makes
  /// that hold for every stored [Interval] at once.
  ///
  /// Since chord inversion is only a meaningful concept for chords stacked
  /// in thirds, calling this on a non-tertian [ChordPattern] (e.g.
  /// quartal or added-tone chords) throws a [StateError].
  ///
  /// A [ChordPattern] spanning all 7 note names (a 13th chord or beyond)
  /// is a special case: reading it from any of its 7 members produces an
  /// equally valid-looking stack of thirds — the same ambiguity as
  /// reading a 7-note diatonic collection starting from any of its
  /// degrees — so generic structure alone cannot identify the bass's
  /// degree unless this [ChordPattern] is already in root position. This
  /// also throws a [StateError] in that case.
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
    if (isRootPosition) return 0;

    if (noteCount > 7) {
      throw StateError(
        'Cannot determine the inversion of a ChordPattern spanning more '
        'than 7 note names: $this',
      );
    }
    if (noteCount == 7) {
      throw StateError(
        'Cannot determine the inversion of a ChordPattern spanning all 7 '
        'note names (a 13th chord or beyond) unless it is already in root '
        'position: from generic structure alone, any of its 7 members '
        'could equally be read as the root. $this',
      );
    }

    final observed = {
      for (final interval in _sortedIntervals) (interval.size - 1) % 7,
    };

    for (var k = 1; k < noteCount; k++) {
      final expected = {
        for (var i = 0; i < noteCount; i++)
          if (i != k) (2 * (i - k)) % 7,
      };
      final matches =
          expected.length == observed.length && expected.containsAll(observed);
      if (matches) return k;
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
