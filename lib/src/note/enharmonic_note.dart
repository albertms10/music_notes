part of '../../music_notes.dart';

final class EnharmonicNote extends Enharmonic<Note>
    implements Scalable<EnharmonicNote> {
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
    final baseNote = BaseNote.fromValue(semitones);

    if (baseNote != null) {
      final baseNoteBelow = BaseNote.fromOrdinal(baseNote.ordinal - 1);
      final baseNoteAbove = BaseNote.fromOrdinal(baseNote.ordinal + 1);

      return SplayTreeSet<Note>.of({
        Note(
          baseNoteBelow,
          Accidental(
            (baseNote.value - baseNoteBelow.value).chromaticModExcludeZero,
          ),
        ),
        Note(baseNote),
        Note(
          baseNoteAbove,
          Accidental(
            baseNote.value -
                baseNoteAbove.value -
                (baseNote.value > baseNoteAbove.value ? chromaticDivisions : 0),
          ),
        ),
      });
    }

    return SplayTreeSet<Note>.of({
      Note(BaseNote.fromValue(semitones - 1)!, Accidental.sharp),
      Note(BaseNote.fromValue(semitones + 1)!, Accidental.flat),
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
  /// EnharmonicNote.fSharp.resolveSpelling(Accidental.flat) == Note.g.flat
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
  ///   == Note.a.flat
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
  /// EnharmonicNote.a.transposeBy(-Interval.M2) == EnharmonicNote.g
  /// ```
  @override
  EnharmonicNote transposeBy(Interval interval) =>
      EnharmonicNote((semitones + interval.semitones).chromaticModExcludeZero);

  /// Returns the [Interval] between this [EnharmonicNote] and [other].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.c.interval(EnharmonicNote.e) == Interval.M3
  /// EnharmonicNote.gSharp.interval(EnharmonicNote.d) == Interval.A4
  /// ```
  @override
  Interval interval(EnharmonicNote other) {
    final difference = other.semitones - semitones;

    return Interval.fromSemitonesQuality(
      difference + (difference.isNegative ? chromaticDivisions : 0),
    );
  }

  /// Returns the shortest fifths distance between this and [other].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.fSharp.shortestFifthsDistance(EnharmonicNote.a) == -3
  /// EnharmonicNote.dSharp.shortestFifthsDistance(EnharmonicNote.g) == 4
  /// ```
  int shortestFifthsDistance(EnharmonicNote other) {
    final distanceAbove = enharmonicIntervalDistance(other, Interval.P5);
    final distanceBelow = enharmonicIntervalDistance(other, -Interval.P5);
    final minDistance = math.min(distanceAbove, distanceBelow);

    return minDistance * (minDistance == distanceAbove ? 1 : -1);
  }

  /// Returns the shortest iteration distance from [enharmonicNote]
  /// to [interval].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.e.enharmonicIntervalDistance(
  ///     EnharmonicNote.d,
  ///     Interval.P5,
  ///   ) == 10
  ///
  /// EnharmonicNote.e.enharmonicIntervalDistance(
  ///     EnharmonicNote.d,
  ///     -Interval.P5,
  ///   ) == 2
  /// ```
  int enharmonicIntervalDistance(
    EnharmonicNote enharmonicNote,
    Interval interval,
  ) {
    var distance = 0;
    var currentPitch = semitones;
    var tempEnharmonicNote = EnharmonicNote(currentPitch);

    while (tempEnharmonicNote != enharmonicNote) {
      distance++;
      currentPitch += interval.semitones;
      tempEnharmonicNote = EnharmonicNote(currentPitch.chromaticModExcludeZero);
    }

    return distance;
  }
}
