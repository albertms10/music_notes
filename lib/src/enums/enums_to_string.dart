part of music_notes;

extension NotesToString on Notes {
  String toText() => toString().split('.')[1];
}

extension AccidentalsToString on Accidentals {
  String toText() => toString().split('.')[1];
}

extension ModesToString on Modes {
  String toText() => toString().split('.')[1];
}

extension IntervalsToString on Intervals {
  String toText() => toString().split('.')[1];
}

extension QualitiesToString on Qualities {
  String toText() => toString().split('.')[1];
}
