part of music_notes;

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
