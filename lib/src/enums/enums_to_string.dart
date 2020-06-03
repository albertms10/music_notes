part of music_notes;

extension on Notes {
  String toText() => toString().split('.')[1];
}

extension on Accidentals {
  String toText() => toString().split('.')[1];
}

extension on Modes {
  String toText() => toString().split('.')[1];
}

extension on Intervals {
  String toText() => toString().split('.')[1];
}

extension on Qualities {
  String toText() => toString().split('.')[1];
}
