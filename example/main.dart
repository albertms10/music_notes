// ignore_for_file: unnecessary_statements, cascade_invocations

import 'package:music_notes/music_notes.dart';

void main() {
  // Notes
  const Note(BaseNote.e, Accidental.flat); // E♭
  Note.c; // C
  Note.d; // D
  Note.f; // F

  BaseNote.fromSemitones(2); // BaseNote.d
  BaseNote.fromSemitones(9); // BaseNote.a

  BaseNote.fromOrdinal(3); // BaseNote.e
  BaseNote.fromOrdinal(7); // BaseNote.b

  Note.c.sharp; // C♯
  Note.d.flat; // D♭
  Note.g.flat.flat; // G𝄫
  Note.f.sharp.sharp.sharp; // F𝄪♯

  Note.f.inOctave(4); // F4
  Note.b.flat.inOctave(5); // B♭5

  BaseNote.parse('b'); // BaseNote.b
  Note.parse('a#'); // A♯
  Pitch.parse("g''"); // G5
  Pitch.parse('Eb3'); // E♭3

  BaseNote.c.difference(BaseNote.e); // 4
  BaseNote.a.difference(BaseNote.e); // -5
  BaseNote.a.positiveDifference(BaseNote.e); // 7

  Note.c.difference(Note.e.flat); // 3
  Pitch.parse('C').difference(Pitch.parse("c''''")); // 60

  Note.g.flat.transposeBy(-Interval.m3); // E♭
  Note.b.inOctave(3).transposeBy(Interval.P5); // F♯4

  Note.c.sharp.respellByBaseNote(BaseNote.d); // D♭
  Note.e.flat.respellByAccidental(Accidental.sharp); // D♯
  Note.g.flat.inOctave(3).respellByOrdinalDistance(-1); // F♯3

  Note.g.sharp.respelledUpwards; // A♭
  Note.a.flat.respelledDownwards; // G♯
  Note.b.sharp.inOctave(4).respelledSimple; // C5

  Note.c.inOctave(4) < Note.c.inOctave(5); // true
  Note.d.inOctave(3) > Note.f.inOctave(4); // false
  Note.a.flat.inOctave(5) >= Note.g.sharp.inOctave(5); // true

  Note.f.sharp.isEnharmonicWith(Note.g.flat); // true
  Note.c.inOctave(4).isEnharmonicWith(Note.b.sharp.inOctave(3)); // true
  Note.a.isEnharmonicWith(Note.b.flat); // false

  Note.d.flat.toClass(); // {C♯|D♭}
  Note.a.inOctave(4).toClass(); // {A}

  PitchClass.cSharp * 7; // {G}
  PitchClass.d * 7; // {D}

  PitchClass.cSharp * 5; // {F}
  PitchClass.d * 5; // {A♯|B♭}

  Note.d.flat
    ..toString() // D♭
    ..toString(system: NoteNotation.romance) // Re♭
    ..toString(system: NoteNotation.german); // Des

  Note.b.flat.inOctave(-1).toString(); // B♭-1
  Note.c.inOctave(6).toString(system: PitchNotation.helmholtz); // c′′′

  PitchClass.c.toString(); // {C}
  PitchClass.dSharp.toString(); // {D♯|E♭}

  PitchClass.f.toString(system: PitchClassNotation.integer); // 5
  PitchClass.aSharp.toString(system: PitchClassNotation.integer); // t

  // Intervals
  const Interval.imperfect(Size.tenth, ImperfectQuality.major); // M10
  Interval.d5; // d5
  Size.sixth.augmented; // A6
  Size.eleventh.simple.perfect; // P4

  Interval.parse('m3'); // m3
  Interval.parse('P-5'); // P-5
  Interval.parse('AA6'); // AA6

  -Interval.m7; // m-7
  Interval.M3.descending(); // M-3

  Interval.m3.inversion; // M6
  Interval.A4.inversion; // d5
  Interval.m9.inversion; // M7

  Interval.m9.simple; // m2
  Interval.P11.simple; // P4
  (-Interval.M3).simple; // M-3

  Interval.P5.isCompound; // false
  Interval.M9.isCompound; // true
  (-Interval.P11).isCompound; // true

  Interval.P5.isDissonant; // false
  Interval.d5.isDissonant; // true
  Interval.M7.isDissonant; // true

  Interval.A4.respellBySize(Size.fifth); // d5
  Interval.d3.respellBySize(Size.second); // M2

  Note.c.interval(Note.g); // P5
  Note.d.interval(Note.f.sharp).inversion; // m6

  BaseNote.d.intervalSize(BaseNote.f); // 3
  BaseNote.a.intervalSize(BaseNote.e); // 5

  Interval.P5.distanceBetween(Note.c, Note.d);
  // (2, notes: [Note.c, Note.g, Note.d])
  Interval.P4.distanceBetween(Note.b.flat, Note.d);
  // (-4, notes: [Note.b.flat, Note.f, Note.d, Note.g, Note.d])

  Interval.P5.circleFrom(Note.c, distance: 12).toList();
  // [C, G, D, A, E, B, F♯, C♯, G♯, D♯, A♯, E♯, B♯]
  Note.c.circleOfFifths();
  // (flats: [F, B♭, E♭, A♭, D♭, G♭], sharps: [G, D, A, E, B, F♯])
  Note.c.flatCircleOfFifths(distance: 3); // [E♭, B♭, F, C, G, D, A]

  Note.d.circleOfFifthsDistance; // 2
  Note.a.flat.circleOfFifthsDistance; // -4

  Note.c.fifthsDistanceWith(Note.e.flat); // -3
  Note.b.fifthsDistanceWith(Note.f.sharp); // 1

  Interval.M3.isEnharmonicWith(Interval.d4); // true
  Interval.A4.isEnharmonicWith(Interval.d5); // true
  Interval.P1.isEnharmonicWith(Interval.m2); // false

  Interval.M2.toClass(); // {M2|d3}
  Interval.m6.toClass(); // {M3|d4}
  Interval.P8.toClass(); // {P1}

  Interval.m3 < Interval.P5; // true
  Interval.m7 <= Interval.P5; // false
  -Interval.P4 > Interval.M3; // true

  Interval.m2 + Interval.M2; // m3
  Interval.M2 + Interval.P4; // P5

  IntervalClass.tritone + IntervalClass.M2; // {M3|d4}
  IntervalClass.M3 + IntervalClass.P4; // {m3}
  IntervalClass.P4 - IntervalClass.m3; // {M2|d3}

  IntervalClass.P4 * -1; // {P4}
  IntervalClass.M2 * 0; // {P1}
  IntervalClass.m3 * 2; // {A4|d5}

  Interval.m2.toString(); // m2
  Interval.A6.toString(); // A6

  IntervalClass.M2.toString(); // {M2|d3}
  IntervalClass.P4.toString(); // {P4}
  IntervalClass.tritone.toString(); // {A4|d5}

  // Keys
  const Key(Note.e, TonalMode.minor); // E minor
  Note.a.flat.major; // A♭ major

  Note.d.major.signature; // 2 (F♯ C♯)
  Note.e.flat.minor.signature; // -6 (B♭ E♭ A♭ D♭ G♭ C♭)

  Note.e.major.isTheoretical; // false
  Note.a.flat.minor.isTheoretical; // true

  Note.d.major.relative; // B minor
  Note.c.minor.relative; // E♭ major

  Note.f.minor.parallel; // F major
  Note.c.sharp.major.parallel; // C♯ minor

  Note.d.flat.major.toString(); // D♭ major
  Note.c.major.toString(system: NoteNotation.romance); // Do maggiore
  Note.e.flat.minor.toString(system: NoteNotation.german); // es-moll

  // Key signatures
  KeySignature.fromDistance(4); // 4 (F♯ C♯ G♯ D♯)
  KeySignature([Note.b.flat, Note.e.flat]); // -2 (B♭ E♭)
  KeySignature([Note.g.sharp, Note.a.sharp]); // null (G♯ A♯)

  KeySignature.fromDistance(-4).incrementBy(-1); // -3 (B♭ E♭ A♭)
  KeySignature([Note.f.sharp, Note.c.sharp]).incrementBy(3);
  // 5 (F♯ C♯ G♯ D♯ A♯)

  KeySignature([Note.f.sharp]).keys[TonalMode.major]; // G major
  KeySignature.empty.keys[TonalMode.minor]; // A minor

  KeySignature([Note.a.flat])
    ..isCanonical // false
    ..distance // null
    ..keys; // <TonalMode, Key>{}

  // Modes
  TonalMode.minor.scale; // ScalePattern.minor
  ModalMode.locrian.scale; // ScalePattern.locrian

  ModalMode.lydian.brightness; // 3
  ModalMode.dorian.brightness; // 0
  ModalMode.aeolian.brightness; // -1

  ModalMode.ionian.mirrored; // ModalMode.phrygian
  ModalMode.aeolian.mirrored; // ModalMode.mixolydian

  // Scales
  ScalePattern.lydian.on(Note.d); // D Lydian (D E F♯ G♯ A B C♯ D)
  ScalePattern.wholeTone.on(Note.f); // F Whole-tone (F G A B C♯ D♯ F)
  ScalePattern.majorPentatonic.on(Note.g.flat);
  // G♭ Major pentatonic (G♭ A♭ B♭ D♭ E♭ G♭)

  Note.a.flat.major.scale; // A♭ Major (ionian) (A♭ B♭ C D♭ E♭ F G A♭)
  Note.d.minor.scale; // D Natural minor (aeolian) (D E F G A B♭ C D)

  ScalePattern.lydian.on(Note.e).degree(ScaleDegree.iv); // A♯
  Note.c.major.scale.functionChord(
    HarmonicFunction.dominantV / HarmonicFunction.dominantV,
  ); // D maj. (D F♯ A)

  ({Note.b, Note.a.sharp, Note.d}).inversion.toSet(); // {B, C, G♯}
  ({PitchClass.dSharp, PitchClass.g, PitchClass.fSharp}).retrograde.toSet();
  // {{F♯|G♭}, {G}, {D♯|E♭}}

  ({PitchClass.b, PitchClass.aSharp, PitchClass.d, PitchClass.e})
    ..numericRepresentation.toSet() // {0, 11, 3, 5}
    ..deltaNumericRepresentation.toList(); // [0, -1, 4, 2]

  // Chords
  Chord([Note.a, Note.c.sharp, Note.e]); // A maj. (A C♯ E)
  ChordPattern.augmentedTriad.add11().add13().on(Note.d.sharp);
  // D♯ aug. (D♯ F𝄪 A𝄪 G♯ B♯)

  Note.f.minorTriad.add7().add9(ImperfectQuality.minor);
  // F min. (F A♭ C E♭ G♭)
  Note.e.flat.diminishedTriad.add7().transposeBy(Interval.m2);
  // F♭ dim. (F♭ A𝄫 C𝄫 E𝄫)

  Note.g.minorTriad.major; // G maj. (G B D)
  Note.f.sharp.majorTriad.add9().diminished; // F♯ dim. (F♯ A C G♯)

  // Frequencies
  Note.a.inOctave(4).frequency(); // 440
  Note.a.inOctave(4).frequency(temperature: const Celsius(18));
  // 438.4619866006409

  Note.a.inOctave(4).at(const Frequency(438)); // A438
  TuningFork.a440; // A440
  TuningFork.c256; // C256

  Note.b.flat.inOctave(4).frequency(
        tuningSystem: const EqualTemperament.edo12(TuningFork.c256),
      ); // 456.1401436878537

  const Frequency(432).closestPitch(); // A4-32
  const Frequency(314).closestPitch(); // E♭4+16
  const Frequency(440).closestPitch(temperature: const Celsius(24)); // A4-12

  Note.c.inOctave(1).harmonics(upToIndex: 15);
  // {C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4, D4+4,
  // E4-14, F♯4-49, G4+2, A♭4+41, A♯4-31, B4-12, C5}

  Note.f.sharp.inOctave(4) + const Cent(16); // F♯4+16
  Note.g.flat.inOctave(5) - const Cent(8.236); // G♭5-8

  ClosestPitch.parse('A4'); // A4
  ClosestPitch.parse('A4+12.4'); // A4+12.4
  ClosestPitch.parse('E♭3-28'); // E♭3-28

  // In a nutshell
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
