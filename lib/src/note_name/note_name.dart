import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../note/note.dart';
import '../size/size.dart';
import '../tuning_system/equal_temperament.dart';
import 'english_note_name_notation.dart';
import 'german_note_name_notation.dart';
import 'romance_note_name_notation.dart';

/// One of the seven natural letter names of the diatonic scale (C through
/// B), unmodified by any [Accidental].
///
/// [NoteName] alone fixes a pitch's letter and its natural position in
/// the octave (via [semitones]), but not any sharp or flat; pairing one
/// with an [Accidental] is what [Note] does. Its seven values are also
/// the fixed cycle that [ordinal], [next], [previous], and
/// [transposeBySize] all walk letter-by-letter, independently of
/// semitone distance — the difference between a generic ("a third") and
/// a specific ("4 semitones") interval.
///
/// ---
/// See also:
/// * [Note].
enum NoteName implements Comparable<NoteName>, Formattable<NoteName> {
  /// Note name C, the tonic of the C major scale.
  c(0),

  /// Note name D, a whole step above [c].
  d(2),

  /// Note name E, a half step above [d].
  e(4),

  /// Note name F, a half step above [e].
  f(5),

  /// Note name G, a whole step above [f].
  g(7),

  /// Note name A, a whole step above [g].
  a(9),

  /// Note name B, a whole step above [a] and a half step below the next
  /// [c].
  b(11)
  ;

  /// This [NoteName]'s natural position in semitones from [NoteName.c],
  /// before any [Accidental] is applied.
  final int semitones;

  /// Creates a new [NoteName] naturally positioned at [semitones] above C.
  const NoteName(this.semitones);

  /// The [NoteName] whose natural [semitones] position matches
  /// `semitones % chromaticDivisions`, or `null` if none does (i.e.
  /// [semitones] lands on a black key with no natural letter of its own).
  ///
  /// Example:
  /// ```dart
  /// NoteName.fromSemitones(2) == .d
  /// NoteName.fromSemitones(7) == .g
  /// NoteName.fromSemitones(10) == null
  /// ```
  static NoteName? fromSemitones(int semitones) => values.firstWhereOrNull(
    (noteName) => semitones % chromaticDivisions == noteName.semitones,
  );

  /// The [NoteName] at [ordinal] in the seven-letter cycle, wrapping
  /// around (and treating an [ordinal] of 0 as a full cycle back) via
  /// [IntExtension.nonZeroMod].
  ///
  /// Example:
  /// ```dart
  /// NoteName.fromOrdinal(3) == .e
  /// NoteName.fromOrdinal(7) == .b
  /// NoteName.fromOrdinal(10) == .e
  /// ```
  factory NoteName.fromOrdinal(int ordinal) =>
      values[ordinal.nonZeroMod(values.length) - 1];

  /// The chain of [StringParser]s tried in turn by [NoteName.parse]:
  /// English letters, German letters (including the `H`/`h` split for B),
  /// then Romance solfège syllables.
  static const parsers = [
    EnglishNoteNameNotation(),
    GermanNoteNameNotation(),
    RomanceNoteNameNotation(),
  ];

  /// Parses [source] as a [NoteName] and returns its value.
  ///
  /// If [source] does not contain a valid [NoteName], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// NoteName.parse('B') == .b
  /// NoteName.parse('a') == .a
  /// NoteName.parse('z') // throws a FormatException
  /// ```
  factory NoteName.parse(
    String source, {
    List<StringParser<NoteName>> chain = parsers,
  }) => chain.parse(source);

  /// This [NoteName]'s one-indexed position in the letter cycle (C is 1,
  /// B is 7), the basis for generic (letter-counting) interval sizes.
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.ordinal == 1
  /// NoteName.f.ordinal == 4
  /// NoteName.b.ordinal == 7
  /// ```
  int get ordinal => values.indexOf(this) + 1;

  /// The generic [Size] spanning this [NoteName] and [other], counted by
  /// letter names alone (always ascending and within a single octave),
  /// regardless of any [Accidental] either note might carry.
  ///
  /// Example:
  /// ```dart
  /// NoteName.d.intervalSize(NoteName.f) == .third
  /// NoteName.a.intervalSize(NoteName.e) == .fifth
  /// NoteName.d.intervalSize(NoteName.c) == .seventh
  /// NoteName.c.intervalSize(NoteName.a) == .sixth
  /// ```
  Size intervalSize(NoteName other) => Size(
    other.ordinal - ordinal + (ordinal > other.ordinal ? values.length : 0) + 1,
  );

  /// The signed semitone distance from this [NoteName] to [other],
  /// negative when [other] is the closer letter below rather than above.
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.difference(.c) == 0
  /// NoteName.c.difference(.e) == 4
  /// NoteName.f.difference(.e) == -1
  /// NoteName.a.difference(.e) == -5
  /// ```
  int difference(NoteName other) => Note(this).difference(Note(other));

  /// The semitone distance from this [NoteName] up to [other], always
  /// non-negative by treating [other] as lying in the octave above when
  /// [difference] would otherwise be negative.
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.positiveDifference(.c) == 0
  /// NoteName.c.positiveDifference(.e) == 4
  /// NoteName.f.positiveDifference(.e) == 11
  /// NoteName.a.positiveDifference(.e) == 7
  /// ```
  int positiveDifference(NoteName other) {
    final diff = difference(other);

    return diff.isNegative ? diff + chromaticDivisions : diff;
  }

  /// This [NoteName] moved [size] letter names away (ascending for a
  /// positive [Size], descending for a negative one), wrapping around the
  /// seven-letter cycle.
  ///
  /// Example:
  /// ```dart
  /// NoteName.g.transposeBySize(.unison) == .g
  /// NoteName.g.transposeBySize(.fifth) == .d
  /// NoteName.a.transposeBySize(-Size.third) == .f
  /// ```
  NoteName transposeBySize(Size size) =>
      .fromOrdinal(ordinal + size.incrementBy(-1));

  /// The next [NoteName] one letter up, wrapping from B back to C.
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.next == .d
  /// NoteName.f.next == .g
  /// NoteName.b.next == .c
  /// ```
  NoteName get next => transposeBySize(.second);

  /// The previous [NoteName] one letter down, wrapping from C back to B.
  ///
  /// Example:
  /// ```dart
  /// NoteName.e.previous == .d
  /// NoteName.g.previous == .f
  /// NoteName.c.previous == .b
  /// ```
  NoteName get previous => transposeBySize(-Size.second);

  /// The string representation of this [NoteName], using [formatter]
  /// (uppercase English letters by default).
  @override
  String format([
    StringFormatter<NoteName> formatter = const EnglishNoteNameNotation(),
  ]) => formatter.format(this);

  @override
  int compareTo(NoteName other) => semitones.compareTo(other.semitones);
}
