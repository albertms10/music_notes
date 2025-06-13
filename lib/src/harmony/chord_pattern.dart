import 'package:collection/collection.dart'
    show IterableExtension, ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../chordable.dart';
import '../interval/interval.dart';
import '../interval/quality.dart';
import '../notation_system.dart';
import '../scalable.dart';
import 'chord.dart';

/// A musical chord pattern.
///
/// ---
/// See also:
/// * [Chord].
/// * [Interval].
@immutable
class ChordPattern with Chordable<ChordPattern> {
  final List<Interval> _intervals;

  /// The intervals from the root note.
  List<Interval> get intervals => UnmodifiableListView(_intervals);

  /// Creates a new [ChordPattern] from [_intervals].
  const ChordPattern(this._intervals);

  /// A diminished triad [ChordPattern].
  static const diminishedTriad = ChordPattern([Interval.m3, Interval.d5]);

  /// A minor triad [ChordPattern].
  static const minorTriad = ChordPattern([Interval.m3, Interval.P5]);

  /// A major triad [ChordPattern].
  static const majorTriad = ChordPattern([Interval.M3, Interval.P5]);

  /// An augmented triad [ChordPattern].
  static const augmentedTriad = ChordPattern([Interval.M3, Interval.A5]);

  /// Creates a new [ChordPattern] from [intervalSteps].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.fromIntervalSteps([Interval.m3, Interval.M3])
  ///   == ChordPattern.minorTriad
  /// ChordPattern.fromIntervalSteps([Interval.M3, Interval.M3])
  ///   == ChordPattern.augmentedTriad
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
  /// ChordPattern.fromQuality(ImperfectQuality.augmented)
  ///   == ChordPattern.augmentedTriad
  /// ChordPattern.fromQuality(ImperfectQuality.minor)
  ///   == ChordPattern.minorTriad
  /// ```
  factory ChordPattern.fromQuality(ImperfectQuality quality) =>
      switch (quality) {
        ImperfectQuality.diminished => diminishedTriad,
        ImperfectQuality.minor => minorTriad,
        ImperfectQuality.major => majorTriad,
        ImperfectQuality.augmented => augmentedTriad,
        _ => majorTriad,
      };

  /// Parse [source] as a [ChordPattern] and return its value.
  ///
  /// If the [source] string does not contain a valid [ChordPattern], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.parse('maj7')
  ///   == ChordPattern.majorTriad.add7(ImperfectQuality.major)
  /// ChordPattern.parse('z') // throws a FormatException
  /// ```
  factory ChordPattern.parse(
    String source, {
    Parser<ChordPattern> parser = const ChordPatternNotation(),
  }) => parser.parse(source);

  /// The [Chord] built on top of [scalable].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.on(Note.c)
  ///   == const Chord([Note.c, Note.e, Note.g])
  /// ```
  Chord<T> on<T extends Scalable<T>>(T scalable) => Chord(
    _intervals.fold(
      [scalable],
      (chordItems, interval) => [...chordItems, scalable.transposeBy(interval)],
    ),
  );

  /// The root triad of this [ChordPattern].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().rootTriad == ChordPattern.majorTriad
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
  ///   == const [Interval.m7, Interval.M9]
  /// ```
  List<Interval> get modifiers => _intervals.skip(2).toList(growable: false);

