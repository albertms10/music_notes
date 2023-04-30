part of '../../music_notes.dart';

abstract class Mode implements Enum, Comparable<Mode> {
  Scale get scale;
  int get brightness;

  static int compareModes(Mode a, Mode b) => compareMultiple([
        () => a.brightness.compareTo(b.brightness),
        () => a.name.compareTo(b.name),
      ]);
}

enum TonalMode implements Mode {
  major(Scale.major, brightness: 0),
  minor(Scale.naturalMinor, brightness: -3);

  @override
  final Scale scale;

  @override
  final int brightness;

  const TonalMode(this.scale, {required this.brightness});

  /// Returns the inverted of this [TonalMode].
  ///
  /// Example:
  /// ```dart
  /// TonalMode.major.inverted == TonalMode.minor
  /// TonalMode.minor.inverted == TonalMode.major
  /// ```
  TonalMode get opposite =>
      this == TonalMode.major ? TonalMode.minor : TonalMode.major;

  @override
  int compareTo(Mode other) => Mode.compareModes(this, other);
}

enum ModalMode implements Mode {
  lydian(Scale.lydian, brightness: 1),
  ionian(Scale.ionian, brightness: 0),
  mixolydian(Scale.mixolydian, brightness: -1),
  dorian(Scale.dorian, brightness: -2),
  aeolian(Scale.aeolian, brightness: -3),
  phrygian(Scale.phrygian, brightness: -4),
  locrian(Scale.locrian, brightness: -5);

  @override
  final Scale scale;

  @override
  final int brightness;

  const ModalMode(this.scale, {required this.brightness});

  @override
  int compareTo(Mode other) => Mode.compareModes(this, other);
}
