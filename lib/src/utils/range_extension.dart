import '../notation_system.dart';
import '../note/pitch.dart';
import '../range.dart';
import '../scalable.dart';
import './iterable_extension.dart';

/// A Range record extension.
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

  /// Fills this range of values between `from` and `to` (`to` not included).
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

/// A Scalable range record extension.
extension ScalableRangeExtension<E extends Scalable<E>> on Range<E> {
  /// Fills this range of values between `from` and `to` (`to` not included).
  ///
  /// Example:
  /// ```dart
  /// (from: Note.c, to: Note.e.flat).explode()
  ///   == <Note>[.c, .d.flat, .d, .e.flat]
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

/// A compressed range extension.
extension RangeIterableExtension<E> on Iterable<Range<E>> {
  /// Parses [source] as a compressed range list.
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
    List<Parser<E>>? chain,
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

  /// Formats this compressed range list into a readable string representation.
  ///
  /// The function expects the given [E] type to have a proper implementation
  /// of `operator ==`.
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
    Formatter<E>? formatter,
  }) => map(
    (range) => [range.from, if (range.from != range.to) range.to]
        .map(formatter?.format ?? (element) => element.toString())
        .join(rangeSeparator),
  ).join(nonConsecutiveSeparator);
}
