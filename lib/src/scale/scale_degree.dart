part of '../../music_notes.dart';

class ScaleDegree implements Comparable<ScaleDegree> {
  final int degree;
  final int inversion;
  final ImperfectQuality? quality;
  final int semitonesDelta;

  /// Creates a new [ScaleDegree].
  const ScaleDegree(
    this.degree, {
    this.quality,
    this.inversion = 0,
    this.semitonesDelta = 0,
  });

  static const i = ScaleDegree(1);
  static const ii = ScaleDegree(2);
  static const neapolitanSixth =
      ScaleDegree(2, inversion: 1, semitonesDelta: -1);
  static const iii = ScaleDegree(3);
  static const iv = ScaleDegree(4);
  static const v = ScaleDegree(5);
  static const vi = ScaleDegree(6);
  static const vii = ScaleDegree(7);

  /// Whether this [ScaleDegree] is raised.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.ii.isRaised == false
  /// ScaleDegree.neapolitanSixth.isRaised == false
  /// ```
  bool get isRaised => semitonesDelta > 0;

  /// Whether this [ScaleDegree] is lowered.
  ///
  /// Example:
  /// ```dart
  /// ScaleDegree.vi.isLowered == false
  /// ScaleDegree.neapolitanSixth.isLowered == true
  /// ```
  bool get isLowered => semitonesDelta < 0;

  @override
  String toString() {
    final buffer = StringBuffer();
    if (semitonesDelta != 0) {
      buffer.write(Accidental(semitonesDelta).symbol);
    }
    final romanNumeral = switch (degree) {
      1 => 'I',
      2 => 'II',
      3 => 'III',
      4 => 'IV',
      5 => 'V',
      6 => 'VI',
      7 => 'VII',
      _ => '',
    };

    if (quality != null && quality!.semitones <= 0) {
      buffer.write(romanNumeral.toLowerCase());
    } else {
      buffer.write(romanNumeral);
    }

    switch (inversion) {
      case 1:
        buffer.write('6');
      case 2:
        buffer.write('64');
    }

    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is ScaleDegree &&
      degree == other.degree &&
      inversion == other.inversion &&
      quality == other.quality &&
      semitonesDelta == other.semitonesDelta;

  @override
  int get hashCode => Object.hash(degree, inversion, quality, semitonesDelta);

  @override
  int compareTo(ScaleDegree other) => compareMultiple([
        () => degree.compareTo(other.degree),
        () => semitonesDelta.compareTo(other.semitonesDelta),
        () => inversion.compareTo(other.inversion),
        () {
          if (quality != null && other.quality != null) {
            return quality!.compareTo(other.quality!);
          }
          if (quality != null) return -1;
          if (other.quality != null) return 1;

          return 0;
        },
      ]);
}
