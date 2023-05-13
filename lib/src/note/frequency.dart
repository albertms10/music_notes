part of '../../music_notes.dart';

/// Represents an absolute pitch, a physical frequency.
@immutable
class Frequency implements Comparable<Frequency> {
  /// The value of this [Frequency] in Hertz.
  final double hertz;

  /// Creates a new [Frequency] instance from [hertz].
  const Frequency(this.hertz);

  /// The symbol for the Hertz unit.
  static const hertzUnitSymbol = 'Hz';

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

  @override
  String toString() => '$hertz $hertzUnitSymbol';

  @override
  bool operator ==(Object other) => other is Frequency && hertz == other.hertz;

  @override
  int get hashCode => hertz.hashCode;

  @override
  int compareTo(Frequency other) => hertz.compareTo(other.hertz);
}
