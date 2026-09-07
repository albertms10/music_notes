![Analysis CI](https://github.com/albertms10/music_notes/actions/workflows/analysis-ci.yaml/badge.svg?branch=main)
[![Coverage Status](https://coveralls.io/repos/github/albertms10/music_notes/badge.svg?branch=main)](https://coveralls.io/github/albertms10/music_notes?branch=main)
[![pub package](https://img.shields.io/pub/v/music_notes.svg)](https://pub.dev/packages/music_notes)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/albertms10/music_notes/badge)](https://api.securityscorecards.dev/projects/github.com/albertms10/music_notes)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/8718/badge)](https://www.bestpractices.dev/projects/8718)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/license/bsd-3-clause/)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

A Dart library for music theory: notes, accidentals, intervals, chords,
scales, keys, key signatures, harmonic functions, and tuning systems, with
MIDI conversion and parsing/formatting across scientific, Helmholtz, ABC,
English, German, and Romance notations.

This README focuses on how the library models music theory:
which class owns which concept, and how they compose.
If you've ever hand-transposed a lead sheet at midnight and made an
arithmetic error on the fourth bar, this is the library that does that
arithmetic for you. :)

## Usage

Import the package into your Dart code:

```dart
import 'package:music_notes/music_notes.dart';
```

## A five-second tour

```dart
Note.a.major          // A major (Key)
    .scale            // A Major (ionian) (A B C♯ D♯ E F♯ G♯ A)
    .degreeChord(.vi) // F♯
    .add7()           // F♯7
    .toPitches();     // [F♯4, A4, C♯5, E5]
```

A key resolves to a scale, a scale degree resolves to a chord, a chord
resolves to a stack of octave-positioned pitches. The rest of this README
walks through each layer.

## Notes and accidentals

A `Note` is a `NoteName` (`.a` through `.g`) plus an `Accidental`. Chained
`sharp`/`flat` getters build up multiple accidentals, and `natural` strips
them back off:

```dart
const Note(.e, .flat);    // E♭
Note.g.flat.flat;         // G𝄫
Note.f.sharp.sharp.sharp; // F𝄪♯
Note.g.flat.flat.natural; // G
```

Parsing accepts the same shorthand you’d type by hand, and `format` mirrors
it back, optionally through a different notation:

```dart
Note.parse('a#'); // A♯

Note.d.flat
  ..format()                                    // D♭
  ..format(const GermanNoteNotation())          // Des
  ..format(const RomanceNoteNotation.symbol()); // Re♭
```

Enharmonic respelling keeps the pitch but changes the spelling, which
matters once you start voice-leading or modulating:

```dart
Note.c.sharp.respellByNoteName(.d);     // D♭
Note.g.sharp.respelledUpwards;          // A♭
Note.f.sharp.isEnharmonicWith(.g.flat); // true
```

`PitchClass` is the octave-independent version of a note, useful for set
theory or [pitch-class multiplication](<https://en.wikipedia.org/wiki/Multiplication_(music)#Pitch-class_multiplication_modulo_12>):

```dart
Note.d.flat.toClass(); // {C♯|D♭}
PitchClass.cSharp * 7; // {G} (a fifths transform)
```

## Intervals

Build an `Interval` from a `Size` and a `Quality`, or reach for a static
shorthand. Sizes carry their own quality getters, which reads close to how
you'd say it out loud:

```dart
Interval.d5;                              // diminished fifth
Size.sixth.augmented;                     // A6
const Interval.imperfect(.tenth, .major); // M10
Interval.parse('P-5');                    // a descending perfect fifth
```

Intervals negate to flip direction, and carry the usual set of derived
properties:

```dart
-Interval.m7;            // m-7
Interval.m9.inversion;   // M7
Interval.M9.simple;      // M2
Interval.d5.isDissonant; // true
```

Two notes resolve to the interval between them, and that interval inverts,
respells, or reduces to an `IntervalClass` when direction and exact spelling
stop mattering:

```dart
Note.c.interval(.g);                 // P5
Note.d.interval(.f.sharp).inversion; // m6
Interval.A4.respellBySize(.fifth);   // d5
Interval.M2.toClass();               // {M2|d3}
```

The circle of fifths falls out of repeated `Interval.P5` transposition, and
`Note` exposes it directly for the common case:

```dart
Note.c.circleOfFifths(distance: 3); // [E♭, B♭, F, C, G, D, A]
Note.c.fifthsDistanceWith(.e.flat); // -3
```

## Pitches

A `Pitch` is a `Note` fixed to an `octave`. It's `Comparable`, supports
MIDI conversion, and transposes the same way a `Note` does, just with
octave bookkeeping handled for you:

```dart
Note.c.inOctave(4) < Note.c.inOctave(5); // true
Pitch.fromMidi(69);                      // A4
Note.a.inOctave(4).midiNumber;           // 69
Note.b.inOctave(3).transposeBy(.P5);     // F♯4
```

Scientific and Helmholtz notation both parse and format:

```dart
Pitch.parse("g''"); // G5
Pitch.parse('Eb3'); // E♭3

Note.c.inOctave(6).format(HelmholtzPitchNotation.english); // c‴
```

Lists of notes turn into voicings: stacked ascending from an octave, or
built like an arranger would, one voice moved at a time:

```dart
const <Note>[.c, .e, .g, .b].toStacked().drop(2); // [G3, C4, E4, B4]
```

## Keys and key signatures

A `Key` pairs a tonic `Note` with a `TonalMode`. Its `signature`, `relative`,
and `parallel` keys are all derived, not stored:

```dart
Note.e.flat.minor
  ..signature      // {G♭ major, E♭ minor} −6 fifths (B♭ E♭ A♭ D♭ G♭ C♭)
  ..relative       // G♭ major
  ..parallel       // E♭ major
  ..isTheoretical; // false
```

`relationshipWith` classifies how far two keys sit from each other, taking
both the fifths distance and any change of mode into account:

```dart
Note.c.major.relationshipWith(Note.e.flat.minor);
// (distance: -3, relationship: KeyRelationship.doubleDirect)
```

`KeySignature` is the other direction: build one from a number of fifths,
then read off which keys it belongs to. Non-canonical signatures (an odd
mix of sharps and flats) simply report `null` instead of throwing:

```dart
KeySignature.fromDistance(-6).keys[TonalMode.minor]; // E♭ minor
KeySignature([.g.sharp]).isCanonical;                // false
```

## Modes and scales

`ScalePattern` holds interval steps; calling `.on(note)` realizes it as a
`Scale`. Built-in patterns cover the major modes, harmonic and melodic
minor, whole-tone, pentatonic, octatonic, and double harmonic major:

```dart
final lydian = ScalePattern.lydian.on(Note.d);
// D Lydian (D E F♯ G♯ A B C♯ D)

lydian.degree(.iv);      // G♯
lydian.transposeBy(.M2); // E Lydian
```

Modes carry a [Dorian brightness quotient] for comparing how bright or dark
they sound relative to each other, and mirror into their tonal opposite:

```dart
ModalMode.lydian.brightness; // 3
ModalMode.locrian.mirrored;  // ModalMode.lydian
```

Scale degrees resolve straight to chords, which is how you'd sketch a
progression without naming every chord by hand:

```dart
Note.c.major.scale.degreeChords();
// [C, Dm, Em, F, G, Am, Bdim]
```

## Chords

`ChordPattern` is a shape (intervals from a root); `Chord` is that shape
anchored to a `Note`. Extensions read like chord symbols do:

```dart
Note.f.minorTriad.add7().add9(.minor);     // F-7 ♭9
Note.f.sharp.majorTriad.add9().diminished; // F♯dim
```

`sus2`/`sus4` replace the third the way they do on a chart:

```dart
Note.f.sharp.minorTriad.add7().sus2(); // [F♯, G♯, C♯, E]
```

Inversions are computed from the interval content, not stored separately,
so a chord built in any order still knows its own inversion number and its
root position:

```dart
const Chord([.e, .g, .c]).inversion;    // 1
const Chord([.e, .g, .c]).rootPosition; // C major triad
```

For actual voicings, `toVoicing` places each chord tone at the nearest
occurrence above the previous one, doubling a repeated index an octave up
rather than in unison:

```dart
ChordPattern.majorTriad.add7().on(.c).toVoicing([0, 1, 2, 3, 0]);
// [C4, E4, G4, B♭4, C5]
```

Chord symbols parse and format with slash notation for inversions and
foreign basses:

```dart
Chord.parse('Cmaj7/E')
  ..items     // [E, G, B, C]
  ..format(); // Cmaj7/E
```

## Harmonic functions and scale degrees

`HarmonicFunction` models a scale degree, an optional chord shape on top of
it, and an optional tonicization, so secondary dominants and chains of
applied chords compose with `/`:

```dart
HarmonicFunction.dominantV / .dominantV;     // V/V
(HarmonicFunction.ii / .dominantV).format(); // II/V
```

Resolve a harmonic function against a scale to get the actual chord it
points to:

```dart
Note.g.major.scale.functionChord(HarmonicFunction.dominantV / .dominantV);
// A
```

Scale degrees themselves format as roman numerals by default, but also as
scale-degree carets or movable-do solfège:

```dart
ScaleDegree.iv.raised.format(const NumericScaleDegreeNotation()); // ♯4̂
ScaleDegree.i.format(const SolfegeScaleDegreeNotation());         // Do
```

## Why not just use semitones as integers?

You can get surprisingly far treating pitch as `int % 12`, until you need
to know whether a note is a D♯ or an E♭. That distinction is invisible to
an integer and load-bearing to a musician: it's the difference between a
chord spelled correctly on a page and one a sight-reader has to decode.
`music_notes` keeps note names, accidentals, and enharmonic spelling as
first-class, separate from raw semitone math, so respelling, key
signatures, and correctly-spelled chord extensions all stay possible
without you reverse-engineering them from a pitch class.

## Frequencies and tuning systems

Any `Pitch` resolves to a `Frequency` under a given tuning system and
temperature. The default is 12-tone equal temperament at A440:

```dart
Note.a.inOctave(4).frequency(); // 440 Hz

Note.a.inOctave(4).frequency(temperature: const Celsius(18)); // 438.46 Hz
```

A `TuningFork` fixes a reference pitch to a reference frequency, which lets
you tune to something other than A440:

```dart
TuningFork.a440; // A440
TuningFork.c256; // C256

Note.a.inOctave(4).at(const Frequency(438)); // A438
```

Alternative tuning systems change the ratios themselves, not just the
reference pitch. `centsOffset` shows how far each drifts from 12-EDO for a
given pitch:

```dart
const pythagorean = PythagoreanTuning();
const meantone = MeantoneTuning.quarter;

pythagorean.centsOffset(Note.g.inOctave(4)); // ≈ +2 cents
meantone.centsOffset(Note.g.inOctave(4));    // ≈ −3.4 cents
```

Every tuning system here is a historical compromise about which intervals
get to be in tune at the expense of the others. 12-EDO just happens to be
the compromise everybody eventually stopped arguing about.

Going the other way, the closest playable pitch to an arbitrary frequency
comes back with its deviation in cents:

```dart
const Frequency(432).closestPitch(); // A4−32
```

And the harmonic series of a fundamental is just repeated closest-pitch
lookups over successive multiples:

```dart
Note.c.inOctave(1).harmonics().take(4).toSet();
// {C1±0, C2±0, G2+2, C3±0}
```

## Notation systems and parsing

Every formatter in this library implements `parse` and `format` as
inverses of each other, and most support several languages plus an ASCII
fallback for terminals or file names that can't hold Unicode symbols:

```dart
Key.parse('f# minor'); // F♯ minor
Note.b.flat.inOctave(4).format(); // B♭4

const NoteNotation.ascii(); // renders ♯/♭ as #/b
```

When more than one notation might match, a chain tries each in order and
uses the first one that fits:

```dart
const chain = [EnglishNoteNotation(), GermanNoteNotation()];
chain.firstMatchingParser('C'); // EnglishNoteNotation
chain.firstMatchingParser('h'); // GermanNoteNotation
```

## Common questions this API answers

- What note is MIDI number 61? → `Pitch.fromMidi(61)`
- What's the key signature for E♭ minor? → `Note.e.flat.minor.signature`
- Is this chord in root position or an inversion? → `chord.inversion`
- What frequency is A4 at 18°C? → `Note.a.inOctave(4).frequency(temperature: const Celsius(18))`
- What's the relative major of C♯ minor? → `Note.c.sharp.minor.relative`

## Similar projects in other languages

- `mingus` [Python](https://github.com/bspaans/python-mingus)
- `modest` [Lua](https://github.com/esbudylin/modest)
- `music21` [Python](https://github.com/cuthbertLab/music21)
- `sharp11` [JavaScript](https://github.com/jsrmath/sharp11)
- `teoria` [JavaScript](https://github.com/saebekassebil/teoria)
- `tonal` [JavaScript](https://github.com/tonaljs/tonal)
- `tonic` [JavaScript](https://github.com/osteele/tonic.ts) | [Dart](https://github.com/osteele/dart-tonic)

## Contributing

Issues and pull requests are welcome on the
[GitHub repository](https://github.com/albertms10/music_notes/pulls).

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
