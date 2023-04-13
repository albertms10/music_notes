part of '../../music_notes.dart';

@immutable
class Note implements MusicItem {
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
  /// Note.fromTonalityAccidentals(2, Modes.major, Accidental.sharp) == Note.d
  /// Note.fromTonalityAccidentals(0, Modes.minor) == Note.a
  /// ```
  factory Note.fromTonalityAccidentals(
    int accidentals,
    Modes mode, [
    Accidental accidental = Accidental.natural,
  ]) {
    final note = Note.fromRawAccidentals(accidentals, accidental);

    return mode == Modes.major
        ? note
        : EnharmonicNote(note.semitones)
            .transposeBy(
              const Interval.imperfect(
                3,
                ImperfectQuality.minor,
                descending: true,
              ).semitones,
            )
            .toNote(accidental);
  }

  /// Returns the [Note] from the [Tonality] given its [accidentals] number
  /// and optional [accidental].
  ///
  /// Example:
  /// ```dart
  /// Note.fromRawAccidentals(2, Accidental.sharp) == Note.d
  /// Note.fromRawAccidentals(0) == Note.a
  /// ```
  factory Note.fromRawAccidentals(
    int accidentals, [
    Accidental accidental = Accidental.natural,
  ]) {
    final fifthInterval = Interval.perfect(
      5,
      PerfectQuality.perfect,
      descending: accidental == Accidental.flat,
    );

    return EnharmonicNote(
      (fifthInterval.semitones * accidentals + 1).chromaticModExcludeZero,
    ).toNote(
      (accidental == Accidental.flat && accidentals > 8) ||
              (accidental == Accidental.sharp && accidentals > 10)
          ? Accidental(accidental.semitones + 1)
          : accidental,
    );
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
  int difference(Note other) => (other.semitones - semitones).chromaticMod;

  /// Returns the exact fifths distance between this and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.aFlat.exactFifthsDistance(Note.cSharp) == 11
  /// Note.aFlat.exactFifthsDistance(Note.dFlat) == -1
  /// ```
  int exactFifthsDistance(Note other) => intervalDistance(
        other,
        const Interval.perfect(5, PerfectQuality.perfect),
      );

  /// Returns the iteration distance of an [interval] between
  /// this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.intervalDistance(
  ///   Note.d,
  ///   const Interval.perfect(5, PerfectQuality.perfect),
  /// ) == 2
  /// ```
  int intervalDistance(Note other, Interval interval) {
    final distance = _runSemitonesDistance(
      other,
      interval.semitones,
      Accidental.sharp,
    );

    return distance < chromaticDivisions
        ? distance
        : _runSemitonesDistance(
              other,
              interval.inverted.semitones,
              Accidental.flat,
            ) *
            -1;
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

    var tempNote = EnharmonicNote(currentPitch).toNote(preferredAccidental);

    while (tempNote != other && distance < chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = EnharmonicNote(currentPitch.chromaticModExcludeZero)
          .toNote(preferredAccidental);
    }

    return distance;
  }

  /// Returns the exact interval between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.exactInterval(Note.d)
  ///   == const Interval.imperfect(2, ImperfectQuality.minor)
  ///
  /// Note.d.exactInterval(Note.aFlat) ==
  ///     const Interval.perfect(5, PerfectQuality.diminished)
  /// ```
  Interval exactInterval(Note other) {
    final interval = note.interval(other.note);

    return Interval.fromDelta(
      interval,
      difference(other) - interval.semitones,
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
  int get hashCode => hash2(note, accidental);

  @override
  int compareTo(covariant Note other) => compareMultiple([
        () => semitones.compareTo(other.semitones),
        () => note.value.compareTo(other.note.value),
      ]);
}
