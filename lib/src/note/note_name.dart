import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../interval/size.dart';
import '../notation/notation_system.dart';
import '../tuning/equal_temperament.dart';
import 'note.dart';

/// The note names of the diatonic scale.
///
/// ---
/// See also:
/// * [Note].
enum NoteName implements Comparable<NoteName> {
  /// Note name C.
  c(0),

  /// Note name D.
  d(2),

  /// Note name E.
  e(4),

  /// Note name F.
  f(5),

  /// Note name G.
  g(7),

  /// Note name A.
  a(9),

  /// Note name B.
  b(11)
  ;

  /// The number of semitones that identify this [NoteName].
  final int semitones;

  /// Creates a new [NoteName] from [semitones].
  const NoteName(this.semitones);

  /// Returns a [NoteName] that matches with [semitones] as in [NoteName],
  /// otherwise returns `null`.
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

  /// Returns a [NoteName] that matches with [ordinal].
  ///
  /// Example:
  /// ```dart
  /// NoteName.fromOrdinal(3) == .e
  /// NoteName.fromOrdinal(7) == .b
  /// NoteName.fromOrdinal(10) == .e
  /// ```
  factory NoteName.fromOrdinal(int ordinal) =>
      values[ordinal.nonZeroMod(values.length) - 1];

  /// The chain of [StringParser]s used to parse a [NoteName].
  static const parsers = [
    EnglishNoteNameNotation(),
    GermanNoteNameNotation(),
    RomanceNoteNameNotation(),
  ];

  /// Parse [source] as a [NoteName] and return its value.
  ///
  /// If the [source] string does not contain a valid [NoteName], a
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

  /// The ordinal number of this [NoteName].
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.ordinal == 1
  /// NoteName.f.ordinal == 4
  /// NoteName.b.ordinal == 7
  /// ```
  int get ordinal => values.indexOf(this) + 1;

  /// The [Size] that conforms between this [NoteName] and [other].
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

  /// The difference in semitones between this [NoteName] and [other].
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.difference(.c) == 0
  /// NoteName.c.difference(.e) == 4
  /// NoteName.f.difference(.e) == -1
  /// NoteName.a.difference(.e) == -5
  /// ```
  int difference(NoteName other) => Note(this).difference(Note(other));

  /// The positive difference in semitones between this [NoteName] and [other].
  ///
  /// When [difference] would return a negative value, this method returns the
  /// difference with [other] being in the next octave.
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

  /// Transposes this [NoteName] by interval [size].
  ///
  /// Example:
  /// ```dart
  /// NoteName.g.transposeBySize(.unison) == .g
  /// NoteName.g.transposeBySize(.fifth) == .d
  /// NoteName.a.transposeBySize(-Size.third) == .f
  /// ```
  NoteName transposeBySize(Size size) =>
      .fromOrdinal(ordinal + size.incrementBy(-1));

  /// The next ordinal [NoteName].
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.next == .d
  /// NoteName.f.next == .a
  /// NoteName.b.next == .c
  /// ```
  NoteName get next => transposeBySize(.second);

  /// The previous ordinal [NoteName].
  ///
  /// Example:
  /// ```dart
  /// NoteName.e.previous == .d
  /// NoteName.g.previous == .f
  /// NoteName.c.previous == .b
  /// ```
  NoteName get previous => transposeBySize(-Size.second);

  /// The string representation of this [NoteName] based on [formatter].
  @override
  String toString({
    StringFormatter<NoteName> formatter = const EnglishNoteNameNotation(),
  }) => formatter.format(this);

  @override
  int compareTo(NoteName other) => semitones.compareTo(other.semitones);
}

/// The English notation system for [NoteName].
final class EnglishNoteNameNotation extends StringNotationSystem<NoteName> {
  /// Creates a new [EnglishNoteNameNotation].
  const EnglishNoteNameNotation();

  static final _noteNames =
      (NoteName.values
              .map(const EnglishNoteNameNotation().format)
              .toList(growable: false)
            ..sort())
          .join();

  static final _regExp = RegExp(
    '(?<noteName>[$_noteNames])',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) =>
      .values.byName(match.namedGroup('noteName')!.toLowerCase());

  @override
  String format(NoteName noteName) => noteName.name.toUpperCase();
}

/// The German notation system for [NoteName].
final class GermanNoteNameNotation extends StringNotationSystem<NoteName> {
  /// Creates a new [GermanNoteNameNotation].
  const GermanNoteNameNotation();

  static const _altB = 'h';

  static final _noteNames = ([
    ...NoteName.values.map(const EnglishNoteNameNotation().format),
    _altB.toUpperCase(),
  ]..sort()).join();

  static final _regExp = RegExp(
    '(?<noteName>[$_noteNames])',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('noteName')!.toLowerCase()) {
        _altB => .b,
        final name => .values.byName(name),
      };

  @override
  String format(NoteName noteName) => switch (noteName) {
    .b => _altB,
    NoteName(:final name) => name,
  }.toUpperCase();
}

/// The Romance notation system for [NoteName].
final class RomanceNoteNameNotation extends StringNotationSystem<NoteName> {
  /// Creates a new [RomanceNoteNameNotation].
  const RomanceNoteNameNotation();

  static final _noteNames = <NoteName, String>{
    .c: 'Do',
    .d: 'Re',
    .e: 'Mi',
    .f: 'Fa',
    .g: 'Sol',
    .a: 'La',
    .b: 'Si',
  };

  static final _regExp = RegExp(
    '(?<noteName>${_noteNames.values.join('|')})',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) {
    final name = match.namedGroup('noteName')!.toLowerCase();

    return _noteNames.entries
        .firstWhere((entry) => entry.value.toLowerCase() == name)
        .key;
  }

  @override
  String format(NoteName noteName) => _noteNames[noteName]!;
}
