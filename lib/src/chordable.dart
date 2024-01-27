import 'harmony/chord.dart';
import 'interval/interval.dart';
import 'interval/quality.dart';
import 'interval/size.dart';

/// A mixin for items that can form chords.
///
/// ---
/// See also:
/// * [Chord].
mixin Chordable<T> {
  /// Returns a new [T] with an [ImperfectQuality.diminished] root triad.
  T get diminished;

  /// Returns a new [T] with an [ImperfectQuality.minor] root triad.
  T get minor;

  /// Returns a new [T] with an [ImperfectQuality.major] root triad.
  T get major;

  /// Returns a new [T] with an [ImperfectQuality.augmented] root triad.
  T get augmented;

  /// Returns a new [T] with a suspended [Interval.M2].
  T sus2() => add(Interval.M2, replaceSizes: const {3, 4});

  /// Returns a new [T] with a suspended [Interval.P4].
  T sus4() => add(Interval.P4, replaceSizes: const {2, 3});

  /// Returns a new [T] adding a [quality] 6th.
  T add6([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(Size.sixth, quality));

  /// Returns a new [T] adding a [quality] 7th.
  T add7([ImperfectQuality quality = ImperfectQuality.minor]) =>
      add(Interval.imperfect(Size.seventh, quality));

  /// Returns a new [T] adding a [quality] 9th.
  T add9([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(Size.ninth, quality));

  /// Returns a new [T] adding an [quality] 11th.
  T add11([PerfectQuality quality = PerfectQuality.perfect]) =>
      add(Interval.perfect(Size.eleventh, quality));

  /// Returns a new [T] adding a [quality] 13th.
  T add13([ImperfectQuality quality = ImperfectQuality.major]) =>
      add(Interval.imperfect(Size.thirteenth, quality));

  /// Returns a new [T] adding [interval].
  T add(Interval interval, {Set<int>? replaceSizes});
}
