import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../notation_system.dart';
import 'note.dart';

/// An accidental.
///
/// ---
/// See also:
/// * [Note].
@immutable
final class Accidental implements Comparable<Accidental> {
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

  /// Parse [source] as an [Accidental] and return its value.
  ///
  /// If the [source] string does not contain a valid [Accidental], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Accidental.parse('♭') == Accidental.flat
  /// Accidental.parse('x') == Accidental.doubleSharp
  /// Accidental.parse('z') // throws a FormatException
  /// ```
  factory Accidental.parse(
    String source, {
    List<Parser<Accidental>> chain = const [
      SymbolAccidentalNotation(),
      GermanAccidentalNotation(),
    ],
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
    > 3 => '×$semitones sharp',
    3 => 'Triple sharp',
    2 => 'Double sharp',
    1 => 'Sharp',
    0 => 'Natural',
    -1 => 'Flat',
    -2 => 'Double flat',
    -3 => 'Triple flat',
    _ => '×${semitones.abs()} flat',
  };

  /// This [Accidental] incremented by [semitones].
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.incrementBy(2) == Accidental.tripleFlat
  /// Accidental.sharp.incrementBy(1) == Accidental.doubleSharp
  /// Accidental.sharp.incrementBy(-1) == Accidental.natural
  /// ```
  Accidental incrementBy(int semitones) =>
      Accidental(this.semitones.incrementBy(semitones));

  /// The string representation of this [Accidental] based on [formatter].
  @override
  String toString({
    Formatter<Accidental> formatter = const SymbolAccidentalNotation(),
  }) => formatter.format(this);

  @override
  bool operator ==(Object other) =>
      other is Accidental && semitones == other.semitones;

  /// Adds [semitones] to this [Accidental].
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp + 1 == Accidental.doubleSharp
  /// Accidental.flat + 2 == Accidental.sharp
  /// Accidental.doubleFlat + 1 == Accidental.flat
  /// ```
  Accidental operator +(int semitones) =>
      Accidental(this.semitones + semitones);

  /// Subtracts [semitones] from this [Accidental].
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp - 1 == Accidental.natural
  /// Accidental.flat - 2 == Accidental.tripleFlat
  /// Accidental.doubleSharp - 1 == Accidental.sharp
  /// ```
  Accidental operator -(int semitones) =>
      Accidental(this.semitones - semitones);

  @override
  int get hashCode => semitones.hashCode;

  @override
  int compareTo(Accidental other) => semitones.compareTo(other.semitones);
}

/// The symbol notation system for [Accidental].
///
/// If the [Accidental] represents a natural note (0 semitones), returns the
/// natural symbol (♮) if [showNatural] is true, an empty string otherwise.
///
/// For other accidentals, returns a combination of sharp (♯), flat (♭), or
/// double sharp or flat symbols (𝄪, 𝄫) depending on the number of semitones
/// above or below the natural note.
final class SymbolAccidentalNotation extends NotationSystem<Accidental> {
  /// Whether a natural [Note] should be represented with the
  /// [Accidental.natural] symbol.
  final bool showNatural;

  /// Creates a new [SymbolAccidentalNotation].
  const SymbolAccidentalNotation({this.showNatural = true});

  static const _doubleSharpSymbol = '𝄪';
  static const _doubleSharpSymbolAlt = 'x';
  static const _sharpSymbol = '♯';
  static const _sharpSymbolAlt = '#';
  static const _naturalSymbol = '♮';
  static const _flatSymbol = '♭';
  static const _flatSymbolAlt = 'b';
  static const _doubleFlatSymbol = '𝄫';

  /// The list of valid symbols for an [Accidental].
  static const symbols = [
    _doubleSharpSymbol,
    _doubleSharpSymbolAlt,
    _sharpSymbol,
    _sharpSymbolAlt,
    _naturalSymbol,
    _flatSymbol,
    _flatSymbolAlt,
    _doubleFlatSymbol,
  ];

  static final _regExp = RegExp('^(?:${symbols.join('|')})*\$');

  @override
  bool matches(String source) => _regExp.hasMatch(source);

  @override
  String format(Accidental accidental) {
    if (!showNatural && accidental.isNatural) return '';
    if (accidental.semitones == 0) return _naturalSymbol;

    final accidentalSymbol = accidental.semitones.isNegative
        ? _flatSymbol
        : _sharpSymbol;
    final doubleAccidentalSymbol = accidental.semitones.isNegative
        ? _doubleFlatSymbol
        : _doubleSharpSymbol;

    final absSemitones = accidental.semitones.abs();
    final singleAccidentals = accidentalSymbol * (absSemitones % 2);
    final doubleAccidentals = doubleAccidentalSymbol * (absSemitones ~/ 2);

    return singleAccidentals + doubleAccidentals;
  }

  static int? _semitonesFromSymbol(String symbol) => switch (symbol) {
    _doubleSharpSymbol || _doubleSharpSymbolAlt => 2,
    _sharpSymbol || _sharpSymbolAlt => 1,
    _naturalSymbol || '' => 0,
    _flatSymbol || _flatSymbolAlt => -1,
    _doubleFlatSymbol => -2,
    _ => null,
  };

  @override
  Accidental parse(String source) {
    // Safely split UTF-16 code units using `runes`.
    final semitones = source.runes.fold(0, (acc, rune) {
      final symbolSemitones = _semitonesFromSymbol(String.fromCharCode(rune));
      if (symbolSemitones == null) {
        throw FormatException('Invalid Accidental', source);
      }

      return acc + symbolSemitones;
    });

    return Accidental(semitones);
  }
}

/// The German notation system for [Accidental].
final class GermanAccidentalNotation extends NotationSystem<Accidental> {
  /// Creates a new [GermanAccidentalNotation].
  const GermanAccidentalNotation();

  static const _flat = 'es';
  static const _sharp = 'is';

  static final _regExp = RegExp('^(?:($_flat)*|($_sharp))*\$');

  @override
  bool matches(String source) => _regExp.hasMatch(source);

  @override
  String format(Accidental accidental) =>
      (accidental.isFlat ? _flat : _sharp) * accidental.semitones.abs();

  @override
  Accidental parse(String source) {
    if (source.isEmpty) return Accidental.natural;

    final flatCount = source.split(_flat).length - 1;
    final sharpCount = source.split(_sharp).length - 1;

    if (flatCount > 0 && sharpCount > 0) {
      throw FormatException(
        'Invalid Accidental: cannot mix flats and sharps',
        source,
      );
    }
    if (flatCount > 0) return Accidental(-flatCount);
    if (sharpCount > 0) return Accidental(sharpCount);

    throw FormatException('Invalid Accidental', source);
  }
}
