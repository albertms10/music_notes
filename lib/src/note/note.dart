part of '../../music_notes.dart';

@immutable
class Note implements MusicItem, Comparable<Note> {
  final Notes note;
  final Accidental accidental;

  const Note(this.note, [this.accidental = Accidental.natural]);

  factory Note.fromSemitones(
    int semitones, [
    Accidental preferredAccidental = Accidental.natural,
  ]) =>
      EnharmonicNote.note(semitones, preferredAccidental);

  /// Returns the [Note] from the [Tonality] given its [accidentals] number,
  /// [mode] and optional [accidental].
  ///
  /// Examples:
  /// ```dart
  /// Note.fromTonalityAccidentals(2, Modes.major, Accidental.sharp)
  ///   == const Note(Notes.re)
  ///
  /// Note.fromTonalityAccidentals(0, Modes.minor)
  ///   == const Note(Notes.la)
  /// ```
  factory Note.fromTonalityAccidentals(
    int accidentals,
    Modes mode, [
    Accidental accidental = Accidental.natural,
  ]) {
    final note = Note.fromRawAccidentals(accidentals, accidental);

    return mode == Modes.major
        ? note
        : note.transposeBy(
            const Interval(Intervals.third, Qualities.minor, descending: true)
                .semitones,
            accidental,
          );
  }

  /// Returns the [Note] from the [Tonality] given its [accidentals] number
  /// and optional [accidental].
  ///
  /// Examples:
  /// ```dart
  /// Note.fromRawAccidentals(2, Accidental.sharp)
  ///   == const Note(Notes.re)
  ///
  /// Note.fromRawAccidentals(0)
  ///   == const Note(Notes.la)
  /// ```
  factory Note.fromRawAccidentals(
    int accidentals, [
    Accidental accidental = Accidental.natural,
  ]) =>
      Note.fromSemitones(
        Interval(
                  Intervals.fifth,
                  Qualities.perfect,
                  descending: accidental == Accidental.flat,
                ).semitones *
                accidentals +
            1,
        (accidental == Accidental.flat && accidentals > 8) ||
                (accidental == Accidental.sharp && accidentals > 10)
            ? Accidental(accidental.value + 1)
            : accidental,
      );

  /// Returns the number of semitones that correspond to this [Note]
  /// from [Notes.ut].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.re).semitones == 3
  /// const Note(Notes.fa, Accidental.sharp).semitones == 7
  /// ```
  @override
  int get semitones => chromaticModExcludeZero(note.value + accidental.value);

  /// Returns the difference in semitones between this [Note] and [other].
  int difference(Note other) => chromaticMod(other.semitones - semitones);

  /// Returns the iteration distance of an [interval] between
  /// this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// const Note(Notes.ut).intervalDistance(
  ///   const Note(Notes.re),
  ///   const Interval(Intervals.fifth, Qualities.perfect),
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
    var distance = 0;
    var currentPitch = this.semitones;

    var tempNote = Note.fromSemitones(currentPitch, preferredAccidental);

    while (tempNote != other && distance < chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = Note.fromSemitones(currentPitch, preferredAccidental);
    }

    return distance;
  }

  /// Returns the exact interval between this [Note] and [other].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.ut).exactInterval(const Note(Notes.re))
  ///   == const Interval(Intervals.second, Qualities.minor)
  ///
  /// const Note(Notes.re)
  ///         .exactInterval(const Note(Notes.la, Accidental.flat)) ==
  ///     const Interval(Intervals.fifth, Qualities.diminished)
  /// ```
  Interval exactInterval(Note other) {
    final interval = note.interval(other.note);

    return Interval.fromDelta(
      interval,
      difference(other) - interval.semitones + 1,
    );
  }

  /// Returns the transposed [Note] by [semitones], with an optional
  /// [preferredAccidental].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.mi, Accidental.flat).transposeBy(-3)
  ///   == const Note(Notes.ut)
  ///
  /// const Note(Notes.la).transposeBy(5)
  ///   == const Note(Notes.re)
  ///
  /// const Note(Notes.mi).transposeBy(
  ///   const Interval(Intervals.fifth, Qualities.perfect),
  /// ) == const Note(Notes.si)
  ///
  /// const Note(Notes.sol).transposeBy(
  ///   const Interval(Intervals.third, Qualities.major, descending: true),
  /// ) == const Note(Notes.mi, Accidental.flat)
  /// ```
  /// ```
  Note transposeBy(
    int semitones, [
    Accidental preferredAccidental = Accidental.natural,
  ]) =>
      Note.fromSemitones(this.semitones + semitones, preferredAccidental);

  @override
  String toString() =>
      note.name + (accidental.value != 0 ? ' ${accidental.symbol}' : '');

  @override
  bool operator ==(Object other) =>
      other is Note && note == other.note && accidental == other.accidental;

  @override
  int get hashCode => hash2(note, accidental);

  @override
  int compareTo(covariant MusicItem other) =>
      semitones.compareTo(other.semitones);
}
