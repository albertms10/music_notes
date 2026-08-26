import 'dart:collection' show UnmodifiableListView;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Chord', () {
    group('.items', () {
      test('returns an unmodifiable collection', () {
        expect(
          ChordPattern.majorTriad.on(.c).items,
          isA<UnmodifiableListView<Note>>(),
        );
      });
    });

    group('.fromPitches()', () {
      test('drops octave information', () {
        expect(
          Chord.fromPitches(<Note>[.c, .e, .g].inOctave(4)),
          const Chord([.c, .e, .g]),
        );
      });

      test('deduplicates doubled tones, keeping first (bass) occurrence', () {
        expect(
          Chord.fromPitches([
            Note.c.inOctave(3),
            Note.e.inOctave(3),
            Note.g.inOctave(3),
            Note.c.inOctave(4),
          ]),
          const Chord([.c, .e, .g]),
        );
      });

      test('preserves inversion via the bass (first) pitch', () {
        expect(
          Chord.fromPitches([
            Note.e.inOctave(3),
            Note.g.inOctave(3),
            Note.c.inOctave(4),
          ]),
          const Chord([.e, .g, .c]),
        );
      });

      test('round-trips identity for a non-doubled, ordered voicing', () {
        final voicing = <Note>[.c, .e, .g].inOctave(4);
        expect(Chord.fromPitches(voicing).toPitches(), voicing);
      });
    });

    group('.root', () {
      test('returns the root of this Chord', () {
        expect(ChordPattern.majorTriad.on(.f).root, Note.f);
      });
    });

    group('.pattern', () {
      test('returns the ChordPattern for this Chord', () {
        expect(ChordPattern.majorTriad.on(.c).pattern, ChordPattern.majorTriad);
        expect(
          const Chord([.a, .c, .e, .g]).pattern,
          ChordPattern.minorTriad.add7(),
        );
        expect(
          const Chord([.c, .e, .g, .b, .d, .f]).pattern,
          ChordPattern.majorTriad.add7(.major).add9().add11(),
        );
      });
    });

    group('.isRootPosition', () {
      test('returns whether this Chord’s pattern is in root position', () {
        expect(ChordPattern.majorTriad.on(.c).isRootPosition, isTrue);
        expect(
          ChordPattern.majorTriad.add7(.major).on(.c).isRootPosition,
          isTrue,
        );
        expect(const Chord([.e, .g, .c]).isRootPosition, isFalse);
        expect(const Chord([.g, .c, .e]).isRootPosition, isFalse);
      });
    });

    group('.inverted', () {
      test('rotates this Chord to its next inversion', () {
        expect(
          ChordPattern.majorTriad.on(.c).inverted,
          const Chord([.e, .g, .c]),
        );
        expect(const Chord([.e, .g, .c]).inverted, const Chord([.g, .c, .e]));
        expect(
          const Chord([.g, .c, .e]).inverted,
          ChordPattern.majorTriad.on(.c),
        );
      });

      test('returns the same Chord for a single-note Chord', () {
        expect(const Chord([.c]).inverted, const Chord([.c]));
      });
    });

    group('.inversion', () {
      test('returns the inversion number of this Chord', () {
        expect(ChordPattern.majorTriad.on(.c).inversion, 0);
        expect(const Chord([.e, .g, .c]).inversion, 1);
        expect(const Chord([.g, .c, .e]).inversion, 2);
        expect(ChordPattern.majorTriad.add7(.major).on(.c).inversion, 0);
        expect(const Chord([.e, .g, .b, .c]).inversion, 1);
        expect(const Chord([.g, .b, .c, .e]).inversion, 2);
        expect(const Chord([.b, .c, .e, .g]).inversion, 3);
      });
    });

    group('.rootPosition', () {
      test('throws a StateError on a non-tertian Chord', () {
        expect(
          () => const Chord([.d, .c, .e, .g]).rootPosition,
          throwsStateError,
        );
      });

      test('rewrites this Chord in root position', () {
        expect(
          const Chord([.e, .g, .c]).rootPosition,
          ChordPattern.majorTriad.on(.c),
        );
        expect(
          const Chord([.g, .c, .e]).rootPosition,
          ChordPattern.majorTriad.on(.c),
        );
        expect(
          const Chord([.g, .b, .c, .e]).rootPosition,
          ChordPattern.majorTriad.add7(.major).on(.c),
        );
        expect(
          ChordPattern.majorTriad.on(.c).rootPosition,
          ChordPattern.majorTriad.on(.c),
        );

        expect(
          skip: 'Sort out repeated notes in a Chord',
          () => const Chord([.c, .e, .g, .c]).rootPosition,
          const Chord([.c, .e, .g]),
        );
        expect(
          skip: 'Should this be the expected output disposition?',
          const Chord([.e, .c, .g]).rootPosition,
          const Chord([.c, .g, .e]),
        );

        expect(
          Chord([.b.flat, .c, .e, .g]).rootPosition,
          Chord([.c, .e, .g, .b.flat]),
        );
        expect(
          skip: 'Unsupported open disposition',
          () => Chord([.b.flat, .c, .g, .e]).rootPosition,
          Chord([.c, .e, .g, .b.flat]),
        );
        expect(
          skip: 'Unsupported non-tertian chords',
          () => Chord([.b.flat, .c, .g, .f]).rootPosition,
          Chord([.c, .f, .g, .b.flat]),
        );

        expect(
          Chord([.d, .f, .a.flat, .b]).rootPosition,
          Chord([.b, .d, .f, .a.flat]),
        );

        expect(
          Chord([.f.sharp, .a, .c, .e.flat]).rootPosition,
          Chord([.f.sharp, .a, .c, .e.flat]),
        );
        expect(
          Chord([.a, .c, .e.flat, .f.sharp]).rootPosition,
          Chord([.f.sharp, .a, .c, .e.flat]),
        );
        expect(
          Chord([.b.flat.flat, .c, .e.flat, .g.flat]).rootPosition,
          Chord([.c, .e.flat, .g.flat, .b.flat.flat]),
        );
        expect(
          Chord([.c, .d.sharp, .f.sharp, .a]).rootPosition,
          Chord([.d.sharp, .f.sharp, .a, .c]),
        );

        expect(
          Note.f.augmentedTriad.add7().add9().rootPosition,
          Chord([.f, .a, .c.sharp, .e.flat, .g]),
        );
        expect(
          skip: 'Unsupported 9th chords',
          () => Chord([.a, .c.sharp, .e.flat, .f, .g]).rootPosition,
          Chord([.f, .a, .c.sharp, .e.flat, .g]),
        );
        expect(
          skip: 'Unsupported 9th chords',
          () => Chord([.c.sharp, .e.flat, .f, .g, .a]).rootPosition,
          Chord([.f, .a, .c.sharp, .e.flat, .g]),
        );
        expect(
          skip: 'Unsupported 9th chords',
          () => Chord([.e.flat, .f, .g, .a, .c.sharp]).rootPosition,
          Chord([.f, .a, .c.sharp, .e.flat, .g]),
        );

        expect(
          Note.a.flat.majorTriad.add7().add9().add11().rootPosition,
          Chord([.a.flat, .c, .e.flat, .g.flat, .b.flat, .d.flat]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .c,
            .e.flat,
            .g.flat,
            .a.flat,
            .b.flat,
            .d.flat,
          ]).rootPosition,
          Chord([.a.flat, .c, .e.flat, .g.flat, .b.flat, .d.flat]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .e.flat,
            .g.flat,
            .a.flat,
            .b.flat,
            .c,
            .d.flat,
          ]).rootPosition,
          Chord([.a.flat, .c, .e.flat, .g.flat, .b.flat, .d.flat]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .g.flat,
            .a.flat,
            .b.flat,
            .c,
            .d.flat,
            .e.flat,
          ]).rootPosition,
          Chord([.a.flat, .c, .e.flat, .g.flat, .b.flat, .d.flat]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .b.flat,
            .c,
            .d.flat,
            .e.flat,
            .g.flat,
            .a.flat,
          ]).rootPosition,
          Chord([.a.flat, .c, .e.flat, .g.flat, .b.flat, .d.flat]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .d.flat,
            .e.flat,
            .g.flat,
            .a.flat,
            .b.flat,
            .c,
          ]).rootPosition,
          Chord([.a.flat, .c, .e.flat, .g.flat, .b.flat, .d.flat]),
        );

        expect(
          Note.d.sharp.minorTriad
              .add7(.major)
              .add9(.minor)
              .add11()
              .rootPosition,
          Chord([
            .d.sharp,
            .f.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .e,
            .g.sharp,
          ]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .f.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .d.sharp,
            .e,
            .g.sharp,
          ]).rootPosition,
          Chord([
            .d.sharp,
            .f.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .e,
            .g.sharp,
          ]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .a.sharp,
            .c.sharp.sharp,
            .d.sharp,
            .e,
            .f.sharp,
            .g.sharp,
          ]).rootPosition,
          Chord([
            .d.sharp,
            .f.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .e,
            .g.sharp,
          ]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .c.sharp.sharp,
            .d.sharp,
            .e,
            .f.sharp,
            .g.sharp,
            .a.sharp,
          ]).rootPosition,
          Chord([
            .d.sharp,
            .f.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .e,
            .g.sharp,
          ]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .e,
            .f.sharp,
            .g.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .d.sharp,
          ]).rootPosition,
          Chord([
            .d.sharp,
            .f.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .e,
            .g.sharp,
          ]),
        );
        expect(
          skip: 'Unsupported 11th chords',
          () => Chord([
            .g.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .d.sharp,
            .e,
            .f.sharp,
          ]).rootPosition,
          Chord([
            .d.sharp,
            .f.sharp,
            .a.sharp,
            .c.sharp.sharp,
            .e,
            .g.sharp,
          ]),
        );

        expect(Note.c.majorTriad.rootPosition, Note.c.majorTriad);
        expect(Note.g.majorTriad.rootPosition, Note.g.majorTriad);
        expect(Note.b.flat.majorTriad.rootPosition, Note.b.flat.majorTriad);
      });
    });

    group('.modifiers', () {
      test('returns the list of modifiers from the root note', () {
        expect(Note.c.majorTriad.modifiers, const <Interval>[]);
        expect(Note.d.majorTriad.add6().add9().modifiers, const <Note>[.b, .e]);
        expect(
          Note.e.flat.diminishedTriad.sus2().add7().add13().modifiers,
          <Note>[.d.flat, .c],
        );
      });
    });

    group('.augmented', () {
      test('returns a new Chord with an augmented root triad', () {
        expect(Note.c.majorTriad.augmented, Note.c.augmentedTriad);
        expect(
          Note.f.majorTriad.add7().add9().augmented,
          Chord([.f, .a, .c.sharp, .e.flat, .g]),
        );
      });
    });

    group('.major', () {
      test('returns a new Chord with a major root triad', () {
        expect(Note.g.minorTriad.major, Note.g.majorTriad);
        expect(
          Note.a.flat.minorTriad.add7().add9().major,
          Chord([.a.flat, .c, .e.flat, .g.flat, .b.flat]),
        );
      });
    });

    group('.minor', () {
      test('returns a new Chord with a minor root triad', () {
        expect(Note.f.sharp.augmentedTriad.minor, Note.f.sharp.minorTriad);
        expect(
          Note.a.majorTriad.add7().add9().minor,
          const Chord([.a, .c, .e, .g, .b]),
        );
      });
    });

    group('.diminished', () {
      test('returns a new Chord with a diminished root triad', () {
        expect(Note.g.flat.majorTriad.diminished, Note.g.flat.diminishedTriad);
        expect(
          Note.g.sharp.augmentedTriad.add7().add9().diminished,
          Chord([.g.sharp, .b, .d, .f.sharp, .a.sharp]),
        );
      });
    });

    group('.sus2()', () {
      test('turns this Chord into a suspended 2nd Chord', () {
        expect(Note.c.majorTriad.sus2(), const Chord([.c, .d, .g]));
        expect(Note.d.minorTriad.sus4().sus2(), const Chord([.d, .e, .a]));
        expect(Note.a.majorTriad.sus2().sus2(), const Chord([.a, .b, .e]));
        expect(
          Note.f.sharp.minorTriad.add7().sus2(),
          Chord([.f.sharp, .g.sharp, .c.sharp, .e]),
        );
      });
    });

    group('.sus4()', () {
      test('turns this Chord into a suspended 4th Chord', () {
        expect(
          Note.d.flat.majorTriad.sus4(),
          Chord([.d.flat, .g.flat, .a.flat]),
        );
        expect(Note.f.minorTriad.sus2().sus4(), Chord([.f, .b.flat, .c]));
        expect(Note.e.majorTriad.sus4().sus4(), const Chord([.e, .a, .b]));
        expect(Note.g.minorTriad.add7().sus4(), const Chord([.g, .c, .d, .f]));
      });
    });

    group('.add6()', () {
      test('adds a 6th Interval to this Chord', () {
        expect(Note.c.majorTriad.add6(), const Chord([.c, .e, .g, .a]));
        expect(
          Note.e.majorTriad.sus2().add6(),
          Chord([.e, .f.sharp, .b, .c.sharp]),
        );
        expect(
          Note.f.minorTriad.sus2().add6(.minor),
          Chord([.f, .g, .c, .d.flat]),
        );
        expect(
          Note.f.sharp.minorTriad.add6(.minor).add9(),
          Chord([.f.sharp, .a, .c.sharp, .d, .g.sharp]),
        );
      });
    });

    group('.add7()', () {
      test('adds a 7th Interval to this Chord', () {
        expect(Note.a.majorTriad.add7(), Chord([.a, .c.sharp, .e, .g]));
        expect(Note.a.minorTriad.sus2().add7(), const Chord([.a, .b, .e, .g]));
        expect(
          Note.b.majorTriad.sus2().add7(.major),
          Chord([.b, .c.sharp, .f.sharp, .a.sharp]),
        );
        expect(Note.c.minorTriad.add7(.major), Chord([.c, .e.flat, .g, .b]));
      });
    });

    group('.add9()', () {
      test('adds a 9th Interval to this Chord', () {
        expect(Note.d.majorTriad.add9(), Chord([.d, .f.sharp, .a, .e]));
        expect(
          Note.d.sharp.minorTriad.sus4().add9(),
          Chord([.d.sharp, .g.sharp, .a.sharp, .e.sharp]),
        );
        expect(
          Note.f.majorTriad.sus2().add9(.minor),
          Chord([.f, .g, .c, .g.flat]),
        );
        expect(
          Note.g.flat.minorTriad.add9(.minor),
          Chord([.g.flat, .b.flat.flat, .d.flat, .a.flat.flat]),
        );
      });
    });

    group('.add11()', () {
      test('adds an 11th Interval to this Chord', () {
        expect(Note.g.majorTriad.add11(), const Chord([.g, .b, .d, .c]));
        expect(
          Note.c.sharp.minorTriad.add7().add9().add11(),
          Chord([.c.sharp, .e, .g.sharp, .b, .d.sharp, .f.sharp]),
        );
        expect(
          Note.d.majorTriad.sus2().add9(.minor).add11(.diminished),
          Chord([.d, .e, .a, .e.flat, .g.flat]),
        );
        expect(
          Note.c.flat.minorTriad.add11(.augmented),
          Chord([.c.flat, .e.flat.flat, .g.flat, .f]),
        );
      });
    });

    group('.add13()', () {
      test('adds an 13th Interval to this Chord', () {
        expect(
          Note.a.sharp.diminishedTriad.add13(),
          Chord([.a.sharp, .c.sharp, .e, .f.sharp.sharp]),
        );
        expect(
          Note.g.minorTriad.add7().add9().add11().add13(),
          Chord([.g, .b.flat, .d, .f, .a, .c, .e]),
        );
        expect(
          Note.a.flat.majorTriad
              .add9(.minor)
              .add11(.augmented)
              .sus2()
              .add13(.minor),
          Chord([.a.flat, .b.flat, .e.flat, .b.flat.flat, .d, .f.flat]),
        );
        expect(
          Note.c.flat.minorTriad.add13(.minor),
          Chord([.c.flat, .e.flat.flat, .g.flat, .a.flat.flat]),
        );
      });
    });

    group('.add()', () {
      test('adds an Interval to this Chord', () {
        expect(
          Note.c.majorTriad.add(.P4, replaceSizes: const {.third}),
          const Chord([.c, .f, .g]),
        );
        expect(Note.c.majorTriad.add(.M7), const Chord([.c, .e, .g, .b]));
      });

      test('ignores any previous Interval size in this ChordPattern', () {
        expect(
          Chord([.e, .g.sharp, .b, .d.sharp]).add(.M7),
          Chord([.e, .g.sharp, .b, .d.sharp]),
        );
        expect(
          const Chord([.f, .a, .c, .e]).add(.m7),
          Chord([.f, .a, .c, .e.flat]),
        );
      });
    });

    group('.transposeBy()', () {
      test('transposes this Chord by Interval', () {
        expect(
          ChordPattern.majorTriad.add9(.minor).on(.c).transposeBy(.M2),
          Chord([.d, .f.sharp, .a, .e.flat]),
        );
        expect(
          ChordPattern.minorTriad.add7(.major).on(.e.flat).transposeBy(.m3),
          Chord([.g.flat, .b.flat.flat, .d.flat, .f]),
        );
      });
    });

    group('.toPitches()', () {
      test('realizes a close-position triad ascending from octave', () {
        expect(
          const Chord([.c, .e, .g]).toPitches(),
          [Note.c.inOctave(4), Note.e.inOctave(4), Note.g.inOctave(4)],
        );
      });

      test('wraps tones into the next octave when needed', () {
        expect(
          Chord([.b, .d.sharp, .f.sharp]).toPitches(octave: 3),
          [
            Note.b.inOctave(3),
            Note.d.sharp.inOctave(4),
            Note.f.sharp.inOctave(4),
          ],
        );
      });

      test('matches toVoicing() over the identity voice order', () {
        const chord = Chord([.c, .e, .g, .b]);
        expect(chord.toPitches(), chord.toVoicing([0, 1, 2, 3]));
      });
    });

    group('.toVoicing()', () {
      test('anchors the first voice at octave', () {
        expect(
          const Chord([.c, .e, .g]).toVoicing([0, 1, 2], octave: 2),
          [Note.c.inOctave(2), Note.e.inOctave(2), Note.g.inOctave(2)],
        );
      });

      test('doubles a repeated index an octave above, never in unison', () {
        expect(
          const Chord([.c, .e, .g]).toVoicing([0, 0, 1, 2, 0], octave: 2),
          [
            Note.c.inOctave(2),
            Note.c.inOctave(3),
            Note.e.inOctave(3),
            Note.g.inOctave(3),
            Note.c.inOctave(4),
          ],
        );
      });

      test('indexes into items literally, ignoring inversion/root order', () {
        // Chord is already in first inversion; index 0 means the literal
        // first item (E), not the harmonic root (C).
        expect(
          const Chord([.e, .g, .c]).toVoicing([0, 1, 2]),
          [Note.e.inOctave(4), Note.g.inOctave(4), Note.c.inOctave(5)],
        );
      });

      test('throws a RangeError for an out-of-range voice index', () {
        expect(
          () => const Chord([.c, .e, .g]).toVoicing([0, 3]),
          throwsRangeError,
        );
      });
    });

    group('.format()', () {
      test('throws UnimplementedError when not implemented', () {
        expect(
          () => const ChordPatternNotation().parseMatch(
            RegExp('a').firstMatch('a')!,
          ),
          throwsUnimplementedError,
        );
      });

      test('returns the string representation of this Chord', () {
        expect(ChordPattern.majorTriad.on(.d).format(), 'D');
        expect(Chord([.g.sharp, .b, .d.sharp]).format(), 'G♯-');
      });
    });

    group('.toString()', () {
      test('returns the verbose string representation of this Chord', () {
        expect(
          ChordPattern.majorTriad.on(.c).toString(),
          '''
Chord(items: [
\tNote(noteName: NoteName.c, accidental: Accidental(semitones: 0)),
\tNote(noteName: NoteName.e, accidental: Accidental(semitones: 0)),
\tNote(noteName: NoteName.g, accidental: Accidental(semitones: 0))
])''',
        );
        expect(
          ChordPattern.minorTriad.add9().on(.f.sharp).toString(),
          '''
Chord(items: [
\tNote(noteName: NoteName.f, accidental: Accidental(semitones: 1)),
\tNote(noteName: NoteName.a, accidental: Accidental(semitones: 0)),
\tNote(noteName: NoteName.c, accidental: Accidental(semitones: 1)),
\tNote(noteName: NoteName.g, accidental: Accidental(semitones: 1))
])''',
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal Chord instances in a Set', () {
        final collection = {
          const Chord([.c, .e, .g]),
          ChordPattern.minorTriad.on(.g),
          ChordPattern.augmentedTriad.on(.d),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const Chord([.c, .e, .g]),
          ChordPattern.minorTriad.on(.g),
          ChordPattern.augmentedTriad.on(.d),
        ]);
      });
    });
  });

  group('ChordNotation', () {
    group('.parse()', () {
      test('throws a FormatException on an invalid Chord', () {
        expect(() => Chord.parse(''), throwsFormatException);
        expect(() => Chord.parse('z'), throwsFormatException);
        expect(() => Chord.parse('C/E/G'), throwsFormatException);
      });

      test('parses source as a Chord', () {
        expect(Chord.parse('C'), ChordPattern.majorTriad.on(.c));
        expect(Chord.parse('A-'), ChordPattern.minorTriad.on(.a));
        expect(Chord.parse('F♯dim'), ChordPattern.diminishedTriad.on(.f.sharp));
        expect(
          Chord.parse('Cmaj7'),
          ChordPattern.majorTriad.add7(.major).on(.c),
        );

        expect(Chord.parse('C/E'), const Chord([.e, .g, .c]));
        expect(Chord.parse('C/G'), const Chord([.g, .c, .e]));
        expect(Chord.parse('A-/C'), const Chord([.c, .e, .a]));
        expect(Chord.parse('Cmaj7/E'), const Chord([.e, .g, .b, .c]));
        expect(Chord.parse('Cmaj7/G'), const Chord([.g, .b, .c, .e]));

        expect(Chord.parse('C/D'), const Chord([.d, .c, .e, .g]));
        expect(Chord.parse('C/C'), Chord.parse('C'));
      });
    });

    group('.format()', () {
      test('returns the string representation of this Chord', () {
        expect(ChordPattern.majorTriad.on(.c).format(), 'C');
        expect(ChordPattern.minorTriad.on(.a).format(), 'A-');
        expect(ChordPattern.majorTriad.add7(.major).on(.c).format(), 'Cmaj7');

        expect(const Chord([.e, .g, .c]).format(), 'C/E');
        expect(const Chord([.g, .c, .e]).format(), 'C/G');
        expect(const Chord([.c, .e, .a]).format(), 'A-/C');
        expect(const Chord([.e, .g, .b, .c]).format(), 'Cmaj7/E');
        expect(const Chord([.d, .c, .e, .g]).format(), 'C/D');
      });

      test('round-trips with .parse()', () {
        for (final source in [
          'C',
          'A-',
          'F♯dim',
          'Cmaj7',
          'C/E',
          'C/G',
          'A-/C',
          'Cmaj7/E',
          'C/D',
        ]) {
          expect(Chord.parse(source).format(), source);
        }
      });
    });
  });
}
