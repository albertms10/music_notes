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
  /// This [T] with an [ImperfectQuality.diminished] root triad.
  T get diminished;

  /// This [T] with an [ImperfectQuality.minor] root triad.
  T get minor;

  /// This [T] with an [ImperfectQuality.major] root triad.
  T get major;

  /// This [T] with an [ImperfectQuality.augmented] root triad.
  T get augmented;

  /// Returns this [T] with a suspended [Interval.M2].
  T sus2() => add(.M2, replaceSizes: const {.third, .fourth});

  /// Returns this [T] with a suspended [Interval.P4].
  T sus4() => add(.P4, replaceSizes: const {.second, .third});

  /// Returns this [T] adding a [quality] 6th.
  T add6([ImperfectQuality quality = .major]) =>
      add(.imperfect(.sixth, quality));

  /// Returns this [T] adding a [quality] 7th.
  T add7([ImperfectQuality quality = .minor]) =>
      add(.imperfect(.seventh, quality));

  /// Returns this [T] adding a [quality] 9th.
  T add9([ImperfectQuality quality = .major]) =>
      add(.imperfect(.ninth, quality));

  /// Returns this [T] adding an [quality] 11th.
  T add11([PerfectQuality quality = .perfect]) =>
      add(.perfect(.eleventh, quality));

  /// Returns this [T] adding a [quality] 13th.
  T add13([ImperfectQuality quality = .major]) =>
      add(.imperfect(.thirteenth, quality));

  /// Returns this [T] adding [interval].
  T add(Interval interval, {Set<Size>? replaceSizes});
}
