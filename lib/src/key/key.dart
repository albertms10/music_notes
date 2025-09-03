import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../interval/interval.dart';
import '../notation_system.dart';
import '../note/accidental.dart';
import '../note/note.dart';
import '../scale/scale.dart';
import 'key_signature.dart';
import 'mode.dart';

/// A musical key or tonality.
///
/// See [Key (music)](https://en.wikipedia.org/wiki/Key_(music)).
///
/// ---
/// See also:
/// * [Note].
/// * [Mode].
/// * [KeySignature].
@immutable
final class Key implements Comparable<Key> {
  /// The tonal center representing this [Key].
  final Note note;

  /// The mode representing this [Key].
  final TonalMode mode;

  /// Creates a new [Key] from [note] and [mode].
  const Key(this.note, this.mode);

  /// Parse [source] as a [Key] and return its value.
  ///
  /// If the [source] string does not contain a valid [Key], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Key.parse('C major') == Note.c.major
  /// Key.parse('f# minor') == Note.f.sharp.minor
  /// Key.parse('z') // throws a FormatException
  /// ```
  factory Key.parse(
    String source, {
    List<Parser<Key>> chain = const [
      EnglishKeyNotation(),
      EnglishKeyNotation.symbol(),
      GermanKeyNotation(),
      RomanceKeyNotation(),
      RomanceKeyNotation.symbol(),
    ],
  }) => chain.parse(source);

  /// The [TonalMode.major] or [TonalMode.minor] relative [Key] of this [Key].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.relative == Note.f.major
  /// Note.b.flat.major.relative == Note.g.minor
  /// ```
  Key get relative => Key(
    note.transposeBy(Interval.m3.descending(mode == TonalMode.major)),
    mode.parallel,
  );

  /// The [TonalMode.major] or [TonalMode.minor] parallel [Key] of this [Key].
  ///
  /// See [Parallel key](https://en.wikipedia.org/wiki/Parallel_key).
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.parallel == Note.d.major
  /// Note.b.flat.major.parallel == Note.b.flat.minor
  /// ```
  Key get parallel => Key(note, mode.parallel);

  /// The [KeySignature] of this [Key].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.signature == KeySignature.empty
  /// Note.a.major.signature == KeySignature.fromDistance(3)
  /// Note.g.flat.major.signature == KeySignature.fromDistance(-6)
  /// ```
  KeySignature get signature => KeySignature.fromDistance(
    KeySignature.empty.keys[mode]!.note.fifthsDistanceWith(note),
  );

  /// Whether this [Key] is theoretical, whose [signature] would have
  /// at least one [Accidental.doubleFlat] or [Accidental.doubleSharp].
  ///
  /// See [Theoretical key](https://en.wikipedia.org/wiki/Theoretical_key).
  ///
  /// Example:
  /// ```dart
  /// Note.e.major.isTheoretical == false
  /// Note.g.sharp.major.isTheoretical == true
  /// Note.f.flat.minor.isTheoretical == true
  /// ```
  bool get isTheoretical => signature.distance!.abs() > 7;

  /// The scale notes of this [Key].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale == const Scale([Note.c, Note.d, Note.e, Note.f, Note.g,
  ///   Note.a, Note.b, Note.c])
  ///
  /// Note.e.minor.scale == Scale([Note.e, Note.f.sharp, Note.g, Note.a, Note.b,
  ///   Note.d, Note.d, Note.e])
  /// ```
  Scale<Note> get scale => mode.scale.on(note);

