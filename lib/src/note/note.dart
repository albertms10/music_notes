part of '../../music_notes.dart';

@immutable
final class Note implements Comparable<Note>, Transposable<Note> {
  final BaseNote baseNote;
  final Accidental accidental;

  const Note(this.baseNote, [this.accidental = Accidental.natural]);

  static const Note c = Note(BaseNote.c);
  static const Note cSharp = Note(BaseNote.c, Accidental.sharp);
  static const Note dFlat = Note(BaseNote.d, Accidental.flat);
  static const Note d = Note(BaseNote.d);
  static const Note dSharp = Note(BaseNote.d, Accidental.sharp);
  static const Note eFlat = Note(BaseNote.e, Accidental.flat);
  static const Note e = Note(BaseNote.e);
  static const Note f = Note(BaseNote.f);
  static const Note fSharp = Note(BaseNote.f, Accidental.sharp);
  static const Note gFlat = Note(BaseNote.g, Accidental.flat);
  static const Note g = Note(BaseNote.g);
  static const Note gSharp = Note(BaseNote.g, Accidental.sharp);
  static const Note aFlat = Note(BaseNote.a, Accidental.flat);
  static const Note a = Note(BaseNote.a);
  static const Note aSharp = Note(BaseNote.a, Accidental.sharp);
  static const Note bFlat = Note(BaseNote.b, Accidental.flat);
  static const Note b = Note(BaseNote.b);

  /// Returns the [Note] from the [Tonality] given its [accidentals] number,
  /// [mode] and optional [accidental].
  ///
  /// Example:
  /// ```dart
  /// Note.fromTonalityAccidentals(2, TonalMode.major, Accidental.sharp)
  ///   == Note.d
  /// Note.fromTonalityAccidentals(0, TonalMode.minor) == Note.a
  /// ```
  factory Note.fromTonalityAccidentals(
    int accidentals,
    TonalMode mode, [
    Accidental accidental = Accidental.natural,
  ]) {
    final note = KeySignature(accidentals, accidental).majorNote;
    if (mode == TonalMode.major) return note;

    return note.transposeBy(-Interval.minorThird);
  }

  /// [Comparator] for [Note]s by fifths distance.
  static int compareByFifthsDistance(Note a, Note b) =>
      a.circleOfFifthsDistance.compareTo(b.circleOfFifthsDistance);

  /// Returns the number of semitones that correspond to this [Note]
  /// from [BaseNote.c].
  ///
  /// Example:
  /// ```dart
  /// Note.d.semitones == 3
  /// Note.fSharp.semitones == 7
  /// ```
  int get semitones =>
      (baseNote.value + accidental.semitones).chromaticModExcludeZero;

  /// Returns the difference in semitones between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.difference(Note.d) == 2
  /// Note.eFlat.difference(Note.bFlat) == 7
  /// Note.a.difference(Note.g) == -2
  /// ```
  int difference(Note other) => other.semitones - semitones;

  /// Returns this [Note] positioned in the given [octave] as [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(3)
  ///   == const PositionedNote(BaseNote.c, Accidental.natural, 3);
  /// Note.aFlat.inOctave(2)
  ///   == const PositionedNote(BaseNote.a, Accidental.flat, 2);
  /// ```
  PositionedNote inOctave(int octave) => PositionedNote(this, octave);

  /// Returns the distance in relation to the circle of fifths.
  ///
  /// Example:
  /// ```dart
  /// Note.c.circleOfFifthsDistance == 0
  /// Note.d.circleOfFifthsDistance == 2
  /// Note.aFlat.circleOfFifthsDistance == -4
  /// ```
  int get circleOfFifthsDistance =>
      Tonality(this, TonalMode.major).keySignature.distance;

  /// Returns the exact fifths distance between this and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.aFlat.exactFifthsDistance(Note.cSharp) == 11
  /// Note.aFlat.exactFifthsDistance(Note.dFlat) == -1
  /// ```
  int exactFifthsDistance(Note other) =>
      intervalDistance(other, Interval.perfectFifth);

  /// Returns the iteration distance of an [interval] between
  /// this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.intervalDistance(Note.d, Interval.perfectFifth) == 2
  /// ```
  int intervalDistance(Note other, Interval interval) {
    final distanceFlat = _runSemitonesDistance(
      other,
      interval.inverted.semitones,
      Accidental.flat,
    );
    final distanceSharp = _runSemitonesDistance(
      other,
      interval.semitones,
      Accidental.sharp,
    );

    return distanceFlat < distanceSharp ? -distanceFlat : distanceSharp;
  }

  /// Returns the iteration distance of an interval between
  /// this [Note] and [other] with a [preferredAccidental].
  ///
  /// It is mainly used by [intervalDistance].
  int _runSemitonesDistance(
    Note other,
    int semitones,
    Accidental preferredAccidental,
  ) {
    if (this == other) return 0;

    var distance = 0;
    var currentPitch = this.semitones;

    var tempNote = EnharmonicNote(currentPitch)
        .resolveClosestSpelling(preferredAccidental);

    while (tempNote != other && distance < chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = EnharmonicNote(currentPitch.chromaticModExcludeZero)
          .resolveClosestSpelling(preferredAccidental);
    }

    return distance;
  }

  /// Returns the exact interval between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.exactInterval(Note.d) == Interval.minorSecond
  /// Note.d.exactInterval(Note.aFlat) == Interval.diminishedFifth
  /// ```
  Interval exactInterval(Note other) {
    final intervalSize = baseNote.intervalSize(other.baseNote);

    return Interval.fromDelta(
      intervalSize,
      difference(other).chromaticMod - intervalSize.semitones,
    );
  }

  /// Returns a transposed [Note] by [interval] from this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.c.transposeBy(Interval.tritone) == Note.fSharp
  /// Note.a.transposeBy(-Interval.majorSecond) == Note.g
  /// ```
  @override
  Note transposeBy(Interval interval) {
    final transposedNote = baseNote.transposeBy(interval.size);
    final positiveDifference = interval.isDescending
        ? transposedNote.positiveDifference(baseNote)
        : baseNote.positiveDifference(transposedNote);

    return Note(
      transposedNote,
      Accidental(
        ((accidental.semitones * interval.size.sign) +
                ((interval.semitones * interval.size.sign) -
                    positiveDifference)) *
            interval.size.sign,
      ),
    );
  }

  @override
  String toString() =>
      baseNote.name.toUpperCase() +
      (accidental != Accidental.natural ? accidental.symbol : '');

  @override
  bool operator ==(Object other) =>
      other is Note &&
      baseNote == other.baseNote &&
      accidental == other.accidental;

  @override
  int get hashCode => Object.hash(baseNote, accidental);

  @override
  int compareTo(Note other) => compareMultiple([
        () => semitones.compareTo(other.semitones),
        () => baseNote.value.compareTo(other.baseNote.value),
      ]);
}
