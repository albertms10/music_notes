part of music_notes;

enum Qualities { Augmentada, Major, Justa, Menor, Disminuida }

extension QualitiesValues on Qualities {
  static const qualitiesDeltas = {
    Qualities.Disminuida,
    Qualities.Menor,
    Qualities.Major,
    Qualities.Augmentada,
  };

  static const perfectQualitiesDeltas = {
    Qualities.Disminuida,
    Qualities.Justa,
    Qualities.Augmentada,
  };

  static const invertedQualities = {
    Qualities.Augmentada: Qualities.Disminuida,
    Qualities.Justa: Qualities.Justa,
    Qualities.Major: Qualities.Menor,
  };

  /// Returns an inverted [Qualities] enum item from [quality].
  static Qualities invert(Qualities quality) => quality.inverted;

  /// Returns an inverted this [Qualities] enum item.
  ///
  /// ```dart
  /// Qualities.Disminuida.inverted == Qualities.Augmentada
  /// Qualities.Major.inverted == Qualities.Menor
  /// Qualities.Justa.inverted == Qualities.Justa
  /// ```
  Qualities get inverted {
    Qualities inverted = invertedQualities[this];
    return inverted != null
        ? inverted
        : invertedQualities.keys
            .firstWhere((quality) => this == invertedQualities[quality]);
  }
}
