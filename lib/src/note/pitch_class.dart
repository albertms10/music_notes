part of '../../music_notes.dart';

/// A set of all pitches that are a whole number of octaves apart, sharing the
/// same chroma.
///
/// See [Pitch class](https://en.wikipedia.org/wiki/Pitch_class).
@immutable
final class PitchClass implements Scalable<PitchClass>, Comparable<PitchClass> {
  /// The chroma value that represents this [PitchClass].
  ///
  /// See [Chroma feature](https://en.wikipedia.org/wiki/Chroma_feature).
  final int chroma;

  /// Creates a new [PitchClass] from [chroma].
  const PitchClass(int chroma) : chroma = chroma % chromaticDivisions;

  /// Pitch class 0, which corresponds to [Note.c].
  static const c = PitchClass(0);

  /// Pitch class 1, which corresponds to [Note.c.sharp] or [Note.d.flat].
  static const cSharp = PitchClass(1);

  /// Pitch class 2, which corresponds to [Note.d].
  static const d = PitchClass(2);

  /// Pitch class 3, which corresponds to [Note.d.sharp] or [Note.e.flat].
  static const dSharp = PitchClass(3);

  /// Pitch class 4, which corresponds to [Note.e].
  static const e = PitchClass(4);

  /// Pitch class 5, which corresponds to [Note.f].
  static const f = PitchClass(5);

  /// Pitch class 6, which corresponds to [Note.f.sharp] or [Note.g.flat].
  static const fSharp = PitchClass(6);

  /// Pitch class 7, which corresponds to [Note.g].
  static const g = PitchClass(7);

  /// Pitch class 8, which corresponds to [Note.g.sharp] or [Note.g.flat].
  static const gSharp = PitchClass(8);

  /// Pitch class 9, which corresponds to [Note.a].
  static const a = PitchClass(9);

  /// Pitch class 10, which corresponds to [Note.a.sharp] or [Note.b.flat].
  static const aSharp = PitchClass(10);

  /// Pitch class 11, which corresponds to [Note.b].
  static const b = PitchClass(11);

  /// Returns the different spellings at [distance] sharing the same [chroma].
  Set<Note> spellings({int distance = 0}) {
    assert(distance >= 0, 'Distance must be greater or equal than zero.');
    final baseNote = BaseNote.fromSemitones(chroma);

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
        Note(BaseNote.fromSemitones(chroma - 1)!, Accidental.sharp);
    final belowNote =
        Note(BaseNote.fromSemitones(chroma + 1)!, Accidental.flat);

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
  /// [PitchClass].
  ///
  /// Throws an [ArgumentError] when [withAccidental] does not match with any
  /// possible note.
  ///
  /// Example:
  /// ```dart
  /// PitchClass.d.resolveSpelling() == Note.d
  /// PitchClass.fSharp.resolveSpelling(Accidental.flat) == Note.g.flat
  /// PitchClass.cSharp.resolveSpelling(Accidental.natural) // throws
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
  /// [PitchClass].
  ///
  /// Like [resolveSpelling] except that this function returns the closest note
  /// where a similar call to [resolveSpelling] would throw an [ArgumentError].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.d.resolveClosestSpelling() == Note.d
  /// PitchClass.gSharp.resolveClosestSpelling(Accidental.flat)
  ///   == Note.a.flat
  /// PitchClass.cSharp.resolveClosestSpelling(Accidental.natural) == null
  /// ```
  Note resolveClosestSpelling([Accidental? preferredAccidental]) {
    try {
      return resolveSpelling(preferredAccidental);
      // ignore: avoid_catching_errors
    } on ArgumentError {
      return resolveSpelling();
    }
  }

  /// Returns a transposed [PitchClass] by [interval] from this [PitchClass].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.c.transposeBy(Interval.tritone) == PitchClass.fSharp
  /// PitchClass.a.transposeBy(-Interval.M2) == PitchClass.g
  /// ```
  @override
  // TODO(albertms10): use [IntervalClass]. See #248.
  PitchClass transposeBy(Interval interval) =>
      PitchClass(chroma + interval.semitones);

  /// Returns the [IntervalClass] expressed as [Interval] between this
  /// [PitchClass] and [other].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.c.interval(PitchClass.e) == Interval.M3
  /// PitchClass.gSharp.interval(PitchClass.d) == Interval.A4
  /// ```
  @override
  // TODO(albertms10): return [IntervalClass]. See #248.
  Interval interval(PitchClass other) {
    final difference = other.chroma - chroma;

    return Interval.fromSemitonesQuality(
      difference + (difference.isNegative ? chromaticDivisions : 0),
    );
  }

  /// Returns the integer notation for this [PitchClass].
  ///
  /// See [Integer notation](https://en.wikipedia.org/wiki/Pitch_class#Integer_notation).
  ///
  /// Example:
  /// ```dart
  /// PitchClass.c.integerNotation == '0'
  /// PitchClass.f.integerNotation == '5'
  /// PitchClass.aSharp.integerNotation == 't'
  /// PitchClass.b.integerNotation == 'e'
  /// ```
  String get integerNotation => switch (chroma) {
        10 => 't',
        11 => 'e',
        final chroma => '$chroma',
      };

  /// Performs a pitch-class multiplication modulo [chromaticDivisions] of this
  /// [PitchClass].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.cSharp * 7 == PitchClass.g
  /// PitchClass.d * 7 == PitchClass.d
  ///
  /// PitchClass.cSharp * 5 == PitchClass.f
  /// PitchClass.d * 5 == PitchClass.aSharp
  /// ```
  ///
  /// The multiplication by the two meaningful operations (5 and 7) gives us the
  /// circle of fourths and fifths transform, respectively, when operated on a
  /// chromatic scale as follows:
  ///
  /// ```dart
  /// ScalePattern.chromatic.on(PitchClass.c)
  ///   .degrees.map((note) => note * 7)
  ///     == Interval.P5.circleFrom(PitchClass.c, distance: 12)
  /// ```
  ///
  /// See [Pitch-class multiplication modulo 12](https://en.wikipedia.org/wiki/Multiplication_(music)#Pitch-class_multiplication_modulo_12).
  PitchClass operator *(int factor) => PitchClass(chroma * factor);

  @override
  String toString() => '{${spellings().join('|')}}';

  @override
  bool operator ==(Object other) =>
      other is PitchClass && chroma == other.chroma;

  @override
  int get hashCode => chroma.hashCode;

  @override
  int compareTo(PitchClass other) => chroma.compareTo(other.chroma);
}
