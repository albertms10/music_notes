import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../harmony/chord.dart';
import '../harmony/chord_pattern.dart';
import '../interval/interval.dart';
import '../interval/size.dart';
import '../key/key.dart';
import '../key/key_signature.dart';
import '../key/mode.dart';
import '../music.dart';
import '../scalable.dart';
import 'accidental.dart';
import 'base_note.dart';
import 'pitch.dart';

/// A musical note.
///
/// ---
/// See also:
/// * [BaseNote].
/// * [Accidental].
/// * [Pitch].
/// * [KeySignature].
/// * [Key].
@immutable
final class Note extends Scalable<Note> implements Comparable<Note> {
  /// The base note that defines this [Note].
  final BaseNote baseNote;

  /// The accidental that modifies the [baseNote].
  final Accidental accidental;

  /// Creates a new [Note] from [baseNote] and [accidental].
  const Note(this.baseNote, [this.accidental = Accidental.natural]);

  /// Note C.
  static const c = Note(BaseNote.c);

  /// Note D.
  static const d = Note(BaseNote.d);

  /// Note E.
  static const e = Note(BaseNote.e);

  /// Note F.
  static const f = Note(BaseNote.f);

  /// Note G.
  static const g = Note(BaseNote.g);

  /// Note A.
  static const a = Note(BaseNote.a);

  /// Note B.
  static const b = Note(BaseNote.b);

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

  /// Predicate to transpose this [Note] by ascending chromatic motion.
  static Note chromaticMotion(Note note) =>
      note.transposeBy(Interval.m2).respelledSimple;

  /// [Comparator] for [Note]s by fifths distance.
  static int compareByFifthsDistance(Note a, Note b) =>
      a.circleOfFifthsDistance.compareTo(b.circleOfFifthsDistance);

