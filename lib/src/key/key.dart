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
    EnglishKeyNotation.symbol(showMode: false),
    EnglishKeyNotation.ascii(),
    GermanKeyNotation(),
    GermanKeyNotation(showMode: false),
    RomanceKeyNotation(),
    RomanceKeyNotation.symbol(),
    RomanceKeyNotation.symbol(showMode: false),
    RomanceKeyNotation.ascii(),
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

  /// The [KeyRelationship] between this [Key] and [other].
  ///
  /// The relationship is derived from two independent vectors:
  ///
  ///  * the fifths-distance between [note] and `other.note` (sharpward
  ///    when positive, flatward when negative), from
  ///    [NoteCircleOfFifths.fifthsDistanceWith];
  ///  * the change in [Mode.brightness] between [mode] and `other.mode`
  ///    (brightening when positive, darkening when negative, zero when
  ///    the mode does not change).
  ///
  /// When the mode is unchanged, the relationship is always
  /// [KeyRelationship.direct]. Otherwise, the two vectors either cancel
  /// each other out (one sharpward/flatward push offset by an opposing
  /// brightening/darkening pull) yielding [KeyRelationship.indirect],
  /// or reinforce each other, yielding [KeyRelationship.doubleDirect].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.relationshipWith(Note.g.major)
  ///   == (distance: 1, relationship: .direct)
  /// Note.c.major.relationshipWith(Note.e.minor)
  ///   == (distance: 4, relationship: .indirect)
  /// Note.c.minor.relationshipWith(Note.f.major)
  ///   == (distance: -1, relationship: .indirect)
  /// Note.c.minor.relationshipWith(Note.e.major)
  ///   == (distance: 4, relationship: .doubleDirect)
  /// Note.c.major.relationshipWith(Note.f.minor)
  ///   == (distance: -1, relationship: .doubleDirect)
  /// ```
  ({int distance, KeyRelationship relationship}) relationshipWith(Key other) {
    final distance = note.fifthsDistanceWith(other.note);

    return (
      distance: distance,
      relationship: mode == other.mode
          ? .direct
          : distance.sign * mode.distanceWith(other.mode).sign > 0
          ? .doubleDirect
          : .indirect,
    );
  }

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

/// The relationship between two tonal centers (keys), classified by how
/// much tonal tension separates them.
///
/// ## Measuring distance
///
/// Distance is counted in fifths from the tonal center, a.k.a. the number of
/// steps along the circle of fifths between one tonic and another,
/// independently of key signature. D major, D dorian, and D minor sit at
/// the same distance from C, 2 fifths, despite their different key
/// signatures: what the ear actually tracks is the fundamental, not the
/// accidentals on the page. This is also why a minor key feels closer to
/// its parallel major (same tonic) than to its relative major (same key
/// signature): C minor leans toward C major far more than toward its
/// relative, E-flat major.
///
/// ## Two independent vectors
///
/// Moving from one key to another involves two separate motions, each
/// with its own direction:
///
///  * **fifth-motion:** sharpward (up the circle of fifths) or flatward
///    (down it);
///  * **mode-change:** brightening (minor → major) or darkening
///    (major → minor), or no change at all.
///
/// Tension builds along both axes independently, and how they combine
/// determines the [KeyRelationship]:
///
///  * if the mode doesn’t change, only fifth-distance matters: [direct];
///  * if the mode changes, its direction can either work *against* the
///    fifth-motion, damping the net tension ([indirect]), or work *with*
///    it, compounding the tension ([doubleDirect]).
enum KeyRelationship {
  /// The two vectors oppose each other: fifth-motion in one direction is
  /// paired with a mode-change pulling the other way, so part of the
  /// tension cancels out.
  ///
  /// This covers sharpward motion darkened by a major-to-minor shift, or
  /// flatward motion brightened by a minor-to-major shift. The resulting
  /// key still shares enough diatonic content with the reference to lean
  /// back toward it.
  ///
  /// Example: C major → E minor moves 4 fifths sharpward, but darkens
  /// from major to minor. E minor’s natural G, among other shared
  /// notes, keeps it tied to C major, so the relationship reads as
  /// indirect rather than as remote as 4 fifths alone would suggest.
  ///
  /// Example: C minor → F major moves 1 fifth flatward while
  /// brightening from minor to major: likewise indirect!
  indirect,

  /// The mode is preserved (major to major, or minor to minor), so
  /// there is no second vector to interact with the first. Tension is
  /// felt directly, in straightforward proportion to the fifth-distance
  /// between the two tonics.
  direct,

  /// The two vectors reinforce each other: fifth-motion in one direction
  /// is paired with a mode-change pulling the *same* way, so the
  /// tensions compound rather than cancel.
  ///
  /// This covers sharpward motion brightened by a minor-to-major shift,
  /// or flatward motion darkened by a major-to-minor shift: moving
  /// much further from the reference tonal center than an [indirect]
  /// relationship at the same fifth-distance.
  ///
  /// Example: C minor → E major moves 4 fifths sharpward while also
  /// brightening from minor to major: doubly reinforced, hence double
  /// direct.
  ///
  /// Example: C major → F minor moves 1 fifth flatward while also
  /// darkening from major to minor: likewise double direct!
  doubleDirect,
}
