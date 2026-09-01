import '../notation_system/notation_system.dart';
import 'frequency.dart';

/// The [StringNotationSystem] for SI-notated [Frequency].
final class FrequencySINotation extends StringNotationSystem<Frequency> {
  /// Creates a new [FrequencySINotation].
  const FrequencySINotation();

  /// The symbol for the Hertz unit.
  static const _hertzUnitSymbol = 'Hz';

  static const _pattern =
      '(?<frequency>\\d+(\\.\\d+)?)(?:\\s*$_hertzUnitSymbol)?';

  @override
  String get pattern => _pattern;

  @override
  Frequency parseMatch(RegExpMatch match) =>
      Frequency(.parse(match.namedGroup('frequency')!));

  @override
  String format(Frequency frequency) => '${frequency.hertz} $_hertzUnitSymbol';
}
