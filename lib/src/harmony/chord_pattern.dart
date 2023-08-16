part of '../../music_notes.dart';

/// A musical chord pattern.
@immutable
class ChordPattern with Chordable<ChordPattern> {
  /// The intervals from the root note.
  final List<Interval> intervals;

  /// Creates a new [ChordPattern] from [intervals].
  const ChordPattern(this.intervals);

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
  /// ChordPattern.intervalSteps([Interval.m3, Interval.M3])
  ///   == ChordPattern.minorTriad
  /// ChordPattern.intervalSteps([Interval.M3, Interval.M3])
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
        ImperfectQuality.diminished => diminishedTriad,
        ImperfectQuality.minor => minorTriad,
        ImperfectQuality.major => majorTriad,
        ImperfectQuality.augmented => augmentedTriad,
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

  /// Whether this [ChordPattern] is [ImperfectQuality.diminished].
  bool get isDiminished => rootTriad == diminishedTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.minor].
  bool get isMinor => rootTriad == minorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.major].
  bool get isMajor => rootTriad == majorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.augmented].
  bool get isAugmented => rootTriad == augmentedTriad;

  /// Returns the list of modifier [Interval]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().add9().modifiers
  ///   == const [Interval.m7, Interval.M9]
  /// ```
  List<Interval> get modifiers => intervals.skip(2).toList();

  /// Returns a new [ChordPattern] with an [ImperfectQuality.diminished] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().diminished
  ///   == const ChordPattern([Interval.m3, Interval.d5, Interval.m7])
  /// ```
  @override
  ChordPattern get diminished =>
      ChordPattern([...diminishedTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] with an [ImperfectQuality.minor] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().minor
  ///   == const ChordPattern([Interval.m3, Interval.P5, Interval.m7])
  /// ```
  @override
  ChordPattern get minor =>
      ChordPattern([...minorTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] with an [ImperfectQuality.major] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.minorTriad.add7().major
  ///   == const ChordPattern([Interval.M3, Interval.P5, Interval.m7])
  /// ```
  @override
  ChordPattern get major =>
      ChordPattern([...majorTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] with an [ImperfectQuality.augmented] root
  /// triad.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.add7().augmented
  ///   == const ChordPattern([Interval.M3, Interval.A5, Interval.m7])
  /// ```
  @override
  ChordPattern get augmented =>
      ChordPattern([...augmentedTriad.intervals, ...modifiers]);

  /// Returns a new [ChordPattern] adding [interval].
  @override
  ChordPattern add(Interval interval, {List<int>? replaceSizes}) {
    final sizesToReplace = [interval.size, ...?replaceSizes];
    final filteredIntervals = intervals.whereNot(
      (chordInterval) => sizesToReplace.contains(chordInterval.size),
    );

    return ChordPattern([...filteredIntervals, interval]..sort());
  }

  /// Returns the abbreviated quality representing this [ChordPattern].
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.abbreviation == 'maj.'
  /// ChordPattern.diminishedTriad.abbreviation == 'dim.'
  /// ```
  String get abbreviation => switch (this) {
        final chord when chord.isDiminished => 'dim.',
        final chord when chord.isMinor => 'min.',
        final chord when chord.isMajor => 'maj.',
        final chord when chord.isAugmented => 'aug.',
        _ => '?',
      };

  /// Returns the [Interval] from [intervals] that matches the given [size], if
  /// any.
  ///
  /// Example:
  /// ```dart
  /// ChordPattern.majorTriad.size(3) == Interval.M3
  /// ChordPattern.diminishedTriad.size(5) == Interval.d5
  /// ChordPattern.minorTriad.add7().size(7) == Interval.m7
  /// ChordPattern.augmentedTriad.size(9) == null
  /// ```
  Interval? size(int size) =>
      intervals.firstWhereOrNull((interval) => interval.size == size);

  /// Returns the symbol of this [ChordPattern].
  String? get symbol {
    final buffer = StringBuffer();
    if (isAugmented) buffer.write('+');
    if (isMajor) buffer.write('');
    if (isMinor) buffer.write('min');

    if (isDiminished) {
      final seventh = size(7);
      if (seventh != null) {
        buffer.write(
          switch (seventh.quality) {
            ImperfectQuality.diminished => 'º',
            ImperfectQuality.minor => 'ø',
            _ => '',
          },
        );
      } else {
        buffer.write('dim');
      }
    }

    if (intervals.first.size == 2) buffer.write('sus2');
    if (intervals.first.size == 4) buffer.write('sus4');

    for (final interval in modifiers) {
      buffer.write(
        switch (interval) {
          Interval(size: 7, quality: ImperfectQuality.major) => ' maj',
          Interval(size: 9 || 13, quality: ImperfectQuality.minor) => ' b',
          Interval(size: 9 || 13, quality: ImperfectQuality.augmented) => ' #',
          Interval(size: 11, quality: ImperfectQuality.augmented) => ' #',
          Interval(size: 11, quality: ImperfectQuality.diminished) => ' b',
          _ => ' ',
        },
      );
      if (!isDiminished) buffer.write(interval.size);
    }

    return buffer.toString().trim();
  }

  @override
  String toString() => '$abbreviation (${intervals.join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is ChordPattern &&
      const ListEquality<Interval>().equals(intervals, other.intervals);

  @override
  int get hashCode => Object.hashAll(intervals);
}
