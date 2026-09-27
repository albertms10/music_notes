import '../notation_system/notation_system.dart';
import 'accidental.dart';

/// The ABC notation system for [Accidental].
///
/// If the [Accidental] represents a natural note (0 semitones), returns the
/// natural symbol (=) if [showNatural] is true, an empty string otherwise.
///
/// For other accidentals, returns a combination of sharp (^) or flat (_)
/// depending on the number of semitones above or below the natural note.
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

  /// The list of valid symbols for an [Accidental].
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
