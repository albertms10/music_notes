import 'package:music_notes/utils.dart';

import '../notation_system/notation_system.dart';
import '../note/english_note_notation.dart';
import '../note/german_note_notation.dart';
import '../note/note.dart';
import '../note/note_notation.dart';
import '../note/romance_note_notation.dart';
import 'pitch.dart';

/// The Helmholtz [Pitch] notation formatter.
///
/// See [Helmholtz’s pitch notation](https://en.wikipedia.org/wiki/Helmholtz_pitch_notation).
final class HelmholtzPitchNotation extends StringNotationSystem<Pitch> {
  /// The [Note] formatter for [Pitch.note].
  final NoteNotation noteNotation;

  /// Whether to use numbers instead of prime symbols.
  final bool _useNumbers;

  /// Whether to use ASCII characters instead of Unicode characters.
  final bool _useAscii;

  /// Creates a new [HelmholtzPitchNotation].
  const HelmholtzPitchNotation({
    this.noteNotation = const EnglishNoteNotation.symbol(),
  }) : _useNumbers = false,
       _useAscii = false;

  /// Creates a new [HelmholtzPitchNotation] using ASCII characters.
  const HelmholtzPitchNotation.ascii({
    this.noteNotation = const EnglishNoteNotation.ascii(),
  }) : _useNumbers = false,
       _useAscii = true;

  /// Creates a new [HelmholtzPitchNotation] using numbers instead of prime
  /// symbols.
  const HelmholtzPitchNotation.numbered({
    this.noteNotation = const GermanNoteNotation(),
  }) : _useNumbers = true,
       _useAscii = false;

  /// The [EnglishNoteNotation] variant of this [HelmholtzPitchNotation].
  static const english = HelmholtzPitchNotation();

  /// The [GermanNoteNotation] variant of this [HelmholtzPitchNotation].
  static const german = HelmholtzPitchNotation(
    noteNotation: GermanNoteNotation(),
  );

  /// The [RomanceNoteNotation] variant of this [HelmholtzPitchNotation].
  static const romance = HelmholtzPitchNotation(
    noteNotation: RomanceNoteNotation.symbol(),
  );

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

  static const _primeSymbols = [
    _superPrime,
    _superPrimeAscii,
    _subPrime,
    _subPrimeAscii,
  ];

  static const _middleOctave = Pitch.referenceOctave - 1;

  @override
  RegExp get regExp => RegExp(
    '${noteNotation.regExp?.pattern}'
    '((?<primes>${[
      ..._compoundPrimeSymbols,
      for (final symbol in _primeSymbols) '$symbol+',
    ].join('|')})|'
    r'(?<numbers>[1-9]\d*))?',
    caseSensitive: false,
  );

  int _octaveFromNumbers(int numbers, bool isBass) =>
      isBass ? 2 - numbers : numbers + 3;

  int? _octaveFromPrimes(List<String>? primes, bool isBass) => isBass
      ? switch (primes?.first) {
          '' || null => _middleOctave - 1,
          _subPrime || _subPrimeAscii => _middleOctave - primes!.length - 1,
          _ => null,
        }
      : switch (primes?.first) {
          '' || null => _middleOctave,
          _superPrime || _superPrimeAscii => _middleOctave + primes!.length,
          _superDoublePrime => _middleOctave + 2,
          _superTriplePrime => _middleOctave + 3,
          _superQuadruplePrime => _middleOctave + 4,
          _ => null,
        };

  @override
  Pitch parseMatch(RegExpMatch match) {
    final noteName = match.namedGroup('noteName')!;
    final textualNumbers = match.namedGroup('numbers');
    final isBass = noteName[0].isUpperCase;

    return Pitch(
      noteNotation.parseMatch(match),
      octave: textualNumbers != null
          ? _octaveFromNumbers(int.parse(textualNumbers), isBass)
          : _octaveFromPrimes(match.namedGroup('primes')?.split(''), isBass) ??
                (throw FormatException('Invalid Pitch', match[0])),
    );
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

  @override
  String format(Pitch pitch) {
    final note = noteNotation.format(pitch.note);
    final symbols = _useNumbers
        ? _numbered
        : _useAscii
        ? _asciiSymbols
        : _symbols;

    return switch (pitch.octave) {
      >= _middleOctave && final octave =>
        '${note.toLowerCase()}${symbols(octave - 3)}',
      final octave => '$note${symbols(octave - 2)}',
    };
  }
}