  /// Enharmonic [Comparator] for [Note].
  static int compareEnharmonically(Note a, Note b) =>
      a.semitones.compareTo(b.semitones);

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
        () => compareEnharmonically(a, b),
        () => a.baseNote.semitones.compareTo(b.baseNote.semitones),
      ];

  /// The semitones distance of this [Note] relative to [Note.c].
  ///
  /// Example:
  /// ```dart
  /// Note.c.semitones == 0
  /// Note.d.semitones == 2
  /// Note.f.sharp.semitones == 6
  /// Note.b.sharp.semitones == 12
  /// Note.c.flat.semitones == -1
  /// ```
  @override
  int get semitones => baseNote.semitones + accidental.semitones;

  /// The difference in semitones between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.difference(Note.d) == 2
  /// Note.a.difference(Note.g) == -2
  /// Note.e.flat.difference(Note.b.flat) == -5
  /// ```
  @override
  int difference(Note other) => super.difference(other);

  /// This [Note] sharpened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.c.sharp == const Note(BaseNote.c, Accidental.sharp)
  /// Note.a.sharp == const Note(BaseNote.a, Accidental.sharp)
  /// ```
  Note get sharp => Note(baseNote, accidental + 1);

  /// This [Note] flattened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat == const Note(BaseNote.e, Accidental.flat)
  /// Note.f.flat == const Note(BaseNote.f, Accidental.flat)
  /// ```
  Note get flat => Note(baseNote, accidental - 1);

  /// This [Note] without an accidental (natural).
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.natural == Note.g
  /// Note.c.sharp.sharp.natural == Note.c
  /// Note.a.natural == Note.a
  /// ```
  Note get natural => Note(baseNote);

  /// The [TonalMode.major] [Key] from this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major == const Key(Note.c, TonalMode.major)
  /// Note.e.flat.major == Key(Note.e.flat, TonalMode.major)
  /// ```
  Key get major => Key(this, TonalMode.major);

  /// The [TonalMode.minor] [Key] from this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor == const Key(Note.d, TonalMode.minor)
  /// Note.g.sharp.minor == Key(Note.g.sharp, TonalMode.minor)
  /// ```
  Key get minor => Key(this, TonalMode.minor);

  /// The [ChordPattern.diminishedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.a.diminishedTriad == Chord([Note.a, Note.c, Note.e.flat])
  /// Note.b.diminishedTriad == Chord([Note.b, Note.d, Note.f])
  /// ```
  Chord<Note> get diminishedTriad => ChordPattern.diminishedTriad.on(this);

  /// The [ChordPattern.minorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.e.minorTriad == Chord([Note.e, Note.g, Note.b])
  /// Note.f.sharp.minorTriad == Chord([Note.f.sharp, Note.a, Note.c.sharp])
  /// ```
  Chord<Note> get minorTriad => ChordPattern.minorTriad.on(this);

  /// The [ChordPattern.majorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.majorTriad == Chord([Note.d, Note.f.sharp, Note.a])
  /// Note.a.flat.majorTriad == Chord([Note.a.flat, Note.c, Note.e.flat])
  /// ```
  Chord<Note> get majorTriad => ChordPattern.majorTriad.on(this);

  /// The [ChordPattern.augmentedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.augmentedTriad == Chord([Note.d.flat, Note.f, Note.a])
  /// Note.g.augmentedTriad == Chord([Note.g, Note.b, Note.d.sharp])
  /// ```
  Chord<Note> get augmentedTriad => ChordPattern.augmentedTriad.on(this);

  /// This [Note] respelled by [baseNote] while keeping the same number of
  /// [semitones].
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

  /// This [Note] respelled by [BaseNote.ordinal] distance while keeping the
  /// same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respellByOrdinalDistance(-1) == Note.f.sharp
  /// Note.e.sharp.respellByOrdinalDistance(2) == Note.g.flat.flat
  /// ```
  Note respellByOrdinalDistance(int distance) =>
      respellByBaseNote(BaseNote.fromOrdinal(baseNote.ordinal + distance));

  /// This [Note] respelled upwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.respelledUpwards == Note.a.flat
  /// Note.e.sharp.respelledUpwards == Note.f
  /// ```
  Note get respelledUpwards => respellByOrdinalDistance(1);

  /// This [Note] respelled downwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respelledDownwards == Note.f.sharp
  /// Note.c.respelledDownwards == Note.b.sharp
  /// ```
  Note get respelledDownwards => respellByOrdinalDistance(-1);

  /// This [Note] respelled by [accidental] while keeping the same number of
  /// [semitones].
  ///
  /// When no respelling is possible with [accidental], the next closest
  /// spelling is returned.
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat.respellByAccidental(Accidental.sharp) == Note.d.sharp
  /// Note.b.respellByAccidental(Accidental.flat) == Note.c.flat
  /// Note.g.respellByAccidental(Accidental.sharp) == Note.f.sharp.sharp
  /// ```
  Note respellByAccidental(Accidental accidental) {
    final baseNote = BaseNote.fromSemitones(semitones - accidental.semitones);
    if (baseNote != null) return Note(baseNote, accidental);

    if (accidental.isNatural) {
      return respellByAccidental(Accidental(this.accidental.semitones.sign));
    }

    return respellByAccidental(accidental.incrementBy(1));
  }

  /// This [Note] with the simplest [Accidental] spelling while keeping the
  /// same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.e.sharp.respelledSimple == Note.f
  /// Note.d.flat.flat.respelledSimple == Note.c
  /// Note.f.sharp.sharp.sharp.respelledSimple == Note.g.sharp
  /// ```
  Note get respelledSimple => respellByAccidental(Accidental.natural);

  /// This [Note] positioned in the given [octave] as a [Pitch].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(3) == const Pitch(Note.c, octave: 3)
  /// Note.a.flat.inOctave(2) == Pitch(Note.a.flat, octave: 2)
  /// ```
  Pitch inOctave(int octave) => Pitch(this, octave: octave);

  /// The circle of fifths starting from this [Note] up to [distance],
  /// split by `sharps` and `flats`.
  ///
  /// Example:
  /// ```dart
  /// Note.c.splitCircleOfFifths(distance: 4) == (
  ///   sharps: [Note.g, Note.d, Note.a, Note.e],
  ///   flats: [Note.f, Note.b.flat, Note.e.flat, Note.a.flat],
  /// )
  ///
  /// Note.a.splitCircleOfFifths(distance: 4) == (
  ///   sharps: [Note.e, Note.b, Note.f.sharp, Note.c.sharp],
  ///   flats: [Note.d, Note.g, Note.c, Note.f],
  /// )
  /// ```
  /// ---
  /// See also:
  /// * [circleOfFifths] for a continuous list version of [splitCircleOfFifths].
  ({List<Note> sharps, List<Note> flats}) splitCircleOfFifths({
    int distance = chromaticDivisions ~/ 2,
  }) =>
      (
        sharps:
            Interval.P5.circleFrom(this, distance: distance).skip(1).toList(),
        flats:
            Interval.P5.circleFrom(this, distance: -distance).skip(1).toList(),
      );

  /// The continuous circle of fifths up to [distance] including this [Note],
  /// from flats to sharps.
  ///
  /// Example:
  /// ```dart
  /// Note.c.circleOfFifths(distance: 3)
  ///   == [Note.e.flat, Note.b.flat, Note.f, Note.c, Note.g, Note.d, Note.a]
  ///
  /// Note.a.circleOfFifths(distance: 3)
  ///   == [Note.c, Note.g, Note.d, Note.a, Note.e, Note.b, Note.f.sharp]
  /// ```
  ///
  /// It is equivalent to sorting an array of the same [Note]s using the
  /// [compareByFifthsDistance] comparator:
  ///
  /// ```dart
  /// Note.c.circleOfFifths(distance: 3)
  ///   == ScalePattern.dorian.on(Note.c).degrees.skip(1)
  ///        .sorted(Note.compareByFifthsDistance)
  /// ```
  /// ---
  /// See also:
  /// * [splitCircleOfFifths] for a different representation of the same
  ///   circle of fifths.
  List<Note> circleOfFifths({int distance = chromaticDivisions ~/ 2}) {
    final (:flats, :sharps) = splitCircleOfFifths(distance: distance);

    return [...flats.reversed, this, ...sharps];
  }

  /// The distance in relation to the circle of fifths.
  ///
  /// Example:
  /// ```dart
  /// Note.c.circleOfFifthsDistance == 0
  /// Note.d.circleOfFifthsDistance == 2
  /// Note.a.flat.circleOfFifthsDistance == -4
  /// ```
  int get circleOfFifthsDistance => Note.c.fifthsDistanceWith(this);

  /// The fifths distance between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.fifthsDistanceWith(Note.e.flat) == -3
  /// Note.f.sharp.fifthsDistanceWith(Note.b) == -1
  /// Note.a.flat.fifthsDistanceWith(Note.c.sharp) == 11
  /// ```
  int fifthsDistanceWith(Note other) =>
      Interval.P5.circleDistance(from: this, to: other).$1;

  /// The [Interval] between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.interval(Note.d) == Interval.m2
  /// Note.d.interval(Note.a.flat) == Interval.d5
  /// ```
  @override
  Interval interval(Note other) => Interval.fromSizeAndSemitones(
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
        chromaticDivisions * (interval.size.absShift ~/ Size.octave);

    return Note(
      transposedBaseNote,
      Accidental(semitonesOctaveMod * interval.size.sign),
    );
  }

  /// The string representation of this [Note] based on [system].
  ///
  /// See [NoteNotation] for all system implementations.
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.toString() == 'D♭'
  /// Note.d.flat.toString(system: NoteNotation.romance) == 'Re♭'
  /// Note.d.flat.toString(system: NoteNotation.german) == 'Des'
  /// ```
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
@immutable
abstract class NoteNotation {
  /// Creates a new [NoteNotation].
  const NoteNotation();

