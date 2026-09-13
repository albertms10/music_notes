import '../notation_system/notation_system.dart';
import 'accidental.dart';

/// The German notation system for [Accidental].
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
