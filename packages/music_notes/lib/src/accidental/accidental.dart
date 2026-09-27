import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/music_notes.dart';
import 'package:music_notes/utils.dart';

import 'abc_accidental_notation.dart';

/// An accidental.
///
/// ---
/// See also:
/// * [Note].
@immutable
final class Accidental
    implements Comparable<Accidental>, Formattable<Accidental> {
  /// The number of semitones above or below the natural note.
  ///
  /// - `> 0` for sharps.
  /// - `== 0` for natural.
  /// - `< 0` for flats.
  final int semitones;

  /// The total octave divisions.
  final int divisions;

  /// Creates a new [Accidental] from [semitones].
  const Accidental(this.semitones, [this.divisions = chromaticDivisions]);

  /// A triple-sharp (♯𝄪) [Accidental].
  static const tripleSharp = Accidental(3);

  /// A double-sharp (𝄪) [Accidental].
  static const doubleSharp = Accidental(2);

  /// A sharp (♯) [Accidental].
  static const sharp = Accidental(1);

  /// A natural (♮) [Accidental].
  static const natural = Accidental(0);

  /// A flat (♭) [Accidental].
  static const flat = Accidental(-1);

  /// A double-flat (𝄫) [Accidental].
  static const doubleFlat = Accidental(-2);

  /// A triple-flat (♭𝄫) [Accidental].
  static const tripleFlat = Accidental(-3);

  /// The chain of [StringParser]s used to parse an [Accidental].
  static const parsers = [
    SymbolAccidentalNotation(),
    SymbolAccidentalNotation.ascii(),
    EnglishAccidentalNotation(),
    GermanAccidentalNotation(),
    RomanceAccidentalNotation(),
    AbcAccidentalNotation(),
  ];

  /// Parse [source] as an [Accidental] and return its value.
  ///
  /// If the [source] string does not contain a valid [Accidental], a
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

  /// The semitones taking [divisions] into account
  Rational get rationalSemitones =>
      Rational(semitones * chromaticDivisions, divisions);

  /// Whether this [Accidental] is flat (♭, 𝄫, etc.).
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

  /// Whether this [Accidental] is natural (♮).
  ///
  /// Example:
  /// ```dart
  /// Accidental.natural.isNatural == true
  /// Accidental.sharp.isNatural == false
  /// Accidental.flat.isNatural == false
  /// ```
  bool get isNatural => semitones == 0;

  /// Whether this [Accidental] is sharp (♯, 𝄪, etc.).
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp.isSharp == true
  /// Accidental.doubleSharp.isSharp == true
  /// Accidental.flat.isSharp == false
  /// Accidental.natural.isSharp == false
  /// ```
  bool get isSharp => semitones > 0;

  /// This [Accidental] incremented by [semitones].
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.incrementBy(2) == .tripleFlat
  /// Accidental.sharp.incrementBy(1) == .doubleSharp
  /// Accidental.sharp.incrementBy(-1) == .natural
  /// ```
  Accidental incrementBy(int semitones) =>
      Accidental(this.semitones.incrementBy(semitones));

  /// The string representation of this [Accidental] based on [formatter].
  @override
  String format([
    StringFormatter<Accidental> formatter = const SymbolAccidentalNotation(),
  ]) => formatter.format(this);

  @override
  String toString() => '$runtimeType(semitones: $semitones)';

  @override
  bool operator ==(Object other) =>
      other is Accidental && rationalSemitones == other.rationalSemitones;

  /// Adds [semitones] to this [Accidental].
  ///
  /// It performs an exact int arithmetic via LCM: no reduction, divisions are
  /// preserved at the finer of the two.
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp + 1 == .doubleSharp
  /// Accidental.flat + 2 == .sharp
  /// Accidental.doubleFlat + 1 == .flat
  /// ```
  Accidental operator +(Accidental other) {
    final common =
        divisions * other.divisions ~/ divisions.gcd(other.divisions);

    return Accidental(
      semitones * (common ~/ divisions) +
          other.semitones * (common ~/ other.divisions),
      common,
    );
  }

  /// Subtracts [semitones] from this [Accidental].
  ///
  /// It performs an exact int arithmetic via LCM: no reduction, divisions are
  /// preserved at the finer of the two.
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp - 1 == .natural
  /// Accidental.flat - 2 == .tripleFlat
  /// Accidental.doubleSharp - 1 == .sharp
  /// ```
  Accidental operator -(Accidental other) {
    final common =
        divisions * other.divisions ~/ divisions.gcd(other.divisions);

    return Accidental(
      semitones * (common ~/ divisions) -
          other.semitones * (common ~/ other.divisions),
      common,
    );
  }

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Accidental other) => semitones.compareTo(other.semitones);
}
