import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../notation/notation_system.dart';
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
  String toString({
    StringFormatter<Accidental> formatter = const SymbolAccidentalNotation(),
  }) => formatter.format(this);

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

/// The symbol notation system for [Accidental].
///
/// If the [Accidental] represents a natural note (0 semitones), returns the
/// natural symbol (♮) if [showNatural] is true, an empty string otherwise.
///
/// For other accidentals, returns a combination of sharp (♯), flat (♭), or
/// double sharp or flat symbols (𝄪, 𝄫) depending on the number of semitones
/// above or below the natural note.
final class SymbolAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Whether a natural [Note] should be represented with the
  /// [Accidental.natural] symbol.
  final bool showNatural;

  /// Whether to use ASCII symbols instead of Unicode symbols.
  final bool _useAscii;

  /// Creates a new [SymbolAccidentalNotation].
  const SymbolAccidentalNotation({this.showNatural = true}) : _useAscii = false;

  /// Creates a new [SymbolAccidentalNotation] using ASCII characters.
  const SymbolAccidentalNotation.ascii({this.showNatural = true})
    : _useAscii = true;

  static const _doubleSharpSymbol = '𝄪';
  static const _doubleSharpSymbolAscii = 'x';
  static const _sharpSymbol = '♯';
  static const _sharpSymbolAscii = '#';
  static const _naturalSymbol = '♮';
  static const _naturalSymbolAscii = 'n';
  static const _flatSymbol = '♭';
  static const _flatSymbolAscii = 'b';
  static const _doubleFlatSymbol = '𝄫';

  /// The list of valid symbols for an [Accidental].
  static const symbols = [
    _doubleSharpSymbol,
    _doubleSharpSymbolAscii,
    _sharpSymbol,
    _sharpSymbolAscii,
    _naturalSymbol,
    _naturalSymbolAscii,
    _flatSymbol,
    _flatSymbolAscii,
    _doubleFlatSymbol,
  ];

  static final _regExp = RegExp(
    '(?<accidental>[${symbols.join()}]*)',
    unicode: true,
  );

  @override
  RegExp get regExp => _regExp;

  static int _semitonesFromSymbol(String symbol) => switch (symbol) {
    _doubleSharpSymbol || _doubleSharpSymbolAscii => 2,
    _sharpSymbol || _sharpSymbolAscii => 1,
    _flatSymbol || _flatSymbolAscii => -1,
    _doubleFlatSymbol => -2,
    _ /* _naturalSymbol || _naturalSymbolAscii || '' */ => 0,
  };

  @override
  Accidental parseMatch(RegExpMatch match) {
    final accidental = match.namedGroup('accidental') ?? '';
    // Safely split UTF-16 code units using `runes`.
    final semitones = accidental.runes.fold(
      0,
      (acc, rune) => acc + _semitonesFromSymbol(.fromCharCode(rune)),
    );

    return Accidental(semitones);
  }

  @override
  String format(Accidental accidental) {
    if (!showNatural && accidental.isNatural) return '';
    if (accidental.semitones == 0) {
      return _useAscii ? _naturalSymbolAscii : _naturalSymbol;
    }

    final accidentalSymbol = accidental.semitones.isNegative
        ? (_useAscii ? _flatSymbolAscii : _flatSymbol)
        : (_useAscii ? _sharpSymbolAscii : _sharpSymbol);
    final doubleAccidentalSymbol = accidental.semitones.isNegative
        ? (_useAscii ? _flatSymbolAscii * 2 : _doubleFlatSymbol)
        : (_useAscii ? _doubleSharpSymbolAscii : _doubleSharpSymbol);

    final absSemitones = accidental.semitones.abs();
    final singleAccidentals = accidentalSymbol * (absSemitones % 2);
    final doubleAccidentals = doubleAccidentalSymbol * (absSemitones ~/ 2);

    return singleAccidentals + doubleAccidentals;
  }
}

