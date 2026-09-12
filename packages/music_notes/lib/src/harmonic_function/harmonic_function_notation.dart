import '../notation_system/notation_system.dart';
import '../scale_degree/roman_scale_degree_notation.dart';
import '../scale_degree/scale_degree.dart';
import 'harmonic_function.dart';

/// The [StringNotationSystem] for [HarmonicFunction] notation.
final class HarmonicFunctionNotation
    extends StringNotationSystem<HarmonicFunction> {
  /// The [StringNotationSystem] for [ScaleDegree] notation.
  final StringNotationSystem<ScaleDegree> scaleDegreeNotation;

  /// Creates a new [HarmonicFunctionNotation].
  const HarmonicFunctionNotation({
    this.scaleDegreeNotation = const RomanScaleDegreeNotation(),
  });

  @override
  String format(HarmonicFunction harmonicFunction) {
    final HarmonicFunction(:scaleDegree, :pattern, :tonicization) =
        harmonicFunction;

    final buffer = StringBuffer()
      ..writeAll([
        switch (scaleDegreeNotation) {
          RomanScaleDegreeNotation(:final format) => format(
            scaleDegree,
            useUppercase:
                !(pattern?.isMinor ?? false) &&
                !(pattern?.isDiminished ?? false),
          ),
          final notationSystem => notationSystem.format(scaleDegree),
        },
        switch (pattern?.inversion) {
          1 => '6',
          2 => '64',
          _ => '',
        },
        if (tonicization != null) '/${format(tonicization)}',
      ]);

    return buffer.toString();
  }
}