  /// This [ChordPattern] with an [ImperfectQuality.diminished] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().diminished
  ///   == const ChordPattern([Interval.m3, Interval.d5, Interval.m7])
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
  ///   == const ChordPattern([Interval.m3, Interval.P5, Interval.m7])
  /// ```
  @override
  ChordPattern get minor =>
      ChordPattern([...minorTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.major] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.minorTriad.add7().major
  ///   == const ChordPattern([Interval.M3, Interval.P5, Interval.m7])
  /// ```
  @override
  ChordPattern get major =>
      ChordPattern([...majorTriad._intervals, ...modifiers]);

  /// This [ChordPattern] with an [ImperfectQuality.augmented] root triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().augmented
  ///   == const ChordPattern([Interval.M3, Interval.A5, Interval.m7])
  /// ```
  @override
  ChordPattern get augmented =>
      ChordPattern([...augmentedTriad._intervals, ...modifiers]);

  /// Returns this [ChordPattern] adding [interval].
  @override
  ChordPattern add(Interval interval, {Set<int>? replaceSizes}) {
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
  /// ChordPattern.majorTriad.size(3) == Interval.M3
  /// ChordPattern.diminishedTriad.size(5) == Interval.d5
  /// ChordPattern.minorTriad.add7().size(7) == Interval.m7
  /// ChordPattern.augmentedTriad.size(9) == null
  /// ```
  Interval? at(int size) =>
      intervals.firstWhereOrNull((interval) => interval.size == size);

  @override
  String toString({
    Formatter<ChordPattern> formatter = const ChordPatternNotation(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is ChordPattern &&
      const ListEquality<Interval>().equals(_intervals, other._intervals);

  @override
  int get hashCode => Object.hashAll(_intervals);
}

/// A notation system for [ChordPattern].
final class ChordPatternNotation extends NotationSystem<ChordPattern> {
  /// Creates a new [ChordPatternNotation].
  const ChordPatternNotation();

  @override
  String format(ChordPattern chordPattern) {
    final buffer = StringBuffer();

    if (chordPattern.isAugmented) {
      buffer.write('+');
    } else if (chordPattern.isMajor) {
      buffer.write('');
    } else if (chordPattern.isMinor) {
      buffer.write('-');
    }

    if (chordPattern.isDiminished) {
      final seventh = chordPattern.at(7);
      if (seventh != null) {
        buffer.write(switch (seventh.quality) {
          ImperfectQuality.diminished => 'º',
          ImperfectQuality.minor => 'ø',
          _ => '',
        });
      } else {
        buffer.write(' dim');
      }
    }

    if (chordPattern.intervals.first.size == 2) buffer.write('sus2');
    if (chordPattern.intervals.first.size == 4) buffer.write('sus4');

    for (final interval in chordPattern.modifiers) {
      buffer.write(switch (interval) {
        Interval(size: 7, quality: ImperfectQuality.major) => ' maj',
        Interval(size: 9 || 13, quality: ImperfectQuality.minor) => ' b',
        Interval(size: 9 || 13, quality: ImperfectQuality.augmented) => ' #',
        Interval(size: 11, quality: ImperfectQuality.augmented) => ' #',
        Interval(size: 11, quality: ImperfectQuality.diminished) => ' b',
        _ => '',
      });
      if (!chordPattern.isDiminished) buffer.write(interval.size);
    }

    return buffer.toString();
  }

  @override
  ChordPattern parse(String source) {
    var s = source.replaceAll(' ', '').toLowerCase();

    if (s == 'ø') return ChordPattern.diminishedTriad.add7();

    ChordPattern triad;
    if (s.startsWith('dim')) {
      triad = ChordPattern.diminishedTriad;
      s = s.substring(3);
    } else if (s.startsWith('+')) {
      triad = ChordPattern.augmentedTriad;
      s = s.substring(1);
    } else if (s.startsWith('-')) {
      triad = ChordPattern.minorTriad;
      s = s.substring(1);
    } else {
      triad = ChordPattern.majorTriad;
    }

    if (s.startsWith('maj7')) {
      return triad.add7(ImperfectQuality.major);
    } else if (s.startsWith('7')) {
      return triad.add7();
    }

    if (s.contains('sus2')) {
      triad = const ChordPattern([Interval.M2, Interval.P5]);
      s = s.replaceAll('sus2', '');
    } else if (s.contains('sus4')) {
      triad = const ChordPattern([Interval.P4, Interval.P5]);
      s = s.replaceAll('sus4', '');
    }

    return triad;
  }
}
