import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../harmony/chord.dart';
import '../harmony/chord_pattern.dart';
import '../interval/interval.dart';
import '../key/key.dart';
import '../key/key_signature.dart';
import '../notation_system.dart';
import '../respellable.dart';
import '../scalable.dart';
import '../tuning/equal_temperament.dart';
import 'accidental.dart';
import 'note_name.dart';
import 'pitch.dart';

/// A musical note.
///
/// ---
/// See also:
/// * [NoteName].
/// * [Accidental].
/// * [Pitch].
/// * [KeySignature].
/// * [Key].
@immutable
final class Note extends Scalable<Note>
    with RespellableScalable<Note>
    implements Comparable<Note> {
  /// The name that defines this [Note].
  final NoteName noteName;

  /// The accidental that modifies the [noteName].
  final Accidental accidental;

  /// Creates a new [Note] from [noteName] and [accidental].
  const Note(this.noteName, [this.accidental = .natural]);

  /// Note C.
  static const c = Note(.c);

  /// Note D.
  static const d = Note(.d);

  /// Note E.
  static const e = Note(.e);

  /// Note F.
  static const f = Note(.f);

  /// Note G.
  static const g = Note(.g);

  /// Note A.
  static const a = Note(.a);

  /// Note B.
  static const b = Note(.b);

  /// The chain of [Parser]s used to parse a [Note].
  static const parsers = [
    EnglishNoteNotation(),
    EnglishNoteNotation.symbol(),
    GermanNoteNotation(),
    RomanceNoteNotation(),
    RomanceNoteNotation.symbol(),
  ];

  /// Parse [source] as a [Note] and return its value.
  ///
  /// If the [source] string does not contain a valid [Note], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Note.parse('Bb') == .b.flat
  /// Note.parse('c') == .c
  /// Note.parse('z') // throws a FormatException
  /// ```
  factory Note.parse(String source, {List<Parser<Note>> chain = parsers}) =>
      chain.parse(source);

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
    () => Scalable.compareEnharmonically(a, b),
    () => a.noteName.semitones.compareTo(b.noteName.semitones),
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
  int get semitones => noteName.semitones + accidental.semitones;

  /// The difference in semitones between this [Note] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.difference(.d) == 2
  /// Note.a.difference(.g) == -2
  /// Note.e.flat.difference(.b.flat) == -5
  /// ```
  @override
  int difference(Note other) => super.difference(other);

  /// This [Note] sharpened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.c.sharp == const Note(.c, .sharp)
  /// Note.a.sharp == const Note(.a, .sharp)
  /// ```
  Note get sharp => Note(noteName, accidental + 1);

  /// This [Note] flattened by 1 semitone.
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat == const Note(.e, .flat)
  /// Note.f.flat == const Note(.f, .flat)
  /// ```
  Note get flat => Note(noteName, accidental - 1);

  /// This [Note] without an accidental (natural).
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.natural == .g
  /// Note.c.sharp.sharp.natural == .c
  /// Note.a.natural == .a
  /// ```
  Note get natural => Note(noteName);

  /// The [TonalMode.major] [Key] from this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major == const Key(.c, .major)
  /// Note.e.flat.major == Key(.e.flat, .major)
  /// ```
  Key get major => Key(this, .major);

  /// The [TonalMode.minor] [Key] from this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor == const Key(.d, .minor)
  /// Note.g.sharp.minor == Key(.g.sharp, .minor)
  /// ```
  Key get minor => Key(this, .minor);

  /// The [ChordPattern.diminishedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.a.diminishedTriad == Chord<Note>([.a, .c, .e.flat])
  /// Note.b.diminishedTriad == Chord<Note>([.b, .d, .f])
  /// ```
  Chord<Note> get diminishedTriad => ChordPattern.diminishedTriad.on(this);

  /// The [ChordPattern.minorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.e.minorTriad == Chord<Note>([.e, .g, .b])
  /// Note.f.sharp.minorTriad == Chord<Note>([.f.sharp, .a, .c.sharp])
  /// ```
  Chord<Note> get minorTriad => ChordPattern.minorTriad.on(this);

  /// The [ChordPattern.majorTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.majorTriad == Chord<Note>([.d, .f.sharp, .a])
  /// Note.a.flat.majorTriad == Chord<Note>([.a.flat, .c, .e.flat])
  /// ```
  Chord<Note> get majorTriad => ChordPattern.majorTriad.on(this);

  /// The [ChordPattern.augmentedTriad] on this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.augmentedTriad == Chord<Note>([.d.flat, .f, .a])
  /// Note.g.augmentedTriad == Chord<Note>([.g, .b, .d.sharp])
  /// ```
  Chord<Note> get augmentedTriad => ChordPattern.augmentedTriad.on(this);

  /// This [Note] respelled by [noteName] while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.c.sharp.respellByNoteName(.d) == .d.flat
  /// Note.f.respellByNoteName(.e) == .e.sharp
  /// Note.g.respellByNoteName(.a) == .a.flat.flat
  /// ```
  @override
  Note respellByNoteName(NoteName noteName) {
    final rawSemitones = semitones - noteName.semitones;
    final deltaSemitones =
        rawSemitones +
        (rawSemitones.abs() > (chromaticDivisions * 0.5)
            ? chromaticDivisions * -rawSemitones.sign
            : 0);

    return Note(noteName, Accidental(deltaSemitones));
  }

  /// This [Note] respelled by [NoteName.ordinal] distance while keeping the
  /// same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respellByOrdinalDistance(-1) == .f.sharp
  /// Note.e.sharp.respellByOrdinalDistance(2) == .g.flat.flat
  /// ```
  @override
  Note respellByOrdinalDistance(int distance) =>
      respellByNoteName(.fromOrdinal(noteName.ordinal + distance));

  /// This [Note] respelled upwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.respelledUpwards == .a.flat
  /// Note.e.sharp.respelledUpwards == .f
  /// ```
  @override
  Note get respelledUpwards => super.respelledUpwards;

  /// This [Note] respelled downwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respelledDownwards == .f.sharp
  /// Note.c.respelledDownwards == .b.sharp
  /// ```
  @override
  Note get respelledDownwards => super.respelledDownwards;

  /// This [Note] respelled by [accidental] while keeping the same number of
  /// [semitones].
  ///
  /// When no respelling is possible with [accidental], the next closest
  /// spelling is returned.
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat.respellByAccidental(Accidental.sharp) == .d.sharp
  /// Note.b.respellByAccidental(Accidental.flat) == .c.flat
  /// Note.g.respellByAccidental(Accidental.sharp) == .f.sharp.sharp
  /// ```
  @override
  Note respellByAccidental(Accidental accidental) {
    final noteName = NoteName.fromSemitones(semitones - accidental.semitones);
    if (noteName != null) return Note(noteName, accidental);

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
  /// Note.e.sharp.respelledSimple == .f
  /// Note.d.flat.flat.respelledSimple == .c
  /// Note.f.sharp.sharp.sharp.respelledSimple == .g.sharp
  /// ```
  @override
  Note get respelledSimple => super.respelledSimple;

  /// This [Note] positioned in the given [octave] as a [Pitch].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(3) == const Pitch(.c, octave: 3)
  /// Note.a.flat.inOctave(2) == Pitch(.a.flat, octave: 2)
  /// ```
  Pitch inOctave(int octave) => Pitch(this, octave: octave);

  /// The circle of fifths starting from this [Note] split by sharps (`up`) and
  /// flats (`down`).
  ///
  /// Example:
  /// ```dart
  /// Note.c.splitCircleOfFifths.up.take(6).toList()
  ///   == <Note>[.g, .d, .a, .e, .b, .f.sharp]
  ///
  /// Note.c.splitCircleOfFifths.down.take(4).toList()
  ///   == <Note>[.f, .b.flat, .e.flat, .a.flat]
  ///
  /// Note.a.splitCircleOfFifths.up.take(4).toList()
  ///   == <Note>[.e, .b, .f.sharp, .c.sharp]
  /// ```
  /// ---
  /// See also:
  /// * [circleOfFifths] for a continuous list version of [splitCircleOfFifths].
  ({Iterable<Note> up, Iterable<Note> down}) get splitCircleOfFifths => (
    up: Interval.P5.circleFrom(this).skip(1),
    down: Interval.P4.circleFrom(this).skip(1),
  );

  /// The continuous circle of fifths up to [distance] including this [Note],
  /// from flats to sharps.
  ///
  /// Example:
  /// ```dart
  /// Note.c.circleOfFifths(distance: 3)
  ///   == <Note>[.e.flat, .b.flat, .f, .c, .g, .d, .a]
  ///
  /// Note.a.circleOfFifths(distance: 3)
  ///   == <Note>[.c, .g, .d, .a, .e, .b, .f.sharp]
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
    final (:down, :up) = splitCircleOfFifths;

    return [
      ...down.take(distance).toList(growable: false).reversed,
      this,
      ...up.take(distance),
    ];
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
  Interval interval(Note other) => .fromSizeAndSemitones(
    noteName.intervalSize(other.noteName),
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
    final transposedNoteName = noteName.transposeBySize(interval.size);
    final positiveDifference = interval.isDescending
        ? transposedNoteName.positiveDifference(noteName)
        : noteName.positiveDifference(transposedNoteName);

    final accidentalSemitones =
        (accidental.semitones * interval.size.sign) +
        ((interval.semitones * interval.size.sign) - positiveDifference);
    final semitonesOctaveMod =
        accidentalSemitones -
        chromaticDivisions * ((interval.size.abs() - 1) ~/ 7);

    return Note(
      transposedNoteName,
      Accidental(semitonesOctaveMod * interval.size.sign),
    );
  }

  /// The string representation of this [Note] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.toString() == 'D♭'
  /// Note.d.flat.toString(formatter: const GermanNoteNotation()) == 'Des'
  /// Note.d.flat.toString(formatter: const RomanceNoteNotation.symbol())
  ///   == 'Re♭'
  /// ```
  @override
  String toString({
    Formatter<Note> formatter = const EnglishNoteNotation.symbol(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is Note &&
      noteName == other.noteName &&
      accidental == other.accidental;

  @override
  int get hashCode => Object.hash(noteName, accidental);

  @override
  int compareTo(Note other) => compareMultiple(_comparators(this, other));
}

/// The abstract [NotationSystem] for [Note].
abstract class NoteNotation extends NotationSystem<Note> {
  /// The [NoteName] notation system used to format the [Note.noteName].
  final NotationSystem<NoteName> noteNameNotation;

  /// The [Accidental] notation system used to format the [Note.accidental].
  final NotationSystem<Accidental> accidentalNotation;

  /// Creates a new [NoteNotation].
  const NoteNotation({
    this.noteNameNotation = const EnglishNoteNameNotation(),
    this.accidentalNotation = const SymbolAccidentalNotation(),
  });
}

/// The English notation system for [Note].
final class EnglishNoteNotation extends NoteNotation {
  /// Creates a new [EnglishNoteNotation].
  const EnglishNoteNotation({
    super.noteNameNotation = const EnglishNoteNameNotation(),
    super.accidentalNotation = const EnglishAccidentalNotation(
      showNatural: false,
    ),
  });

  /// Creates a new symbolic [EnglishNoteNotation].
  const EnglishNoteNotation.symbol({
    super.noteNameNotation = const EnglishNoteNameNotation(),
    super.accidentalNotation = const SymbolAccidentalNotation(
      showNatural: false,
    ),
  });

  /// Creates a new symbolic [EnglishNoteNotation] using ASCII characters.
  const EnglishNoteNotation.ascii({
    super.noteNameNotation = const EnglishNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation.ascii(
           showNatural: false,
         ),
       );

  /// The [EnglishNoteNotation] format variant that shows the
  /// [Accidental.natural] accidental.
  static const showNatural = EnglishNoteNotation.symbol(
    accidentalNotation: SymbolAccidentalNotation(),
  );

  /// Whether to use symbolic representation for [Accidental].
  bool get _isSymbol => accidentalNotation is SymbolAccidentalNotation;

  @override
  String format(Note note) {
    final noteName = noteNameNotation.format(note.noteName);
    final accidental = accidentalNotation.format(note.accidental);
    if (accidental.isEmpty) return noteName;

    return '$noteName${_isSymbol ? '' : '-'}$accidental';
  }

  @override
  RegExp get regExp => RegExp(
    '${noteNameNotation.regExp?.pattern}${_isSymbol ? r'\s*' : r'(?:-|\s*)'}'
    '${accidentalNotation.regExp?.pattern}',
    caseSensitive: false,
  );

  @override
  Note parseMatch(RegExpMatch match) => Note(
    noteNameNotation.parseMatch(match),
    accidentalNotation.parseMatch(match),
  );
}

/// The German alphabetic notation system for [Note].
///
/// See [Versetzungszeichen](https://de.wikipedia.org/wiki/Versetzungszeichen).
final class GermanNoteNotation extends NoteNotation {
  /// Creates a new [GermanNoteNotation].
  const GermanNoteNotation({
    super.noteNameNotation = const GermanNoteNameNotation(),
    super.accidentalNotation = const GermanAccidentalNotation(),
  });

  @override
  String format(Note note) => switch (note) {
    Note(noteName: .b, accidental: .flat) => 'B',

    Note(noteName: .a || .e, :final accidental) && Note(:final noteName)
        when accidental.isFlat =>
      noteNameNotation.format(noteName) +
          accidentalNotation.format(accidental).substring(1),

    Note(:final noteName, :final accidental) =>
      noteNameNotation.format(noteName) + accidentalNotation.format(accidental),
  };

  @override
  RegExp get regExp => RegExp(
    '${noteNameNotation.regExp?.pattern}${accidentalNotation.regExp?.pattern}',
    caseSensitive: false,
  );

  @override
  Note parseMatch(RegExpMatch match) {
    final noteName = match.namedGroup('noteName')!;
    if (noteName.toLowerCase() == 'b') return .b.flat;
    final accidental = match.namedGroup('accidental');
    if (accidental == null) return Note(noteNameNotation.parseMatch(match));
    if (const {'a', 'e'}.contains(noteName.toLowerCase())) {
      if (accidental.startsWith('e')) {
        throw FormatException('Invalid Note', match);
      }
    } else if (accidental.startsWith('s')) {
      throw FormatException('Invalid Note', match);
    }

    return Note(
      noteNameNotation.parseMatch(match),
      accidentalNotation.parseMatch(match),
    );
  }
}

/// The Romance alphabetic notation system for [Note].
final class RomanceNoteNotation extends NoteNotation {
  /// Creates a new [RomanceNoteNotation].
  const RomanceNoteNotation({
    super.noteNameNotation = const RomanceNoteNameNotation(),
    super.accidentalNotation = const RomanceAccidentalNotation(
      showNatural: false,
    ),
  });

  /// Creates a new symbolic [RomanceNoteNotation].
  const RomanceNoteNotation.symbol({
    super.noteNameNotation = const RomanceNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation(showNatural: false),
       );

  /// Creates a new symbolic [RomanceNoteNotation] using ASCII characters.
  const RomanceNoteNotation.ascii({
    super.noteNameNotation = const RomanceNoteNameNotation(),
  }) : super(
         accidentalNotation: const SymbolAccidentalNotation.ascii(
           showNatural: false,
         ),
       );

  /// The [RomanceNoteNotation] format variant that shows the
  /// [Accidental.natural] accidental.
  static const showNatural = RomanceNoteNotation(
    accidentalNotation: SymbolAccidentalNotation(),
  );

  /// Whether to use symbolic representation for [Accidental].
  bool get _isSymbol => accidentalNotation is SymbolAccidentalNotation;

  @override
  String format(Note note) {
    final noteName = noteNameNotation.format(note.noteName);
    final accidental = accidentalNotation.format(note.accidental);
    if (accidental.isEmpty) return noteName;

    return '$noteName${_isSymbol ? '' : ' '}$accidental';
  }

  @override
  RegExp get regExp => RegExp(
    '${noteNameNotation.regExp?.pattern}\\s*'
    '${accidentalNotation.regExp?.pattern}',
    caseSensitive: false,
  );

  @override
  Note parseMatch(RegExpMatch match) => Note(
    noteNameNotation.parseMatch(match),
    accidentalNotation.parseMatch(match),
  );
}

/// A list of notes extension.
extension Notes on List<Note> {
  /// Flattens all notes on this [List].
  List<Note> get flat => map((note) => note.flat).toList();

  /// Sharpens all notes on this [List].
  List<Note> get sharp => map((note) => note.sharp).toList();

  /// Makes all notes on this [List] natural.
  List<Note> get natural => map((note) => note.natural).toList();

  /// Creates a [Pitch] at [octave] for each [Note] in this list.
  ///
  /// Example:
  /// ```dart
  /// const <Note>[.a, .c, .e].inOctave(4)
  ///   == [Note.a.inOctave(4), Note.c.inOctave(4), Note.e.inOctave(4)]
  /// ```
  List<Pitch> inOctave(int octave) =>
      map((note) => note.inOctave(octave)).toList();
}
