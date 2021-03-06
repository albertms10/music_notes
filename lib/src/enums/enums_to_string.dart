part of music_notes;

extension on Notes {
  String toText() => toString().split('.').last;
}

extension on Accidentals {
  String toText() => toString().split('.').last;
}

extension on Modes {
  String toText() => toString().split('.').last;
}

extension on Intervals {
  String toText() => toString().split('.').last;
}

extension on Qualities {
  String toText() => toString().split('.').last;
}
