part of '../../music_notes.dart';

enum BaseNote {
  c(1),
  d(3),
  e(5),
  f(6),
  g(8),
  a(10),
  b(12);

  final int value;

  const BaseNote(this.value);

  /// Returns a [BaseNote] enum item that matches with [value]
  /// as in [BaseNote], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.fromValue(3) == BaseNote.d
  /// BaseNote.fromValue(8) == BaseNote.g
  /// BaseNote.fromValue(11) == null
  /// ```
  static BaseNote? fromValue(int value) => values.firstWhereOrNull(
        (note) => value.chromaticModExcludeZero == note.value,
      );

  /// Returns a [BaseNote] enum item that matches with [ordinal].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.fromOrdinal(3) == BaseNote.e
  /// BaseNote.fromOrdinal(7) == BaseNote.b
  /// BaseNote.fromOrdinal(10) == BaseNote.e
  /// ```
  static BaseNote fromOrdinal(int ordinal) =>
      BaseNote.values[ordinal.nModExcludeZero(BaseNote.values.length) - 1];

  /// Returns the ordinal number of this [BaseNote] enum item.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.ordinal == 1
  /// BaseNote.f.ordinal == 4
  /// BaseNote.b.ordinal == 7
  /// ```
  int get ordinal => BaseNote.values.indexOf(this) + 1;

  /// Returns the [Interval.size] that conforms between this [BaseNote] enum
  /// item and [other].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.d.intervalSize(BaseNote.f) == 3
  /// BaseNote.a.intervalSize(BaseNote.e) == 5
  /// ```
  int intervalSize(BaseNote other) =>
      other.ordinal -
      ordinal +
      (ordinal > other.ordinal ? values.length : 0) +
      1;

  /// Returns the difference in semitones between this [BaseNote] enum item and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.difference(BaseNote.c) == 0
  /// BaseNote.c.difference(BaseNote.e) == 4
  /// BaseNote.a.difference(BaseNote.d) == -7
  /// ```
  int difference(BaseNote other) => other.value - value;

  /// Returns the positive difference in semitones between this [BaseNote] enum
  /// item and [other].
  ///
  /// When [difference] would return a negative value, this method returns the
  /// difference with [other] being in the next octave.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.positiveDifference(BaseNote.c) == 0
  /// BaseNote.c.positiveDifference(BaseNote.e) == 4
  /// BaseNote.a.positiveDifference(BaseNote.d) == 5
  /// ```
  int positiveDifference(BaseNote other) {
    final differenceWithOther = difference(other);

    return differenceWithOther.isNegative
        ? differenceWithOther + chromaticDivisions
        : differenceWithOther;
  }

  /// Returns this [BaseNote] enum item transposed by interval [size].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.g.transposeBySize(1) == BaseNote.g
  /// BaseNote.g.transposeBySize(5) == BaseNote.d
  /// BaseNote.a.transposeBySize(-3) == BaseNote.f
  /// ```
  BaseNote transposeBySize(int size) {
    assert(size != 0, 'Size must be non-zero');

    return fromOrdinal(ordinal + (size.abs() - 1) * size.sign);
  }
}
