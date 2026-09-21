// For documentation purposes.
// ignore_for_file: unnecessary_statements, cascade_invocations
// ignore_for_file: use_named_constants

import 'package:music_notes/music_notes.dart';

void main() {
  const note = Note.a;
  note
      .major // A major (Key)
      .scale // A Major (ionian) (A B C♯ D♯ E F♯ G♯ A)
      .degreeChord(.vi) // F♯
      .add7() // F♯7
      .toPitches(); // [F♯4, A4, C♯5, E5]

  const Note(.e, .flat); // E♭
  Note.g.flat.flat; // G𝄫
  Note.f.sharp.sharp.sharp; // F𝄪♯
  Note.g.flat.flat.natural; // G

  Note.parse('a#'); // A♯

  Note.d.flat
    ..format() // D♭
    ..format(const GermanNoteNotation()) // Des
    ..format(const RomanceNoteNotation.symbol()); // Re♭

  Note.c.sharp.respellByNoteName(.d); // D♭
  Note.g.sharp.respelledUpwards; // A♭
  Note.f.sharp.isEnharmonicWith(Note.g.flat); // true

  Note.d.flat.toClass(); // {C♯|D♭}
  PitchClass.cSharp * 7; // {G} (a fifths transform)

  Interval.d5; // diminished fifth
  Size.sixth.augmented; // A6
  const Interval.imperfect(.tenth, .major); // M10
  Interval.parse('P-5'); // a descending perfect fifth

  -Interval.m7; // m-7
  Interval.m9.inversion; // M7
  Interval.M9.simple; // M2
  Interval.d5.isDissonant; // true

  Note.c.interval(.g); // P5
  Note.d.interval(.f.sharp).inversion; // m6
  Interval.A4.respellBySize(.fifth); // d5
  Interval.M2.toClass(); // {M2|d3}

  Note.c.circleOfFifths(distance: 3); // [E♭, B♭, F, C, G, D, A]
  Note.c.fifthsDistanceWith(.e.flat); // -3

  Note.c.inOctave(4) < Note.c.inOctave(5); // true
  Pitch.fromMidi(69); // A4
  Note.a.inOctave(4).midiNumber; // 69
  Note.b.inOctave(3).transposeBy(.P5); // F♯4

  Pitch.parse("g''"); // G5
  Pitch.parse('Eb3'); // E♭3

  Note.c.inOctave(6).format(HelmholtzPitchNotation.english); // c‴

  const <Note>[.c, .e, .g, .b].toStacked().drop(2); // [G3, C4, E4, B4]

  Note.e.flat.minor
    ..signature // {G♭ major, E♭ minor} −6 fifths (B♭ E♭ A♭ D♭ G♭ C♭)
    ..relative // G♭ major
    ..parallel // E♭ major
    ..isTheoretical; // false

  Note.c.major.relationshipWith(Note.e.flat.minor);
  // (distance: -3, relationship: KeyRelationship.doubleDirect)

  KeySignature.fromDistance(-6).keys[TonalMode.minor]; // E♭ minor
  KeySignature([.g.sharp]).isCanonical; // false

  final lydian = ScalePattern.lydian.on(Note.d);
  // D Lydian (D E F♯ G♯ A B C♯ D)

  lydian.degree(.iv); // G♯
  lydian.transposeBy(.M2); // E Lydian

  ModalMode.lydian.brightness; // 3
  ModalMode.locrian.mirrored; // ModalMode.lydian

  Note.c.major.scale.degreeChords();
  // [C, Dm, Em, F, G, Am, Bdim]

  Note.f.minorTriad.add7().add9(.minor); // F-7 ♭9
  Note.f.sharp.majorTriad.add9().diminished; // F♯dim

  Note.f.sharp.minorTriad.add7().sus2(); // [F♯, G♯, C♯, E]

  const Chord([.e, .g, .c]).inversion; // 1
  const Chord([.e, .g, .c]).rootPosition; // C major triad

  ChordPattern.majorTriad.add7().on(.c).toVoicing([0, 1, 2, 3, 0]);
  // [C4, E4, G4, B♭4, C5]

  Chord.parse('Cmaj7/E')
    ..items // [E, G, B, C]
    ..format(); // Cmaj7/E

  HarmonicFunction.dominantV / .dominantV; // V/V
  (HarmonicFunction.ii / .dominantV).format(); // II/V

  Note.g.major.scale.functionChord(HarmonicFunction.dominantV / .dominantV);
  // A

  ScaleDegree.iv.raised.format(const NumericScaleDegreeNotation()); // ♯4̂
  ScaleDegree.i.format(const SolfegeScaleDegreeNotation()); // Do

  Note.a.inOctave(4).frequency(); // 440 Hz
  Note.a.inOctave(4).frequency(temperature: const Celsius(18)); // 438.46 Hz

  TuningFork.a440; // A440
  TuningFork.c256; // C256
  Note.a.inOctave(4).at(const Frequency(438)); // A438

  const pythagorean = PythagoreanTuning();
  const meantone = MeantoneTuning.quarter;

  pythagorean.centsOffset(Note.g.inOctave(4)); // ≈ +2 cents
  meantone.centsOffset(Note.g.inOctave(4)); // ≈ −3.4 cents

  const Frequency(432).closestPitch(); // A4−32

  Note.c.inOctave(1).harmonics().take(4).toSet();
  // {C1±0, C2±0, G2+2, C3±0}

  Key.parse('f# minor'); // F♯ minor
  Note.b.flat.inOctave(4).format(); // B♭4

  const EnglishNoteNotation.ascii(); // renders ♯/♭ as #/b

  const chain = [EnglishNoteNotation(), GermanNoteNotation()];
  chain.firstMatchingParser('C'); // EnglishNoteNotation
  chain.firstMatchingParser('h'); // GermanNoteNotation
}