/// The English notation system for [Accidental].
final class EnglishAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Whether a natural [Note] should be represented with the
  /// [Accidental.natural] symbol.
  final bool showNatural;

  /// Creates a new [EnglishAccidentalNotation].
  const EnglishAccidentalNotation({this.showNatural = true});

  static const _natural = 'natural';
  static const _flat = 'flat';
  static const _sharp = 'sharp';
  static const _double = 'double';
  static const _triple = 'triple';
  static const _times = '×';

  static final _regExp = RegExp(
    '(?<accidental>(?:(?:$_double|$_triple)\\s*)?'
    '(?:$_flat|$_sharp)|$_natural)?',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  Accidental parseMatch(RegExpMatch match) {
    final accidental = match.namedGroup('accidental')?.toLowerCase();
    if (accidental == null || accidental == _natural) return .natural;

    final semitones = switch (accidental.split(' ').first) {
      _double => 2,
      _triple => 3,
      _ => 1,
    };

    return accidental.contains(_sharp)
        ? Accidental(semitones)
        : Accidental(-semitones);
  }

  @override
  String format(Accidental accidental) => switch (accidental.semitones) {
    3 => '$_triple $_sharp',
    2 => '$_double $_sharp',
    1 => _sharp,
    0 => showNatural ? _natural : '',
    -1 => _flat,
    -2 => '$_double $_flat',
    -3 => '$_triple $_flat',
    > 3 && final semitones => '$_times$semitones $_sharp',
    final semitones => '$_times${semitones.abs()} $_flat',
  };
}

/// The German notation system for [Accidental].
final class GermanAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Creates a new [GermanAccidentalNotation].
  const GermanAccidentalNotation();

  static const _flatShort = 's';
  static const _flat = 'es';
  static const _sharp = 'is';

  static final _regExp = RegExp(
    '(?<accidental>$_flatShort?(?:$_flat)*|(?:$_sharp)+)?',
  );

  @override
  RegExp get regExp => _regExp;

  @override
  Accidental parseMatch(RegExpMatch match) {
    final accidental = match.namedGroup('accidental');
    if (accidental == null) return .natural;

    final semitones = accidental.split(_flatShort).length - 1;

    return accidental.startsWith(_sharp)
        ? Accidental(semitones)
        : Accidental(-semitones);
  }

  @override
  String format(Accidental accidental) =>
      (accidental.isFlat ? _flat : _sharp) * accidental.semitones.abs();
}

/// The Romance notation system for [Accidental].
final class RomanceAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Whether a natural [Note] should be represented with the
  /// [Accidental.natural] symbol.
  final bool showNatural;

  /// Creates a new [RomanceAccidentalNotation].
  const RomanceAccidentalNotation({this.showNatural = true});

  static const _natural = 'naturale';
  static const _flat = 'bemolle';
  static const _sharp = 'diesis';
  static const _double = 'doppio';
  static const _triple = 'triplo';
  static const _times = '×';

  static final _regExp = RegExp(
    '(?<accidental>(?:(?:$_double|$_triple)\\s*)?'
    '(?:$_flat|$_sharp)|$_natural)?',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  Accidental parseMatch(RegExpMatch match) {
    final accidental = match.namedGroup('accidental')?.toLowerCase();
    if (accidental == null || accidental == _natural) return .natural;

    final semitones = switch (accidental.split(' ').first) {
      _double => 2,
      _triple => 3,
      _ => 1,
    };

    return accidental.contains(_sharp)
        ? Accidental(semitones)
        : Accidental(-semitones);
  }

  @override
  String format(Accidental accidental) => switch (accidental.semitones) {
    3 => '$_triple $_sharp',
    2 => '$_double $_sharp',
    1 => _sharp,
    0 => showNatural ? _natural : '',
    -1 => _flat,
    -2 => '$_double $_flat',
    -3 => '$_triple $_flat',
    > 3 && final semitones => '$_times$semitones $_sharp',
    final semitones => '$_times${semitones.abs()} $_flat',
  };
}
