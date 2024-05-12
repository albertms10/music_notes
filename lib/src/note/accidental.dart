import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

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

  static const _doubleSharpSymbol = '𝄪';
  static const _doubleSharpSymbolAscii = 'x';
  static const _sharpSymbol = '♯';
  static const _sharpSymbolAscii = '#';
  static const _naturalSymbol = '♮';
  static const _naturalSymbolAscii = '';
  static const _flatSymbol = '♭';
  static const _flatSymbolAscii = 'b';
  static const _doubleFlatSymbol = '𝄫';

  static const _symbols = (
    doubleSharp: _doubleSharpSymbol,
    sharp: _sharpSymbol,
    natural: _naturalSymbol,
    flat: _flatSymbol,
    doubleFlat: _doubleFlatSymbol,
  );

  static const _asciiSymbols = (
    doubleSharp: _doubleSharpSymbolAscii,
    sharp: _sharpSymbolAscii,
    natural: _naturalSymbolAscii,
    flat: _flatSymbolAscii,
    doubleFlat: '$_flatSymbolAscii$_flatSymbolAscii',
  );

  /// The list of all valid symbols for an [Accidental].
  static const symbols = [
    _doubleSharpSymbol,
    _doubleSharpSymbolAscii,
    _sharpSymbol,
    _sharpSymbolAscii,
    _naturalSymbol,
    _flatSymbol,
    _flatSymbolAscii,
    _doubleFlatSymbol,
  ];

  static int? _semitonesFromSymbol(String symbol) => switch (symbol) {
        _doubleSharpSymbol || _doubleSharpSymbolAscii => 2,
        _sharpSymbol || _sharpSymbolAscii => 1,
        _naturalSymbol || _naturalSymbolAscii => 0,
        _flatSymbol || _flatSymbolAscii => -1,
        _doubleFlatSymbol => -2,
        _ => null,
      };

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
  factory Accidental.parse(String source) {
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

  /// The symbol of this [Accidental].
  ///
  /// If the [Accidental] represents a natural note (0 semitones), returns the
  /// natural symbol (♮).
  ///
  /// For other accidentals, returns a combination of sharp (♯), flat (♭), or
  /// double sharp or flat symbols (𝄪, 𝄫) depending on the number of semitones
  /// above or below the natural note.
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.symbol == '♭'
  /// Accidental.natural.symbol == '♮'
  /// Accidental.doubleFlat.symbol == '𝄫'
  /// Accidental.tripleSharp.symbol == '♯𝄪'
  /// ```
  String get symbol => _symbol();

  /// The ASCII symbol of this [Accidental].
  ///
  /// If the [Accidental] represents a natural note (0 semitones), returns an
  /// empty string.
  ///
  /// For other accidentals, returns a combination of sharp (#), flat (b), or
  /// double sharp or flat symbols (x, bb) depending on the number of semitones
  /// above or below the natural note.
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.asciiSymbol == 'b'
  /// Accidental.natural.asciiSymbol == ''
  /// Accidental.doubleFlat.asciiSymbol == 'bb'
  /// Accidental.tripleSharp.asciiSymbol == '#x'
  /// ```
  String get asciiSymbol => _symbol(useAscii: true);

  String _symbol({bool useAscii = false}) {
    final symbols = useAscii ? Accidental._asciiSymbols : Accidental._symbols;
    if (semitones == 0) return _naturalSymbol;

    final accidentalSymbol =
        semitones.isNegative ? symbols.flat : symbols.sharp;
    final doubleAccidentalSymbol =
        semitones.isNegative ? symbols.doubleFlat : symbols.doubleSharp;

    final absSemitones = semitones.abs();
    final singleAccidentals = accidentalSymbol * (absSemitones % 2);
    final doubleAccidentals = doubleAccidentalSymbol * (absSemitones ~/ 2);

    return singleAccidentals + doubleAccidentals;
  }

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

  /// The string representation of this [Accidental] based on [system].
  ///
  /// See [NoteNotation] for all system implementations.
  @override
  String toString({
    NoteNotation system = const EnglishNoteNotation(showNatural: true),
  }) =>
      system.accidental(this);

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
