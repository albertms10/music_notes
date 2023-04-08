part of '../../music_notes.dart';

class EnharmonicNote extends Enharmonic<Note> {
  const EnharmonicNote(super.semitones);

  static const c = EnharmonicNote(1);
  static const cSharp = EnharmonicNote(2);
  static const d = EnharmonicNote(3);
  static const dSharp = EnharmonicNote(4);
  static const e = EnharmonicNote(5);
  static const f = EnharmonicNote(6);
  static const fSharp = EnharmonicNote(7);
  static const g = EnharmonicNote(8);
  static const gSharp = EnharmonicNote(9);
  static const a = EnharmonicNote(10);
  static const aSharp = EnharmonicNote(11);
  static const b = EnharmonicNote(12);

  @override
  Set<Note> get items {
    final note = Notes.fromValue(semitones);

    if (note != null) {
      final noteBelow = Notes.fromOrdinal(Notes.values.indexOf(note));
      final noteAbove = Notes.fromOrdinal(Notes.values.indexOf(note) + 2);

      return SplayTreeSet<Note>.from({
        Note(
          noteBelow,
          Accidental(note.value - noteBelow.value),
        ),
        Note(note),
        Note(
          noteAbove,
          Accidental(note.value - noteAbove.value),
        ),
      });
    }

    return SplayTreeSet<Note>.from({
      Note(
        Notes.fromValue(semitones - 1)!,
        Accidental.sharp,
      ),
      Note(
        Notes.fromValue(semitones + 1)!,
        Accidental.flat,
      ),
    });
  }

  /// Returns the [Note] from [semitones] and a [preferredAccidental].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.e.toNote() == Note.e
  /// EnharmonicNote.dSharp.toNote(Accidental.flat) == Note.eFlat
  /// ```
  Note toNote([Accidental preferredAccidental = Accidental.natural]) {
    return items.firstWhereOrNull(
          (note) => note.accidental == preferredAccidental,
        ) ??
        items.firstWhereOrNull(
          (note) => note.accidental == Accidental.natural,
        ) ??
        items.first;
  }

  /// Returns a transposed [EnharmonicNote] by [semitones]
  /// from this [EnharmonicNote].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.c.transposeBy(6) == EnharmonicNote.fSharp
  /// ```
  @override
  EnharmonicNote transposeBy(int semitones) =>
      EnharmonicNote(this.semitones + semitones);

  /// Returns the shortest fifths distance between this and [other].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.fSharp.shortestFifthsDistance(EnharmonicNote.a) == -3
  /// EnharmonicNote.dSharp.shortestFifthsDistance(EnharmonicNote.g) == 4
  /// ```
  int shortestFifthsDistance(EnharmonicNote other) {
    final distanceAbove = enharmonicIntervalDistance(
      other,
      const Interval(Intervals.fifth, Qualities.perfect),
    );
    final distanceBelow = enharmonicIntervalDistance(
      other,
      const Interval(Intervals.fifth, Qualities.perfect, descending: true),
    );
    final minDistance = math.min(distanceAbove, distanceBelow);

    return minDistance * (minDistance == distanceAbove ? 1 : -1);
  }

  /// Returns the shortest iteration distance from [enharmonicNote]
  /// to [semitones].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.g.enharmonicSemitonesDistance(EnharmonicNote.a, 7) == 2
  /// ```
  int enharmonicSemitonesDistance(
    EnharmonicNote enharmonicNote,
    int semitones,
  ) {
    var distance = 0;
    var currentPitch = this.semitones;
    var tempEnharmonicNote = EnharmonicNote(currentPitch);

    while (tempEnharmonicNote != enharmonicNote) {
      distance++;
      currentPitch += semitones;
      tempEnharmonicNote = EnharmonicNote(currentPitch.chromaticModExcludeZero);
    }

    return distance;
  }

  /// Returns the shortest iteration distance from [enharmonicNote]
  /// to [interval].
  ///
  /// Examples:
  /// ```dart
  /// EnharmonicNote.e.enharmonicIntervalDistance(
  ///     EnharmonicNote.d,
  ///     const Interval(Intervals.fifth, Qualities.perfect),
  ///   ) == 10
  ///
  /// EnharmonicNote.e.enharmonicIntervalDistance(
  ///     EnharmonicNote.d,
  ///     const Interval(Intervals.fifth, Qualities.perfect, descending: true),
  ///   ) == 2
  /// ```
  int enharmonicIntervalDistance(
    EnharmonicNote enharmonicNote,
    Interval interval,
  ) =>
      enharmonicSemitonesDistance(enharmonicNote, interval.semitones);
}
