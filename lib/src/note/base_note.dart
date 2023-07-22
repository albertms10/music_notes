part of '../../music_notes.dart';

enum BaseNote {
  c(0),
  d(2),
  e(4),
  f(5),
  g(7),
  a(9),
  b(11);

  final int semitones;

  const BaseNote(this.semitones);

  /// Returns a [BaseNote] enum item that matches with [semitones]
  /// as in [BaseNote], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.fromSemitones(2) == BaseNote.d
  /// BaseNote.fromSemitones(7) == BaseNote.g
  /// BaseNote.fromSemitones(10) == null
  /// ```
  static BaseNote? fromSemitones(int semitones) => values
      .firstWhereOrNull((note) => semitones.chromaticMod == note.semitones);

  /// Returns a [BaseNote] enum item that matches with [ordinal].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.fromOrdinal(3) == BaseNote.e
  /// BaseNote.fromOrdinal(7) == BaseNote.b
  /// BaseNote.fromOrdinal(10) == BaseNote.e
  /// ```
  factory BaseNote.fromOrdinal(int ordinal) =>
      BaseNote.values[ordinal.nModExcludeZero(BaseNote.values.length) - 1];

  /// Parse [source] as a [BaseNote] and return its value.
  ///
  /// If the [source] string does not contain a valid [BaseNote], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.parse('B') == BaseNote.b
  /// BaseNote.parse('a') == BaseNote.a
  /// BaseNote.parse('z') // throws a FormatException
  /// ```
  factory BaseNote.parse(String source) {
    try {
      return values.byName(source.toLowerCase());
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        FormatException('Invalid BaseNote', source, 0),
        stackTrace,
      );
    }
  }

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
  int difference(BaseNote other) => other.semitones - semitones;

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

    return BaseNote.fromOrdinal(ordinal + (size.abs() - 1) * size.sign);
  }
}
