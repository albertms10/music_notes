import 'package:music_notes/music_notes.dart';

void main() {
  // Notes
  Note.a.flat; // A♭
  Note.c.sharp; // C♯
  Note.parse('fx'); // F𝄪
  PositionedNote.parse("g''"); // G5
  PositionedNote.parse('Bb3'); // B♭3

  // Intervals
  Note.c.interval(Note.g); // P5
  Note.d.interval(Note.f.sharp).inverted; // m6
  Note.g.flat.transposeBy(-Interval.m3); // E♭

  Interval.P5.circleFrom(Note.c, distance: 12);
  // [C, G, D, A, E, B, F♯, C♯, G♯, D♯, A♯, E♯, B♯]
  Note.c.circleOfFifths();
  // (flats: [F, B♭, E♭, A♭, D♭, G♭], sharps: [G, D, A, E, B, F♯])

  // Scales
  Note.a.flat.major.scale; // A♭ Major (ionian) (A♭ B♭ C D♭ E♭ F G A♭)
  ScalePattern.lydian.on(Note.d).degree(ScaleDegree.iv); // G♯
  Note.c.major.scale.functionChord(
    HarmonicFunction.dominantV / HarmonicFunction.dominantV,
  ); // D maj. (D F♯ A)

  // Chords
  Note.c.majorTriad; // C maj. (C E G)
  ChordPattern.augmentedTriad.add11().add13().on(Note.d.sharp);
  // D♯ aug. (D♯ F𝄪 A𝄪 G♯ B♯)
  Note.f.minorTriad.add7().add9(ImperfectQuality.minor);
  // F min. (F A♭ C E♭ G♭)
  Note.e.flat.diminishedTriad.add7().transposeBy(Interval.m2);
  // F♭ dim. (F♭ A𝄫 C𝄫 E𝄫)

  // Frequencies
  Note.a.inOctave(4).equalTemperamentFrequency(); // 440.0 Hz
  Note.b.flat.inOctave(4).equalTemperamentFrequency(
        reference: Note.c.inOctave(4),
        frequency: const Frequency(256),
      ); // 456.1401436878537 Hz

  // Crazy chaining
  ScalePattern.lydian // Lydian (M2 M2 M2 m2 M2 M2 m2)
      .on(Note.parse('a')) // A Lydian (A B C♯ D♯ E F♯ G♯ A)
      .transposeBy(Interval.M2) // B Lydian (B C♯ D♯ E♯ F♯ G♯ A♯ B)
      .degree(ScaleDegree.iii) // D♯
      .respelledUpwards // E♭
      .major // E♭ major
      .relative // C minor
      .scale // C Natural minor (aeolian) (C D E♭ F G A♭ B♭ C)
      .degreeChord(ScaleDegree.v) // G min. (G B♭ D)
      .add9(); // G min. (G B♭ D A)
}
