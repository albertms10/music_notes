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

  static Qualities invert(Qualities quality) => quality.inverted;

  Qualities get inverted {
    Qualities inverted = invertedQualities[this];
    return inverted != null
        ? inverted
        : invertedQualities.values.toList().indexOf(this);
  }
}
