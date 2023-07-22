part of '../../music_notes.dart';

@immutable
final class EnharmonicNote extends Enharmonic<Note>
    implements Scalable<EnharmonicNote> {
  const EnharmonicNote(super.semitones)
      : assert(
          semitones >= 0 && semitones < chromaticDivisions,
          'Semitones must be in chromatic divisions range',
        );

  static const c = EnharmonicNote(0);
  static const cSharp = EnharmonicNote(1);
  static const d = EnharmonicNote(2);
  static const dSharp = EnharmonicNote(3);
  static const e = EnharmonicNote(4);
  static const f = EnharmonicNote(5);
  static const fSharp = EnharmonicNote(6);
  static const g = EnharmonicNote(7);
  static const gSharp = EnharmonicNote(8);
  static const a = EnharmonicNote(9);
  static const aSharp = EnharmonicNote(10);
  static const b = EnharmonicNote(11);

  @override
  Set<Note> spellings({int distance = 0}) {
    assert(distance >= 0, 'Distance must be greater or equal than zero.');
    final baseNote = BaseNote.fromSemitones(semitones);

    if (baseNote != null) {
      final note = Note(baseNote);

      return SplayTreeSet<Note>.of({
        note,
        for (var i = 1; i <= distance; i++) ...[
          note.respellByBaseNoteDistance(distance),
          note.respellByBaseNoteDistance(-distance),
        ],
      });
    }

    final aboveNote =
        Note(BaseNote.fromSemitones(semitones - 1)!, Accidental.sharp);
    final belowNote =
        Note(BaseNote.fromSemitones(semitones + 1)!, Accidental.flat);

    return SplayTreeSet<Note>.of({
      aboveNote,
      belowNote,
      for (var i = 1; i <= distance; i++) ...[
        belowNote.respellByBaseNoteDistance(distance),
        aboveNote.respellByBaseNoteDistance(-distance),
      ],
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
    final matchedNote = spellings(distance: 1).firstWhereOrNull(
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

    return spellings()
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
      EnharmonicNote((semitones + interval.semitones).chromaticMod);

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

  /// Performs a pitch-class multiplication modulo 12 of this [EnharmonicNote].
  ///
  /// Example:
  /// ```dart
  /// EnharmonicNote.cSharp * 7 == EnharmonicNote.g
  /// EnharmonicNote.d * 7 == EnharmonicNote.d
  ///
  /// EnharmonicNote.cSharp * 5 == EnharmonicNote.f
  /// EnharmonicNote.d * 5 == EnharmonicNote.aSharp
  /// ```
  ///
  /// The multiplication by the two meaningful operations (5 and 7) gives us the
  /// circle of fourths and fifths transform, respectively, when operated on a
  /// chromatic scale as follows:
  ///
  /// ```dart
  /// ScalePattern.chromatic.on(EnharmonicNote.c)
  ///   .degrees.map((note) => note * 7)
  ///     == Interval.P5.circleFrom(EnharmonicNote.c, distance: 12)
  /// ```
  ///
  /// See [Pitch-class multiplication modulo 12](https://en.wikipedia.org/wiki/Multiplication_(music)#Pitch-class_multiplication_modulo_12).
  EnharmonicNote operator *(int factor) =>
      EnharmonicNote((semitones * factor).chromaticMod);
}
