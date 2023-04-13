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
  /// Example:
  /// ```dart
  /// Notes.fromValue(3) == Notes.d
  /// Notes.fromValue(8) == Notes.g
  /// Notes.fromValue(11) == null
  /// ```
  static Notes? fromValue(int value) => values.firstWhereOrNull(
        (note) => value.chromaticModExcludeZero == note.value,
      );

  /// Returns a [Notes] enum item that matches [ordinal].
  ///
  /// Example:
  /// ```dart
  /// Notes.fromOrdinal(3) == Notes.e
  /// Notes.fromOrdinal(7) == Notes.b
  /// Notes.fromOrdinal(10) == Notes.e
  /// ```
  static Notes fromOrdinal(int ordinal) =>
      Notes.values[ordinal.nModExcludeZero(Notes.values.length) - 1];

  /// Returns `true` if a [Notes] enum item needs and accidental
  /// to be represented—that is, it cannot be found in [Notes].
  ///
  /// Example:
  /// ```dart
  /// Notes.needsAccidental(4) == true
  /// Notes.needsAccidental(6) == false
  /// ```
  static bool needsAccidental(int value) => fromValue(value) == null;

  /// Returns the ordinal number of this [Notes] enum item.
  ///
  /// Example:
  /// ```dart
  /// Notes.c.ordinal == 1
  /// Notes.f.ordinal == 4
  /// ```
  int get ordinal => Notes.values.indexOf(this) + 1;

  /// Returns an [int] interval that conforms an interval
  /// between this [Notes] enum item and [note] in ascending manner by default.
  ///
  /// Example:
  /// ```dart
  /// Notes.d.interval(Notes.f) == 3
  /// Notes.a.interval(Notes.e) == 5
  /// Notes.a.interval(Notes.e, descending: true) == 4
  /// ```
  int interval(Notes note, {bool descending = false}) {
    final noteOrdinal1 = ordinal;
    var noteOrdinal2 = note.ordinal;

    if (!descending && noteOrdinal1 > noteOrdinal2) {
      noteOrdinal2 += values.length;
    }

    return ((noteOrdinal2 - noteOrdinal1) * (descending ? -1 : 1)) + 1;
  }

  /// Returns a transposed [Notes] enum item from this [Notes] one
  /// given an [int] interval, ascending by default.
  ///
  /// Example:
  /// ```dart
  /// Notes.c.transpose(5) == Notes.g
  /// Notes.f.transpose(3, descending: true) == Notes.d
  /// Notes.a.transpose(4) == Notes.d
  /// ```
  Notes transpose(int interval, {bool descending = false}) => Notes.fromOrdinal(
        ordinal + (interval - 1) * (descending ? -1 : 1),
      );
}
