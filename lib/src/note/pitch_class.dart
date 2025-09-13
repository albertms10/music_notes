import 'dart:collection' show SplayTreeSet;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:meta/meta.dart' show immutable;

import '../interval/interval.dart';
import '../interval/interval_class.dart';
import '../notation_system.dart';
import '../scalable.dart';
import '../tuning/equal_temperament.dart';
import 'accidental.dart';
import 'base_note.dart';
import 'note.dart';
import 'pitch.dart';

/// A set of all pitches that are a whole number of octaves apart, sharing the
/// same chroma.
///
/// See [Pitch class](https://en.wikipedia.org/wiki/Pitch_class).
///
/// ---
/// See also:
/// * [Pitch].
@immutable
final class PitchClass extends Scalable<PitchClass>
    implements Comparable<PitchClass> {
  /// The number of semitones (chroma) that represent this [PitchClass].
  ///
  /// See [Chroma feature](https://en.wikipedia.org/wiki/Chroma_feature).
  @override
  final int semitones;

  /// Creates a new [PitchClass] from [semitones].
  const PitchClass(int semitones) : semitones = semitones % chromaticDivisions;

  /// Pitch class 0, which corresponds to [Note.c].
  static const c = PitchClass(0);

  /// Pitch class 1, which corresponds to `Note.c.sharp` or `Note.d.flat`.
  static const cSharp = PitchClass(1);

  /// Pitch class 2, which corresponds to [Note.d].
  static const d = PitchClass(2);

  /// Pitch class 3, which corresponds to `Note.d.sharp` or `Note.e.flat`.
  static const dSharp = PitchClass(3);

  /// Pitch class 4, which corresponds to [Note.e].
  static const e = PitchClass(4);

  /// Pitch class 5, which corresponds to [Note.f].
  static const f = PitchClass(5);

  /// Pitch class 6, which corresponds to `Note.f.sharp` or `Note.g.flat`.
  static const fSharp = PitchClass(6);

  /// Pitch class 7, which corresponds to [Note.g].
  static const g = PitchClass(7);

  /// Pitch class 8, which corresponds to `Note.g.sharp` or `Note.g.flat`.
  static const gSharp = PitchClass(8);

  /// Pitch class 9, which corresponds to [Note.a].
  static const a = PitchClass(9);

  /// Pitch class 10, which corresponds to `Note.a.sharp` or `Note.b.flat`.
  static const aSharp = PitchClass(10);

  /// Pitch class 11, which corresponds to [Note.b].
  static const b = PitchClass(11);

  /// Parse [source] as a [PitchClass] and return its value.
  ///
  /// If the [source] string does not contain a valid [PitchClass], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// PitchClass.parse('{C#|Db}') == PitchClass.cSharp
  /// PitchClass.parse('5') == PitchClass.f
  /// PitchClass.parse('t') == PitchClass.aSharp
  /// PitchClass.parse('z') // throws a FormatException
  /// ```
  factory PitchClass.parse(
    String source, {
    List<Parser<PitchClass>> chain = const [
      EnharmonicSpellingsPitchClassNotation(),
      IntegerPitchClassNotation(),
    ],
  }) => chain.parse(source);

  /// The different spellings at [distance] sharing the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.g.spellings() == {Note.g}
  /// PitchClass.dSharp.spellings() == {Note.d.sharp, Note.e.flat}
  /// PitchClass.b.spellings(distance: 1)
  ///   == {Note.a.sharp.sharp, Note.b, Note.c.flat}
  /// ```
  Set<Note> spellings({int distance = 0}) {
    assert(distance >= 0, 'Distance must be greater or equal than zero.');
    final baseNote = BaseNote.fromSemitones(semitones);

    if (baseNote != null) {
      final note = Note(baseNote);

      return SplayTreeSet<Note>.of({
        note,
        for (var i = 1; i <= distance; i++) ...[
          note.respellByOrdinalDistance(distance),
          note.respellByOrdinalDistance(-distance),
        ],
      }, Note.compareByClosestDistance);
    }

    final aboveNote = Note(
      BaseNote.fromSemitones(semitones - 1)!,
      Accidental.sharp,
    );
    final belowNote = Note(
      BaseNote.fromSemitones(semitones + 1)!,
      Accidental.flat,
    );

    return SplayTreeSet<Note>.of({
      aboveNote,
      belowNote,
      for (var i = 1; i <= distance; i++) ...[
        belowNote.respellByOrdinalDistance(distance),
        aboveNote.respellByOrdinalDistance(-distance),
      ],
    }, Note.compareByClosestDistance);
  }

  /// The [Note] that matches [withAccidental] from this [PitchClass].
  ///
  /// Throws an [ArgumentError] when [withAccidental] does not match with any
  /// possible note.
  ///
  /// Example:
  /// ```dart
  /// PitchClass.d.resolveSpelling() == Note.d
  /// PitchClass.fSharp.resolveSpelling(Accidental.flat) == Note.g.flat
  /// PitchClass.cSharp.resolveSpelling(Accidental.natural) // throws
  /// ```
  Note resolveSpelling([Accidental? withAccidental]) {
    final matchedNote = spellings(
      distance: 1,
    ).firstWhereOrNull((note) => note.accidental == withAccidental);
    if (matchedNote != null) return matchedNote;

    if (withAccidental != null) {
      throw ArgumentError.value(
        '$withAccidental',
        'preferredAccidental',
        'Impossible match for $this',
      );
    }

    return spellings()
        // TODO(albertms10): return the note with the closest accidental #50.
        .sorted(
          (a, b) => a.accidental.semitones.abs().compareTo(
            b.accidental.semitones.abs(),
          ),
        )
        .first;
  }

  /// The [Note] that matches with [preferredAccidental] from this [PitchClass].
  ///
  /// Like [resolveSpelling] except that this function returns the closest note
  /// where a similar call to [resolveSpelling] would throw an [ArgumentError].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.d.resolveClosestSpelling() == Note.d
  /// PitchClass.gSharp.resolveClosestSpelling(Accidental.flat)
  ///   == Note.a.flat
  /// PitchClass.cSharp.resolveClosestSpelling(Accidental.natural) == null
  /// ```
  Note resolveClosestSpelling([Accidental? preferredAccidental]) {
    try {
      return resolveSpelling(preferredAccidental);
      // ignore: avoid_catching_errors to catch `ArgumentError`.
    } on ArgumentError {
      return resolveSpelling();
    }
  }

  /// Transposes this [PitchClass] by [interval].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.c.transposeBy(Interval.tritone) == PitchClass.fSharp
  /// PitchClass.a.transposeBy(-Interval.M2) == PitchClass.g
  /// ```
  @override
  // TODO(albertms10): expect [IntervalClass]. See #248.
  PitchClass transposeBy(Interval interval) =>
      PitchClass(semitones + interval.semitones);

  /// The [IntervalClass] expressed as [Interval] between this [PitchClass] and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.c.interval(PitchClass.e) == Interval.M3
  /// PitchClass.gSharp.interval(PitchClass.d) == Interval.A4
  /// ```
  @override
  // TODO(albertms10): return [IntervalClass]. See #248.
  Interval interval(PitchClass other) {
    final diff = difference(other);

    return IntervalClass(
      diff,
    ).resolveClosestSpelling().descending(diff.isNegative);
  }

  /// The difference in semitones between this [PitchClass] and [other].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.g.difference(PitchClass.a) == 2
  /// PitchClass.dSharp.difference(PitchClass.c) == -3
  /// PitchClass.c.difference(PitchClass.fSharp) == -6
  /// ```
  @override
  int difference(PitchClass other) => super.difference(other);

  @override
  PitchClass get respelledUpwards => this;

  @override
  PitchClass get respelledDownwards => this;

  @override
  PitchClass get respelledSimple => this;

  /// A pitch-class multiplication modulo [chromaticDivisions] of this
  /// [PitchClass].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.cSharp * 7 == PitchClass.g
  /// PitchClass.d * 7 == PitchClass.d
  /// // observe one semitone upwards results in ascending fifths G -> D.
  ///
  /// PitchClass.cSharp * 5 == PitchClass.f
  /// PitchClass.d * 5 == PitchClass.aSharp
  /// // observe one semitone upwards results in ascending fourths F -> B-flat.
  /// ```
  ///
  /// The multiplication by the two meaningful operations (5 and 7) gives us the
  /// circle of fourths and fifths transform, respectively, when operated on a
  /// chromatic scale as follows:
  ///
  /// ```dart
  /// final chromaticScale = ScalePattern.chromatic.on(PitchClass.c);
  ///
  /// // Cycle of fourths transform
  /// chromaticScale.degrees.map((note) => note * 5)
  ///   == Interval.P4.circleFrom(PitchClass.c, distance: 12)
  ///
  /// // Cycle of fifths transform
  /// chromaticScale.degrees.map((note) => note * 7)
  ///   == Interval.P5.circleFrom(PitchClass.c, distance: 12)
  ///
  /// // Inversion
  /// chromaticScale.degrees.map((note) => note * 11)
  ///   .toList() == chromaticScale.descendingDegrees
  ///
  /// // Whole-tone transform
  /// final wholeToneScale = ScalePattern.wholeTone.on(PitchClass.c);
  /// chromaticScale.degrees.skip(6).map((note) => note * 2)
  ///   .toList() == wholeToneScale.degrees
  /// ```
  ///
  /// See [Pitch-class multiplication modulo 12](https://en.wikipedia.org/wiki/Multiplication_(music)#Pitch-class_multiplication_modulo_12).
  PitchClass operator *(int factor) => PitchClass(semitones * factor);

  /// The string representation of this [PitchClass] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// PitchClass.c.toString() == '{C}'
  /// PitchClass.g.toString() == '{G}'
  /// PitchClass.dSharp.toString() == '{D♯|E♭}'
  ///
  /// const integer = IntegerPitchClassNotation();
  /// PitchClass.c.toString(formatter: integer) == '0'
  /// PitchClass.f.toString(formatter: integer) == '5'
  /// PitchClass.aSharp.toString(formatter: integer) == 't'
  /// PitchClass.b.toString(formatter: integer) == 'e'
  /// ```
  @override
  String toString({
    Formatter<PitchClass> formatter =
        const EnharmonicSpellingsPitchClassNotation(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is PitchClass && semitones == other.semitones;

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(PitchClass other) => semitones.compareTo(other.semitones);
}

/// The [NotationSystem] for enharmonic spellings [PitchClass].
///
/// See [Tonal counterparts](https://en.wikipedia.org/wiki/Pitch_class#Other_ways_to_label_pitch_classes).
final class EnharmonicSpellingsPitchClassNotation
    extends NotationSystem<PitchClass> {
  /// The [NotationSystem] for [Note].
  final NotationSystem<Note> noteNotation;

  /// Creates a new [EnharmonicSpellingsPitchClassNotation].
  const EnharmonicSpellingsPitchClassNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
  });

  @override
  String format(PitchClass pitchClass) =>
      '{${pitchClass.spellings().join('|')}}';

  @override
  RegExp get regExp => RegExp(
    r'(?:\{|\|)'
    '${noteNotation.regExp?.pattern}'
    r'(?:\|.*|\})',
    caseSensitive: false,
  );

  @override
  PitchClass parseMatch(RegExpMatch match) {
    final Note(:semitones) = noteNotation.parseMatch(match);

    return PitchClass(semitones);
  }
}

/// The [NotationSystem] for integer [PitchClass].
///
/// See [Integer notation](https://en.wikipedia.org/wiki/Pitch_class#Integer_notation).
final class IntegerPitchClassNotation extends NotationSystem<PitchClass> {
  /// Creates a new [IntegerPitchClassNotation].
  const IntegerPitchClassNotation();

  @override
  String format(PitchClass pitchClass) => switch (pitchClass.semitones) {
    10 => 't',
    11 => 'e',
    final semitones => '$semitones',
  };

  static final _regExp = RegExp('(?<pitchClass>[0-9et])');

  @override
  RegExp get regExp => _regExp;

  @override
  PitchClass parseMatch(RegExpMatch match) =>
      PitchClass(switch (match.namedGroup('pitchClass')!) {
        't' => 10,
        'e' => 11,
        final semitones => int.parse(semitones),
      });
}
