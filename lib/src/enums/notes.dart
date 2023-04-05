part of '../../music_notes.dart';

enum Notes { ut, re, mi, fa, sol, la, si }

extension NotesValues on Notes {
  static const notesValues = {
    Notes.ut: 1,
    Notes.re: 3,
    Notes.mi: 5,
    Notes.fa: 6,
    Notes.sol: 8,
    Notes.la: 10,
    Notes.si: 12,
  };

  /// Returns a [Notes] enum item that matches [value]
  /// as in [notesValues], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// NotesValues.fromValue(3) == Notes.re
  /// NotesValues.fromValue(8) == Notes.sol
  /// NotesValues.fromValue(11) == null
  /// ```
  static Notes? fromValue(int value) => notesValues.keys.firstWhereOrNull(
        (note) => chromaticModExcludeZero(value) == notesValues[note],
      );

  /// Returns a [Notes] enum item that matches [ordinal].
  ///
  /// Examples:
  /// ```dart
  /// NotesValues.fromOrdinal(3) == Notes.mi
  /// NotesValues.fromOrdinal(7) == Notes.si
  /// NotesValues.fromOrdinal(10) == Notes.mi
  /// ```
  static Notes fromOrdinal(int ordinal) =>
      Notes.values[nModExcludeZero(ordinal, Notes.values.length) - 1];

  /// Returns `true` if a [Notes] enum item needs and accidental
  /// to be represented—that is, it cannot be found in [notesValues].
  ///
  /// Examples:
  /// ```dart
  /// NotesValues.needsAccidental(4) == true
  /// NotesValues.needsAccidental(6) == false
  /// ```
  static bool needsAccidental(int value) => fromValue(value) == null;

  /// Returns the ordinal number of this [Notes] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Notes.ut.ordinal == 1
  /// Notes.fa.ordinal == 4
  /// ```
  int get ordinal => Notes.values.indexOf(this) + 1;

  /// Returns the value of this [Notes] enum item as in [notesValues].
  ///
  /// Examples:
  /// ```dart
  /// Notes.ut.value == 1
  /// Notes.sol.value == 8
  /// Notes.si.value == 12
  /// ```
  int get value => notesValues[this]!;

  /// Returns an [Intervals] enum item that conforms an interval
  /// between this [Notes] enum item and [note] in ascending manner by default.
  ///
  /// Examples:
  /// ```dart
  /// Notes.re.interval(Notes.fa) == Intervals.third
  /// Notes.la.interval(Notes.mi) == Intervals.fifth
  /// Notes.la.interval(Notes.mi, descending: true) == Intervals.fourth
  /// ```
  Intervals interval(Notes note, {bool descending = false}) {
    final noteOrdinal1 = ordinal;
    var noteOrdinal2 = note.ordinal;

    if (!descending && noteOrdinal1 > noteOrdinal2) {
      noteOrdinal2 += notesValues.length;
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
  /// Notes.ut.transpose(Intervals.fifth) == Notes.sol
  /// Notes.fa.transpose(Intervals.third, descending: true) == Notes.re
  /// Notes.la.transpose(Intervals.fourth) == Notes.re
  /// ```
  Notes transpose(Intervals interval, {bool descending = false}) =>
      NotesValues.fromOrdinal(
        ordinal + (interval.ordinal - 1) * (descending ? -1 : 1),
      );
}
