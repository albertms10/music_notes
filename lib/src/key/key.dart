import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../accidental/accidental.dart';
import '../key_signature/key_signature.dart';
import '../mode/mode.dart';
import '../notation_system/notation_system.dart';
import '../note/note.dart';
import '../scale/scale.dart';
import 'english_key_notation.dart';
import 'german_key_notation.dart';
import 'romance_key_notation.dart';

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
final class Key implements Comparable<Key>, Formattable<Key> {
  /// The tonal center representing this [Key].
  final Note note;

  /// The mode representing this [Key].
  final TonalMode mode;

  /// Creates a new [Key] from [note] and [mode].
  const Key(this.note, this.mode);

  /// The chain of [StringParser]s used to parse a [Key].
  static const parsers = [
    EnglishKeyNotation(),
    EnglishKeyNotation.symbol(),
    GermanKeyNotation(),
    RomanceKeyNotation(),
    RomanceKeyNotation.symbol(),
  ];

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
  factory Key.parse(String source, {List<StringParser<Key>> chain = parsers}) =>
      chain.parse(source);

  /// The [TonalMode.major] or [TonalMode.minor] relative [Key] of this [Key].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.relative == Note.f.major
  /// Note.b.flat.major.relative == Note.g.minor
  /// ```
  Key get relative =>
      Key(note.transposeBy(.m3.withDescending(mode == .major)), mode.parallel);

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
  /// Note.c.major.signature == .empty
  /// Note.a.major.signature == .fromDistance(3)
  /// Note.g.flat.major.signature == .fromDistance(-6)
  /// ```
  KeySignature get signature => .fromDistance(
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
  /// Note.c.major.scale == const Scale<Note>([.c, .d, .e, .f, .g, .a, .b, .c])
  /// Note.e.minor.scale == Scale<Note>([.e, .f.sharp, .g, .a, .b, .d, .d, .e])
  /// ```
  Scale<Note> get scale => mode.scale.on(note);

  /// The string representation of this [Key] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// Note.c.minor.format() == 'C minor'
  /// Note.e.flat.major.format() == 'E♭ major'
  ///
  /// const romance = RomanceKeyNotation.symbol();
  /// Note.c.major.format(romance) == 'Do maggiore'
  /// Note.f.sharp.minor.format(romance) == 'Fa♯ minore'
  ///
  /// const german = GermanKeyNotation();
  /// Note.e.flat.major.format(german) == 'Es-Dur'
  /// Note.g.sharp.minor.format(german) == 'gis-Moll'
  /// ```
  @override
  String format([
    StringFormatter<Key> formatter = const EnglishKeyNotation.symbol(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(note: $note, mode: $mode)';

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