  /// The English alphabetic [NoteNotation] system.
  static const english = EnglishNoteNotation();

  /// The German alphabetic [NoteNotation] system.
  static const german = GermanNoteNotation();

  /// The Romance solmization [NoteNotation] system.
  static const romance = RomanceNoteNotation();

  /// The string notation for [note].
  String note(Note note) =>
      note.baseNote.toString(system: this) +
      note.accidental.toString(system: this);

  /// The string notation for [baseNote].
  String baseNote(BaseNote baseNote);

  /// The string notation for [accidental].
  String accidental(Accidental accidental);

  /// The string notation for [tonalMode].
  String tonalMode(TonalMode tonalMode);

  /// The string notation for [key].
  String key(Key key) {
    final note = key.note.toString(system: this);
    final mode = key.mode.toString(system: this);

    return '$note $mode';
  }
}

/// The English alphabetic [Note] notation system.
final class EnglishNoteNotation extends NoteNotation {
  /// Whether a natural [Note] should be represented with the
  /// [Accidental.natural] symbol.
  final bool showNatural;

  /// Creates a new [EnglishNoteNotation].
  const EnglishNoteNotation({this.showNatural = false});

  @override
  String accidental(Accidental accidental) =>
      !showNatural && accidental.isNatural ? '' : accidental.symbol;

