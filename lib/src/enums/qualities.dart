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
}
