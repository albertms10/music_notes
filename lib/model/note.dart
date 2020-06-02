import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/enums.dart';
import 'package:music_notes_relations/model/enums/notes.dart';

class Note {
  final Notes note;
  final Accidentals accidental;

  Note(this.note, [this.accidental]);

  int get noteValue => note.value + accidental.value % 12;

  @override
  String toString() =>
      '${note.toText()}' +
      (accidental != null ? ' ${accidental.toText()}' : '');
}
