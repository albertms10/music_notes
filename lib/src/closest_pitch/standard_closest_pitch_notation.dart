import 'package:music_notes/utils.dart';

import '../cent/cent.dart';
import '../notation_system/notation_system.dart';
import '../pitch/pitch.dart';
import '../pitch/scientific_pitch_notation.dart';
import 'closest_pitch.dart';

/// The [StringNotationSystem] for standard [ClosestPitch].
class StandardClosestPitchNotation extends StringNotationSystem<ClosestPitch> {
  /// The [StringNotationSystem] for [Pitch] notation.
  final StringNotationSystem<Pitch> pitchNotation;

  /// The number of fraction digits to use when formatting cents.
  final int? fractionDigits;

  /// Whether to use ASCII characters instead of Unicode characters.
  final bool _useAscii;

  /// Creates a new [StandardClosestPitchNotation].
  const StandardClosestPitchNotation({
    this.pitchNotation = ScientificPitchNotation.english,
    this.fractionDigits = 0,
  }) : _useAscii = false;

  /// Creates a new [StandardClosestPitchNotation] using ASCII characters.
  const StandardClosestPitchNotation.ascii({
    this.pitchNotation = const ScientificPitchNotation.ascii(),
    this.fractionDigits = 0,
  }) : _useAscii = true;

  /// A [StandardClosestPitchNotation] that does not round cents.
  static const noRound = StandardClosestPitchNotation(fractionDigits: null);

  @override
  RegExp get regExp => RegExp(
    '${pitchNotation.regExp?.pattern}\\s*'
    '(?<cents>[+-${NumExtension.minusSign}${NumExtension.plusMinusSign}]\\d+(?:\\.\\d+)?)?',
    caseSensitive: false,
  );

  @override
  ClosestPitch parseMatch(RegExpMatch match) => ClosestPitch(
    pitchNotation.parseMatch(match),
    cents: Cent(.parse(match.namedGroup('cents')?.toAscii() ?? '0')),
  );

  @override
  String format(ClosestPitch closestPitch) {
    final pitch = pitchNotation.format(closestPitch.pitch);
    final cents = closestPitch.cents.toDeltaString(
      useAscii: _useAscii,
      fractionDigits: fractionDigits,
    );

    return '$pitch$cents';
  }
}
