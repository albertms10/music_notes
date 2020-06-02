import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/enums/modes.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/enums/qualities.dart';

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