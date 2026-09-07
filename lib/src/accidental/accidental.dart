import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../note/note.dart';
import '../note_name/note_name.dart';
import 'abc_accidental_notation.dart';
import 'english_accidental_notation.dart';
import 'german_accidental_notation.dart';
import 'romance_accidental_notation.dart';
import 'symbol_accidental_notation.dart';

/// A modifier that raises or lowers a [NoteName] by a whole number of
/// semitones, e.g. the sharp in F♯ or the flat in B♭.
///
/// [semitones] is unbounded in either direction, so double- and
/// triple-sharps/flats (𝄪, 𝄫) are ordinary [Accidental] values rather than
/// special cases, which is what lets [Note.respellByAccidental] chase an
/// arbitrarily remote spelling when the nearest one isn't available.
///
/// ---
/// See also:
/// * [Note].
@immutable
final class Accidental
    implements Comparable<Accidental>, Formattable<Accidental> {
  /// This alteration's size and direction in semitones: positive raises
  /// the pitch (sharp), negative lowers it (flat), and zero leaves it
  /// unaltered (natural).
  final int semitones;

  /// Creates a new [Accidental] that alters a note by [semitones].
  const Accidental(this.semitones);

  /// A triple-sharp (♯𝄪), raising the note by 3 semitones.
  static const tripleSharp = Accidental(3);

  /// A double-sharp (𝄪), raising the note by 2 semitones.
  static const doubleSharp = Accidental(2);

  /// A sharp (♯), raising the note by 1 semitone.
  static const sharp = Accidental(1);

  /// A natural (♮): no alteration.
  static const natural = Accidental(0);

  /// A flat (♭), lowering the note by 1 semitone.
  static const flat = Accidental(-1);

  /// A double-flat (𝄫), lowering the note by 2 semitones.
  static const doubleFlat = Accidental(-2);

  /// A triple-flat (♭𝄫), lowering the note by 3 semitones.
  static const tripleFlat = Accidental(-3);

  /// The chain of [StringParser]s tried in turn by [Accidental.parse]:
  /// Unicode symbols, their ASCII equivalents, then the English, German,
  /// Romance, and ABC textual notations.

  static const parsers = [
    SymbolAccidentalNotation(),
    SymbolAccidentalNotation.ascii(),
    EnglishAccidentalNotation(),
    GermanAccidentalNotation(),
    RomanceAccidentalNotation(),
    AbcAccidentalNotation(),
  ];

  /// Parses [source] as an [Accidental] and returns its value.
  ///
  /// If [source] does not contain a valid [Accidental], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Accidental.parse('♭') == .flat
  /// Accidental.parse('x') == .doubleSharp
  /// Accidental.parse('z') // throws a FormatException
  /// ```
  factory Accidental.parse(
    String source, {
    List<StringParser<Accidental>> chain = parsers,
  }) => chain.parse(source);

  /// Whether this [Accidental] lowers the pitch (flat, double-flat, and
  /// so on).
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.isFlat == true
  /// Accidental.doubleFlat.isFlat == true
  /// Accidental.sharp.isFlat == false
  /// Accidental.natural.isFlat == false
  /// ```
  // using < 0 instead of isNegative to avoid -0 being treated as negative
  bool get isFlat => semitones < 0;

  /// Whether this [Accidental] leaves the pitch unaltered.
  ///
  /// Example:
  /// ```dart
  /// Accidental.natural.isNatural == true
  /// Accidental.sharp.isNatural == false
  /// Accidental.flat.isNatural == false
  /// ```
  bool get isNatural => semitones == 0;

  /// Whether this [Accidental] raises the pitch (sharp, double-sharp, and
  /// so on).
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp.isSharp == true
  /// Accidental.doubleSharp.isSharp == true
  /// Accidental.flat.isSharp == false
  /// Accidental.natural.isSharp == false
  /// ```
  bool get isSharp => semitones > 0;

  /// This [Accidental] shifted by [semitones] more (or, if negative,
  /// fewer) semitones of alteration — a triple-flat plus 2 becomes a
  /// single flat, for instance.
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.incrementBy(2) == .tripleFlat
  /// Accidental.sharp.incrementBy(1) == .doubleSharp
  /// Accidental.sharp.incrementBy(-1) == .natural
  /// ```
  Accidental incrementBy(int semitones) =>
      Accidental(this.semitones.incrementBy(semitones));

  /// The string representation of this [Accidental], using [formatter]
  /// (Unicode symbols by default).
  @override
  String format([
    StringFormatter<Accidental> formatter = const SymbolAccidentalNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(semitones: $semitones)';

  @override
  bool operator ==(Object other) =>
      other is Accidental && semitones == other.semitones;

  /// This [Accidental] raised by [semitones] more.
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp + 1 == .doubleSharp
  /// Accidental.flat + 2 == .sharp
  /// Accidental.doubleFlat + 1 == .flat
  /// ```
  Accidental operator +(int semitones) =>
      Accidental(this.semitones + semitones);

  /// This [Accidental] lowered by [semitones].
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp - 1 == .natural
  /// Accidental.flat - 2 == .tripleFlat
  /// Accidental.doubleSharp - 1 == .sharp
  /// ```
  Accidental operator -(int semitones) =>
      Accidental(this.semitones - semitones);

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Accidental other) => semitones.compareTo(other.semitones);
}
