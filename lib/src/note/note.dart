part of '../../music_notes.dart';

/// A musical note.
///
/// ---
/// See also:
/// * [BaseNote].
/// * [Accidental].
/// * [Pitch].
/// * [KeySignature].
/// * [Tonality].
@immutable
final class Note extends Scalable<Note> implements Comparable<Note> {
  /// The base note that defines this [Note].
  final BaseNote baseNote;

  /// The accidental that modifies the [baseNote].
  final Accidental accidental;

  /// Creates a new [Note] from [baseNote] and [accidental].
  const Note(this.baseNote, [this.accidental = Accidental.natural]);

  /// Note C.
  static const Note c = Note(BaseNote.c);

  /// Note D.
  static const Note d = Note(BaseNote.d);

  /// Note E.
  static const Note e = Note(BaseNote.e);

  /// Note F.
  static const Note f = Note(BaseNote.f);

  /// Note G.
  static const Note g = Note(BaseNote.g);

  /// Note A.
  static const Note a = Note(BaseNote.a);

  /// Note B.
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

  /// [Comparator] for [Note]s by closest distance.
  static int compareByClosestDistance(Note a, Note b) => compareMultiple([
        () {
          final distance = (a.semitones - b.semitones).abs();

          return (distance <= chromaticDivisions - distance)
              ? a.semitones.compareTo(b.semitones)
              : b.semitones.compareTo(a.semitones);
        },
        ..._comparators(a, b),
      ]);

  static List<int Function()> _comparators(Note a, Note b) => [
        () => a.semitones.compareTo(b.semitones),
        () => a.baseNote.semitones.compareTo(b.baseNote.semitones),
      ];

  /// Returns the number of semitones that correspond to this [Note]
  /// from [BaseNote.c].
  ///
  /// Example:
  /// ```dart
  /// Note.d.semitones == 2
  /// Note.f.sharp.semitones == 6
  /// Note.b.sharp.semitones == 12
  /// Note.c.flat.semitones == -1
  /// ```
  @override
  int get semitones => baseNote.semitones + accidental.semitones;

  /// Returns the difference in semitones between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.difference(Note.d) == 2
  /// Note.a.difference(Note.g) == -2
  /// Note.e.flat.difference(Note.b.flat) == -5
  /// ```
  @override
  int difference(Note other) => super.difference(other);

  /// Returns this [Note] sharpened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.c.sharp == const Note(BaseNote.c, Accidental.sharp)
  /// Note.a.sharp == const Note(BaseNote.a, Accidental.sharp)
  /// ```
  Note get sharp => Note(baseNote, accidental + 1);

  /// Returns this [Note] flattened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat == const Note(BaseNote.e, Accidental.flat)
  /// Note.f.flat == const Note(BaseNote.f, Accidental.flat)
  /// ```
  Note get flat => Note(baseNote, accidental - 1);

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

  /// Returns the [ChordPattern.diminishedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.a.diminishedTriad == Chord([Note.a, Note.c, Note.e.flat])
  /// Note.b.diminishedTriad == Chord([Note.b, Note.d, Note.f])
  /// ```
  Chord<Note> get diminishedTriad => ChordPattern.diminishedTriad.on(this);

  /// Returns the [ChordPattern.minorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.e.minorTriad == Chord([Note.e, Note.g, Note.b])
  /// Note.f.sharp.minorTriad == Chord([Note.f.sharp, Note.a, Note.c.sharp])
  /// ```
  Chord<Note> get minorTriad => ChordPattern.minorTriad.on(this);

  /// Returns the [ChordPattern.majorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.majorTriad == Chord([Note.d, Note.f.sharp, Note.a])
  /// Note.a.flat.majorTriad == Chord([Note.a.flat, Note.c, Note.e.flat])
  /// ```
  Chord<Note> get majorTriad => ChordPattern.majorTriad.on(this);

