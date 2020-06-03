import 'package:music_notes_relations/model/enharmonic_note.dart';
import 'package:music_notes_relations/model/enums/accidentals.dart';
import 'package:music_notes_relations/model/enums/enums_to_string.dart';
import 'package:music_notes_relations/model/enums/intervals.dart';
import 'package:music_notes_relations/model/enums/notes.dart';
import 'package:music_notes_relations/model/interval.dart';
import 'package:music_notes_relations/model/mixins/music.dart';

class Note with Music {
  final Notes note;
  final Accidentals accidental;

  Note(this.note, [this.accidental]) : assert(note != null);

  int get value => Music.modValueWithZero(
      note.value + (accidental != null ? accidental.value : 0));

  int get accidentalValue => accidental != null ? accidental.value : 0;

  int semitonesDelta(Note note) => Music.modValue(note.value - this.value);

  int exactSemitonesDistance(Note note, int semitones) {
    int distance = 0;
    int currentPitch = this.value;
    EnharmonicNote tempNote = EnharmonicNote.fromValue(currentPitch);

    while (tempNote.enharmonicNotes.every((temp) => temp != note)) {
      distance++;
      currentPitch += semitones;
      tempNote = EnharmonicNote.fromValue(currentPitch);
    }

    return distance;
  }

  Interval exactInterval(Note note) {
    Intervals interval = this.note.interval(note.note);

    return Interval.fromDelta(
        interval,
        semitonesDelta(note) -
            IntervalsValues.intervalsQualitiesIndex[interval] +
            1);
  }

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
