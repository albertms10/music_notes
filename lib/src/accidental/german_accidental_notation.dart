import '../notation_system/notation_system.dart';
import '../note_name/german_note_name_notation.dart';
import 'accidental.dart';

/// The German notation for [Accidental]: the suffixes `-is` (sharp) and
/// `-es`/`-s` (flat) that [GermanNoteNameNotation] attaches directly onto
/// a note letter, repeated for each semitone of alteration (e.g. `isis`
/// for double-sharp, `eses` for double-flat).
///
/// See [Versetzungszeichen](https://de.wikipedia.org/wiki/Versetzungszeichen).
final class GermanAccidentalNotation extends StringNotationSystem<Accidental> {
  /// Creates a new [GermanAccidentalNotation].
  const GermanAccidentalNotation();

  static const _flatShort = 's';
  static const _flat = 'es';
  static const _sharp = 'is';

  static final _regExp = RegExp(
    '(?<accidental>$_flatShort?(?:$_flat)*|(?:$_sharp)+)?',
  );

  @override
  RegExp get regExp => _regExp;

  @override
  Accidental parseMatch(RegExpMatch match) {
    final accidental = match.namedGroup('accidental');
    if (accidental == null) return .natural;

    final semitones = accidental.split(_flatShort).length - 1;

    return accidental.startsWith(_sharp)
        ? Accidental(semitones)
        : Accidental(-semitones);
  }

  @override
  String format(Accidental accidental) =>
      (accidental.isFlat ? _flat : _sharp) * accidental.semitones.abs();
}