  /// Returns the [ChordPattern.augmentedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.augmentedTriad == Chord([Note.d.flat, Note.f, Note.a])
  /// Note.g.augmentedTriad == Chord([Note.g, Note.b, Note.d.sharp])
  /// ```
  Chord<Note> get augmentedTriad => ChordPattern.augmentedTriad.on(this);

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
    final rawSemitones = semitones - baseNote.semitones;
    final deltaSemitones = rawSemitones +
        (rawSemitones.abs() > (chromaticDivisions * 0.5)
            ? chromaticDivisions * -rawSemitones.sign
            : 0);

    return Note(baseNote, Accidental(deltaSemitones));
  }

  /// Returns this [Note] respelled by [BaseNote.ordinal] distance while keeping
  /// the same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respellByBaseNoteDistance(-1) == Note.f.sharp
  /// Note.e.sharp.respellByBaseNoteDistance(2) == Note.g.flat.flat
  /// ```
  Note respellByBaseNoteDistance(int distance) =>
      respellByBaseNote(BaseNote.fromOrdinal(baseNote.ordinal + distance));

  /// Returns this [Note] respelled upwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.respelledUpwards == Note.a.flat
  /// Note.e.sharp.respelledUpwards == Note.f
  /// ```
  Note get respelledUpwards => respellByBaseNoteDistance(1);

  /// Returns this [Note] respelled downwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respelledDownwards == Note.f.sharp
  /// Note.c.respelledDownwards == Note.b.sharp
  /// ```
  Note get respelledDownwards => respellByBaseNoteDistance(-1);

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
    final baseNote = BaseNote.fromSemitones(semitones - accidental.semitones);
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

  /// Whether this [Note] is enharmonically equivalent to [other].
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.isEnharmonicWith(Note.a.flat) == true
  /// Note.c.isEnharmonicWith(Note.b.sharp) == true
  /// Note.e.isEnharmonicWith(Note.f) == false
  /// ```
  bool isEnharmonicWith(Note other) => toClass() == other.toClass();

  /// Returns this [Note] positioned in the given [octave] as a [Pitch].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(3) == const Pitch(Note.c, octave: 3)
  /// Note.a.flat.inOctave(2) == Pitch(Note.a.flat, octave: 2)
  /// ```
  Pitch inOctave(int octave) => Pitch(this, octave: octave);

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
        flats:
            Interval.P5.circleFrom(this, distance: -distance).skip(1).toList(),
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
  int get circleOfFifthsDistance => major.keySignature.distance;

  /// Returns the fifths distance between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.fifthsDistanceWith(Note.e.flat) == -3
  /// Note.f.sharp.fifthsDistanceWith(Note.b) == -1
  /// Note.a.flat.fifthsDistanceWith(Note.c.sharp) == 11
  /// ```
  int fifthsDistanceWith(Note other) =>
      Interval.P5.distanceBetween(this, other).$1;

  /// Returns the [Interval] between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.interval(Note.d) == Interval.m2
  /// Note.d.interval(Note.a.flat) == Interval.d5
  /// ```
  @override
  Interval interval(Note other) => Interval.fromSemitones(
        baseNote.intervalSize(other.baseNote),
        difference(other) % chromaticDivisions,
      );

  /// Transposes this [Note] by [interval].
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

  /// Creates a new [PitchClass] from [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.c.toClass() == PitchClass.c
  /// Note.e.sharp.toClass() == PitchClass.f
  /// Note.c.flat.flat.toClass() == PitchClass.aSharp
  /// ```
  PitchClass toClass() => PitchClass(semitones);

  @override
  String toString({NoteNotation system = NoteNotation.english}) =>
      system.note(this);

  @override
  bool operator ==(Object other) =>
      other is Note &&
      baseNote == other.baseNote &&
      accidental == other.accidental;

  @override
  int get hashCode => Object.hash(baseNote, accidental);

  @override
  int compareTo(Note other) => compareMultiple(_comparators(this, other));
}

/// The abstraction for [Note] notation systems.
abstract class NoteNotation {
  /// Creates a new [NoteNotation].
  const NoteNotation();

  /// The English alphabetic [NoteNotation] system.
  static const english = EnglishNoteNotation();

  /// The German alphabetic [NoteNotation] system.
  static const german = GermanNoteNotation();

