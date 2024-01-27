import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../music.dart';
import 'note.dart';

/// The base note names of the diatonic scale.
///
/// ---
/// See also:
/// * [Note].
enum BaseNote implements Comparable<BaseNote> {
  /// Note C.
  c(0),

  /// Note D.
  d(2),

  /// Note E.
  e(4),

  /// Note F.
  f(5),

  /// Note G.
  g(7),

  /// Note A.
  a(9),

  /// Note B.
  b(11);

  /// The number of semitones that identify this [BaseNote].
  final int semitones;

  /// Creates a new [BaseNote] from [semitones].
  const BaseNote(this.semitones);

  /// Returns a [BaseNote] that matches with [semitones] as in [BaseNote],
  /// otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.fromSemitones(2) == BaseNote.d
  /// BaseNote.fromSemitones(7) == BaseNote.g
  /// BaseNote.fromSemitones(10) == null
  /// ```
  static BaseNote? fromSemitones(int semitones) => values.firstWhereOrNull(
        (note) => semitones % chromaticDivisions == note.semitones,
      );

  /// Returns a [BaseNote] that matches with [ordinal].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.fromOrdinal(3) == BaseNote.e
  /// BaseNote.fromOrdinal(7) == BaseNote.b
  /// BaseNote.fromOrdinal(10) == BaseNote.e
  /// ```
  factory BaseNote.fromOrdinal(int ordinal) =>
      values[ordinal.nonZeroMod(values.length) - 1];

  /// Parse [source] as a [BaseNote] and return its value.
  ///
  /// If the [source] string does not contain a valid [BaseNote], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.parse('B') == BaseNote.b
  /// BaseNote.parse('a') == BaseNote.a
  /// BaseNote.parse('z') // throws a FormatException
  /// ```
  factory BaseNote.parse(String source) {
    try {
      return values.byName(source.toLowerCase());
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        FormatException('Invalid BaseNote', source, 0),
        stackTrace,
      );
    }
  }

  /// Returns the ordinal number of this [BaseNote].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.ordinal == 1
  /// BaseNote.f.ordinal == 4
  /// BaseNote.b.ordinal == 7
  /// ```
  int get ordinal => values.indexOf(this) + 1;

  /// Returns the [Interval.size] that conforms between this [BaseNote] and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.d.intervalSize(BaseNote.f) == 3
  /// BaseNote.a.intervalSize(BaseNote.e) == 5
  /// ```
  int intervalSize(BaseNote other) =>
      other.ordinal -
      ordinal +
      (ordinal > other.ordinal ? values.length : 0) +
      1;

  /// Returns the difference in semitones between this [BaseNote] and [other].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.difference(BaseNote.c) == 0
  /// BaseNote.c.difference(BaseNote.e) == 4
  /// BaseNote.a.difference(BaseNote.d) == 5
  /// ```
  int difference(BaseNote other) => Note(this).difference(Note(other));

  /// Returns the positive difference in semitones between this [BaseNote] and
  /// [other].
  ///
  /// When [difference] would return a negative value, this method returns the
  /// difference with [other] being in the next octave.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.positiveDifference(BaseNote.c) == 0
  /// BaseNote.c.positiveDifference(BaseNote.e) == 4
  /// BaseNote.a.positiveDifference(BaseNote.d) == 5
  /// ```
  int positiveDifference(BaseNote other) {
    final diff = difference(other);

    return diff.isNegative ? diff + chromaticDivisions : diff;
  }

  /// Transposes this [BaseNote] by interval [size].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.g.transposeBySize(1) == BaseNote.g
  /// BaseNote.g.transposeBySize(5) == BaseNote.d
  /// BaseNote.a.transposeBySize(-3) == BaseNote.f
  /// ```
  BaseNote transposeBySize(int size) {
    assert(size != 0, 'Size must be non-zero');

    return BaseNote.fromOrdinal(ordinal + size.incrementBy(-1));
  }

  @override
  String toString({NoteNotation system = NoteNotation.english}) =>
      system.baseNote(this);

  @override
  int compareTo(BaseNote other) => semitones.compareTo(other.semitones);
}
