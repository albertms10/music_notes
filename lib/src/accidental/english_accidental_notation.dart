import '../notation_system/notation_system.dart';
import '../note/note.dart';
import 'accidental.dart';

/// The written-out English notation for [Accidental]: "sharp", "flat",
/// "double-sharp", "triple-flat", and so on, as read aloud rather than
/// engraved.
///
/// Beyond triple, an accidental has no name of its own and falls back to
/// a multiplier, e.g. 4 semitones sharp formats as `×4-sharp`.
final class EnglishAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Whether a natural [Note] should be spelled out as "natural" rather
  /// than an empty string.
  final bool showNatural;

  /// The text placed between the magnitude and the direction of a
  /// compound accidental, e.g. the hyphen in "double-sharp".
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
  RegExp get regExp => RegExp(
    '(?<accidental>(?:(?:$_double|$_triple)[$separator]*)?'
    '(?:$_flat|$_sharp)|$_natural)?',
    caseSensitive: false,
  );

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
