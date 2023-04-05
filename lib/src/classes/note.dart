part of '../../music_notes.dart';

@immutable
class Note implements MusicItem, Comparable<Note> {
  final Notes note;
  final Accidental? accidental;

  const Note(this.note, [this.accidental]);

  factory Note.fromSemitones(
    int semitones, [
    Accidental? preferredAccidental,
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
    Accidental? accidental,
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
  factory Note.fromRawAccidentals(int accidentals, [Accidental? accidental]) =>
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
            ? Accidental(accidental!.value + 1)
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
  int get semitones => chromaticModExcludeZero(note.value + accidentalValue);

  /// Returns this [Note]’s [accidental] value.
  int get accidentalValue => accidental?.value ?? 0;

  /// Returns the `delta` difference between this [Note] and [note].
  int semitonesDelta(Note note) => chromaticMod(note.semitones - semitones);

  /// Returns the iteration distance of an [interval] between
  /// this [Note] and [note].
  ///
  /// Example:
  /// ```dart
  /// const Note(Notes.ut).intervalDistance(
  ///   const Note(Notes.re),
  ///   const Interval(Intervals.fifth, Qualities.perfect),
  /// ) == 2
  /// ```
  int intervalDistance(Note note, Interval interval) {
    final distance = _runSemitonesDistance(
      note,
      interval.semitones,
      Accidental.sharp,
    );

    return distance < chromaticDivisions
        ? distance
        : _runSemitonesDistance(
              note,
              interval.inverted.semitones,
              Accidental.flat,
            ) *
            -1;
  }

  /// Returns the iteration distance of an interval between
  /// this [Note] and [note] with a [preferredAccidental].
  ///
  /// It is mainly used by [intervalDistance].
  int _runSemitonesDistance(
    Note note,
    int semitones,
    Accidental preferredAccidental,
  ) {
    var distance = 0;
    var currentPitch = this.semitones;

    var tempNote = Note.fromSemitones(currentPitch, preferredAccidental);

    while (tempNote != note && distance < chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = Note.fromSemitones(currentPitch, preferredAccidental);
    }

    return distance;
  }

  /// Returns the exact interval between this [Note] and [note].
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
  Interval exactInterval(Note note) {
    final interval = this.note.interval(note.note);

    return Interval.fromDelta(
      interval,
      semitonesDelta(note) - interval.semitones + 1,
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
  Note transposeBy(int semitones, [Accidental? preferredAccidental]) =>
      Note.fromSemitones(this.semitones + semitones, preferredAccidental);

  @override
  String toString() =>
      note.name + (accidental != null ? ' ${accidental!.symbol}' : '');

  @override
  bool operator ==(Object other) =>
      other is Note && note == other.note && accidental == other.accidental;

  @override
  int get hashCode => hash2(note, accidental);

  @override
  int compareTo(covariant MusicItem other) =>
      semitones.compareTo(other.semitones);
}
