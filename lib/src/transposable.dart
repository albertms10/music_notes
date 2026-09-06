import 'interval/interval.dart';

/// An interface for values that can be shifted up or down by a musical
/// [Interval] while remaining the same kind of value, e.g. moving a
/// [Note], [Pitch], [Chord], or [Scale] to a new tonal center.
///
/// See [Transposition](https://en.wikipedia.org/wiki/Transposition_(music)).
/// A negative (descending) [Interval] transposes downward.
// ignore: one_member_abstracts
abstract interface class Transposable<T> {
  /// This [T] transposed by [interval]; negative (descending) intervals
  /// move it down instead of up.
  T transposeBy(Interval interval);
}
