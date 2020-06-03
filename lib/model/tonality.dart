import 'package:music_notes_relations/model/circle_of_fifths.dart';
import 'package:music_notes_relations/model/enums/modes.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/key_signature.dart';
import 'package:music_notes_relations/model/note.dart';

abstract class Tonality {
  final Note note;
  final Modes mode;

  Tonality(this.note, this.mode)
      : assert(note != null),
        assert(mode != null);

  int get accidentals =>
      CircleOfFifths.exactFifthsDistance(Note(Notes.Do), note);

  KeySignature get keySignature;
}
