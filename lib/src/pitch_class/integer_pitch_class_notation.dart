import '../notation_system/notation_system.dart';
import 'pitch_class.dart';

/// The [StringNotationSystem] for integer [PitchClass].
///
/// See [Integer notation](https://en.wikipedia.org/wiki/Pitch_class#Integer_notation).
final class IntegerPitchClassNotation extends StringNotationSystem<PitchClass> {
  /// Creates a new [IntegerPitchClassNotation].
  const IntegerPitchClassNotation();

  static const _ten = 't';
  static const _eleven = 'e';

  static const _pattern = '(?<pitchClass>[0-9$_ten$_eleven])';

  @override
  String get pattern => _pattern;

  @override
  PitchClass parseMatch(RegExpMatch match) =>
      PitchClass(switch (match.namedGroup('pitchClass')!) {
        _ten => 10,
        _eleven => 11,
        final semitones => .parse(semitones),
      });

  @override
  String format(PitchClass pitchClass) => switch (pitchClass.semitones) {
    10 => _ten,
    11 => _eleven,
    final semitones => '$semitones',
  };
}
