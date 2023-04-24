part of '../../music_notes.dart';

enum Notes {
  c(1),
  d(3),
  e(5),
  f(6),
  g(8),
  a(10),
  b(12);

  final int value;

  const Notes(this.value);

  /// Returns a [Notes] enum item that matches with [value]
  /// as in [Notes], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// Notes.fromValue(3) == Notes.d
  /// Notes.fromValue(8) == Notes.g
  /// Notes.fromValue(11) == null
  /// ```
  static Notes? fromValue(int value) => values.firstWhereOrNull(
        (note) => value.chromaticModExcludeZero == note.value,
      );

  /// Returns a [Notes] enum item that matches with [ordinal].
  ///
  /// Example:
  /// ```dart
  /// Notes.fromOrdinal(3) == Notes.e
  /// Notes.fromOrdinal(7) == Notes.b
  /// Notes.fromOrdinal(10) == Notes.e
  /// ```
  static Notes fromOrdinal(int ordinal) =>
      Notes.values[ordinal.nModExcludeZero(Notes.values.length) - 1];

  /// Returns the ordinal number of this [Notes] enum item.
  ///
  /// Example:
  /// ```dart
  /// Notes.c.ordinal == 1
  /// Notes.f.ordinal == 4
  /// ```
  int get ordinal => Notes.values.indexOf(this) + 1;

  /// Returns the interval size that conforms between this [Notes] enum item and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// Notes.d.intervalSize(Notes.f) == 3
  /// Notes.a.intervalSize(Notes.e) == 5
  /// Notes.a.intervalSize(Notes.e, descending: true) == 4
  /// ```
  int intervalSize(Notes other, {bool descending = false}) {
    var otherOrdinal = other.ordinal;
    if (descending && ordinal < otherOrdinal) {
      otherOrdinal -= values.length;
    } else if (!descending && ordinal > otherOrdinal) {
      otherOrdinal += values.length;
    }

    return ((otherOrdinal - ordinal) * (descending ? -1 : 1)) + 1;
  }

  /// Returns the difference in semitones between this [Notes] enum item and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// Notes.c.difference(Notes.c) == 0
  /// Notes.c.difference(Notes.e) == 4
  /// Notes.a.difference(Notes.d) == -7
  /// ```
  int difference(Notes other) => other.value - value;

  /// Returns the positive difference in semitones between this [Notes] enum
  /// item and [other].
  ///
  /// When [difference] would return a negative value, this method returns the
  /// difference with [other] being in the next octave.
  ///
  /// Example:
  /// ```dart
  /// Notes.c.positiveDifference(Notes.c) == 0
  /// Notes.c.positiveDifference(Notes.e) == 4
  /// Notes.a.positiveDifference(Notes.d) == 5
  /// ```
  int positiveDifference(Notes other) {
    final differenceWithOther = difference(other);

    return differenceWithOther.isNegative
        ? differenceWithOther + chromaticDivisions
        : differenceWithOther;
  }

  /// Returns this [Notes] enum item transposed by interval [size].
  ///
  /// Example:
  /// ```dart
  /// Notes.g.transposeBy(1) == Notes.g
  /// Notes.g.transposeBy(5) == Notes.d
  /// Notes.a.transposeBy(-3) == Notes.f
  /// ```
  Notes transposeBy(int size) {
    assert(size != 0, 'Size must be non-zero');

    return fromOrdinal(ordinal + (size.abs() - 1) * size.sign);
  }
}
