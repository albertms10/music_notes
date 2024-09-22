import '../note/note.dart';
import 'range_extension.dart';

/// An Iterable extension.
extension IterableExtension<E> on Iterable<E> {
  /// The closest element [E] to [target].
  ///
  /// Example:
  /// ```dart
  /// const [2, 5, 6, 8, 10].closestTo(7) == 6
  ///
  /// [Note.c, Note.e, Note.f.sharp, Note.a]
  ///     .closestTo(Note.g, (a, b) => b.semitones - a.semitones)
  ///   == Note.f.sharp
  /// ```
  E closestTo(E target, [num Function(E a, E b)? difference]) =>
      reduce((closest, element) {
        if (difference == null && closest is! num) {
          throw ArgumentError.value(
            difference,
            'difference',
            'Provide difference when elements are not num',
          );
        }

        difference ??= (a, b) => (b as num) - (a as num);

        return difference!(element, target).abs() <
                difference!(closest, target).abs()
            ? element
            : closest;
      });

  Iterable<Range<E>> _compact({
    required E Function(E current) nextValue,
    required int Function(E a, E b) compare,
    bool inclusive = false,
  }) {
    if (isEmpty) return const Iterable.empty();

    var start = first;
    late E b;

    final ranges = <Range<E>>{};
    if (length > 1) {
      for (var i = 0; i < length - 1; i++) {
        final a = elementAt(i);
        b = elementAt(i + 1);

        final nextA = nextValue(a);
        if (compare(nextA, b) != 0) {
          ranges.add((from: start, to: inclusive ? b : a));
          start = b;
        }
      }
    } else {
      b = first;
    }

    return (ranges..add((from: start, to: inclusive ? nextValue(b) : b)))
        .toList();
  }

  /// Returns a list of consecutive values of this [Iterable]
  /// compacted as tuples. Consecutive values are computed
  /// based on [nextValue], which:
  ///
  /// * if [E] is of type [num], it defaults to an increment of 1.
  /// * if [E] is of type [String], it defaults to an increment of 1
  ///   of every [String.codeUnits].
  ///
  /// Throws an [ArgumentError] if no [nextValue] is specified for types other
  /// than [num] or [String].
  ///
  /// Examples:
  /// ```dart
  /// const inputNum = [1, 2, 3, 4, 5.0, 7, 8, 9, 11];
  /// const compactedNum = [[1, 5], [7, 9], [11, 11]];
  /// inputNum.compact() == compactedNum
  ///
  /// final inputString = 'abcdfxy'.split('');
  /// const compactedString = [['a', 'e'], ['f', 'g'], ['x', 'z']];
  /// inputString.compact(inclusive: true) == compactedString
  ///
  /// final inputDateTime = [
  ///   DateTime(2021, 8, 30, 9, 30),
  ///   DateTime(2021, 8, 31),
  ///   for (var i = 1; i < 10; i++) DateTime(2021, 9, i, 21, 30),
  ///   DateTime(2021, 9, 30),
  /// ];
  ///
  /// final compactedDateTime = [
  ///   [DateTime(2021, 8, 30, 9, 30), DateTime(2021, 9, 10, 21, 30)],
  ///   [DateTime(2021, 9, 30), DateTime(2021, 10)],
  /// ];
  ///
  /// inputDateTime.compact(
  ///       nextValue: (dateTime) => dateTime.add(const Duration(days: 1)),
  ///       compare: (a, b) => b.compareTo(a),
  ///       inclusive: true,
  ///     ) ==
  ///     compactedDateTime
  /// ```
  Iterable<Range<E>> compact({
    required E Function(E current) nextValue,
    required int Function(E a, E b) compare,
    bool inclusive = false,
  }) =>
      _compact(nextValue: nextValue, compare: compare, inclusive: inclusive);
}

/// A Comparable Iterable extension.
extension ComparableIterableExtension<E extends Comparable<E>> on Iterable<E> {
  /// Compacts this [Iterable] into a collection of [Range]s, based on
  /// [nextValue], [compare] and [inclusive].
  Iterable<Range<E>> compact({
    required E Function(E current) nextValue,
    int Function(E a, E b) compare = Comparable.compare,
    bool inclusive = false,
  }) =>
      _compact(nextValue: nextValue, compare: compare, inclusive: inclusive);
}

/// A Note Iterable extension.
extension NoteIterableExtension on Iterable<Note> {
  /// Compacts this [Iterable] into a collection of [Range]s, based on
  /// [nextValue], [compare] and [inclusive].
  Iterable<Range<Note>> compact({
    Note Function(Note current) nextValue = Note.stepwiseMotion,
    int Function(Note a, Note b) compare = Note.compareEnharmonically,
    bool inclusive = false,
  }) =>
      _compact(nextValue: nextValue, compare: compare, inclusive: inclusive);
}

/// Compares multiple comparators.
int compareMultiple(List<int Function()> comparators) {
  assert(comparators.length > 1, 'Provide more than one comparator.');
  late int compareValue;
  for (final comparator in comparators) {
    compareValue = comparator();
    if (compareValue != 0) break;
  }

  return compareValue;
}
