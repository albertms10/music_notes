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
      final noteBelow = Notes.fromOrdinal(note.ordinal - 1);
      final noteAbove = Notes.fromOrdinal(note.ordinal + 1);

      return SplayTreeSet<Note>.of({
        Note(
          noteBelow,
          Accidental((note.value - noteBelow.value).chromaticModExcludeZero),
        ),
        Note(note),
        Note(
          noteAbove,
          Accidental(
            note.value -
                noteAbove.value -
                (note.value > noteAbove.value ? chromaticDivisions : 0),
          ),
        ),
      });
    }

    return SplayTreeSet<Note>.of({
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

  /// Returns the [Note] that matches [withAccidental] from this
  /// [EnharmonicNote].
  ///
  /// Throws an [ArgumentError] when [withAccidental] does not match with any
  /// possible note.
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.d.toNote() == Note.d
  /// EnharmonicNote.fSharp.toNote(Accidental.flat) == Note.gFlat
  /// EnharmonicNote.cSharp.toNote(Accidental.natural) // throws
  /// ```
  Note toNote([Accidental? withAccidental]) {
    final matchedNote = items.firstWhereOrNull(
      (note) => note.accidental == withAccidental,
    );
    if (matchedNote != null) return matchedNote;

    if (withAccidental != null) {
      throw ArgumentError.value(
        '$withAccidental',
        'preferredAccidental',
        'Impossible match for',
      );
    }

    return items
        // TODO(albertms10): return the note with the closest accidental #50.
        .sorted(
          (a, b) => a.accidental.semitones
              .abs()
              .compareTo(b.accidental.semitones.abs()),
        )
        .first;
  }

  /// Returns the [Note] that matches with [preferredAccidental] from this
  /// [EnharmonicNote].
  ///
  /// Like [toNote] except that this function returns the closest note where a
  /// similar call to [toNote] would throw an [ArgumentError].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.d.toClosestNote() == Note.d
  /// EnharmonicNote.gSharp.toClosestNote(Accidental.flat) == Note.aFlat
  /// EnharmonicNote.cSharp.toClosestNote(Accidental.natural) == null
  /// ```
  Note toClosestNote([Accidental? preferredAccidental]) {
    try {
      return toNote(preferredAccidental);
      // ignore: avoid_catching_errors
    } on ArgumentError {
      return toNote();
    }
  }

  /// Returns a transposed [EnharmonicNote] by [semitones]
  /// from this [EnharmonicNote].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.c.transposeBy(6) == EnharmonicNote.fSharp
  /// EnharmonicNote.a.transposeBy(-2) == EnharmonicNote.g
  /// ```
  @override
  EnharmonicNote transposeBy(int semitones) =>
      EnharmonicNote((this.semitones + semitones).chromaticModExcludeZero);

  /// Returns the shortest fifths distance between this and [other].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.fSharp.shortestFifthsDistance(EnharmonicNote.a) == -3
  /// EnharmonicNote.dSharp.shortestFifthsDistance(EnharmonicNote.g) == 4
  /// ```
  int shortestFifthsDistance(EnharmonicNote other) {
    final distanceAbove = enharmonicIntervalDistance(
      other,
      const Interval.perfect(5, PerfectQuality.perfect),
    );
    final distanceBelow = enharmonicIntervalDistance(
      other,
      const Interval.perfect(5, PerfectQuality.perfect, descending: true),
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
  /// Example:
  /// ```dart
  /// EnharmonicNote.e.enharmonicIntervalDistance(
  ///     EnharmonicNote.d,
  ///     const Interval.perfect(5, PerfectQuality.perfect),
  ///   ) == 10
  ///
  /// EnharmonicNote.e.enharmonicIntervalDistance(
  ///     EnharmonicNote.d,
  ///     const Interval(
  ///       5,
  ///       PerfectQuality.perfect,
  ///       descending: true
  ///     ),
  ///   ) == 2
  /// ```
  int enharmonicIntervalDistance(
    EnharmonicNote enharmonicNote,
    Interval interval,
  ) =>
      enharmonicSemitonesDistance(enharmonicNote, interval.semitones);
}
