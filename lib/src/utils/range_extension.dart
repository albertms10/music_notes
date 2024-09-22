import 'package:music_notes/music_notes.dart';

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
  List<E> explode({
    required E Function(E current) nextValue,
    required int Function(E a, E b) compare,
  }) =>
      _explode(nextValue: nextValue, compare: compare);
}

/// A Comparable range record extension.
extension ComparableRangeExtension<E extends Comparable<E>> on Range<E> {
  /// Fills this range of values between `from` and `to`.
  List<E> explode({
    required E Function(E current) nextValue,
    int Function(E a, E b) compare = Comparable.compare,
  }) =>
      _explode(nextValue: nextValue, compare: compare);
}

/// A Comparable range record extension.
extension NoteRangeExtension on Range<Note> {
  /// Fills this range of values between `from` and `to`.
  List<Note> explode({
    Note Function(Note current) nextValue = Note.stepwiseMotion,
    int Function(Note a, Note b) compare = Note.compareEnharmonically,
  }) =>
      _explode(nextValue: nextValue, compare: compare);
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
