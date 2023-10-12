part of '../../music_notes.dart';

/// An accidental.
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

  /// A triple sharp [Accidental].
  static const Accidental tripleSharp = Accidental(3);

  /// A double sharp [Accidental].
  static const Accidental doubleSharp = Accidental(2);

  /// A sharp [Accidental].
  static const Accidental sharp = Accidental(1);

  /// A natural [Accidental].
  static const Accidental natural = Accidental(0);

  /// A flat [Accidental].
  static const Accidental flat = Accidental(-1);

  /// A double flat [Accidental].
  static const Accidental doubleFlat = Accidental(-2);

  /// A triple flat [Accidental].
  static const Accidental tripleFlat = Accidental(-3);

  static const String _doubleSharpSymbol = '𝄪';
  static const String _doubleSharpSymbolAlt = 'x';
  static const String _sharpSymbol = '♯';
  static const String _sharpSymbolAlt = '#';
  static const String _naturalSymbol = '♮';
  static const String _flatSymbol = '♭';
  static const String _flatSymbolAlt = 'b';
  static const String _doubleFlatSymbol = '𝄫';

  static const List<String> _symbols = [
    _doubleSharpSymbol,
    _doubleSharpSymbolAlt,
    _sharpSymbol,
    _sharpSymbolAlt,
    _naturalSymbol,
    _flatSymbol,
    _flatSymbolAlt,
    _doubleFlatSymbol,
  ];

  static int? _semitonesFromSymbol(String symbol) => switch (symbol) {
        _doubleSharpSymbol || _doubleSharpSymbolAlt => 2,
        _sharpSymbol || _sharpSymbolAlt => 1,
        _naturalSymbol || '' => 0,
        _flatSymbol || _flatSymbolAlt => -1,
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

  /// The name of this [Accidental].
  ///
  /// Example:
  /// ```dart
  /// Accidental.sharp.name == 'Sharp'
  /// Accidental.doubleFlat.name == 'Double flat'
  /// Accidental.natural.name == 'Natural'
  /// ```
  String? get name => switch (semitones) {
        3 => 'Triple sharp',
        2 => 'Double sharp',
        1 => 'Sharp',
        0 => 'Natural',
        -1 => 'Flat',
        -2 => 'Double flat',
        -3 => 'Triple flat',
        _ => null,
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
  String get symbol {
    if (semitones == 0) return _naturalSymbol;

    final accidentalSymbol = semitones.isNegative ? _flatSymbol : _sharpSymbol;
    final doubleAccidentalSymbol =
        semitones.isNegative ? _doubleFlatSymbol : _doubleSharpSymbol;

    final absSemitones = semitones.abs();
    final singleAccidentals = accidentalSymbol * (absSemitones % 2);
    final doubleAccidentals = doubleAccidentalSymbol * (absSemitones ~/ 2);

    return singleAccidentals + doubleAccidentals;
  }

  /// Returns this [Accidental] incremented by [semitones].
  ///
  /// Example:
  /// ```dart
  /// Accidental.flat.incrementBy(2) == Accidental.tripleFlat
  /// Accidental.sharp.incrementBy(1) == Accidental.doubleSharp
  /// Accidental.sharp.incrementBy(-1) == Accidental.natural
  /// ```
  Accidental incrementBy(int semitones) =>
      Accidental(this.semitones.incrementBy(semitones));

  @override
  String toString() => [
        if (name != null) name,
        symbol,
        '(${semitones.toDeltaString()})',
      ].join(' ');

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
