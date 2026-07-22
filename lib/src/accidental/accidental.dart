import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../note/note.dart';
import 'english_accidental_notation.dart';
import 'german_accidental_notation.dart';
import 'romance_accidental_notation.dart';
import 'symbol_accidental_notation.dart';

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

  /// Creates a new [Accidental] from [semitones].
  const Accidental(this.semitones);

  /// A triple sharp (♯𝄪) [Accidental].
  static const tripleSharp = Accidental(3);

  /// A double sharp (𝄪) [Accidental].
  static const doubleSharp = Accidental(2);

  /// A sharp (♯) [Accidental].
  static const sharp = Accidental(1);

  /// A natural (♮) [Accidental].
  static const natural = Accidental(0);

  /// A flat (♭) [Accidental].
  static const flat = Accidental(-1);

  /// A double flat (𝄫) [Accidental].
  static const doubleFlat = Accidental(-2);

  /// A triple flat (♭𝄫) [Accidental].
  static const tripleFlat = Accidental(-3);

  /// The chain of [StringParser]s used to parse an [Accidental].
  static const parsers = [
    SymbolAccidentalNotation(),
    EnglishAccidentalNotation(),
    GermanAccidentalNotation(),
    RomanceAccidentalNotation(),
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

  /// Whether this [Accidental] is flat (♭, 𝄫, etc.).
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.isFlat == true
  /// Accidental.doubleFlat.isFlat == true
  /// Accidental.sharp.isFlat == false
  /// Accidental.natural.isFlat == false
  /// ```
  bool get isFlat => semitones.isNegative;

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

  /// The name of this [Accidental].
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp.name == 'Sharp'
  /// Accidental.doubleFlat.name == 'Double flat'
  /// Accidental.natural.name == 'Natural'
  /// ```
  String get name => switch (semitones) {
    3 => 'Triple sharp',
    2 => 'Double sharp',
    1 => 'Sharp',
    0 => 'Natural',
    -1 => 'Flat',
    -2 => 'Double flat',
    -3 => 'Triple flat',
    > 3 && final semitones => '×$semitones sharp',
    final semitones => '×${semitones.abs()} flat',
  };

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
      other is Accidental && semitones == other.semitones;

  /// Adds [semitones] to this [Accidental].
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp + 1 == .doubleSharp
  /// Accidental.flat + 2 == .sharp
  /// Accidental.doubleFlat + 1 == .flat
  /// ```
  Accidental operator +(int semitones) =>
      Accidental(this.semitones + semitones);

  /// Subtracts [semitones] from this [Accidental].
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
