import '../notation_system/notation_system.dart';
import '../pitch/pitch.dart';
import '../range.dart';
import '../scalable.dart';
import 'iterable_extension.dart';

/// Expands a [Range] back into the individual values it spans — the
/// inverse of [IterableExtension.compact] — generalized over an explicit
/// [nextValue] step function and [compare] ordering.
extension RangeExtension<E> on Range<E> {
  List<E> _explode({
    required E Function(E current) nextValue,
    required Comparator<E> compare,
  }) {
    if (from == to) return const [];

    assert(
      E != Pitch || compare(from, to) <= 0,
      'To must be greater than or equal to from.',
    );

    final set = {from};
    var temp = from;
    while (compare(nextValue(temp), to) != 0) {
      temp = nextValue(temp);
      if (set.contains(temp)) break;
      set.add(temp);
    }

    return set.toList(growable: false);
  }

  /// Every value from [Range.from] up to (but not including)
  /// [Range.to], stepping with [nextValue] and ordering with [compare].
  ///
  /// Example:
  /// ```dart
  /// const (from: 1, to: 10).explode(
  ///   nextValue: (current) => current + 1,
  ///   compare: Comparable.compare,
  /// ) == const [1, 2, 3, 4, 5, 6, 7, 8, 9]
  /// ```
  /// ---
  /// See also:
  /// * [IterableExtension.compact] for the inverse operation.
  List<E> explode({
    required E Function(E current) nextValue,
    required Comparator<E> compare,
  }) => _explode(nextValue: nextValue, compare: compare);
}

/// [RangeExtension.explode] specialized for [Scalable] values, defaulting
/// to chromatic stepping ([Scalable.chromaticMotion]) and enharmonic
/// comparison ([Scalable.compareEnharmonically]) — turning a compact
/// "C–E♭" style range back into every chromatic pitch it covers.
extension ScalableRangeExtension<E extends Scalable<E>> on Range<E> {
  /// Every pitch from [Range.from] up to (but not including) [Range.to],
  /// stepping chromatically by default.
  ///
  /// Example:
  /// ```dart
  /// (from: Note.c, to: Note.e.flat).explode() == const <Note>[.c, .d.flat, .d]
  /// ```
  /// ---
  /// See also:
  /// * [IterableExtension.compact] for the inverse operation.
  List<E> explode({E Function(E current)? nextValue, Comparator<E>? compare}) =>
      _explode(
        nextValue: nextValue ?? Scalable.chromaticMotion,
        compare: compare ?? Scalable.compareEnharmonically,
      );
}

/// Parsing and formatting for a list of [Range]s as a compact,
/// comma-separated notation (e.g. `C–E♭, G♯–B`) — the written form of a
/// [IterableExtension.compact] result.
extension RangeIterableExtension<E> on Iterable<Range<E>> {
  /// Parses [source] as a comma-separated list of `from`–`to` spans (each
  /// parsed with [chain] if given, or kept as raw strings of type [E]
  /// otherwise).
  ///
  /// Example:
  /// ```dart
  /// RangeIterableExtension.parse('C–E♭, G♯–B', chain: Note.parsers) == [
  ///   (from: Note.c, to: Note.e.flat),
  ///   (from: Note.g.sharp, to: Note.b),
  /// ]
  /// ```
  static List<Range<E>> parse<E>(
    String source, {
    String rangeSeparator = '–',
    String nonConsecutiveSeparator = ', ',
    List<StringParser<E>>? chain,
  }) => source
      .split(nonConsecutiveSeparator)
      .map((range) {
        final List(:first, :last) = range.split(rangeSeparator);
        final from = first.trim();
        final to = last.trim();

        return (
          from: (chain?.parse(from) ?? from) as E,
          to: (chain?.parse(to) ?? to) as E,
        );
      })
      .toList(growable: false);

  /// Renders this list of [Range]s as a comma-separated string, collapsing
  /// a single-value range (where `from == to`) down to just that value.
  ///
  /// [E] must have a proper `operator ==` for the single-value collapse to
  /// be detected correctly.
  ///
  /// Example:
  /// ```dart
  /// [
  ///   (from: Note.c, to: Note.e.flat),
  ///   (from: Note.g.sharp, to: Note.b),
  /// ].format() == 'C–E♭, G♯–B'
  /// ```
  String format({
    String rangeSeparator = '–',
    String nonConsecutiveSeparator = ', ',
    StringFormatter<E>? formatter,
  }) => map(
    (range) => [range.from, if (range.from != range.to) range.to]
        .map(
          formatter?.format ??
              (range.from is Formattable<E>
                  ? (element) => (element as Formattable<E>).format()
                  : (element) => element.toString()),
        )
        .join(rangeSeparator),
  ).join(nonConsecutiveSeparator);
}
