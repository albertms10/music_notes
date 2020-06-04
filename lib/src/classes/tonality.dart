part of music_notes;

class Tonality {
  final Note note;
  final Modes mode;

  const Tonality(this.note, this.mode)
      : assert(note != null),
        assert(mode != null);

  int get accidentals =>
      CircleOfFifths.exactFifthsDistance(Note(Notes.Do), note).abs();

  Tonality get relative => Tonality(
        note.transposeBy(
          Interval(
            Intervals.Tercera,
            Qualities.Menor,
            descending: mode == Modes.Major,
          ).semitones,
        ),
        mode.inverted,
      );

  KeySignature get keySignature => KeySignature.fromDistance(
        CircleOfFifths.exactFifthsDistance(
          Note(Notes.Do),
          mode == Modes.Major ? note : this.relative.note,
        ),
      );

  @override
  String toString() => '$note ${mode.toText()}';
}
