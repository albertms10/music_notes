import '../notation_system/notation_system.dart';
import 'accidental.dart';

/// The [ABC notation](https://abcnotation.com/wiki/abc:standard:v2.1)
/// for [Accidental]: `^` (sharp) and `_` (flat) prefixed directly onto a
/// note letter, doubled for a double alteration (`^^`, `__`); there is no
/// dedicated triple-accidental symbol, so those repeat the base symbol a
/// third time.
final class AbcAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Whether to emit an explicit `=` for natural pitches.
  ///
  /// ABC scores normally infer naturals from the prevailing key signature,
  /// so a standalone natural pitch is written with no accidental at all.
  /// Set this to `true` when you need the symbol to be unambiguous outside
  /// of that context, e.g., cancelling an accidental from earlier in the
  /// same bar.
  final bool showNatural;

  /// Creates a new [AbcAccidentalNotation].
  const AbcAccidentalNotation({this.showNatural = true});

  static const _flatSymbol = '_';
  static const _naturalSymbol = '=';
  static const _sharpSymbol = '^';

  /// Every symbol this notation can parse or emit: flat, natural, and
  /// sharp.
  static const symbols = [_flatSymbol, _naturalSymbol, _sharpSymbol];

  static final _regExp = RegExp('(?<accidental>[${symbols.join()}]*)');

  @override
  RegExp get regExp => _regExp;

  static int _semitonesFromSymbol(String symbol) => switch (symbol) {
    _sharpSymbol => 1,
    _flatSymbol => -1,
    _ /* _naturalSymbol || '' */ => 0,
  };

  @override
  Accidental parseMatch(RegExpMatch match) => Accidental(
    (match.namedGroup('accidental') ?? '')
        .split('')
        .fold(0, (acc, character) => acc + _semitonesFromSymbol(character)),
  );

  @override
  String format(Accidental accidental) => accidental.isNatural
      ? showNatural
            ? _naturalSymbol
            : ''
      : (accidental.isFlat ? _flatSymbol : _sharpSymbol) *
            accidental.semitones.abs();
}
