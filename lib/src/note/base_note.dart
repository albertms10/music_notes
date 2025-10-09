import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../interval/size.dart';
import '../notation_system.dart';
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

  static const _parsers = [
    EnglishBaseNoteNotation(),
    GermanBaseNoteNotation(),
    RomanceBaseNoteNotation(),
  ];

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
  factory BaseNote.parse(
    String source, {
    List<Parser<BaseNote>> chain = _parsers,
  }) => chain.parse(source);

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

  /// The string representation of this [BaseNote] based on [formatter].
  @override
  String toString({
    Formatter<BaseNote> formatter = const EnglishBaseNoteNotation(),
  }) => formatter.format(this);

  @override
  int compareTo(BaseNote other) => semitones.compareTo(other.semitones);
}

/// The English notation system for [BaseNote].
final class EnglishBaseNoteNotation extends NotationSystem<BaseNote> {
  /// Creates a new [EnglishBaseNoteNotation].
  const EnglishBaseNoteNotation();

  static final _baseNotes =
      (BaseNote.values
              .map(const EnglishBaseNoteNotation().format)
              .toList(growable: false)
            ..sort())
          .join();

  static final _regExp = RegExp(
    '(?<baseNote>[$_baseNotes])',
    caseSensitive: false,
  );

  @override
  String format(BaseNote baseNote) => baseNote.name.toUpperCase();

  @override
  RegExp get regExp => _regExp;

  @override
  BaseNote parseMatch(RegExpMatch match) =>
      BaseNote.values.byName(match.namedGroup('baseNote')!.toLowerCase());
}

/// The German notation system for [BaseNote].
final class GermanBaseNoteNotation extends NotationSystem<BaseNote> {
  /// Creates a new [GermanBaseNoteNotation].
  const GermanBaseNoteNotation();

  static const _altB = 'h';

  static final _baseNotes = ([
    ...BaseNote.values.map(const EnglishBaseNoteNotation().format),
    _altB.toUpperCase(),
  ]..sort()).join();

  static final _regExp = RegExp(
    '(?<baseNote>[$_baseNotes])',
    caseSensitive: false,
  );

  @override
  String format(BaseNote baseNote) => switch (baseNote) {
    BaseNote.b => _altB,
    BaseNote(:final name) => name,
  }.toUpperCase();

  @override
  RegExp get regExp => _regExp;

  @override
  BaseNote parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('baseNote')!.toLowerCase()) {
        _altB => BaseNote.b,
        final name => BaseNote.values.byName(name),
      };
}

/// The Romance notation system for [BaseNote].
final class RomanceBaseNoteNotation extends NotationSystem<BaseNote> {
  /// Creates a new [RomanceBaseNoteNotation].
  const RomanceBaseNoteNotation();

  @override
  String format(BaseNote baseNote) => _noteNames[baseNote]!;

  static final _noteNames = {
    BaseNote.c: 'Do',
    BaseNote.d: 'Re',
    BaseNote.e: 'Mi',
    BaseNote.f: 'Fa',
    BaseNote.g: 'Sol',
    BaseNote.a: 'La',
    BaseNote.b: 'Si',
  };

  static final _regExp = RegExp(
    '(?<baseNote>${_noteNames.values.join('|')})',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  BaseNote parseMatch(RegExpMatch match) {
    final name = match.namedGroup('baseNote')!.toLowerCase();

    return _noteNames.entries
        .firstWhere((entry) => entry.value.toLowerCase() == name)
        .key;
  }
}
