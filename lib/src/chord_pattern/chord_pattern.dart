import 'package:collection/collection.dart'
    show IterableExtension, ListEquality, UnmodifiableListView;
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
class ChordPattern
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
