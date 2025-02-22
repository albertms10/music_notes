import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../chordable.dart';
import '../interval/interval.dart';
import '../interval/quality.dart';
import '../scalable.dart';
import '../transposable.dart';
import 'chord_pattern.dart';

/// A musical chord.
///
/// ---
/// See also:
/// * [ChordPattern].
/// * [Scalable].
/// * [Chordable].
@immutable
class Chord<T extends Scalable<T>>
    with Chordable<Chord<T>>
    implements Transposable<Chord<T>> {
  final List<T> _items;

  /// The [Scalable] items this [Chord] is built of.
  List<T> get items => UnmodifiableListView(_items);

  /// Creates a new [Chord] from [_items].
  const Chord(this._items);

  /// The root [Scalable] of this [Chord].
  T get root => _items.first;

  /// The [ChordPattern] for this [Chord].
  ///
  /// Example:
  /// ```dart
  /// const Chord([Note.a, Note.c, Note.e]).pattern == ChordPattern.minorTriad
  /// const Chord([Note.g, Note.b, Note.d, Note.f, Note.a]).pattern
  ///   == ChordPattern.majorTriad.add7().add9()
  /// ```
  ChordPattern get pattern =>
      // The pattern is calculated based on the intervals between the notes
      // rather than from the root note. This approach helps differentiate
      // compound intervals (e.g., [Interval.M9]) from simple intervals
      // (e.g., [Interval.M2]) in chords where distance is not explicit
      // (so, [Note] based chords rather than [Pitch] based).
      ChordPattern.fromIntervalSteps(_items.intervalSteps);

  /// The modifier [T]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// Note.a.majorTriad.add7().add9().modifiers == const [Note.g, Note.b]
  /// ```
  List<T> get modifiers => _items.skip(3).toList(growable: false);

  /// This [Chord] with an [ImperfectQuality.diminished] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().diminished
  ///   == Chord([Note.c, Note.e.flat, Note.g.flat, Note.b.flat])
  /// ```
  @override
  Chord<T> get diminished => pattern.diminished.on(root);

  /// This [Chord] with an [ImperfectQuality.minor] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().minor
  ///   == Chord([Note.c, Note.e.flat, Note.g, Note.b.flat])
  /// ```
  @override
  Chord<T> get minor => pattern.minor.on(root);

  /// This [Chord] with an [ImperfectQuality.major] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.minorTriad.add7().major
  ///   == Chord([Note.c, Note.e, Note.g, Note.b.flat])
  /// ```
  @override
  Chord<T> get major => pattern.major.on(root);

  /// This [Chord] with an [ImperfectQuality.augmented] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().augmented
  ///   == Chord([Note.c, Note.e, Note.g.sharp, Note.b.flat])
  /// ```
  @override
  Chord<T> get augmented => pattern.augmented.on(root);

  /// Returns this [Chord] adding [interval].
  @override
  Chord<T> add(Interval interval, {Set<int>? replaceSizes}) =>
      pattern.add(interval, replaceSizes: replaceSizes).on(root);

  /// Transposes this [Chord] by [interval].
  ///
  /// Example:
  /// ```dart
  /// const Chord([Note.a, Note.c, Note.e]).transposeBy(Interval.m3)
  ///   == Chord([Note.c, Note.e.flat, Note.g])
  ///
  /// ChordPattern.majorTriad.on(Note.g.inOctave(4))
  ///   .transposeBy(Interval.M3)
  ///     == Chord([
  ///          Note.b.inOctave(4),
  ///          Note.d.sharp.inOctave(5),
  ///          Note.f.sharp.inOctave(5)
  ///        ])
  /// ```
  @override
  Chord<T> transposeBy(Interval interval) =>
      Chord(_items.transposeBy(interval).toList(growable: false));

  @override
  String toString() => '$root ${pattern.abbreviation} (${_items.join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is Chord<T> && ListEquality<T>().equals(_items, other._items);

  @override
  int get hashCode => Object.hashAll(_items);
}
