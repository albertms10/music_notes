import 'package:collection/collection.dart'
    show ListEquality, UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../chordable.dart';
import '../interval/interval.dart';
import '../interval/quality.dart';
import '../interval/size.dart';
import '../notation/notation_system.dart';
import '../scalable.dart';
import '../transposable.dart';
import '../tuning/equal_temperament.dart';
import 'chord_normalization.dart';
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
    implements Transposable<Chord<T>>, Formattable<Chord<T>> {
  final List<T> _items;

  /// The [Scalable] items this [Chord] is built of.
  List<T> get items => UnmodifiableListView(_items);

  /// Creates a new [Chord] from [_items].
  const Chord(this._items);

  /// The bass [Scalable] of this [Chord].
  ///
  /// Example:
  /// ```dart
  /// const Chord<Note>([.c, .e, .g]).bass == .c
  /// const Chord<Note>([.e, .g, .c]).bass == .e
  /// const Chord<Note>([.g, .c, .e]).bass == .g
  /// ```
  T get bass => _items.first;

  /// The root [Scalable] of this [Chord].
  /// Example:
  /// ```dart
  ///
  /// const Chord<Note>([.c, .e, .g]).root == .c
  /// const Chord<Note>([.e, .g, .c]).root == .c
  /// const Chord<Note>([.g, .c, .e]).root == .c
  /// ```
  T get root => normalized._items.first;

  /// The normalized version of this [Chord], in root position with enharmonic
  /// duplicates removed.
  ///
  /// Example:
  /// ```dart
  /// Chord<Note>([.c, .e, .g, .c]).normalized
  ///   == const Chord<Note>([.c, .e, .g])
  /// Chord<Note>([.e, .c, .g]).normalized == const Chord<Note>([.c, .e, .g])
  /// Chord<Note>([.b.flat, .c, .g, .e]).normalized
  ///   == Chord<Note>([.c, .e, .g, .b.flat])
  /// Chord<Note>([.a, .c, .f.sharp, .e.flat]).normalized
  ///   == Chord<Note>([.f.sharp, .a, .c, .e.flat])
  /// ```
  Chord<T> get normalized {
    if (_items.isEmpty) return Chord(const []);

    final seenPitchClasses = <int>{};
    final unique = _items
        .where(
          (item) => seenPitchClasses.add(item.semitones % chromaticDivisions),
        )
        .toList(growable: false);

    if (unique.length == 1) return Chord(unique);

    ({
      Chord<T> chord,
      int sizePenalty,
      int qualityPenalty,
      int templatePriority,
      int span,
    })
    buildCandidate(T root) {
      final pairs = unique
          .where((item) => item != root)
          .map((item) => (item: item, interval: root.interval(item)))
          .toList(growable: false);
      final normalized = normalizeIntervalsByTemplate(
        pairs.map((pair) => pair.interval).toList(growable: false),
      );

      return (
        chord: Chord([
          root,
          ...normalized.order.map((index) => pairs[index].item),
        ]),
        sizePenalty: normalized.sizePenalty,
        qualityPenalty: normalized.qualityPenalty,
        templatePriority: normalized.templatePriority,
        span: normalized.span,
      );
    }

    var best = buildCandidate(unique.first);

    for (final root in unique.skip(1)) {
      final candidate = buildCandidate(root);
      if (isBetterNormalizationScore(
        sizePenalty: candidate.sizePenalty,
        qualityPenalty: candidate.qualityPenalty,
        templatePriority: candidate.templatePriority,
        span: candidate.span,
        bestSizePenalty: best.sizePenalty,
        bestQualityPenalty: best.qualityPenalty,
        bestTemplatePriority: best.templatePriority,
        bestSpan: best.span,
      )) {
        best = candidate;
      }
    }

    return best.chord;
  }

  /// The [ChordPattern] for this [Chord].
  ///
  /// Example:
  /// ```dart
  /// const Chord<Note>([.a, .c, .e]).pattern == .minorTriad
  /// const Chord<Note>([.g, .b, .d, .f, .a]).pattern
  ///   == .majorTriad.add7().add9()
  /// ```
  ChordPattern get pattern =>
      // The pattern is calculated based on the intervals between the notes
      // rather than from the root note. This approach helps differentiate
      // compound intervals (e.g., [Interval.M9]) from simple intervals
      // (e.g., [Interval.M2]) in chords where distance is not explicit
      // (so, [Note] based chords rather than [Pitch] based).
      .fromIntervalSteps(_items.intervalSteps);

  /// The modifier [T]s from the root note.
  ///
  /// Example:
  /// ```dart
  /// Note.a.majorTriad.add7().add9().modifiers == const <Note>[.g, .b]
  /// ```
  List<T> get modifiers => _items.skip(3).toList(growable: false);

  /// The next inversion of this [Chord].
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.inverted == Chord<Note>([.e, .g, .c])
  /// Note.c.majorTriad.inverted.inverted == Chord<Note>([.g, .c, .e])
  /// ```
  Chord<T> get inverted =>
      Chord(_items.skip(1).followedBy([_items.first]).toList(growable: false));

  /// This [Chord] with an [ImperfectQuality.diminished] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().diminished
  ///   == Chord<Note>([.c, .e.flat, .g.flat, .b.flat])
  /// ```
  @override
  Chord<T> get diminished => pattern.diminished.on(root);

  /// This [Chord] with an [ImperfectQuality.minor] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().minor == Chord<Note>([.c, .e.flat, .g, .b.flat])
  /// ```
  @override
  Chord<T> get minor => pattern.minor.on(root);

  /// This [Chord] with an [ImperfectQuality.major] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.minorTriad.add7().major == Chord<Note>([.c, .e, .g, .b.flat])
  /// ```
  @override
  Chord<T> get major => pattern.major.on(root);

  /// This [Chord] with an [ImperfectQuality.augmented] root triad.
  ///
  /// Example:
  /// ```dart
  /// Note.c.majorTriad.add7().augmented
  ///   == Chord<Note>([.c, .e, .g.sharp, .b.flat])
  /// ```
  @override
  Chord<T> get augmented => pattern.augmented.on(root);

  /// Returns this [Chord] adding [interval].
  @override
  Chord<T> add(Interval interval, {Set<Size>? replaceSizes}) =>
      pattern.add(interval, replaceSizes: replaceSizes).on(bass);

  /// Transposes this [Chord] by [interval].
  ///
  /// Example:
  /// ```dart
  /// const Chord<Note>([.a, .c, .e]).transposeBy(.m3)
  ///   == Chord<Note>([.c, .e.flat, .g])
  ///
  /// ChordPattern.majorTriad.on(Note.g.inOctave(4)).transposeBy(.M3)
  ///   == Chord([
  ///        Note.b.inOctave(4),
  ///        Note.d.sharp.inOctave(5),
  ///        Note.f.sharp.inOctave(5)
  ///      ])
  /// ```
  @override
  Chord<T> transposeBy(Interval interval) =>
      Chord(_items.transposeBy(interval).toList(growable: false));

  @override
  String format() => '${root.format()}${pattern.format()}';

  @override
  String toString() => '$runtimeType(items: ${items.prettyToString()})';

  @override
  bool operator ==(Object other) =>
      other is Chord<T> && ListEquality<T>().equals(_items, other._items);

  @override
  int get hashCode => Object.hashAll(_items);
}
