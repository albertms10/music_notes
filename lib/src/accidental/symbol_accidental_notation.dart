import '../notation_system/notation_system.dart';
import '../note/note.dart';
import 'accidental.dart';

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

  /// Whether to place larger accidentals (double sharps/flats) before smaller
  /// ones.
  final bool largerFirst;

  /// Whether to use ASCII symbols instead of Unicode symbols.
  final bool _useAscii;

  /// Creates a new [SymbolAccidentalNotation].
  const SymbolAccidentalNotation({
    this.showNatural = true,
    this.largerFirst = false,
  }) : _useAscii = false;

  /// Creates a new [SymbolAccidentalNotation] using ASCII characters.
  const SymbolAccidentalNotation.ascii({
    this.showNatural = true,
    this.largerFirst = false,
  }) : _useAscii = true;

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
    if (accidental.isNatural) {
      if (!showNatural) return '';
      return _useAscii ? _naturalSymbolAscii : _naturalSymbol;
    }

    final accidentalSymbol = accidental.semitones.isNegative
        ? (_useAscii ? _flatSymbolAscii : _flatSymbol)
        : (_useAscii ? _sharpSymbolAscii : _sharpSymbol);
    final doubleAccidentalSymbol = accidental.semitones.isNegative
        ? (_useAscii ? _flatSymbolAscii * 2 : _doubleFlatSymbol)
        : (_useAscii ? _doubleSharpSymbolAscii : _doubleSharpSymbol);

    final absSemitones = accidental.semitones.abs();
    final fragments = [
      accidentalSymbol * (absSemitones % 2),
      doubleAccidentalSymbol * (absSemitones ~/ 2),
    ];

    return largerFirst ? fragments.reversed.join() : fragments.join();
  }
}
