import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/enums_to_string.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

class Note with Music {
  final Notes note;
  final Accidentals accidental;

  Note(this.note, [this.accidental]) : assert(note != null);

  int get noteValue => Music.modValue(note.value + accidental.value);

  @override
  String toString() =>
      '${note.toText()}' +
      (accidental != null ? ' ${accidental.toText()}' : '');

  @override
  bool operator ==(other) => other is Note && this.note == other.note;
}
