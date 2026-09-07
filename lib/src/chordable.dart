import 'chord/chord.dart';
import 'interval/interval.dart';
import 'quality/quality.dart';
import 'size/size.dart';

/// A mixin providing the shared vocabulary for building and altering
/// tertian chords: swapping the root triad's quality, suspending its
/// third, and stacking extensions (6th through 13th) above it.
///
/// Implemented by both [Chord] (a chord built on a specific root note) and
/// `ChordPattern` (its root-agnostic interval shape), so the same fluent
/// API (`.add7().add9()`) works whether or not a root has been chosen yet.
///
/// ---
/// See also:
/// * [Chord].
mixin Chordable<T> {
  /// This [T] with its root triad recast as [ImperfectQuality.diminished]
  /// (e.g. a major triad becomes diminished, its extensions untouched).
  T get diminished;

  /// This [T] with its root triad recast as [ImperfectQuality.minor].
  T get minor;

  /// This [T] with its root triad recast as [ImperfectQuality.major].
  T get major;

  /// This [T] with its root triad recast as [ImperfectQuality.augmented].
  T get augmented;

  /// This [T] with its third replaced by a suspended [Interval.M2] (a
  /// "sus2" chord).
  T sus2() => add(.M2, replaceSizes: const {.third, .fourth});

  /// This [T] with its third replaced by a suspended [Interval.P4] (a
  /// "sus4" chord).
  T sus4() => add(.P4, replaceSizes: const {.second, .third});

  /// This [T] with a 6th of [quality] added above the root.
  T add6([ImperfectQuality quality = .major]) =>
      add(.imperfect(.sixth, quality));

  /// This [T] with a 7th of [quality] added above the root.
  T add7([ImperfectQuality quality = .minor]) =>
      add(.imperfect(.seventh, quality));

  /// This [T] with a 9th of [quality] added above the root.
  T add9([ImperfectQuality quality = .major]) =>
      add(.imperfect(.ninth, quality));

  /// This [T] with an 11th of [quality] added above the root.
  T add11([PerfectQuality quality = .perfect]) =>
      add(.perfect(.eleventh, quality));

  /// This [T] with a 13th of [quality] added above the root.
  T add13([ImperfectQuality quality = .major]) =>
      add(.imperfect(.thirteenth, quality));

  /// This [T] with [interval] added above the root, replacing any existing
  /// member(s) at [replaceSizes] (or at [interval]'s own [Size] if
  /// [replaceSizes] is omitted).
  T add(Interval interval, {Set<Size>? replaceSizes});
}
