import '../notation_system/notation_system.dart';
import 'frequency.dart';

/// The [StringNotationSystem] for SI-notated [Frequency].
class FrequencySINotation extends StringNotationSystem<Frequency> {
  /// Creates a new [FrequencySINotation].
  const FrequencySINotation();

  /// The symbol for the Hertz unit.
  static const _hertzUnitSymbol = 'Hz';

  /// The [RegExp] pattern for parsing [Frequency].
  static final _regExp = RegExp(
    '(?<frequency>\\d+(\\.\\d+)?)(?:\\s*$_hertzUnitSymbol)?',
  );

  @override
  RegExp get regExp => _regExp;

  @override
  Frequency parseMatch(RegExpMatch match) =>
      Frequency(.parse(match.namedGroup('frequency')!));

  @override
  String format(Frequency frequency) => '${frequency.hertz} $_hertzUnitSymbol';
}
