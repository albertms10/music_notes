import '../note/pitch.dart';
import '../scalable.dart';
import './iterable_extension.dart';

/// A representation of a range between `from` and `to`.
typedef Range<E> = ({E from, E to});

/// A Range record extension.
extension RangeExtension<E> on Range<E> {
  List<E> _explode({
    required E Function(E current) nextValue,
    required int Function(E a, E b) compare,
  }) {
    assert(
      E != Pitch || compare(from, to) <= 0,
      'To must be greater than or equal to from.',
    );

    final set = {from};
    var temp = from;
    while (compare(temp, to) != 0) {
      temp = nextValue(temp);
      if (set.contains(temp)) break;
      set.add(temp);
    }

    return set.toList();
  }

  /// Fills this range of values between `from` and `to`.
  ///
  /// Example:
  /// ```dart
  /// const (from: 1, to: 10).explode(
  ///   nextValue: (current) => current + 1,
  ///   compare: Comparable.compare,
  /// ) == const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  /// ```
  /// ---
  /// See also:
  /// * [IterableExtension.compact] for the inverse operation.
  List<E> explode({
    required E Function(E current) nextValue,
    required int Function(E a, E b) compare,
  }) =>
      _explode(nextValue: nextValue, compare: compare);
}

/// A Scalable range record extension.
extension ScalableRangeExtension<E extends Scalable<E>> on Range<E> {
  /// Fills this range of values between `from` and `to`.
  ///
  /// Example:
  /// ```dart
  /// (from: Note.c, to: Note.e.flat).explode()
  ///   == const [Note.c, Note.d.flat, Note.d, Note.e.flat]
  /// ```
  /// ---
  /// See also:
  /// * [IterableExtension.compact] for the inverse operation.
  List<E> explode({
    E Function(E current)? nextValue,
    int Function(E a, E b)? compare,
  }) =>
      _explode(
        nextValue: nextValue ?? Scalable.chromaticMotion,
        compare: compare ?? Scalable.compareEnharmonically,
      );
}

/// A compressed range extension.
extension RangeIterableExtension<E> on Iterable<Range<E>> {
  /// Formats this compressed range list into a readable string representation.
  String format({
    String rangeSeparator = '–',
    String nonConsecutiveSeparator = ', ',
    String Function(E)? toString,
  }) =>
      map(
        (range) => [range.from, if (range.from != range.to) range.to]
            .map((item) => toString?.call(item) ?? item.toString())
            .join(rangeSeparator),
      ).join(nonConsecutiveSeparator);
}
