part of '../../music_notes.dart';

@immutable
final class Note implements Comparable<Note>, Scalable<Note> {
  final BaseNote baseNote;
  final Accidental accidental;

  const Note(this.baseNote, [this.accidental = Accidental.natural]);

  static const Note c = Note(BaseNote.c);
  static const Note d = Note(BaseNote.d);
  static const Note e = Note(BaseNote.e);
  static const Note f = Note(BaseNote.f);
  static const Note g = Note(BaseNote.g);
  static const Note a = Note(BaseNote.a);
  static const Note b = Note(BaseNote.b);

  /// Parse [source] as a [Note] and return its value.
  ///
  /// If the [source] string does not contain a valid [Note], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Note.parse('Bb') == Note.b.flat
  /// Note.parse('c') == Note.c
  /// Note.parse('z') // throws a FormatException
  /// ```
  factory Note.parse(String source) => Note(
        BaseNote.parse(source[0]),
        Accidental.parse(source.length > 1 ? source.substring(1) : ''),
      );

  /// [Comparator] for [Note]s by fifths distance.
  static int compareByFifthsDistance(Note a, Note b) =>
      a.circleOfFifthsDistance.compareTo(b.circleOfFifthsDistance);

  /// Returns the number of semitones that correspond to this [Note]
  /// from [BaseNote.c].
  ///
  /// Example:
  /// ```dart
  /// Note.d.semitones == 3
  /// Note.f.sharp.semitones == 7
  /// ```
  int get semitones =>
      (baseNote.value + accidental.semitones).chromaticModExcludeZero;

  /// Returns the difference in semitones between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.difference(Note.d) == 2
  /// Note.e.flat.difference(Note.b.flat) == 7
  /// Note.a.difference(Note.g) == -2
  /// ```
  int difference(Note other) => other.semitones - semitones;

  /// Returns this [Note] sharpened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.c.sharp == const Note(BaseNote.c, Accidental.sharp)
  /// Note.a.sharp == const Note(BaseNote.a, Accidental.sharp)
  /// ```
  Note get sharp => Note(baseNote, Accidental(accidental.semitones + 1));

  /// Returns this [Note] flattened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat == const Note(BaseNote.e, Accidental.flat)
  /// Note.f.flat == const Note(BaseNote.f, Accidental.flat)
  /// ```
  Note get flat => Note(baseNote, Accidental(accidental.semitones - 1));

  /// Returns the [TonalMode.major] [Tonality] from this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major == const Tonality(Note.c, TonalMode.major)
  /// Note.e.flat.major == const Tonality(Note.e.flat, TonalMode.major)
  /// ```
  Tonality get major => Tonality(this, TonalMode.major);

  /// Returns the [TonalMode.minor] [Tonality] from this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor == const Tonality(Note.d, TonalMode.minor)
  /// Note.g.sharp.minor == const Tonality(Note.g.sharp, TonalMode.minor)
  /// ```
  Tonality get minor => Tonality(this, TonalMode.minor);

  /// Returns the [ChordPattern.augmentedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.augmentedTriad == Chord([Note.d.flat, Note.f, Note.a])
  /// Note.g.augmentedTriad == Chord([Note.g, Note.b, Note.d.sharp])
  /// ```
  Chord<Note> get augmentedTriad => ChordPattern.augmentedTriad.on(this);

  /// Returns the [ChordPattern.majorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.majorTriad == Chord([Note.d, Note.f.sharp, Note.a])
  /// Note.a.flat.majorTriad == Chord([Note.a.flat, Note.c, Note.e.flat])
  /// ```
  Chord<Note> get majorTriad => ChordPattern.majorTriad.on(this);

  /// Returns the [ChordPattern.minorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.e.minorTriad == Chord([Note.e, Note.g, Note.b])
  /// Note.f.sharp.minorTriad == Chord([Note.f.sharp, Note.a, Note.c.sharp])
  /// ```
  Chord<Note> get minorTriad => ChordPattern.minorTriad.on(this);

  /// Returns the [ChordPattern.diminishedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.a.diminishedTriad == Chord([Note.a, Note.c, Note.e.flat])
  /// Note.b.diminishedTriad == Chord([Note.b, Note.d, Note.f])
  /// ```
  Chord<Note> get diminishedTriad => ChordPattern.diminishedTriad.on(this);

  /// Returns this [Note] respelled by [baseNote] while keeping the same
  /// number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.c.sharp.respellByBaseNote(BaseNote.d) == Note.d.flat
  /// Note.f.respellByBaseNote(BaseNote.e) == Note.e.sharp
  /// Note.g.respellByBaseNote(BaseNote.a) == Note.a.flat.flat
  /// ```
  Note respellByBaseNote(BaseNote baseNote) {
    final rawSemitones = semitones - baseNote.value;
    final deltaSemitones = rawSemitones +
        (rawSemitones.abs() > (chromaticDivisions * 0.5)
            ? chromaticDivisions * -rawSemitones.sign
            : 0);

    return Note(baseNote, Accidental(deltaSemitones));
  }

  /// Returns this [Note] respelled upwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.respelledUpwards == Note.a.flat
  /// Note.e.sharp.respelledUpwards == Note.f
  /// ```
  Note get respelledUpwards =>
      respellByBaseNote(BaseNote.fromOrdinal(baseNote.ordinal + 1));

  /// Returns this [Note] respelled downwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respelledDownwards == Note.f.sharp
  /// Note.c.respelledDownwards == Note.b.sharp
  /// ```
  Note get respelledDownwards =>
      respellByBaseNote(BaseNote.fromOrdinal(baseNote.ordinal - 1));

