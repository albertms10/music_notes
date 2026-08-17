import '../notation_system/notation_system.dart';
import '../note/note.dart';
import 'accidental.dart';

/// The English notation system for [Accidental].
final class EnglishAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Whether a natural [Note] should be represented with the
  /// [Accidental.natural] symbol.
  final bool showNatural;

  /// The separator to use between compound accidentals
  /// (e.g. "double-sharp" or "triple-flat").
  final String separator;

  /// Creates a new [EnglishAccidentalNotation].
  const EnglishAccidentalNotation({
    this.showNatural = true,
    this.separator = '-',
  });

  static const _natural = 'natural';
  static const _flat = 'flat';
  static const _sharp = 'sharp';
  static const _double = 'double';
  static const _triple = 'triple';
  static const _times = '×';

  @override
  String get pattern =>
      '(?<accidental>(?:(?:$_double|$_triple)[$separator]*)?'
      '(?:$_flat|$_sharp)|$_natural)?';

  @override
  Accidental parseMatch(RegExpMatch match) {
    final accidental = match.namedGroup('accidental')?.toLowerCase();
    if (accidental == null || accidental == _natural) return .natural;

    final semitones = switch (accidental.split(separator).first) {
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
    3 => const [_triple, _sharp],
    2 => const [_double, _sharp],
    1 => const [_sharp],
    0 => showNatural ? const [_natural] : const [''],
    -1 => const [_flat],
    -2 => const [_double, _flat],
    -3 => const [_triple, _flat],
    > 3 && final semitones => ['$_times$semitones', _sharp],
    final semitones => ['$_times${semitones.abs()}', _flat],
  }.join(separator);
}
