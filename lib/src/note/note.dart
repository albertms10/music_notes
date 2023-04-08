part of '../../music_notes.dart';

@immutable
class Note implements MusicItem, Comparable<Note> {
  final Notes note;
  final Accidental accidental;

  const Note(this.note, [this.accidental = Accidental.natural]);

  /// Returns the [Note] from the [Tonality] given its [accidentals] number,
  /// [mode] and optional [accidental].
  ///
  /// Examples:
  /// ```dart
  /// Note.fromTonalityAccidentals(2, Modes.major, Accidental.sharp)
  ///   == const Note(Notes.d)
  ///
  /// Note.fromTonalityAccidentals(0, Modes.minor)
  ///   == const Note(Notes.a)
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
              const Interval(Intervals.third, Qualities.minor, descending: true)
                  .semitones,
            )
            .note(accidental);
  }

  /// Returns the [Note] from the [Tonality] given its [accidentals] number
  /// and optional [accidental].
  ///
  /// Examples:
  /// ```dart
  /// Note.fromRawAccidentals(2, Accidental.sharp)
  ///   == const Note(Notes.d)
  ///
  /// Note.fromRawAccidentals(0)
  ///   == const Note(Notes.a)
  /// ```
  factory Note.fromRawAccidentals(
    int accidentals, [
    Accidental accidental = Accidental.natural,
  ]) =>
      EnharmonicNote(
        Interval(
                  Intervals.fifth,
                  Qualities.perfect,
                  descending: accidental == Accidental.flat,
                ).semitones *
                accidentals +
            1,
      ).note(
        (accidental == Accidental.flat && accidentals > 8) ||
                (accidental == Accidental.sharp && accidentals > 10)
            ? Accidental(accidental.semitones + 1)
            : accidental,
      );

  /// Returns the number of semitones that correspond to this [Note]
  /// from [Notes.c].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.d).semitones == 3
  /// const Note(Notes.f, Accidental.sharp).semitones == 7
  /// ```
  @override
  int get semitones =>
      chromaticModExcludeZero(note.value + accidental.semitones);

  /// Returns the difference in semitones between this [Note] and [other].
  int difference(Note other) => chromaticMod(other.semitones - semitones);

  /// Returns the iteration distance of an [interval] between
  /// this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// const Note(Notes.c).intervalDistance(
  ///   const Note(Notes.d),
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

    var tempNote = EnharmonicNote(currentPitch).note(preferredAccidental);

    while (tempNote != other && distance < chromaticDivisions) {
      distance++;
      currentPitch += semitones;
      tempNote = EnharmonicNote(currentPitch).note(preferredAccidental);
    }

    return distance;
  }

  /// Returns the exact interval between this [Note] and [other].
  ///
  /// Examples:
  /// ```dart
  /// const Note(Notes.c).exactInterval(const Note(Notes.d))
  ///   == const Interval(Intervals.second, Qualities.minor)
  ///
  /// const Note(Notes.d)
  ///         .exactInterval(const Note(Notes.a, Accidental.flat)) ==
  ///     const Interval(Intervals.fifth, Qualities.diminished)
  /// ```
  Interval exactInterval(Note other) {
    final interval = note.interval(other.note);

    return Interval.fromDelta(
      interval,
      difference(other) - interval.semitones + 1,
    );
  }

  @override
  String toString() =>
      note.name +
      (accidental != Accidental.natural ? ' ${accidental.symbol}' : '');

  @override
  bool operator ==(Object other) =>
      other is Note && note == other.note && accidental == other.accidental;

  @override
  int get hashCode => hash2(note, accidental);

  @override
  int compareTo(covariant MusicItem other) =>
      semitones.compareTo(other.semitones);
}