  /// Returns this [Note] respelled by [accidental] while keeping the same
  /// number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat.respellByAccidental(Accidental.sharp) == Note.d.sharp
  /// Note.b.respellByAccidental(Accidental.flat) == Note.c.flat
  /// Note.g.respellByAccidental(Accidental.sharp) == null
  /// ```
  Note? respellByAccidental(Accidental accidental) {
    final baseNote = BaseNote.fromValue(semitones - accidental.semitones);
    if (baseNote == null) return null;

    return Note(baseNote, accidental);
  }

  /// Returns this [Note] with the simplest [Accidental] spelling while keeping
  /// the same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.e.sharp.respelledSimple == Note.f
  /// Note.d.flat.flat.respelledSimple == Note.c
  /// Note.f.sharp.sharp.sharp.respelledSimple == Note.g.sharp
  /// ```
  Note get respelledSimple =>
      respellByAccidental(Accidental.natural) ??
      respellByAccidental(Accidental(accidental.semitones.sign))!;

  /// Returns this [Note] positioned in the given [octave] as [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(3) == const PositionedNote(Note.c, 3)
  /// Note.a.flat.inOctave(2) == PositionedNote(Note.a.flat, 2)
  /// ```
  PositionedNote inOctave(int octave) => PositionedNote(this, octave);

  /// Returns the circle of fifths starting from this [Note] up to [distance].
  ///
  /// Example:
  /// ```dart
  /// Note.c.circleOfFifths(distance: 4) == (
  ///   sharps: [Note.g, Note.d, Note.a, Note.e],
  ///   flats: [Note.f, Note.b.flat, Note.e.flat, Note.a.flat],
  /// )
  ///
  /// Note.a.circleOfFifths(distance: 4) == (
  ///   sharps: [Note.e, Note.b, Note.f.sharp, Note.c.sharp],
  ///   flats: [Note.d, Note.g, Note.c, Note.f],
  /// )
  /// ```
  /// ---
  /// See also:
  /// * [flatCircleOfFifths] for a flattened version of [circleOfFifths].
  ({List<Note> sharps, List<Note> flats}) circleOfFifths({
    int distance = chromaticDivisions ~/ 2,
  }) =>
      (
        sharps:
            Interval.P5.circleFrom(this, distance: distance).skip(1).toList(),
        flats: (-Interval.P5)
            .circleFrom(this, distance: distance)
            .skip(1)
            .toList(),
      );

  /// Returns the flattened version of [circleOfFifths] from this [Note] up to
  /// [distance].
  ///
  /// Example:
  /// ```dart
  /// Note.c.flatCircleOfFifths(distance: 3)
  ///   == [Note.e.flat, Note.b.flat, Note.f, Note.c, Note.g, Note.d, Note.a]
  ///
  /// Note.a.flatCircleOfFifths(distance: 3)
  ///   == [Note.c, Note.g, Note.d, Note.a, Note.e, Note.b, Note.f.sharp]
  /// ```
  ///
  /// It is equivalent to sorting an array of the same [Note]s using the
  /// [compareByFifthsDistance] comparator:
  ///
  /// ```dart
  /// Note.c.flatCircleOfFifths(distance: 3)
  ///   == ScalePattern.dorian.on(Note.c).degrees.skip(1)
  ///        .sorted(Note.compareByFifthsDistance)
  /// ```
  /// ---
  /// See also:
  /// * [circleOfFifths] for a different representation of the same circle of
  ///   fifths.
  List<Note> flatCircleOfFifths({int distance = chromaticDivisions ~/ 2}) {
    final (:flats, :sharps) = circleOfFifths(distance: distance);

    return [...flats.reversed, this, ...sharps];
  }

  /// Returns the distance in relation to the circle of fifths.
  ///
  /// Example:
  /// ```dart
  /// Note.c.circleOfFifthsDistance == 0
  /// Note.d.circleOfFifthsDistance == 2
  /// Note.a.flat.circleOfFifthsDistance == -4
  /// ```
  int get circleOfFifthsDistance =>
      Tonality(this, TonalMode.major).keySignature.distance;

  /// Returns the exact fifths distance between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.a.flat.fifthsDistanceWith(Note.c.sharp) == 11
  /// Note.a.flat.fifthsDistanceWith(Note.d.flat) == -1
  /// ```
  int fifthsDistanceWith(Note other) =>
      Interval.P5.distanceBetween(this, other);

  /// Returns the exact interval between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.interval(Note.d) == Interval.m2
  /// Note.d.interval(Note.a.flat) == Interval.d5
  /// ```
  @override
  Interval interval(Note other) {
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
  /// Note.c.transposeBy(Interval.tritone) == Note.f.sharp
  /// Note.a.transposeBy(-Interval.M2) == Note.g
  /// ```
  @override
  Note transposeBy(Interval interval) {
    final transposedBaseNote = baseNote.transposeBySize(interval.size);
    final positiveDifference = interval.isDescending
        ? transposedBaseNote.positiveDifference(baseNote)
        : baseNote.positiveDifference(transposedBaseNote);

    final accidentalSemitones = (accidental.semitones * interval.size.sign) +
        ((interval.semitones * interval.size.sign) - positiveDifference);
    final semitonesOctaveMod = accidentalSemitones -
        chromaticDivisions * (interval.size._sizeAbsShift ~/ 8);

    return Note(
      transposedBaseNote,
      Accidental(semitonesOctaveMod * interval.size.sign),
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
