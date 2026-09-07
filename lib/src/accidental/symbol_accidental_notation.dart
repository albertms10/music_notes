import '../notation_system/notation_system.dart';
import '../note/note.dart';
import 'accidental.dart';

/// The engraved-symbol notation for [Accidental]: ♯, ♭, 𝄪, 𝄫, and ♮, the
/// glyphs that appear directly on a printed staff.
///
/// Compound accidentals decompose greedily into the largest symbols
/// first (so 3 semitones sharp is 𝄪♯, a double- plus a single sharp,
/// never ♯♯♯); [largerFirst] only controls which symbol is written
/// first, not which symbols are chosen. A natural note formats as an
/// empty string unless [showNatural] is set, matching how naturals are
/// normally silent outside of cautionary or cancellation contexts.
final class SymbolAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Whether a natural [Note] should be spelled out with the
  /// [Accidental.natural] symbol (♮) rather than nothing.
  final bool showNatural;

  /// Whether a compound accidental writes its larger symbol (𝄪 or 𝄫)
  /// before its smaller one, e.g. `𝄪♯` instead of `♯𝄪` for a triple sharp.
  final bool largerFirst;

  /// Whether to render with the ASCII stand-ins `x`, `#`, `n`, `b` instead
  /// of the Unicode glyphs 𝄪, ♯, ♮, ♭, 𝄫.
  final bool useAscii;

  /// Creates a new [SymbolAccidentalNotation].
  const SymbolAccidentalNotation({
    this.showNatural = true,
    this.largerFirst = false,
    this.useAscii = false,
  });

  /// Creates a new [SymbolAccidentalNotation] that renders with ASCII
  /// stand-ins (`x`, `#`, `n`, `b`) instead of Unicode glyphs.
  const SymbolAccidentalNotation.ascii({
    this.showNatural = true,
    this.largerFirst = false,
  }) : useAscii = true;

  static const _doubleSharpSymbol = '𝄪';
  static const _doubleSharpSymbolAscii = 'x';
  static const _sharpSymbol = '♯';
  static const _sharpSymbolAscii = '#';
  static const _naturalSymbol = '♮';
  static const _naturalSymbolAscii = 'n';
  static const _flatSymbol = '♭';
  static const _flatSymbolAscii = 'b';
  static const _doubleFlatSymbol = '𝄫';

  /// Every Unicode symbol this notation can parse or emit, ordered from
  /// most sharp to most flat.
  static const symbols = [
    _doubleSharpSymbol,
    _sharpSymbol,
    _naturalSymbol,
    _flatSymbol,
    _doubleFlatSymbol,
  ];

  /// Every ASCII stand-in symbol this notation can parse or emit
  /// (`useAscii: true`), ordered from most sharp to most flat.
  static const asciiSymbols = [
    _doubleSharpSymbolAscii,
    _sharpSymbolAscii,
    _naturalSymbolAscii,
    _flatSymbolAscii,
  ];

  @override
  RegExp get regExp => RegExp(
    '(?<accidental>[${(useAscii ? asciiSymbols : symbols).join()}]*)',
    unicode: true,
  );

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
      return useAscii ? _naturalSymbolAscii : _naturalSymbol;
    }

    final accidentalSymbol = accidental.isFlat
        ? (useAscii ? _flatSymbolAscii : _flatSymbol)
        : (useAscii ? _sharpSymbolAscii : _sharpSymbol);
    final doubleAccidentalSymbol = accidental.isFlat
        ? (useAscii ? _flatSymbolAscii * 2 : _doubleFlatSymbol)
        : (useAscii ? _doubleSharpSymbolAscii : _doubleSharpSymbol);

    final absSemitones = accidental.semitones.abs();
    final fragments = [
      accidentalSymbol * (absSemitones % 2),
      doubleAccidentalSymbol * (absSemitones ~/ 2),
    ];

    return largerFirst ? fragments.reversed.join() : fragments.join();
  }
}
