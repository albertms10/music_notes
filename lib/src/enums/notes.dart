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

  /// Returns a [Notes] enum item that matches [value]
  /// as in [Notes], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// Notes.fromValue(3) == Notes.d
  /// Notes.fromValue(8) == Notes.g
  /// Notes.fromValue(11) == null
  /// ```
  static Notes? fromValue(int value) => values.firstWhereOrNull(
        (note) => chromaticModExcludeZero(value) == note.value,
      );

  /// Returns a [Notes] enum item that matches [ordinal].
  ///
  /// Examples:
  /// ```dart
  /// Notes.fromOrdinal(3) == Notes.e
  /// Notes.fromOrdinal(7) == Notes.b
  /// Notes.fromOrdinal(10) == Notes.e
  /// ```
  static Notes fromOrdinal(int ordinal) =>
      Notes.values[nModExcludeZero(ordinal, Notes.values.length) - 1];

  /// Returns `true` if a [Notes] enum item needs and accidental
  /// to be represented—that is, it cannot be found in [Notes].
  ///
  /// Examples:
  /// ```dart
  /// Notes.needsAccidental(4) == true
  /// Notes.needsAccidental(6) == false
  /// ```
  static bool needsAccidental(int value) => fromValue(value) == null;

  /// Returns the ordinal number of this [Notes] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Notes.c.ordinal == 1
  /// Notes.f.ordinal == 4
  /// ```
  int get ordinal => Notes.values.indexOf(this) + 1;

  /// Returns an [Intervals] enum item that conforms an interval
  /// between this [Notes] enum item and [note] in ascending manner by default.
  ///
  /// Examples:
  /// ```dart
  /// Notes.d.interval(Notes.f) == Intervals.third
  /// Notes.a.interval(Notes.e) == Intervals.fifth
  /// Notes.a.interval(Notes.e, descending: true) == Intervals.fourth
  /// ```
  Intervals interval(Notes note, {bool descending = false}) {
    final noteOrdinal1 = ordinal;
    var noteOrdinal2 = note.ordinal;

    if (!descending && noteOrdinal1 > noteOrdinal2) {
      noteOrdinal2 += values.length;
    }

    return IntervalsValues.fromOrdinal(
      ((noteOrdinal2 - noteOrdinal1) * (descending ? -1 : 1)) + 1,
    );
  }

  /// Returns a transposed [Notes] enum item from this [Notes] one
  /// given an [Intervals] enum item, ascending by default.
  ///
  /// Examples:
  /// ```dart
  /// Notes.c.transpose(Intervals.fifth) == Notes.g
  /// Notes.f.transpose(Intervals.third, descending: true) == Notes.d
  /// Notes.a.transpose(Intervals.fourth) == Notes.d
  /// ```
  Notes transpose(Intervals interval, {bool descending = false}) =>
      Notes.fromOrdinal(
        ordinal + (interval.ordinal - 1) * (descending ? -1 : 1),
      );
}