  @override
  String baseNote(BaseNote baseNote) => baseNote.name.toUpperCase();

  @override
  String tonalMode(TonalMode tonalMode) => tonalMode.name;
}

/// The German alphabetic [Note] notation system.
///
/// See [Versetzungszeichen](https://de.wikipedia.org/wiki/Versetzungszeichen).
final class GermanNoteNotation extends NoteNotation {
  /// Creates a new [GermanNoteNotation].
  const GermanNoteNotation();

  @override
  String note(Note note) => switch (note) {
        Note(baseNote: BaseNote.b, accidental: Accidental.flat) => 'B',
        // Flattened notes.
        final note when note.accidental.isFlat => switch (note.baseNote) {
            BaseNote.a || BaseNote.e => note.baseNote.toString(system: this) +
                note.accidental.toString(system: this).substring(1),
            _ => super.note(note),
          },
        // Sharpened and natural notes.
        final note => super.note(note),
      };

  @override
  String baseNote(BaseNote baseNote) => switch (baseNote) {
        BaseNote.b => 'H',
        final baseNote => baseNote.name.toUpperCase(),
      };

  @override
  String accidental(Accidental accidental) =>
      (accidental.isFlat ? 'es' : 'is') * accidental.semitones.abs();

  @override
  String tonalMode(TonalMode tonalMode) => switch (tonalMode) {
        TonalMode.major => 'Dur',
        TonalMode.minor => 'Moll',
      };

  @override
  String key(Key key) {
    final note = key.note.toString(system: this);
    final mode = key.mode.toString(system: this).toLowerCase();
    final casedNote = switch (key.mode) {
      TonalMode.major => note,
      TonalMode.minor => note.toLowerCase(),
    };

    return '$casedNote-$mode';
  }
}

/// The Romance alphabetic [Note] notation system.
final class RomanceNoteNotation extends NoteNotation {
  /// Whether a natural [Note] should be represented with the
  /// [Accidental.natural] symbol.
  final bool showNatural;

  /// Creates a new [RomanceNoteNotation].
  const RomanceNoteNotation({this.showNatural = false});

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
  String accidental(Accidental accidental) =>
      !showNatural && accidental.isNatural ? '' : accidental.symbol;

  @override
  String tonalMode(TonalMode tonalMode) => switch (tonalMode) {
        TonalMode.major => 'maggiore',
        TonalMode.minor => 'minore',
      };
}

/// A list of notes extension.
extension Notes on List<Note> {
  /// Flattens all notes on this [List].
  List<Note> get flat => map((note) => note.flat).toList();

  /// Sharpens all notes on this [List].
  List<Note> get sharp => map((note) => note.sharp).toList();

  /// Makes all notes on this [List] natural.
  List<Note> get natural => map((note) => note.natural).toList();
}
