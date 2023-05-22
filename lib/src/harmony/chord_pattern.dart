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

  /// Returns the [Chord<T>] from [scalable].
  Chord<T> from<T extends Scalable<T>>(T scalable) => Chord(
        intervals.fold(
          [scalable],
          (chordItems, interval) =>
              [...chordItems, scalable.transposeBy(interval)],
        ),
      );

  /// Returns the root triad of this [ChordPattern].
  ChordPattern get rootTriad => ChordPattern(intervals.sublist(0, 2));

  /// Whether this [ChordPattern] is [ImperfectQuality.major].
  bool get isMajor => rootTriad == majorTriad;

  /// Whether this [ChordPattern] is [ImperfectQuality.minor].
  bool get isMinor => rootTriad == minorTriad;

  /// Returns a new [ChordPattern] adding a suspended [quality] 2nd.
  ChordPattern sus2([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(2, quality));

  /// Returns a new [ChordPattern] adding a suspended [quality] 4th.
  ChordPattern sus4([PerfectQuality quality = PerfectQuality.perfect]) =>
      add(Interval.perfect(4, quality));

  /// Returns a new [ChordPattern] adding a [quality] 6th.
  ChordPattern add6([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(7, quality));

  /// Returns a new [ChordPattern] adding a [quality] 7th.
  ChordPattern add7([ImperfectQuality quality = ImperfectQuality.minor]) =>
      add(Interval.imperfect(7, quality));

  /// Returns a new [ChordPattern] adding a [quality] 9th.
  ChordPattern add9([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(9, quality));

  /// Returns a new [ChordPattern] adding an [quality] 11th.
  ChordPattern add11([ImperfectQuality quality = ImperfectQuality.minor]) =>
      add(Interval.imperfect(11, quality));

  /// Returns a new [ChordPattern] adding a [quality] 13th.
  ChordPattern add13([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(13, quality));

  /// Returns a new [ChordPattern] adding [interval].
  ChordPattern add(Interval interval) {
    final filteredIntervals = intervals.toList()
      ..removeWhere((chordInterval) => chordInterval.size == interval.size);

    return ChordPattern(
      // Keep the intervals sorted after the addition.
      SplayTreeSet.of([...filteredIntervals, interval]).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChordPattern &&
      const ListEquality<Interval>().equals(intervals, other.intervals);

  @override
  int get hashCode => Object.hashAll(intervals);
}
