part of music_notes;

class Tonality {
  final Note note;
  final Modes mode;

  const Tonality(this.note, this.mode)
      : assert(note != null),
        assert(mode != null);

  int get accidentals =>
      CircleOfFifths.exactFifthsDistance(Note(Notes.Do), note).abs();

  KeySignature get keySignature => KeySignature.fromDistance(
        CircleOfFifths.exactFifthsDistance(Note(Notes.Do), note),
      );

  @override
  String toString() => '$note ${mode.toText()}';
}
