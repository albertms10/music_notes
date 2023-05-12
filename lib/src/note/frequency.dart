part of '../../music_notes.dart';

/// Represents an absolute pitch, a physical frequency.
class Frequency {
  Frequency(this.hertz);

  final double hertz;

  /// Whether this [Frequency] is inside the human hearing range.
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).isHumanAudibleAt() == true
  /// Note.d.inOctave(0).isHumanAudibleAt() == false
  /// Note.g.inOctave(12).isHumanAudibleAt(442) == false
  /// ```
  bool get isHumanAudible {
    const minFrequency = 20;
    const maxFrequency = 20000;

    return hertz >= minFrequency && hertz <= maxFrequency;
  }
}
