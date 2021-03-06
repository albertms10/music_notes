part of music_notes;

enum Notes { Do, Re, Mi, Fa, Sol, La, Si }

extension NotesValues on Notes {
  static const notesValues = {
    Notes.Do: 1,
    Notes.Re: 3,
    Notes.Mi: 5,
    Notes.Fa: 6,
    Notes.Sol: 8,
    Notes.La: 10,
    Notes.Si: 12,
  };

  /// Returns a [Notes] enum item that matches [value]
  /// as in [notesValues], otherwise returns `null`.
  ///
  /// Examples:
  /// ```dart
  /// NotesValues.fromValue(3) == Notes.Re
  /// NotesValues.fromValue(8) == Notes.Sol
  /// NotesValues.fromValue(11) == null
  /// ```
  static Notes? fromValue(int value) => notesValues.keys.firstWhereOrNull(
        (note) => Music.modValueExcludeZero(value) == notesValues[note],
      );

  /// Returns a [Notes] enum item that matches [ordinal].
  ///
  /// Examples:
  /// ```dart
  /// NotesValues.fromOrdinal(3) == Notes.Mi
  /// NotesValues.fromOrdinal(7) == Notes.Si
  /// NotesValues.fromOrdinal(10) == Notes.Mi
  /// ```
  static Notes fromOrdinal(int ordinal) => Notes
      .values[Music.nModValueExcludeZero(ordinal, Notes.values.length) - 1];

  /// Returns `true` if a [Notes] enum item needs and accidental to be represented
  /// – that is, it cannot be found in [notesValues].
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
  /// Notes.Do.ordinal == 1
  /// Notes.Fa.ordinal == 4
  /// ```
  int get ordinal => Notes.values.indexOf(this) + 1;

  /// Returns the value of this [Notes] enum item as in [notesValues].
  ///
  /// Examples:
  /// ```dart
  /// Notes.Do.value == 1
  /// Notes.Sol.value == 8
  /// Notes.Si.value == 12
  /// ```
  int get value => notesValues[this]!;

  /// Returns an [Intervals] enum item that conforms an interval
  /// between this [Notes] enum item and [note] in ascending manner by default.
  ///
  /// Examples:
  /// ```dart
  /// Notes.Re.interval(Notes.Fa) == Intervals.Tercera
  /// Notes.La.interval(Notes.Mi) == Intervals.Quinta
  /// Notes.La.interval(Notes.Mi, descending: true) == Intervals.Quarta
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
  /// Notes.Do.transpose(Intervals.Quinta) == Notes.Sol
  /// Notes.Fa.transpose(Intervals.Tercera, descending: true) == Notes.Re
  /// Notes.La.transpose(Intervals.Quarta) == Notes.Re
  /// ```
  Notes transpose(Intervals interval, {bool descending = false}) =>
      NotesValues.fromOrdinal(
        ordinal + (interval.ordinal - 1) * (descending ? -1 : 1),
      );
}
