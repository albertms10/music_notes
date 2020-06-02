import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/enums_to_string.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/interval.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

class Note with Music {
  final Notes note;
  final Accidentals accidental;

  Note(this.note, [this.accidental]) : assert(note != null);

  int get value =>
      Music.modValue(note.value + (accidental != null ? accidental.value : 0));

  int get accidentalValue => accidental != null ? accidental.value : 0;

  int exactIntervalDistance(Note note, int interval) {
    int distance = 0;
    int currentPitch = this.value;
    EnharmonicNote tempNote = EnharmonicNote.fromValue(currentPitch);

    while (tempNote.enharmonicNotes.every((temp) => temp != note)) {
      distance++;
      currentPitch += interval;
      tempNote = EnharmonicNote.fromValue(currentPitch);
    }

    return distance;
  }

  Interval exactInterval(Note note) => Interval.fromDelta(
        this.note.interval(note.note),
        note.accidentalValue - this.accidentalValue,
      );

  @override
  String toString() =>
      '${note.toText()}' +
      (accidental != null ? ' ${accidental.toText()}' : '');

  @override
  bool operator ==(other) =>
      other is Note &&
      this.note == other.note &&
      this.accidental == other.accidental;
}