  /// The Italian solmization [NoteNotation] system.
  static const italian = ItalianNoteNotation();

  /// The French solmization [NoteNotation] system.
  static const french = FrenchNoteNotation();

  /// Returns the string notation for [note].
  String note(Note note) =>
      note.baseNote.toString(system: this) +
      (note.accidental.isNatural ? '' : note.accidental.symbol);

  /// Returns the string notation for [baseNote].
  String baseNote(BaseNote baseNote);

  /// Returns the string notation for [tonalMode].
  String tonalMode(TonalMode tonalMode);

  /// Returns the string notation for [tonality].
  String tonality(Tonality tonality) {
    final note = tonality.note.toString(system: this);
    final mode = tonality.mode.toString(system: this);

    return '$note $mode';
  }
}

/// The English alphabetic notation system.
class EnglishNoteNotation extends NoteNotation {
  /// Creates a new [EnglishNoteNotation].
  const EnglishNoteNotation();

  @override
  String baseNote(BaseNote baseNote) => baseNote.name.toUpperCase();

  @override
  String tonalMode(TonalMode tonalMode) => tonalMode.name;
}

/// The German alphabetic notation system.
class GermanNoteNotation extends NoteNotation {
  /// Creates a new [GermanNoteNotation].
  const GermanNoteNotation();

  @override
  String note(Note note) => switch (note) {
        Note(baseNote: BaseNote.b, accidental: Accidental.flat) => 'B',
        // Flattened notes.
        final note when note.accidental.isFlat => switch (note.baseNote) {
            BaseNote.a ||
            BaseNote.e =>
              '${note.baseNote.toString(system: this)}s'
                  '${'es' * (note.accidental.semitones.abs() - 1)}',
            final baseNote => '${baseNote.toString(system: this)}'
                '${'es' * note.accidental.semitones.abs()}',
          },
        // Sharpened and natural notes.
        final note => '${note.baseNote.toString(system: this)}'
            '${'is' * note.accidental.semitones}',
      };

  @override
  String baseNote(BaseNote baseNote) => switch (baseNote) {
        BaseNote.b => 'H',
        final baseNote => baseNote.name.toUpperCase(),
      };

  @override
  String tonalMode(TonalMode tonalMode) => switch (tonalMode) {
        TonalMode.major => 'Dur',
        TonalMode.minor => 'Moll',
      };

  @override
  String tonality(Tonality tonality) {
    final noteString = tonality.note.toString(system: this);
    final modeString = tonality.mode.toString(system: this);

    return '${switch (tonality.mode) {
      TonalMode.minor => noteString.toLowerCase(),
      _ => noteString
    }}-$modeString';
  }
}

/// The Italian alphabetic notation system.
class ItalianNoteNotation extends NoteNotation {
  /// Creates a new [ItalianNoteNotation].
  const ItalianNoteNotation();

  @override
  String baseNote(BaseNote baseNote) => switch (baseNote) {
        BaseNote.c => 'Do',
        BaseNote.d => 'Re',
        BaseNote.e => 'Mi',
        BaseNote.f => 'Fa',
        BaseNote.g => 'Sol',
        BaseNote.a => 'La',
        BaseNote.b => 'Si',
      };

  @override
  String tonalMode(TonalMode tonalMode) => switch (tonalMode) {
        TonalMode.major => 'maggiore',
        TonalMode.minor => 'minore',
      };
}

/// The French alphabetic notation system.
class FrenchNoteNotation extends NoteNotation {
  /// Creates a new [FrenchNoteNotation].
  const FrenchNoteNotation();

  @override
  String baseNote(BaseNote baseNote) => switch (baseNote) {
        BaseNote.c => 'Ut',
        BaseNote.d => 'Ré',
        BaseNote.e => 'Mi',
        BaseNote.f => 'Fa',
        BaseNote.g => 'Sol',
        BaseNote.a => 'La',
        BaseNote.b => 'Si',
      };

  @override
  String tonalMode(TonalMode tonalMode) => switch (tonalMode) {
        TonalMode.major => 'majeur',
        TonalMode.minor => 'mineur',
      };
}
