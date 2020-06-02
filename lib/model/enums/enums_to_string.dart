import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';

extension NotesToString on Notes {
  String toText() => toString().split('.')[1];
}

extension AccidentalsToString on Accidentals {
  String toText() => toString().split('.')[1];
}
