part of '../../music_notes.dart';

/// Represents an absolute pitch, a physical frequency.
@immutable
class Frequency {
  const Frequency(this.hertz);

  final double hertz;

  /// Whether this [Frequency] is inside the human hearing range.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(880).isHumanAudible == true
  /// Note.a.inOctave(4).equalTemperamentFrequency().isHumanAudible == true
  /// Note.g.inOctave(12).equalTemperamentFrequency(442).isHumanAudible == false
  /// ```
  bool get isHumanAudible {
    const minFrequency = 20;
    const maxFrequency = 20000;

    return hertz >= minFrequency && hertz <= maxFrequency;
  }
}
