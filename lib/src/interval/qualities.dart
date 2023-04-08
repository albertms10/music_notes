part of '../../music_notes.dart';

enum Qualities {
  augmented(2),
  major(1),
  perfect(0),
  minor(-1),
  diminished(-2);

  final int value;

  const Qualities(this.value);

  static const qualities = {
    Qualities.diminished,
    Qualities.minor,
    Qualities.major,
    Qualities.augmented,
  };

  static const perfectQualities = {
    Qualities.diminished,
    Qualities.perfect,
    Qualities.augmented,
  };

  // ignore: avoid-missing-enum-constant-in-map
  static const invertedQualities = {
    Qualities.augmented: Qualities.diminished,
    Qualities.perfect: Qualities.perfect,
    Qualities.major: Qualities.minor,
  };

  /// Returns the [Set] of [Qualities] that corresponds to the
  /// perfect nature of [interval].
  ///
  /// Examples:
  /// ```dart
  /// Qualities.intervalQualities(Intervals.fourth)
  ///   == Qualities.perfectQualities
  ///
  /// Qualities.intervalQualities(Intervals.sixth)
  ///   == Qualities.qualities
  /// ```
  static Set<Qualities> intervalQualities(Intervals interval) =>
      interval.isPerfect ? perfectQualities : qualities;

  /// Returns `true` if the [Qualities] enum item that matches [interval]
  /// and [semitones] exist in its corresponding [Set] of [Qualities].
  ///
  /// Examples:
  /// ```dart
  /// Qualities.exists(Intervals.second, 2) == true
  /// Qualities.exists(Intervals.sixth, 8) == true
  /// Qualities.exists(Intervals.sixth, 10) == false
  /// ```
  static bool exists(Intervals? interval, int semitones) {
    if (interval == null) return false;

    final delta = semitones - interval.semitones + (interval.isPerfect ? 0 : 1);

    return delta > 0 && delta <= intervalQualities(interval).length;
  }

  /// Returns an inverted [Qualities] enum item from [quality].
  ///
  /// Examples:
  /// ```dart
  /// Qualities.invert(Qualities.augmented) == Qualities.diminished
  /// Qualities.invert(Qualities.minor) == Qualities.major
  /// Qualities.invert(Qualities.perfect) == Qualities.perfect
  /// ```
  static Qualities invert(Qualities quality) => quality.inverted;

  /// Returns an inverted this [Qualities] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Qualities.diminished.inverted == Qualities.augmented
  /// Qualities.major.inverted == Qualities.minor
  /// Qualities.perfect.inverted == Qualities.perfect
  /// ```
  Qualities get inverted {
    final inverted = invertedQualities[this];

    return inverted ??
        invertedQualities.keys
            .firstWhere((quality) => this == invertedQualities[quality]);
  }
}
