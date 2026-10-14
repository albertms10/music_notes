import '../notation_system/notation_system.dart';
import 'octave.dart';

/// The Helmholtz pitch notation system for [Octave], expressed as the marks
/// (primes/commas, or their numbered equivalent) that follow a Helmholtz
/// note letter.
///
/// Every non-empty run of marks is self-describing regardless of the
/// letter's case: a prime always counts up from [Octave.small] and a comma
/// always counts down from [Octave.great]. [isBass] only resolves the one
/// case marks alone cannot: an *empty* run of marks, meaning a bare letter
/// with no marks attached at all, which is [Octave.great] for an uppercase
/// letter and [Octave.small] for a lowercase one. Because that empty case
/// still depends on letter case, this is not part of [Octave.parsers] by
/// default. See [Octave] for the parsers that are.
///
/// ---
/// See also:
/// * [Octave].
final class HelmholtzOctaveNotation extends StringNotationSystem<Octave> {
  /// What an empty run of marks means: whether the letter it follows is
  /// uppercase ([Octave.great]) or lowercase ([Octave.small]).
  final bool isBass;

  /// Whether to use numbers instead of prime symbols.
  final bool useNumbers;

  /// Whether to use ASCII characters instead of Unicode characters.
  final bool useAscii;

  /// Creates a new [HelmholtzOctaveNotation].
  const HelmholtzOctaveNotation({
    this.isBass = false,
    this.useNumbers = false,
    this.useAscii = false,
  });

  /// Creates a new [HelmholtzOctaveNotation] using ASCII characters.
  const HelmholtzOctaveNotation.ascii({
    this.isBass = false,
    this.useNumbers = false,
  }) : useAscii = true;

  /// The lowest treble (lowercase-letter) [Octave], and one above the
  /// highest bass (uppercase-letter) [Octave], both with no marks attached.
  static const middle = Octave(3);

  static const _superPrime = '′';
  static const _superDoublePrime = '″';
  static const _superTriplePrime = '‴';
  static const _superQuadruplePrime = '⁗';
  static const _superPrimeAscii = "'";
  static const _subPrime = '͵';
  static const _subPrimeAscii = ',';

  static const _compoundPrimeSymbols = [
    _superDoublePrime,
    _superTriplePrime,
    _superQuadruplePrime,
  ];
  static const _primeSymbols = [_superPrime, _subPrime];
  static const _asciiPrimeSymbols = [_superPrimeAscii, _subPrimeAscii];

  @override
  RegExp get regExp => RegExp(
    useNumbers
        ? r'(?<numbers>[1-9]\d*)?'
        : '(?<primes>${[
            if (useAscii)
              for (final symbol in _asciiPrimeSymbols) '$symbol+'
            else ...[
              ..._compoundPrimeSymbols,
              for (final symbol in _primeSymbols) '$symbol+',
            ],
          ].join('|')})?',
  );

  @override
  Octave parseMatch(RegExpMatch match) => useNumbers
      ? _fromNumberOfMarks(int.parse(match.namedGroup('numbers') ?? '0'))
      : _fromMarks(match.namedGroup('primes')?.split('')) ??
            (throw FormatException('Invalid Octave', match[0]));

  Octave _fromNumberOfMarks(int numbers) => numbers == 0
      ? (isBass ? Octave.great : Octave.small)
      : isBass
      ? Octave(Octave.great.number - numbers)
      : Octave(Octave.small.number + numbers);

  /// Resolves independently of [isBass] whenever [marks] is non-empty: the
  /// mark type alone (comma vs. prime) already says which direction and
  /// which octave to count from.
  Octave? _fromMarks(List<String>? marks) => switch (marks?.first) {
    '' || null => isBass ? Octave.great : Octave.small,
    _subPrime || _subPrimeAscii => Octave(Octave.great.number - marks!.length),
    _superPrime || _superPrimeAscii => Octave(
      Octave.small.number + marks!.length,
    ),
    _superDoublePrime => Octave(Octave.small.number + 2),
    _superTriplePrime => Octave(Octave.small.number + 3),
    _superQuadruplePrime => Octave(Octave.small.number + 4),
    _ => null,
  };

  @override
  String format(Octave octave) {
    final symbols = useNumbers
        ? _numbered
        : useAscii
        ? _asciiSymbols
        : _symbols;
    final n = isBass
        ? octave.number - Octave.great.number
        : octave.number - Octave.small.number;

    return symbols(n);
  }

  static String _symbols(int n) => switch (n) {
    4 => _superQuadruplePrime,
    3 => _superTriplePrime,
    2 => _superDoublePrime,
    < 0 && final n => _subPrime * n.abs(),
    final n => _superPrime * n,
  };

  static String _asciiSymbols(int n) => switch (n) {
    < 0 && final n => _subPrimeAscii * n.abs(),
    final n => _superPrimeAscii * n,
  };

  static String _numbered(int n) => n == 0 ? '' : '${n.abs()}';
}
