import '../notation_system/notation_system.dart';
import 'pitch_class.dart';

/// The [StringNotationSystem] for integer [PitchClass].
///
/// See [Integer notation](https://en.wikipedia.org/wiki/Pitch_class#Integer_notation).
final class IntegerPitchClassNotation extends StringNotationSystem<PitchClass> {
  /// Creates a new [IntegerPitchClassNotation].
  const IntegerPitchClassNotation();

  static final _regExp = RegExp('(?<pitchClass>[0-9et])');

  @override
  RegExp get regExp => _regExp;

  @override
  PitchClass parseMatch(RegExpMatch match) =>
      PitchClass(switch (match.namedGroup('pitchClass')!) {
        't' => 10,
        'e' => 11,
        final semitones => .parse(semitones),
      });

  @override
  String format(PitchClass pitchClass) => switch (pitchClass.semitones) {
    10 => 't',
    11 => 'e',
    final semitones => '$semitones',
  };
}
