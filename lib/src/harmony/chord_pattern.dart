part of '../../music_notes.dart';

class ChordPattern {
  /// The intervals from the root note.
  final List<Interval> intervals;

  /// Creates a new [ChordPattern] from [intervals].
  const ChordPattern(this.intervals);

  static const augmentedTriad = ChordPattern([
    Interval.majorThird,
    Interval.augmentedFifth,
  ]);

  static const majorTriad = ChordPattern([
    Interval.majorThird,
    Interval.perfectFifth,
  ]);

  static const minorTriad = ChordPattern([
    Interval.minorThird,
    Interval.perfectFifth,
  ]);

  static const diminishedTriad = ChordPattern([
    Interval.minorThird,
    Interval.diminishedFifth,
  ]);

  /// Creates a new [ChordPattern] from [intervalSteps].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.intervalSteps([Interval.minorThird, Interval.majorThird])
  ///   == ChordPattern.minorTriad
  ///
  /// ChordPattern.intervalSteps([Interval.majorThird, Interval.majorThird])
  ///   == ChordPattern.augmentedTriad
  /// ```
  factory ChordPattern.intervalSteps(List<Interval> intervalSteps) =>
      ChordPattern(
        intervalSteps.skip(1).fold(
          [intervalSteps.first],
          (steps, interval) => [...steps, interval + steps.last],
        ),
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
        ImperfectQuality.augmented => augmentedTriad,
        ImperfectQuality.major => majorTriad,
        ImperfectQuality.minor => minorTriad,
        ImperfectQuality.diminished => diminishedTriad,
        _ => majorTriad,
      };

  /// Returns the [Chord<T>] from [scalable].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.on(Note.c)
  ///   == const Chord([Note.c, Note.e, Note.g])
  /// ```
  Chord<T> on<T extends Scalable<T>>(T scalable) => Chord(
        intervals.fold(
          [scalable],
          (chordItems, interval) =>
              [...chordItems, scalable.transposeBy(interval)],
        ),
      );

  /// Returns the root triad of this [ChordPattern].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().rootTriad == ChordPattern.majorTriad
  /// ```
  ChordPattern get rootTriad => ChordPattern(intervals.sublist(0, 2));

  /// Whether this [ChordPattern] is [ImperfectQuality.augmented].
  bool get isAugmented => rootTriad == augmentedTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.major].
  bool get isMajor => rootTriad == majorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.minor].
  bool get isMinor => rootTriad == minorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.diminished].
  bool get isDiminished => rootTriad == diminishedTriad;

  /// Returns the list of modifier [Interval]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().modifiers
  ///   == const [Interval.minorSeventh, Interval.majorNinth]
  /// ```
  List<Interval> get modifiers => intervals.skip(2).toList();

  /// Returns a new [ChordPattern] with an [ImperfectQuality.augmented] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().augmented
  ///   == const ChordPattern([
  ///        Interval.majorThird,
  ///        Interval.augmentedFifth,
  ///        Interval.minorSeventh
  ///      ])
  /// ```
  ChordPattern get augmented =>
      ChordPattern([...augmentedTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] with an [ImperfectQuality.major] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.minorTriad.add7().major
  ///   == const ChordPattern([
  ///        Interval.majorThird,
  ///        Interval.perfectFifth,
  ///        Interval.minorSeventh
  ///      ])
  /// ```
  ChordPattern get major =>
      ChordPattern([...majorTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] with an [ImperfectQuality.minor] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().minor
  ///   == const ChordPattern([
  ///        Interval.minorThird,
  ///        Interval.perfectFifth,
  ///        Interval.minorSeventh
  ///      ])
  /// ```
  ChordPattern get minor =>
      ChordPattern([...minorTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] with an [ImperfectQuality.diminished] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().diminished
  ///   == const ChordPattern([
  ///        Interval.minorThird,
  ///        Interval.diminishedFifth,
  ///        Interval.minorSeventh
  ///      ])
  /// ```
  ChordPattern get diminished =>
      ChordPattern([...diminishedTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] with a suspended [Interval.majorSecond].
  ChordPattern sus2() => add(Interval.majorSecond, replaceSizes: const [3, 4]);

  /// Returns a new [ChordPattern] with a suspended [Interval.perfectFourth].
  ChordPattern sus4() =>
      add(Interval.perfectFourth, replaceSizes: const [2, 3]);

  /// Returns a new [ChordPattern] adding a [quality] 6th.
  ChordPattern add6([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(6, quality));

  /// Returns a new [ChordPattern] adding a [quality] 7th.
  ChordPattern add7([ImperfectQuality quality = ImperfectQuality.minor]) =>
      add(Interval.imperfect(7, quality));

  /// Returns a new [ChordPattern] adding a [quality] 9th.
  ChordPattern add9([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(9, quality));

  /// Returns a new [ChordPattern] adding an [quality] 11th.
  ChordPattern add11([PerfectQuality quality = PerfectQuality.perfect]) =>
      add(Interval.perfect(11, quality));

  /// Returns a new [ChordPattern] adding a [quality] 13th.
  ChordPattern add13([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(13, quality));

  /// Returns a new [ChordPattern] adding [interval].
  ChordPattern add(Interval interval, {List<int>? replaceSizes}) {
    final sizesToReplace = [interval.size, ...?replaceSizes];
    final filteredIntervals = intervals.whereNot(
      (chordInterval) => sizesToReplace.contains(chordInterval.size),
    );

    return ChordPattern(
      // Keep the intervals sorted after these operations.
      SplayTreeSet.of([...filteredIntervals, interval]).toList(),
    );
  }

  /// Returns the abbreviated quality representing this [ChordPattern].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.abbreviation == 'maj.'
  /// ChordPattern.diminishedTriad.abbreviation == 'dim.'
  /// ```
  String get abbreviation => switch (this) {
        final chord when chord.isAugmented => 'aug.',
        final chord when chord.isMajor => 'maj.',
        final chord when chord.isMinor => 'min.',
        final chord when chord.isDiminished => 'dim.',
        _ => '?',
      };

  @override
  String toString() => '$abbreviation (${intervals.join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is ChordPattern &&
      const ListEquality<Interval>().equals(intervals, other.intervals);

  @override
  int get hashCode => Object.hashAll(intervals);
}
