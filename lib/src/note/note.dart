import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../accidental/accidental.dart';
import '../chord/chord.dart';
import '../chord_pattern/chord_pattern.dart';
import '../interval/interval.dart';
import '../key/key.dart';
import '../key_signature/key_signature.dart';
import '../notation_system/notation_system.dart';
import '../note_name/note_name.dart';
import '../pitch/pitch.dart';
import '../respellable.dart';
import '../scalable.dart';
import '../scale/scale.dart';
import '../size/size.dart';
import '../tuning_system/equal_temperament.dart';
import 'english_note_notation.dart';
import 'german_note_notation.dart';
import 'romance_note_notation.dart';

/// An unpositioned musical note: a [NoteName] letter modified by an
/// [Accidental], with no octave attached (e.g. "D♭", as opposed to the
/// octave-specific "D♭4" a [Pitch] would represent).
///
/// Being octave-free is what lets a single [Note] serve as a [Key]'s
/// tonic, a step in a [Scale], or a member of a [Chord] without
/// committing to where in register it sounds; anywhere octave matters,
/// call [inOctave] to promote it to a [Pitch].
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
    implements Comparable<Note>, Formattable<Note> {
  /// The letter name this [Note] is spelled with, before [accidental] is
  /// applied.
  final NoteName noteName;

  /// The sharp, flat, or natural alteration applied to [noteName].
  final Accidental accidental;

  /// Creates a new [Note] from [noteName] altered by [accidental]
  /// (natural by default).
  const Note(this.noteName, [this.accidental = .natural]);

  /// Note C, the tonic of [ScalePattern.major] built on itself.
  static const c = Note(.c);

  /// Note D.
  static const d = Note(.d);

  /// Note E.
  static const e = Note(.e);

  /// Note F.
  static const f = Note(.f);

  /// Note G.
  static const g = Note(.g);

  /// Note A, the tonic of [ScalePattern.naturalMinor] built on itself, and
  /// the pitch class of [Pitch.reference] (A440 by default).
  static const a = Note(.a);

  /// Note B.
  static const b = Note(.b);

  /// The chain of [StringParser]s tried in turn by [Note.parse]: textual
  /// then symbolic then ASCII English spellings, German letter spellings,
  /// then textual, symbolic, and ASCII Romance solfège spellings.

  static const parsers = [
    EnglishNoteNotation(),
    EnglishNoteNotation.symbol(),
    EnglishNoteNotation.ascii(),
    GermanNoteNotation(),
    RomanceNoteNotation(),
    RomanceNoteNotation.symbol(),
    RomanceNoteNotation.ascii(),
  ];

  /// Parses [source] as a [Note] and returns its value.
  ///
  /// If [source] does not contain a valid [Note], a [FormatException] is
  /// thrown.
  ///
  /// Example:
  /// ```dart
  /// Note.parse('Bb') == .b.flat
  /// Note.parse('c') == .c
  /// Note.parse('z') // throws a FormatException
  /// ```
  factory Note.parse(
    String source, {
    List<StringParser<Note>> chain = parsers,
  }) => chain.parse(source);

  /// [Comparator] that orders [Note]s by their
  /// [circleOfFifthsDistance] — sharpward notes sort after flatward ones,
  /// regardless of pitch height.
  static int compareByFifthsDistance(Note a, Note b) =>
      a.circleOfFifthsDistance.compareTo(b.circleOfFifthsDistance);

  /// [Comparator] that orders [Note]s by chromatic proximity: enharmonic
  /// spellings of the same pitch class (e.g. C♯ and D♭) sort adjacent to
  /// each other, using letter-name and accidental size only to break
  /// exact ties.
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

  /// This [Note]'s position in semitones relative to [Note.c], with no
  /// octave folding — a triple sharp or flat can push it well outside
  /// `[0, 11]`.
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

  /// The signed semitone distance from this [Note] to [other], taking
  /// the shorter path around the octave (so a descending step reports
  /// negative even if [other]'s letter name comes later alphabetically).
  ///
  /// Example:
  /// ```dart
  /// Note.c.difference(.d) == 2
  /// Note.a.difference(.g) == -2
  /// Note.e.flat.difference(.b.flat) == -5
  /// ```
  @override
  int difference(Note other) => super.difference(other);

  /// This [Note] raised by one semitone, adding a sharp to its
  /// [accidental] (e.g. natural becomes sharp, sharp becomes double sharp).
  ///
  /// Example:
  /// ```dart
  /// Note.c.sharp == const Note(.c, .sharp)
  /// Note.a.sharp == const Note(.a, .sharp)
  /// ```
  Note get sharp => Note(noteName, accidental + 1);

  /// This [Note] lowered by one semitone, adding a flat to its
  /// [accidental] (e.g. natural becomes flat, flat becomes double flat).
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat == const Note(.e, .flat)
  /// Note.f.flat == const Note(.f, .flat)
  /// ```
  Note get flat => Note(noteName, accidental - 1);

  /// This [Note] with [accidental] cleared, keeping only [noteName] (e.g.
  /// G♭ becomes plain G — note that this changes the sounding pitch,
  /// unlike the other respelling methods).
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.natural == .g
  /// Note.c.sharp.sharp.natural == .c
  /// Note.a.natural == .a
  /// ```
  Note get natural => Note(noteName);

  /// The [TonalMode.major] [Key] whose tonic is this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major == const Key(.c, .major)
  /// Note.e.flat.major == Key(.e.flat, .major)
  /// ```
  Key get major => Key(this, .major);

  /// The [TonalMode.minor] [Key] whose tonic is this [Note].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor == const Key(.d, .minor)
  /// Note.g.sharp.minor == Key(.g.sharp, .minor)
  /// ```
  Key get minor => Key(this, .minor);

  /// The [ChordPattern.diminishedTriad] built with this [Note] as root.
  ///
  /// Example:
  /// ```dart
  /// Note.a.diminishedTriad == Chord([.a, .c, .e.flat])
  /// Note.b.diminishedTriad == Chord([.b, .d, .f])
  /// ```
  Chord get diminishedTriad => ChordPattern.diminishedTriad.on(this);

  /// The [ChordPattern.minorTriad] built with this [Note] as root.
  ///
  /// Example:
  /// ```dart
  /// Note.e.minorTriad == Chord([.e, .g, .b])
  /// Note.f.sharp.minorTriad == Chord([.f.sharp, .a, .c.sharp])
  /// ```
  Chord get minorTriad => ChordPattern.minorTriad.on(this);

  /// The [ChordPattern.majorTriad] built with this [Note] as root.
  ///
  /// Example:
  /// ```dart
  /// Note.d.majorTriad == Chord([.d, .f.sharp, .a])
  /// Note.a.flat.majorTriad == Chord([.a.flat, .c, .e.flat])
  /// ```
  Chord get majorTriad => ChordPattern.majorTriad.on(this);

  /// The [ChordPattern.augmentedTriad] built with this [Note] as root.
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.augmentedTriad == Chord([.d.flat, .f, .a])
  /// Note.g.augmentedTriad == Chord([.g, .b, .d.sharp])
  /// ```
  Chord get augmentedTriad => ChordPattern.augmentedTriad.on(this);

  /// This [Note] rewritten under [noteName], keeping the same number of
  /// [semitones] by choosing whichever [Accidental] makes up the
  /// difference — however extreme (e.g. respelling C as D takes a double
  /// flat).
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

  /// This [Note] respelled [distance] letter names away (see
  /// [NoteName.ordinal]), keeping the same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respellByOrdinalDistance(-1) == .f.sharp
  /// Note.e.sharp.respellByOrdinalDistance(2) == .g.flat.flat
  /// ```
  @override
  Note respellByOrdinalDistance(int distance) =>
      respellByNoteName(.fromOrdinal(noteName.ordinal + distance));

  /// This [Note] respelled with the next letter name up, keeping the
  /// same number of [semitones] (e.g. G♯ becomes A♭).
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.respelledUpwards == .a.flat
  /// Note.e.sharp.respelledUpwards == .f
  /// ```
  @override
  Note get respelledUpwards => super.respelledUpwards;

  /// This [Note] respelled with the next letter name down, keeping the
  /// same number of [semitones] (e.g. C becomes B♯).
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.respelledDownwards == .f.sharp
  /// Note.c.respelledDownwards == .b.sharp
  /// ```
  @override
  Note get respelledDownwards => super.respelledDownwards;

  /// This [Note] rewritten with [accidental], keeping the same number of
  /// [semitones] by moving to whichever [noteName] the arithmetic demands
  /// (e.g. respelling by [Accidental.sharp] turns B♭ into A♯).
  ///
  /// When no [noteName] can express this pitch with exactly [accidental],
  /// the next-closest [accidental] value is used instead — walking
  /// outward one semitone at a time until a valid [NoteName] is found.
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

  /// This [Note] rewritten with as plain an [Accidental] as possible
  /// (natural where a natural letter exists at this pitch, otherwise a
  /// single sharp or flat).
  ///
  /// Example:
  /// ```dart
  /// Note.e.sharp.respelledSimple == .f
  /// Note.d.flat.flat.respelledSimple == .c
  /// Note.f.sharp.sharp.sharp.respelledSimple == .g.sharp
  /// ```
  @override
  Note get respelledSimple => super.respelledSimple;

  /// This [Note] fixed at [octave], promoting it to a [Pitch].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(3) == const Pitch(.c, octave: 3)
  /// Note.a.flat.inOctave(2) == Pitch(.a.flat, octave: 2)
  /// ```
  Pitch inOctave(int octave) => Pitch(this, octave: octave);

  /// The [Interval] from this [Note] up to [other] (or descending, if
  /// [other]'s letter name comes at or before this one's), combining the
  /// generic size from [NoteName.intervalSize] with the actual semitone
  /// [difference].
  ///
  /// Example:
  /// ```dart
  /// Note.c.interval(.d) == .M2
  /// Note.d.interval(.a.flat) == .d5
  /// ```
  @override
  Interval interval(Note other) => .fromSizeAndSemitones(
    noteName.intervalSize(other.noteName),
    difference(other) % chromaticDivisions,
  );

  /// This [Note] transposed by [interval]: its letter name shifts by
  /// [interval]'s generic [Size] and its [Accidental] is recomputed so the
  /// result is exactly [interval] away, rather than merely the nearest
  /// enharmonic pitch.
  ///
  /// Example:
  /// ```dart
  /// Note.c.transposeBy(.tritone) == .f.sharp
  /// Note.a.transposeBy(.M2.descending) == .g
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

  /// The string representation of this [Note], using [formatter]
  /// (symbolic English by default: letter name plus ♯/♭ glyphs).
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.format() == 'D♭'
  /// Note.d.flat.format(const GermanNoteNotation()) == 'Des'
  /// Note.d.flat.format(const RomanceNoteNotation.symbol()) == 'Re♭'
  /// ```
  @override
  String format([
    StringFormatter<Note> formatter = const EnglishNoteNotation.symbol(),
  ]) => formatter.format(this);

  @override
  String toString() =>
      '$runtimeType(noteName: $noteName, accidental: $accidental)';

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

/// [Circle of fifths](https://en.wikipedia.org/wiki/Circle_of_fifths)
/// navigation for [Note]: walking by ascending or descending perfect
/// fifths, and measuring how many fifths separate two notes.
extension NoteCircleOfFifths on Note {
  /// This [Note]'s circle of fifths split into two one-directional
  /// sequences: `up` walking sharpward by ascending [Interval.P5], `down`
  /// walking flatward by ascending [Interval.P4] (the octave-complement
  /// direction), each starting one step away from this [Note] itself.
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

  /// A single flats-to-sharps sequence of `2 * distance + 1` notes,
  /// centered on this [Note], built by merging both directions of
  /// [splitCircleOfFifths].
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

  /// How many fifths this [Note] sits from [Note.c] on the circle of
  /// fifths — positive sharpward, negative flatward.
  ///
  /// Example:
  /// ```dart
  /// Note.c.circleOfFifthsDistance == 0
  /// Note.d.circleOfFifthsDistance == 2
  /// Note.a.flat.circleOfFifthsDistance == -4
  /// ```
  int get circleOfFifthsDistance => Note.c.fifthsDistanceWith(this);

  /// How many fifths separate this [Note] from [other], found by walking
  /// the circle of fifths in whichever direction reaches [other] first.
  ///
  /// Example:
  /// ```dart
  /// Note.c.fifthsDistanceWith(.e.flat) == -3
  /// Note.f.sharp.fifthsDistanceWith(.b) == -1
  /// Note.a.flat.fifthsDistanceWith(.c.sharp) == 11
  /// ```
  int fifthsDistanceWith(Note other) =>
      Interval.P5.circleDistance(from: this, to: other).$1;
}

/// Melodic-line analysis for a sequence of [Note]s, treating each
/// consecutive pair as the smaller of its two possible intervals (an
/// ascending sixth read as a descending third, and so on) rather than
/// [ScalableIterable.intervalSteps]'s literal, potentially compound
/// distance.
extension NoteIterable on Iterable<Note> {
  /// The [Interval] from each element to the next, folded to whichever
  /// direction spans less than a [Interval.P5] (so a leap up a sixth
  /// reports as a step down a third instead).
  Iterable<Interval> get closestSteps sync* {
    for (var i = 0; i < length - 1; i++) {
      final interval = elementAt(i).interval(elementAt(i + 1));
      yield interval >= .P5 ? interval - Interval.m6 : interval;
    }
  }

  /// Whether every consecutive pair in this melodic line moves by
  /// [Size.second] at most, using [closestSteps] rather than
  /// [ScalableIterable.intervalSteps] so registral leaps that are really
  /// just an inverted step (as [closestSteps] resolves them) still count
  /// as stepwise.
  ///
  /// See [Steps and skips](https://en.wikipedia.org/wiki/Steps_and_skips).
  ///
  /// Example:
  /// ```dart
  /// <Note>[.c, .d, .e, .f.sharp].isStepwise == true
  /// const <Note>[.c, .e, .g, .a].isStepwise == false
  /// ```
  bool get isStepwise =>
      closestSteps.every((interval) => interval.size.abs() <= Size.second);
}

/// Bulk operations over a [List] of [Note]s: uniform respelling and
/// promotion to voiced [Pitch]es (either stacked upward like a chord or
/// following the nearest-pitch path of a melody).
extension NoteList on List<Note> {
  /// Every [Note] in this [List], flattened by one semitone (see
  /// [Note.flat]).
  List<Note> get flat => map((note) => note.flat).toList();

  /// Every [Note] in this [List], sharpened by one semitone (see
  /// [Note.sharp]).
  List<Note> get sharp => map((note) => note.sharp).toList();

  /// Every [Note] in this [List] with its [Accidental] cleared (see
  /// [Note.natural]).
  List<Note> get natural => map((note) => note.natural).toList();

  /// Every [Note] in this list fixed at the same [octave], preserving
  /// order and register (unlike [toStacked] or [toMelody], each note
  /// lands in the exact same octave regardless of its neighbors).
  ///
  /// Example:
  /// ```dart
  /// const <Note>[.a, .c, .e].inOctave(4)
  ///   == [Note.a.inOctave(4), Note.c.inOctave(4), Note.e.inOctave(4)]
  /// ```
  List<Pitch> inOctave(int octave) =>
      map((note) => note.inOctave(octave)).toList();

  /// This [List] realized as ascending [Pitch]es, each placed just above
  /// the previous one starting from [octave] — the natural registral
  /// spread of a chord voicing read bottom to top.
  ///
  /// Example:
  /// ```dart
  /// const <Note>[.e, .g, .c].toStacked(octave: 4)
  ///   == [Note.e.inOctave(4), Note.g.inOctave(4), Note.c.inOctave(5)]
  /// ```
  List<Pitch> toStacked({int octave = 4}) =>
      _mapToPitches(octave, (previous, note) => previous.nearestAbove(note));

  /// This [List] realized as [Pitch]es following the smoothest possible
  /// voice leading: each note lands at whichever octave puts it nearest
  /// the previous pitch, the way a singable melodic line moves rather
  /// than a strictly ascending chord voicing.
  ///
  /// Example:
  /// ```dart
  /// const <Note>[.c, .a, .d].toMelody(octave: 3)
  ///   == [Note.c.inOctave(3), Note.a.inOctave(2), Note.d.inOctave(3)]
  /// ```
  List<Pitch> toMelody({int octave = 4}) =>
      _mapToPitches(octave, (previous, note) => previous.closestTo(note));

  List<Pitch> _mapToPitches(
    int octave,
    Pitch Function(Pitch previous, Note note) next,
  ) {
    var current = first.inOctave(octave);

    return [
      current,
      for (final note in skip(1)) current = next(current, note),
    ];
  }
}
