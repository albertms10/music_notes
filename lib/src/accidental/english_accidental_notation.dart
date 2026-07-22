import '../notation_system/notation_system.dart';
import '../note/note.dart';
import 'accidental.dart';

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
