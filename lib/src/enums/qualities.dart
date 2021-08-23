part of music_notes;

enum Qualities { augmented, major, perfect, minor, diminished }

extension QualitiesValues on Qualities {
  static const qualitiesValues = {
    Qualities.diminished: -2,
    Qualities.minor: -1,
    Qualities.perfect: 0,
    Qualities.major: 1,
    Qualities.augmented: 2,
  };

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
  /// QualitiesValues.intervalQualities(Intervals.fourth)
  ///   == QualitiesValues.perfectQualities
  ///
  /// QualitiesValues.intervalQualities(Intervals.sixth)
  ///   == QualitiesValues.qualities
  /// ```
  static Set<Qualities> intervalQualities(Intervals interval) =>
      interval.isPerfect ? perfectQualities : qualities;

  /// Returns `true` if the [Qualities] enum item that matches [interval]
  /// and [semitones] exist in its corresponding [Set] of [Qualities].
  ///
  /// Examples:
  /// ```dart
  /// QualitiesValues.exists(Intervals.second, 2) == true
  /// QualitiesValues.exists(Intervals.sixth, 8) == true
  /// QualitiesValues.exists(Intervals.sixth, 10) == false
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
  /// QualitiesValues.invert(Qualities.augmented) == Qualities.diminished
  /// QualitiesValues.invert(Qualities.minor) == Qualities.major
  /// QualitiesValues.invert(Qualities.perfect) == Qualities.perfect
  /// ```
  static Qualities invert(Qualities quality) => quality.inverted;

  /// Returns the value of this [Qualities] enum item as in [qualitiesValues].
  ///
  /// Examples:
  /// ```dart
  /// Qualities.perfect.value == 0
  /// Qualities.minor.value == -1
  /// Qualities.augmented.value == 2
  /// Qualities.major.value == 1
  /// ```
  int get value => qualitiesValues[this]!;

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
