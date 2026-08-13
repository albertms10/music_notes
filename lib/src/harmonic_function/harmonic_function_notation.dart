import 'package:music_notes/src/scale_degree/roman_scale_degree_notation.dart';

import '../notation_system/notation_system.dart';
import '../scale_degree/scale_degree.dart';
import 'harmonic_function.dart';

/// The [StringNotationSystem] for [HarmonicFunction] notation.
class HarmonicFunctionNotation extends StringNotationSystem<HarmonicFunction> {
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
    final scaleDegreePart = scaleDegreeNotation.format(scaleDegree);

    final buffer = StringBuffer()
      ..writeAll([
        if ((pattern?.isMinor ?? false) || (pattern?.isDiminished ?? false))
          scaleDegreePart.toLowerCase()
        else
          scaleDegreePart.toUpperCase(),
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
