import '../notation_system/notation_system.dart';
import 'octave.dart';

/// The German named notation system for [Octave],
/// e.g. _große_, _eingestrichene_.
///
/// See [Octave § Octave naming systems](https://en.wikipedia.org/wiki/Octave#Octave_naming_systems).
final class GermanNamedOctaveNotation extends StringNotationSystem<Octave> {
  /// Creates a new [GermanNamedOctaveNotation].
  const GermanNamedOctaveNotation();

  static const _names = <int, String>{
    0: 'subkontra',
    1: 'kontra',
    2: 'große',
    3: 'kleine',
    4: 'eingestrichene',
    5: 'zweigestrichene',
    6: 'dreigestrichene',
    7: 'viergestrichene',
    8: 'fünfgestrichene',
  };

  static final _lookup = {
    for (final entry in _names.entries) entry.value.toLowerCase(): entry.key,
  };

  static final _regExp = RegExp(
    '(?<octave>${_names.values.join('|')})',
    caseSensitive: false,
    unicode: true,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  Octave parseMatch(RegExpMatch match) => Octave(
    _lookup[match.namedGroup('octave')!.toLowerCase()] ??
        (throw FormatException('Invalid German named Octave', match[0])),
  );

  @override
  String format(Octave octave) =>
      _names[octave.number] ??
      (throw UnsupportedError(
        'No German name for octave $octave (only octaves in '
        '[${_names.keys.first}, ${_names.keys.last}] are supported).',
      ));
}
