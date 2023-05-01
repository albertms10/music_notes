part of '../../music_notes.dart';

/// A type of musical scale coupled with a set of characteristic melodic and
/// harmonic behaviors.
///
/// See [Mode (music)](https://en.wikipedia.org/wiki/Mode_(music)).
abstract class Mode implements Enum, Comparable<Mode> {
  Scale get scale;
  int get brightness;

  /// [Comparator] for [Mode]s.
  static int compareModes(Mode a, Mode b) => compareMultiple([
        () => a.brightness.compareTo(b.brightness),
        () => a.name.compareTo(b.name),
      ]);
}

enum TonalMode implements Mode {
  /// See [Major mode](https://en.wikipedia.org/wiki/Major_mode).
  major(Scale.major, brightness: 0),

  /// See [Minor mode](https://en.wikipedia.org/wiki/Minor_mode).
  minor(Scale.naturalMinor, brightness: -3);

  @override
  final Scale scale;

  @override
  final int brightness;

  const TonalMode(this.scale, {required this.brightness});

  /// Returns the opposite of this [TonalMode].
  ///
  /// Example:
  /// ```dart
  /// TonalMode.major.opposite == TonalMode.minor
  /// TonalMode.minor.opposite == TonalMode.major
  /// ```
  TonalMode get opposite =>
      this == TonalMode.major ? TonalMode.minor : TonalMode.major;

  @override
  int compareTo(Mode other) => Mode.compareModes(this, other);
}

enum ModalMode implements Mode {
  /// See [Lydian mode](https://en.wikipedia.org/wiki/Lydian_mode).
  lydian(Scale.lydian, brightness: 1),

  /// See [Ionian mode](https://en.wikipedia.org/wiki/Ionian_mode).
  ionian(Scale.ionian, brightness: 0),

  /// See [Mixolydian mode](https://en.wikipedia.org/wiki/Mixolydian_mode).
  mixolydian(Scale.mixolydian, brightness: -1),

  /// See [Dorian mode](https://en.wikipedia.org/wiki/Dorian_mode).
  dorian(Scale.dorian, brightness: -2),

  /// See [Aeolian mode](https://en.wikipedia.org/wiki/Aeolian_mode).
  aeolian(Scale.aeolian, brightness: -3),

  /// See [Phrygian mode](https://en.wikipedia.org/wiki/Phrygian_mode).
  phrygian(Scale.phrygian, brightness: -4),

  /// See [Locrian mode](https://en.wikipedia.org/wiki/Locrian_mode).
  locrian(Scale.locrian, brightness: -5);

  @override
  final Scale scale;

  @override
  final int brightness;

  const ModalMode(this.scale, {required this.brightness});

  @override
  int compareTo(Mode other) => Mode.compareModes(this, other);
}
