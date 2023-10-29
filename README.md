![Analysis CI](https://github.com/albertms10/music_notes/workflows/Analysis%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/albertms10/music_notes/badge.svg?branch=main)](https://coveralls.io/github/albertms10/music_notes?branch=main)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![pub package](https://img.shields.io/pub/v/music_notes.svg)](https://pub.dev/packages/music_notes)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/license/bsd-3-clause/)

A simple Dart library that provides a comprehensive set of utilities for working with music theory concepts through a beautifully crafted API.

## Features

- Chords, harmonic functions, and circle of fifths
- Intervals and qualities
- Notes, frequencies, accidentals, and enharmonic operations
- Scales and scale degrees
- Tonalities, key signatures, and modes
- Tuning systems (_work in progress_)

## Usage

Import the package into your Dart code:

```dart
import 'package:music_notes/music_notes.dart';
```

Now, you can use the provided APIs to perform various music theory operations. For more detailed usage instructions and examples, please refer to the [API documentation](https://pub.dev/documentation/music_notes/latest/).

### Notes

Define `Note`s from the musical scale:

```dart
Note.c; // C
Note.d; // D
Note.f; // F
```

Alter them:

```dart
Note.c.sharp; // C♯
Note.d.flat; // D♭
Note.g.flat.flat; // G𝄫
Note.f.sharp.sharp.sharp; // F𝄪♯
```

And position them in the octave, resulting in `PositionedNote`s:

```dart
Note.f.inOctave(4); // F4
Note.b.flat.inOctave(5); // B♭5
```

Or just parse them in both scientific and Helmholtz notations:

```dart
Note.parse('a#'); // A♯
PositionedNote.parse("g''"); // G5
PositionedNote.parse('Eb3'); // E♭3
```

### Intervals

Create an `Interval`:

```dart
const Interval.perfect(5, PerfectQuality.perfect); // P5
Interval.P4; // P4
```

Or turn it descending:

```dart
-Interval.P4; // desc P4
Interval.M3.descending(); // desc M3
```

Calculate the `Interval` between two notes:

```dart
Note.c.interval(Note.g); // P5
Note.d.interval(Note.f.sharp).inverted; // m6
Note.g.flat.transposeBy(-Interval.m3); // E♭
```

And even play with the circle of fifths or any circle of intervals up to a distance:

```dart
Interval.P5.circleFrom(Note.c, distance: 12);
// [C, G, D, A, E, B, F♯, C♯, G♯, D♯, A♯, E♯, B♯]
Note.c.circleOfFifths();
// (flats: [F, B♭, E♭, A♭, D♭, G♭], sharps: [G, D, A, E, B, F♯])
```

### Tonalities

Create a `Tonality` or get it from a given `Note`:

```dart
const Tonality(Note.e, TonalMode.minor); // E minor
Note.a.flat.major; // A♭ major
```

Know its `KeySignature`:

```dart
Note.d.major.keySignature; // 2 (F♯ C♯)
Note.e.flat.minor.keySignature; // -6 (B♭ E♭ A♭ D♭ G♭ C♭)
```

And its relative `Tonality`:

```dart
Note.d.major.relative; // B minor
Note.c.minor.relative; // E♭ major
```

### Key signatures

Create a `KeySignature`:

```dart
KeySignature([Note.b.flat, Note.e.flat]); // 2 (B♭ E♭)
KeySignature.fromDistance(4); // 4 (F♯ C♯ G♯ D♯)
```

And know its tonalities:

```dart
KeySignature([Note.f.sharp]).tonalities.major; // G major
KeySignature.fromDistance(-3).tonalities.minor; // C minor
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

Or get it from a `Tonality`:

```dart
Note.a.flat.major.scale; // A♭ Major (ionian) (A♭ B♭ C D♭ E♭ F G A♭)
Note.d.minor.scale; // D Natural minor (aeolian) (D E F G A B♭ C D)
```

Even play with any `ScaleDegree` or `HarmonicFunction`:

```dart
ScalePattern.lydian.on(Note.e).degree(ScaleDegree.iv); // A♯
Note.c.major.scale.functionChord(
  HarmonicFunction.dominantV / HarmonicFunction.dominantV,
); // D maj. (D F♯ A)
```

### Chords

Create a `Chord` from a series of `Note`s or from a `ChordPattern`:

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

Get the `Frequency` of a `PositionedNote`:

```dart
Note.a.inOctave(4).frequency(); // 440.0 Hz
Note.b.flat.inOctave(4).frequency(
      referenceFrequency: const Frequency(256),
      tuningSystem: EqualTemperament.edo12(referenceNote: Note.c.inOctave(4)),
    ); // 456.1401436878537 Hz
```

Get the closest note from a given `Frequency`:

```dart
const Frequency(415).closestPositionedNote();
// (G♯4, cents: -1.2706247484469828 ¢, hertz: -0.3046975799451275)
```

And combining both methods, the harmonic series of a given `PositionedNote`:

```dart
Note.c
    .inOctave(1)
    .frequency()
    .harmonics(upToIndex: 15)
    .map((frequency) => frequency.closestPositionedNote().displayString())
    .toSet();
// {C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4, D4+4, E4-14, F♯4-49, G4+2,
// A♭4+41, A♯4-31, B4-12, C5}
```

### In a nutshell

```dart
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
```

## Inspiration

This library is inspired by a range of music theory projects.

- [Teoria.js](https://github.com/saebekassebil/teoria)
- [Tonal](https://github.com/tonaljs/tonal)
- [Tonic](https://github.com/osteele/dart-tonic)

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/albertms10/music_notes/pulls).

## License

This package is released under the [BSD-3-Clause License](LICENSE).

[Dorian Brightness Quotient]: https://mynewmicrophone.com/dorian-brightness-quotient
