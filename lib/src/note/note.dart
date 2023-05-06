part of '../../music_notes.dart';

@immutable
class Note implements MusicItem, Transposable<Note> {
  final Notes note;
  final Accidental accidental;

  const Note(this.note, [this.accidental = Accidental.natural]);

  static const Note c = Note(Notes.c);
  static const Note cSharp = Note(Notes.c, Accidental.sharp);
  static const Note dFlat = Note(Notes.d, Accidental.flat);
  static const Note d = Note(Notes.d);
  static const Note dSharp = Note(Notes.d, Accidental.sharp);
  static const Note eFlat = Note(Notes.e, Accidental.flat);
  static const Note e = Note(Notes.e);
  static const Note f = Note(Notes.f);
  static const Note fSharp = Note(Notes.f, Accidental.sharp);
  static const Note gFlat = Note(Notes.g, Accidental.flat);
  static const Note g = Note(Notes.g);
  static const Note gSharp = Note(Notes.g, Accidental.sharp);
  static const Note aFlat = Note(Notes.a, Accidental.flat);
  static const Note a = Note(Notes.a);
  static const Note aSharp = Note(Notes.a, Accidental.sharp);
  static const Note bFlat = Note(Notes.b, Accidental.flat);
  static const Note b = Note(Notes.b);

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

  /// Returns the number of semitones that correspond to this [Note]
  /// from [Notes.c].
  ///
  /// Example:
  /// ```dart
  /// Note.d.semitones == 3
  /// Note.fSharp.semitones == 7
  /// ```
  @override
  int get semitones =>
      (note.value + accidental.semitones).chromaticModExcludeZero;

  /// Returns the difference in semitones between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.difference(Note.d) == 2
  /// Note.eFlat.difference(Note.bFlat) == 7
  /// Note.a.difference(Note.g) == -2
  /// ```
  int difference(covariant Note other) => other.semitones - semitones;

  /// Returns this [Note] positioned in the given [octave] as [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(3)
  ///   == const PositionedNote(Notes.c, Accidental.natural, 3);
  /// Note.aFlat.inOctave(2)
  ///   == const PositionedNote(Notes.a, Accidental.flat, 2);
  /// ```
  PositionedNote inOctave(int octave) =>
      PositionedNote(note, accidental, octave);

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

    var tempNote =
        EnharmonicNote(currentPitch).toClosestNote(preferredAccidental);

    while (tempNote != other && distance < chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = EnharmonicNote(currentPitch.chromaticModExcludeZero)
          .toClosestNote(preferredAccidental);
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
    final intervalSize = note.intervalSize(other.note);

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
    final transposedNote = note.transposeBy(interval.size);
    final positiveDifference = interval.isDescending
        ? transposedNote.positiveDifference(note)
        : note.positiveDifference(transposedNote);

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
      note.name.toUpperCase() +
      (accidental != Accidental.natural ? accidental.symbol : '');

  @override
  bool operator ==(Object other) =>
      other is Note && note == other.note && accidental == other.accidental;

  @override
  int get hashCode => Object.hash(note, accidental);

  @override
  int compareTo(covariant Note other) => compareMultiple([
        () => semitones.compareTo(other.semitones),
        () => note.value.compareTo(other.note.value),
      ]);
}