  /// The string representation of this [Key] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// Note.c.minor.toString() == 'C minor'
  /// Note.e.flat.major.toString() == 'E♭ major'
  ///
  /// const romance = RomanceKeyNotation.symbol();
  /// Note.c.major.toString(formatter: romance) == 'Do maggiore'
  /// Note.f.sharp.minor.toString(formatter: romance) == 'Fa♯ minore'
  ///
  /// const german = GermanKeyNotation();
  /// Note.e.flat.major.toString(formatter: german) == 'Es-dur'
  /// Note.g.sharp.minor.toString(formatter: german) == 'gis-moll'
  /// ```
  @override
  String toString({
    Formatter<Key> formatter = const EnglishKeyNotation.symbol(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is Key && note == other.note && mode == other.mode;

  @override
  int get hashCode => Object.hash(note, mode);

  @override
  int compareTo(Key other) => compareMultiple([
    () => note.compareTo(other.note),
    () => mode.name.compareTo(other.mode.name),
  ]);
}

/// The English notation system for [Key].
final class EnglishKeyNotation extends NotationSystem<Key> {
  /// The [EnglishNoteNotation] used to format the [Key.note].
  final EnglishNoteNotation noteNotation;

  /// The [EnglishTonalModeNotation] used to format the [Key.mode].
  final EnglishTonalModeNotation tonalModeNotation;

  /// Creates a new [EnglishKeyNotation].
  const EnglishKeyNotation({
    this.noteNotation = const EnglishNoteNotation(),
    this.tonalModeNotation = const EnglishTonalModeNotation(),
  });

  /// Creates a new symbolic [EnglishKeyNotation].
  const EnglishKeyNotation.symbol({
    this.noteNotation = const EnglishNoteNotation.symbol(),
    this.tonalModeNotation = const EnglishTonalModeNotation(),
  });

  @override
  String format(Key key) {
    final note = key.note.toString(formatter: noteNotation);
    final mode = key.mode.toString(formatter: tonalModeNotation);

    return '$note $mode';
  }

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp.pattern}\\s+${tonalModeNotation.regExp.pattern}',
    caseSensitive: false,
  );

  @override
  Key parseMatch(RegExpMatch match) =>
      Key(noteNotation.parseMatch(match), tonalModeNotation.parseMatch(match));
}

/// The German notation system for [Key].
final class GermanKeyNotation extends NotationSystem<Key> {
  /// The [GermanNoteNotation] used to format the [Key.note].
  final GermanNoteNotation noteNotation;

  /// The [GermanTonalModeNotation] used to format the [Key.mode].
  final GermanTonalModeNotation tonalModeNotation;

  /// Creates a new [GermanKeyNotation].
  const GermanKeyNotation({
    this.noteNotation = const GermanNoteNotation(),
    this.tonalModeNotation = const GermanTonalModeNotation(),
  });

  @override
  String format(Key key) {
    final note = key.note.toString(formatter: noteNotation);
    final mode = key.mode.toString(formatter: tonalModeNotation).toLowerCase();
    final casedNote = switch (key.mode) {
      TonalMode.major => note,
      TonalMode.minor => note.toLowerCase(),
    };

    return '$casedNote-$mode';
  }

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp.pattern}-${tonalModeNotation.regExp.pattern}',
    caseSensitive: false,
  );

  @override
  Key parseMatch(RegExpMatch match) =>
      Key(noteNotation.parseMatch(match), tonalModeNotation.parseMatch(match));
}

/// The Romance notation system for [Key].
final class RomanceKeyNotation extends NotationSystem<Key> {
  /// The [RomanceNoteNotation] used to format the [Key.note].
  final RomanceNoteNotation noteNotation;

  /// The [RomanceTonalModeNotation] used to format the [Key.mode].
  final RomanceTonalModeNotation tonalModeNotation;

  /// Creates a new [RomanceKeyNotation].
  const RomanceKeyNotation({
    this.noteNotation = const RomanceNoteNotation(),
    this.tonalModeNotation = const RomanceTonalModeNotation(),
  });

  /// Creates a new symbolic [RomanceKeyNotation].
  const RomanceKeyNotation.symbol({
    this.noteNotation = const RomanceNoteNotation.symbol(),
    this.tonalModeNotation = const RomanceTonalModeNotation(),
  });

  @override
  String format(Key key) {
    final note = key.note.toString(formatter: noteNotation);
    final mode = key.mode.toString(formatter: tonalModeNotation);

    return '$note $mode';
  }

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp.pattern}\\s+${tonalModeNotation.regExp.pattern}',
    caseSensitive: false,
  );

  @override
  Key parseMatch(RegExpMatch match) =>
      Key(noteNotation.parseMatch(match), tonalModeNotation.parseMatch(match));
}
