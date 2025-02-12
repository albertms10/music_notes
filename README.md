![Analysis CI](https://github.com/albertms10/music_notes/workflows/Analysis%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/albertms10/music_notes/badge.svg?branch=main)](https://coveralls.io/github/albertms10/music_notes?branch=main)
[![pub package](https://img.shields.io/pub/v/music_notes.svg)](https://pub.dev/packages/music_notes)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/albertms10/music_notes/badge)](https://api.securityscorecards.dev/projects/github.com/albertms10/music_notes)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/8718/badge)](https://www.bestpractices.dev/projects/8718)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/license/bsd-3-clause/)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

A comprehensive Dart library for effortlessly working with music theory concepts,
offering an elegant and beautifully crafted API.

## Features

- Notes, accidentals, and enharmonic operations
- Intervals, qualities, and circle of fifths
- Chords, scales, harmonic functions, inversions and retrogrades
- Keys, key signatures, and modes
- Frequencies and tuning systems (_work in progress_)

## Usage

Import the package into your Dart code:

```dart
import 'package:music_notes/music_notes.dart';
```

Now, you can use the provided APIs to perform various music theory operations.
For more detailed usage instructions and examples, please refer to the
[API documentation](https://pub.dev/documentation/music_notes/latest/).

### Notes

Define a `Note` from a `BaseNote` and an `Accidental`, or using their
shorthand static constants:

```dart
const Note(BaseNote.e, Accidental.flat); // E♭
Note.c; // C
Note.d; // D
Note.f; // F
```

`BaseNote`s can be obtained from semitones or ordinal:

```dart
BaseNote.fromSemitones(2); // BaseNote.d
BaseNote.fromSemitones(9); // BaseNote.a

BaseNote.fromOrdinal(3); // BaseNote.e
BaseNote.fromOrdinal(7); // BaseNote.b
```

Alter a `Note` with `sharp` or `flat`:

```dart
Note.c.sharp; // C♯
Note.d.flat; // D♭
Note.g.flat.flat; // G𝄫
Note.f.sharp.sharp.sharp; // F𝄪♯
```

And position them in the octave, resulting in `Pitch`es:

```dart
Note.f.inOctave(4); // F4
Note.b.flat.inOctave(5); // B♭5
```

Or parse them in both scientific and Helmholtz notations:

```dart
BaseNote.parse('b'); // BaseNote.b
Note.parse('a#'); // A♯
Pitch.parse("g''"); // G5
Pitch.parse('Eb3'); // E♭3
```

Get their difference in semitones:

```dart
BaseNote.c.difference(BaseNote.e); // 4
BaseNote.a.difference(BaseNote.e); // -5
BaseNote.a.positiveDifference(BaseNote.e); // 7

Note.c.difference(Note.e.flat); // 3
Pitch.parse('C').difference(Pitch.parse("c''''")); // 60
```

Transpose them:

```dart
Note.g.flat.transposeBy(-Interval.m3); // E♭
Note.b.inOctave(3).transposeBy(Interval.P5); // F♯4
```

Respell them by any criteria:

```dart
Note.c.sharp.respellByBaseNote(BaseNote.d); // D♭
Note.e.flat.respellByAccidental(Accidental.sharp); // D♯
Note.g.flat.inOctave(3).respellByOrdinalDistance(-1); // F♯3

Note.g.sharp.respelledUpwards; // A♭
Note.a.flat.respelledDownwards; // G♯
Note.b.sharp.inOctave(4).respelledSimple; // C5
```

Compare two `Pitch`es based on their semitones:

```dart
Note.c.inOctave(4) < Note.c.inOctave(5); // true
Note.d.inOctave(3) > Note.f.inOctave(4); // false
Note.a.flat.inOctave(5) >= Note.g.sharp.inOctave(5); // true
```

Know whether two `Note`s or `Pitch`es are enharmonically equivalent:

```dart
Note.f.sharp.isEnharmonicWith(Note.g.flat); // true
Note.c.inOctave(4).isEnharmonicWith(Note.b.sharp.inOctave(3)); // true
Note.a.isEnharmonicWith(Note.b.flat); // false
```

Represent them as [`PitchClass`es](https://en.wikipedia.org/wiki/Pitch_class):

```dart
Note.d.flat.toClass(); // {C♯|D♭}
Note.a.inOctave(4).toClass(); // {A}
```

Perform [`PitchClass` multiplications (modulo 12)](<https://en.wikipedia.org/wiki/Multiplication_(music)#Pitch-class_multiplication_modulo_12>):

```dart
PitchClass.cSharp * 7; // {G}
PitchClass.d * 7; // {D}
// observe one semitone upwards results in ascending fifths G -> D.

PitchClass.cSharp * 5; // {F}
PitchClass.d * 5; // {A♯|B♭}
// observe one semitone upwards results in ascending fourths F -> B-flat.
```

Represent them using any notation system:

```dart
Note.d.flat
  ..toString() // D♭
  ..toString(system: NoteNotation.romance) // Re♭
  ..toString(system: NoteNotation.german); // Des

Note.b.flat.inOctave(-1).toString(); // B♭-1
Note.c.inOctave(6).toString(system: PitchNotation.helmholtz); // c‴

PitchClass.c.toString(); // {C}
PitchClass.dSharp.toString(); // {D♯|E♭}

PitchClass.f.toString(system: PitchClassNotation.integer); // 5
PitchClass.aSharp.toString(system: PitchClassNotation.integer); // t
```

### Intervals

Create an `Interval`:

```dart
const Interval.imperfect(Size.tenth, ImperfectQuality.major); // M10
Interval.d5; // d5
Size.sixth.augmented; // A6
Size.eleventh.simple.perfect; // P4
```

Or parse it from a string:

```dart
Interval.parse('m3'); // m3
Interval.parse('P-5'); // P-5
Interval.parse('AA6'); // AA6
```

Turn it descending:

```dart
-Interval.m7; // m-7
Interval.M3.descending(); // M-3
(-Interval.P4).descending(false); // P4
```

Perform common interval operations:

```dart
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
```

Respell an `Interval` by size:

```dart
Interval.A4.respellBySize(Size.fifth); // d5
Interval.d3.respellBySize(Size.second); // M2
```

Calculate the `Interval` between two notes:

```dart
Note.c.interval(Note.g); // P5
Note.d.interval(Note.f.sharp).inversion; // m6

BaseNote.d.intervalSize(BaseNote.f); // 3
BaseNote.a.intervalSize(BaseNote.e); // 5
```

Know the intervallic distance between two notes:

```dart
Interval.P5.circleDistance(from: Note.c, to: Note.d);
// (2, notes: [Note.c, Note.g, Note.d])
Interval.P4.circleDistance(from: Note.b.flat, to: Note.d);
// (-4, notes: [Note.b.flat, Note.f, Note.d, Note.g, Note.d])
```

And even explore the circle of fifths or any circle of intervals
up to a distance:

```dart
Interval.P5.circleFrom(Note.c).take(13).toList();
// [C, G, D, A, E, B, F♯, C♯, G♯, D♯, A♯, E♯, B♯]
Note.c.circleOfFifths(distance: 3); // [E♭, B♭, F, C, G, D, A]
Note.c.splitCircleOfFifths.down.take(6).toList();
// [F, B♭, E♭, A♭, D♭, G♭]
Note.c.splitCircleOfFifths.up.take(8).toList();
// [G, D, A, E, B, F♯, C♯, G♯]

Note.d.circleOfFifthsDistance; // 2
Note.a.flat.circleOfFifthsDistance; // -4

Note.c.fifthsDistanceWith(Note.e.flat); // -3
Note.b.fifthsDistanceWith(Note.f.sharp); // 1
```

Know whether two `Interval`s are enharmonically equivalent:

```dart
Interval.M3.isEnharmonicWith(Interval.d4); // true
Interval.A4.isEnharmonicWith(Interval.d5); // true
Interval.P1.isEnharmonicWith(Interval.m2); // false
```

Represent them as [`IntervalClass`es](https://en.wikipedia.org/wiki/Interval_class):

```dart
Interval.M2.toClass(); // {M2|d3}
Interval.m6.toClass(); // {M3|d4}
Interval.P8.toClass(); // {P1}
```

Compare two `Interval`s based on their semitones:

```dart
Interval.m3 < Interval.P5; // true
Interval.m7 <= Interval.P5; // false
-Interval.P4 > Interval.M3; // true
```

Add, subtract and multiply `Interval`s and `IntervalClass`es:

```dart
Interval.m2 + Interval.M2; // m3
Interval.M2 + Interval.P4; // P5

IntervalClass.tritone + IntervalClass.M2; // {M3|d4}
IntervalClass.M3 + IntervalClass.P4; // {m3}
IntervalClass.P4 - IntervalClass.m3; // {M2|d3}

IntervalClass.P4 * -1; // {P4}
IntervalClass.M2 * 0; // {P1}
IntervalClass.m3 * 2; // {A4|d5}
```

Represent them as a string:

```dart
Interval.m2.toString(); // m2
Interval.A6.toString(); // A6

IntervalClass.M2.toString(); // {M2|d3}
IntervalClass.P4.toString(); // {P4}
IntervalClass.tritone.toString(); // {A4|d5}
```

### Keys

Create a `Key` or get it from a given `Note`:

```dart
const Key(Note.e, TonalMode.minor); // E minor
Note.a.flat.major; // A♭ major
```

Know its `KeySignature`:

```dart
Note.d.major.signature; // 2 (F♯ C♯)
Note.e.flat.minor.signature; // -6 (B♭ E♭ A♭ D♭ G♭ C♭)
```

Whether it is theoretical:

```dart
Note.e.major.isTheoretical; // false
Note.a.flat.minor.isTheoretical; // true
```

And its relative and parallel `Key`s:

```dart
Note.d.major.relative; // B minor
Note.c.minor.relative; // E♭ major

Note.f.minor.parallel; // F major
Note.c.sharp.major.parallel; // C♯ minor
```

Represent it using any notation system:

```dart
Note.d.flat.major.toString(); // D♭ major
Note.c.major.toString(system: NoteNotation.romance); // Do maggiore
Note.e.flat.minor.toString(system: NoteNotation.german); // es-moll
```

### Key signatures

Create a `KeySignature`:

```dart
KeySignature.fromDistance(4); // 4 (F♯ C♯ G♯ D♯)
KeySignature([Note.b.flat, Note.e.flat]); // -2 (B♭ E♭)
KeySignature([Note.g.sharp, Note.a.sharp]); // null (G♯ A♯)
```

Increment them by sharps or flats:

```dart
KeySignature.fromDistance(-4).incrementBy(-1); // -3 (B♭ E♭ A♭)
KeySignature([Note.f.sharp, Note.c.sharp]).incrementBy(3);
// 5 (F♯ C♯ G♯ D♯ A♯)
```

And know its `Key`s:

```dart
KeySignature([Note.f.sharp]).keys[TonalMode.major]; // G major
KeySignature.empty.keys[TonalMode.minor]; // A minor
```

Non-canonical key signatures are also supported, although they
return `null` when asked about their fifths distance or keys:

```dart
KeySignature([Note.a.flat])
  ..isCanonical // false
  ..distance // null
  ..keys; // <TonalMode, Key>{}
```

### Modes

Get each `Mode`’s `ScalePattern`:

```dart
TonalMode.minor.scale; // ScalePattern.minor
ModalMode.locrian.scale; // ScalePattern.locrian
```

Their [Dorian Brightness Quotient]:

```dart
ModalMode.lydian.brightness; // 3
ModalMode.dorian.brightness; // 0
ModalMode.aeolian.brightness; // -1
```

Or its mirrored version:

```dart
ModalMode.ionian.mirrored; // ModalMode.phrygian
ModalMode.aeolian.mirrored; // ModalMode.mixolydian
```

### Scales

Create a `Scale` from a `ScalePattern`:

```dart
ScalePattern.lydian.on(Note.d); // D Lydian (D E F♯ G♯ A B C♯ D)
ScalePattern.wholeTone.on(Note.f); // F Whole-tone (F G A B C♯ D♯ F)
ScalePattern.majorPentatonic.on(Note.g.flat);
// G♭ Major pentatonic (G♭ A♭ B♭ D♭ E♭ G♭)
```

Or get it from a `Key`:

```dart
Note.a.flat.major.scale; // A♭ Major (ionian) (A♭ B♭ C D♭ E♭ F G A♭)
Note.d.minor.scale; // D Natural minor (aeolian) (D E F G A B♭ C D)
```

Even experiment with any `ScaleDegree` or `HarmonicFunction`:

```dart
ScalePattern.lydian.on(Note.e).degree(ScaleDegree.iv); // A♯
Note.c.major.scale.functionChord(
  HarmonicFunction.dominantV / HarmonicFunction.dominantV,
); // D maj. (D F♯ A)
```

Rearrange any collection of `Note`s, `Pitch`es or `PitchClass`es
as `inversion` or `retrograde`:

```dart
({Note.b, Note.a.sharp, Note.d}).inversion.toSet(); // {B, C, G♯}
({PitchClass.dSharp, PitchClass.g, PitchClass.fSharp}).retrograde.toSet();
// {{F♯|G♭}, {G}, {D♯|E♭}}
```

Or know its numeric representation:

```dart
({PitchClass.b, PitchClass.aSharp, PitchClass.d, PitchClass.e})
  ..numericRepresentation()
      .toSet() // {0, 11, 3, 5}
  ..numericRepresentation(reference: PitchClass.d)
      .toSet() // {9, 8, 0, 2}
  ..deltaNumericRepresentation.toList(); // [0, -1, 4, 2]
```

### Chords

Create a `Chord` from a series of `Note`s or a `ChordPattern`:

```dart
Chord([Note.a, Note.c.sharp, Note.e]); // A maj. (A C♯ E)
ChordPattern.augmentedTriad.add11().add13().on(Note.d.sharp);
// D♯ aug. (D♯ F𝄪 A𝄪 G♯ B♯)
```

Or build it on top of a `Note`:

```dart
Note.f.minorTriad.add7().add9(ImperfectQuality.minor);
// F min. (F A♭ C E♭ G♭)
Note.e.flat.diminishedTriad.add7().transposeBy(Interval.m2);
// F♭ dim. (F♭ A𝄫 C𝄫 E𝄫)
```

Or modify its root triad:

```dart
Note.g.minorTriad.major; // G maj. (G B D)
Note.f.sharp.majorTriad.add9().diminished; // F♯ dim. (F♯ A C G♯)
```

### Frequencies

Get the `Frequency` of a `Pitch`:

```dart
Note.a.inOctave(4).frequency(); // 440
Note.a.inOctave(4).frequency(temperature: const Celsius(18));
// 438.4619866006409
```

Create a `TuningFork` from a `Pitch` and a reference `Frequency`,
or using its shorthand static constants:

```dart
Note.a.inOctave(4).at(const Frequency(438)); // A438
TuningFork.a440; // A440
TuningFork.c256; // C256
```

And use it in a `TuningSystem`:

```dart
Note.b.flat
    .inOctave(4)
    .frequency(
      tuningSystem: const EqualTemperament.edo12(fork: TuningFork.c256),
    ); // 456.1401436878537
```

Get the `Frequency` at a given temperature:

```dart
const Frequency(440).at(const Celsius(18)); // 438.4619866006409
const Frequency(440).at(const Celsius(24)); // 443.07602679871826
```

Get the closest `Pitch` from a given `Frequency`:

```dart
const Frequency(432).closestPitch(); // A4-32
const Frequency(314).closestPitch(); // E♭4+16
const Frequency(440).closestPitch(temperature: const Celsius(24)); // A4-12
```

And combining both `frequency` and `closestPitch` methods,
the harmonic series of a given `Pitch`:

```dart
Note.c.inOctave(1).harmonics(upToIndex: 15);
// {C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4, D4+4,
// E4-14, F♯4-49, G4+2, A♭4+41, A♯4-31, B4-12, C5}
```

Create a `ClosestPitch` by adding or subtracting `Cent`s to a `Pitch`:

```dart
Note.f.sharp.inOctave(4) + const Cent(16); // F♯4+16
Note.g.flat.inOctave(5) - const Cent(8.236); // G♭5-8
```

Or parse a `ClosestPitch` from a string:

```dart
ClosestPitch.parse('A4'); // A4
ClosestPitch.parse('A4+12.6'); // A4+13
ClosestPitch.parse('E♭3-28'); // E♭3-28
```

### In a nutshell

```dart
ScalePattern
    .lydian // Lydian (M2 M2 M2 m2 M2 M2 m2)
    .on(Note.parse('a')) // A Lydian (A B C♯ D♯ E F♯ G♯ A)
    .transposeBy(Interval.M2) // B Lydian (B C♯ D♯ E♯ F♯ G♯ A♯ B)
    .degree(ScaleDegree.iii) // D♯
    .respelledUpwards // E♭
    .major // E♭ major
    .relative // C minor
    .scale // C Natural minor (aeolian) (C D E♭ F G A♭ B♭ C)
    .degreeChord(ScaleDegree.v) // G min. (G B♭ D)
    .add9(); // G min. (G B♭ D A)
```

## Similar projects in other languages

- **Mingus** [Python](https://github.com/bspaans/python-mingus)
- **Modest** [Lua](https://github.com/esbudylin/modest)
- **Sharp11** [JavaScript](https://github.com/jsrmath/sharp11)
- **Teoria** [JavaScript](https://github.com/saebekassebil/teoria)
- **Tonal** [JavaScript](https://github.com/tonaljs/tonal)
- **Tonic** [JavaScript](https://github.com/osteele/tonic.ts) | [Dart](https://github.com/osteele/dart-tonic)

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/albertms10/music_notes/pulls).

## Star History

<a href="https://star-history.com/#albertms10/music_notes&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=albertms10/music_notes&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=albertms10/music_notes&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=albertms10/music_notes&type=Date" />
  </picture>
</a>

## License

This package is released under the [BSD-3-Clause License](LICENSE).

[Dorian Brightness Quotient]: https://mynewmicrophone.com/dorian-brightness-quotient
