import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/utils.dart';

import '../interval/size.dart';
import '../notation_system.dart';
import '../tuning/equal_temperament.dart';
import 'note.dart';

/// The note names of the diatonic scale.
///
/// ---
/// See also:
/// * [Note].
enum NoteName implements Comparable<NoteName> {
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

  /// The number of semitones that identify this [NoteName].
  final int semitones;

  /// Creates a new [NoteName] from [semitones].
  const NoteName(this.semitones);

  /// Returns a [NoteName] that matches with [semitones] as in [NoteName],
  /// otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// NoteName.fromSemitones(2) == NoteName.d
  /// NoteName.fromSemitones(7) == NoteName.g
  /// NoteName.fromSemitones(10) == null
  /// ```
  static NoteName? fromSemitones(int semitones) => values.firstWhereOrNull(
    (note) => semitones % chromaticDivisions == note.semitones,
  );

  /// Returns a [NoteName] that matches with [ordinal].
  ///
  /// Example:
  /// ```dart
  /// NoteName.fromOrdinal(3) == NoteName.e
  /// NoteName.fromOrdinal(7) == NoteName.b
  /// NoteName.fromOrdinal(10) == NoteName.e
  /// ```
  factory NoteName.fromOrdinal(int ordinal) =>
      values[ordinal.nonZeroMod(values.length) - 1];

  /// The chain of [Parser]s used to parse a [NoteName].
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
  /// NoteName.parse('B') == NoteName.b
  /// NoteName.parse('a') == NoteName.a
  /// NoteName.parse('z') // throws a FormatException
  /// ```
  factory NoteName.parse(
    String source, {
    List<Parser<NoteName>> chain = parsers,
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
  /// NoteName.d.intervalSize(NoteName.f) == Size.third
  /// NoteName.a.intervalSize(NoteName.e) == Size.fifth
  /// NoteName.d.intervalSize(NoteName.c) == Size.seventh
  /// NoteName.c.intervalSize(NoteName.a) == Size.sixth
  /// ```
  Size intervalSize(NoteName other) => Size(
    other.ordinal - ordinal + (ordinal > other.ordinal ? values.length : 0) + 1,
  );

  /// The difference in semitones between this [NoteName] and [other].
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.difference(NoteName.c) == 0
  /// NoteName.c.difference(NoteName.e) == 4
  /// NoteName.f.difference(NoteName.e) == -1
  /// NoteName.a.difference(NoteName.e) == -5
  /// ```
  int difference(NoteName other) => Note(this).difference(Note(other));

  /// The positive difference in semitones between this [NoteName] and [other].
  ///
  /// When [difference] would return a negative value, this method returns the
  /// difference with [other] being in the next octave.
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.positiveDifference(NoteName.c) == 0
  /// NoteName.c.positiveDifference(NoteName.e) == 4
  /// NoteName.f.positiveDifference(NoteName.e) == 11
  /// NoteName.a.positiveDifference(NoteName.e) == 7
  /// ```
  int positiveDifference(NoteName other) {
    final diff = difference(other);

    return diff.isNegative ? diff + chromaticDivisions : diff;
  }

  /// Transposes this [NoteName] by interval [size].
  ///
  /// Example:
  /// ```dart
  /// NoteName.g.transposeBySize(Size.unison) == NoteName.g
  /// NoteName.g.transposeBySize(Size.fifth) == NoteName.d
  /// NoteName.a.transposeBySize(-Size.third) == NoteName.f
  /// ```
  NoteName transposeBySize(Size size) =>
      NoteName.fromOrdinal(ordinal + size.incrementBy(-1));

  /// The next ordinal [NoteName].
  ///
  /// Example:
  /// ```dart
  /// NoteName.c.next == NoteName.d
  /// NoteName.f.next == NoteName.a
  /// NoteName.b.next == NoteName.c
  /// ```
  NoteName get next => transposeBySize(Size.second);

  /// The previous ordinal [NoteName].
  ///
  /// Example:
  /// ```dart
  /// NoteName.e.previous == NoteName.d
  /// NoteName.g.previous == NoteName.f
  /// NoteName.c.previous == NoteName.b
  /// ```
  NoteName get previous => transposeBySize(-Size.second);

  /// The string representation of this [NoteName] based on [formatter].
  @override
  String toString({
    Formatter<NoteName> formatter = const EnglishNoteNameNotation(),
  }) => formatter.format(this);

  @override
  int compareTo(NoteName other) => semitones.compareTo(other.semitones);
}

/// The English notation system for [NoteName].
final class EnglishNoteNameNotation extends NotationSystem<NoteName> {
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
  String format(NoteName noteName) => noteName.name.toUpperCase();

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) =>
      NoteName.values.byName(match.namedGroup('noteName')!.toLowerCase());
}

/// The German notation system for [NoteName].
final class GermanNoteNameNotation extends NotationSystem<NoteName> {
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
  String format(NoteName noteName) => switch (noteName) {
    NoteName.b => _altB,
    NoteName(:final name) => name,
  }.toUpperCase();

  @override
  RegExp get regExp => _regExp;

  @override
  NoteName parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('noteName')!.toLowerCase()) {
        _altB => NoteName.b,
        final name => NoteName.values.byName(name),
      };
}

/// The Romance notation system for [NoteName].
final class RomanceNoteNameNotation extends NotationSystem<NoteName> {
  /// Creates a new [RomanceNoteNameNotation].
  const RomanceNoteNameNotation();

  @override
  String format(NoteName noteName) => _noteNames[noteName]!;

  static final _noteNames = {
    NoteName.c: 'Do',
    NoteName.d: 'Re',
    NoteName.e: 'Mi',
    NoteName.f: 'Fa',
    NoteName.g: 'Sol',
    NoteName.a: 'La',
    NoteName.b: 'Si',
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
}
