import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../interval/size.dart';
import '../tuning/equal_temperament.dart';
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
    }
    // TODO(albertms10): find a better way to catch an invalid BaseNote.
    // ignore: avoid_catching_errors
    on ArgumentError catch (e, stackTrace) {
      Error.throwWithStackTrace(
        FormatException('Invalid BaseNote', source, 0),
        stackTrace,
      );
    }
  }

  /// The ordinal number of this [BaseNote].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.ordinal == 1
  /// BaseNote.f.ordinal == 4
  /// BaseNote.b.ordinal == 7
  /// ```
  int get ordinal => values.indexOf(this) + 1;

  /// The [Size] that conforms between this [BaseNote] and [other].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.d.intervalSize(BaseNote.f) == Size.third
  /// BaseNote.a.intervalSize(BaseNote.e) == Size.fifth
  /// BaseNote.d.intervalSize(BaseNote.c) == Size.seventh
  /// BaseNote.c.intervalSize(BaseNote.a) == Size.sixth
  /// ```
  Size intervalSize(BaseNote other) => Size(
    other.ordinal - ordinal + (ordinal > other.ordinal ? values.length : 0) + 1,
  );

  /// The difference in semitones between this [BaseNote] and [other].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.difference(BaseNote.c) == 0
  /// BaseNote.c.difference(BaseNote.e) == 4
  /// BaseNote.f.difference(BaseNote.e) == -1
  /// BaseNote.a.difference(BaseNote.e) == -5
  /// ```
  int difference(BaseNote other) => Note(this).difference(Note(other));

  /// The positive difference in semitones between this [BaseNote] and [other].
  ///
  /// When [difference] would return a negative value, this method returns the
  /// difference with [other] being in the next octave.
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.positiveDifference(BaseNote.c) == 0
  /// BaseNote.c.positiveDifference(BaseNote.e) == 4
  /// BaseNote.f.positiveDifference(BaseNote.e) == 11
  /// BaseNote.a.positiveDifference(BaseNote.e) == 7
  /// ```
  int positiveDifference(BaseNote other) {
    final diff = difference(other);

    return diff.isNegative ? diff + chromaticDivisions : diff;
  }

  /// Transposes this [BaseNote] by interval [size].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.g.transposeBySize(Size.unison) == BaseNote.g
  /// BaseNote.g.transposeBySize(Size.fifth) == BaseNote.d
  /// BaseNote.a.transposeBySize(-Size.third) == BaseNote.f
  /// ```
  BaseNote transposeBySize(Size size) =>
      BaseNote.fromOrdinal(ordinal + size.incrementBy(-1));

  /// The next ordinal [BaseNote].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.c.next == BaseNote.d
  /// BaseNote.f.next == BaseNote.a
  /// BaseNote.b.next == BaseNote.c
  /// ```
  BaseNote get next => transposeBySize(Size.second);

  /// The previous ordinal [BaseNote].
  ///
  /// Example:
  /// ```dart
  /// BaseNote.e.previous == BaseNote.d
  /// BaseNote.g.previous == BaseNote.f
  /// BaseNote.c.previous == BaseNote.b
  /// ```
  BaseNote get previous => transposeBySize(-Size.second);

  /// The string representation of this [BaseNote] based on [system].
  ///
  /// See [NoteNotation] for all system implementations.
  @override
  String toString({NoteNotation system = NoteNotation.english}) =>
      system.baseNote(this);

  @override
  int compareTo(BaseNote other) => semitones.compareTo(other.semitones);
}
