part of music_notes;

enum Qualities { Augmentada, Major, Justa, Menor, Disminuida }

extension QualitiesValues on Qualities {
  static const qualities = {
    Qualities.Disminuida,
    Qualities.Menor,
    Qualities.Major,
    Qualities.Augmentada,
  };

  static const perfectQualities = {
    Qualities.Disminuida,
    Qualities.Justa,
    Qualities.Augmentada,
  };

  static const invertedQualities = {
    Qualities.Augmentada: Qualities.Disminuida,
    Qualities.Justa: Qualities.Justa,
    Qualities.Major: Qualities.Menor,
  };

  /// Returns the [Set] of [Qualities] that corresponds to the perfect nature of [interval].
  ///
  /// Examples:
  /// ```dart
  /// QualitiesValues.intervalQualitiesSet(Intervals.Quarta)
  ///   == QualitiesValues.perfectQualities
  ///
  /// QualitiesValues.intervalQualitiesSet(Intervals.Sexta)
  ///   == QualitiesValues.qualities
  /// ```
  static Set<Qualities> intervalQualitiesSet(Intervals interval) =>
      interval.isPerfect ? perfectQualities : qualities;

  /// Returns `true` if the [Qualities] enum item that matches [interval]
  /// and [semitones] exist in its corresponding [Set] of [Qualities].
  ///
  /// Examples:
  /// ```dart
  /// QualitiesValues.exists(Intervals.Segona, 2) == true
  /// QualitiesValues.exists(Intervals.Sexta, 8) == true
  /// QualitiesValues.exists(Intervals.Sexta, 10) == false
  /// ```
  static bool exists(Intervals interval, int semitones) {
    final int delta =
        semitones - interval.semitones + (interval.isPerfect ? 0 : 1);
    return delta > 0 && delta <= intervalQualitiesSet(interval).length;
  }

  /// Returns an inverted [Qualities] enum item from [quality].
  ///
  /// Examples:
  /// ```dart
  /// QualitiesValues.invert(Qualities.Augmentada) == Qualities.Disminuida
  /// QualitiesValues.invert(Qualities.Menor) == Qualities.Major
  /// QualitiesValues.invert(Qualities.Justa) == Qualities.Justa
  /// ```
  static Qualities invert(Qualities quality) => quality.inverted;

  /// Returns an inverted this [Qualities] enum item.
  ///
  /// Examples:
  /// ```dart
  /// Qualities.Disminuida.inverted == Qualities.Augmentada
  /// Qualities.Major.inverted == Qualities.Menor
  /// Qualities.Justa.inverted == Qualities.Justa
  /// ```
  Qualities get inverted {
    final Qualities inverted = invertedQualities[this];
    return inverted != null
        ? inverted
        : invertedQualities.keys
            .firstWhere((quality) => this == invertedQualities[quality]);
  }
}
