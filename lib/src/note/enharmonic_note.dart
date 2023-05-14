part of '../../music_notes.dart';

final class EnharmonicNote extends Enharmonic<Note>
    implements Transposable<EnharmonicNote> {
  const EnharmonicNote(super.semitones)
      : assert(
          semitones > 0 && semitones <= chromaticDivisions,
          'Semitones must be in chromatic divisions range',
        );

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
  Set<Note> get spellings {
    final note = BaseNote.fromValue(semitones);

    if (note != null) {
      final noteBelow = BaseNote.fromOrdinal(note.ordinal - 1);
      final noteAbove = BaseNote.fromOrdinal(note.ordinal + 1);

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
        BaseNote.fromValue(semitones - 1)!,
        Accidental.sharp,
      ),
      Note(
        BaseNote.fromValue(semitones + 1)!,
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
  /// EnharmonicNote.d.resolveSpelling() == Note.d
  /// EnharmonicNote.fSharp.resolveSpelling(Accidental.flat) == Note.gFlat
  /// EnharmonicNote.cSharp.resolveSpelling(Accidental.natural) // throws
  /// ```
  Note resolveSpelling([Accidental? withAccidental]) {
    final matchedNote = spellings.firstWhereOrNull(
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

    return spellings
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
  /// Like [resolveSpelling] except that this function returns the closest note
  /// where a similar call to [resolveSpelling] would throw an [ArgumentError].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.d.resolveClosestSpelling() == Note.d
  /// EnharmonicNote.gSharp.resolveClosestSpelling(Accidental.flat)
  ///   == Note.aFlat
  /// EnharmonicNote.cSharp.resolveClosestSpelling(Accidental.natural) == null
  /// ```
  Note resolveClosestSpelling([Accidental? preferredAccidental]) {
    try {
      return resolveSpelling(preferredAccidental);
      // ignore: avoid_catching_errors
    } on ArgumentError {
      return resolveSpelling();
    }
  }

  /// Returns a transposed [EnharmonicNote] by [interval]
  /// from this [EnharmonicNote].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.c.transposeBy(Interval.tritone) == EnharmonicNote.fSharp
  /// EnharmonicNote.a.transposeBy(-Interval.majorSecond) == EnharmonicNote.g
  /// ```
  @override
  EnharmonicNote transposeBy(Interval interval) =>
      EnharmonicNote((semitones + interval.semitones).chromaticModExcludeZero);

  /// Returns the shortest fifths distance between this and [other].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.fSharp.shortestFifthsDistance(EnharmonicNote.a) == -3
  /// EnharmonicNote.dSharp.shortestFifthsDistance(EnharmonicNote.g) == 4
  /// ```
  int shortestFifthsDistance(EnharmonicNote other) {
    final distanceAbove =
        enharmonicIntervalDistance(other, Interval.perfectFifth);
    final distanceBelow =
        enharmonicIntervalDistance(other, -Interval.perfectFifth);
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
  ///     Interval.perfectFifth,
  ///   ) == 10
  ///
  /// EnharmonicNote.e.enharmonicIntervalDistance(
  ///     EnharmonicNote.d,
  ///     const Interval(5, PerfectQuality.perfect, descending: true),
  ///   ) == 2
  /// ```
  int enharmonicIntervalDistance(
    EnharmonicNote enharmonicNote,
    Interval interval,
  ) =>
      enharmonicSemitonesDistance(enharmonicNote, interval.semitones);
}
