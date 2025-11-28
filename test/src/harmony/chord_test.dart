import 'dart:collection' show UnmodifiableListView;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Chord', () {
    group('.items', () {
      test('returns an unmodifiable collection', () {
        expect(
          ChordPattern.majorTriad.on(Note.c).items,
          isA<UnmodifiableListView<Note>>(),
        );
      });
    });

    group('.root', () {
      test('returns the root of this Chord', () {
        expect(ChordPattern.majorTriad.on(Note.f).root, Note.f);
        expect(
          Chord([
            Note.d.inOctave(3),
            Note.f.inOctave(3),
            Note.a.inOctave(3),
          ]).root,
          Note.d.inOctave(3),
        );
      });
    });

    group('.pattern', () {
      test('returns the ChordPattern for this Chord', () {
        expect(
          ChordPattern.majorTriad.on(Note.c).pattern,
          ChordPattern.majorTriad,
        );
        expect(
          const Chord<Note>([.a, .c, .e, .g]).pattern,
          ChordPattern.minorTriad.add7(),
        );
        expect(
          Chord([
            Note.a.flat.inOctave(4),
            Note.c.inOctave(5),
            Note.e.inOctave(5),
            Note.g.inOctave(5),
          ]).pattern,
          ChordPattern.augmentedTriad.add7(.major),
        );
        expect(
          const Chord<Note>([.c, .e, .g, .b, .d, .f]).pattern,
          ChordPattern.majorTriad.add7(.major).add9().add11(),
        );
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
          Chord<Note>([.f, .a, .c.sharp, .e.flat, .g]),
        );
      });
    });

    group('.major', () {
      test('returns a new Chord with a major root triad', () {
        expect(Note.g.minorTriad.major, Note.g.majorTriad);
        expect(
          Note.a.flat.minorTriad.add7().add9().major,
          Chord<Note>([.a.flat, .c, .e.flat, .g.flat, .b.flat]),
        );
      });
    });

    group('.minor', () {
      test('returns a new Chord with a minor root triad', () {
        expect(Note.f.sharp.augmentedTriad.minor, Note.f.sharp.minorTriad);
        expect(
          Note.a.majorTriad.add7().add9().minor,
          const Chord<Note>([.a, .c, .e, .g, .b]),
        );
      });
    });

    group('.diminished', () {
      test('returns a new Chord with a diminished root triad', () {
        expect(Note.g.flat.majorTriad.diminished, Note.g.flat.diminishedTriad);
        expect(
          Note.g.sharp.augmentedTriad.add7().add9().diminished,
          Chord<Note>([.g.sharp, .b, .d, .f.sharp, .a.sharp]),
        );
      });
    });

    group('.sus2()', () {
      test('turns this Chord into a suspended 2nd Chord', () {
        expect(Note.c.majorTriad.sus2(), const Chord<Note>([.c, .d, .g]));
        expect(
          Note.d.minorTriad.sus4().sus2(),
          const Chord<Note>([.d, .e, .a]),
        );
        expect(
          Note.a.majorTriad.sus2().sus2(),
          const Chord<Note>([.a, .b, .e]),
        );
        expect(
          Note.f.sharp.minorTriad.add7().sus2(),
          Chord<Note>([.f.sharp, .g.sharp, .c.sharp, .e]),
        );
      });
    });

    group('.sus4()', () {
      test('turns this Chord into a suspended 4th Chord', () {
        expect(
          Note.d.flat.majorTriad.sus4(),
          Chord<Note>([.d.flat, .g.flat, .a.flat]),
        );
        expect(Note.f.minorTriad.sus2().sus4(), Chord<Note>([.f, .b.flat, .c]));
        expect(
          Note.e.majorTriad.sus4().sus4(),
          const Chord<Note>([.e, .a, .b]),
        );
        expect(
          Note.g.minorTriad.add7().sus4(),
          const Chord<Note>([.g, .c, .d, .f]),
        );
      });
    });

    group('.add6()', () {
      test('adds a 6th Interval to this Chord', () {
        expect(Note.c.majorTriad.add6(), const Chord<Note>([.c, .e, .g, .a]));
        expect(
          Note.e.majorTriad.sus2().add6(),
          Chord<Note>([.e, .f.sharp, .b, .c.sharp]),
        );
        expect(
          Note.f.minorTriad.sus2().add6(.minor),
          Chord<Note>([.f, .g, .c, .d.flat]),
        );
        expect(
          Note.f.sharp.minorTriad.add6(.minor).add9(),
          Chord<Note>([.f.sharp, .a, .c.sharp, .d, .g.sharp]),
        );
      });
    });

    group('.add7()', () {
      test('adds a 7th Interval to this Chord', () {
        expect(Note.a.majorTriad.add7(), Chord<Note>([.a, .c.sharp, .e, .g]));
        expect(
          Note.a.minorTriad.sus2().add7(),
          const Chord<Note>([.a, .b, .e, .g]),
        );
        expect(
          Note.b.majorTriad.sus2().add7(.major),
          Chord<Note>([.b, .c.sharp, .f.sharp, .a.sharp]),
        );
        expect(
          Note.c.minorTriad.add7(.major),
          Chord<Note>([.c, .e.flat, .g, .b]),
        );
      });
    });

    group('.add9()', () {
      test('adds a 9th Interval to this Chord', () {
        expect(Note.d.majorTriad.add9(), Chord<Note>([.d, .f.sharp, .a, .e]));
        expect(
          Note.d.sharp.minorTriad.sus4().add9(),
          Chord<Note>([.d.sharp, .g.sharp, .a.sharp, .e.sharp]),
        );
        expect(
          Note.f.majorTriad.sus2().add9(.minor),
          Chord<Note>([.f, .g, .c, .g.flat]),
        );
        expect(
          Note.g.flat.minorTriad.add9(.minor),
          Chord<Note>([.g.flat, .b.flat.flat, .d.flat, .a.flat.flat]),
        );
      });
    });

    group('.add11()', () {
      test('adds an 11th Interval to this Chord', () {
        expect(Note.g.majorTriad.add11(), const Chord<Note>([.g, .b, .d, .c]));
        expect(
          Note.c.sharp.minorTriad.add7().add9().add11(),
          Chord<Note>([.c.sharp, .e, .g.sharp, .b, .d.sharp, .f.sharp]),
        );
        expect(
          Note.d.majorTriad.sus2().add9(.minor).add11(.diminished),
          Chord<Note>([.d, .e, .a, .e.flat, .g.flat]),
        );
        expect(
          Note.c.flat.minorTriad.add11(.augmented),
          Chord<Note>([.c.flat, .e.flat.flat, .g.flat, .f]),
        );
      });
    });

    group('.add13()', () {
      test('adds an 13th Interval to this Chord', () {
        expect(
          Note.a.sharp.diminishedTriad.add13(),
          Chord<Note>([.a.sharp, .c.sharp, .e, .f.sharp.sharp]),
        );
        expect(
          Note.g.minorTriad.add7().add9().add11().add13(),
          Chord<Note>([.g, .b.flat, .d, .f, .a, .c, .e]),
        );
        expect(
          Note.a.flat.majorTriad
              .add9(.minor)
              .add11(.augmented)
              .sus2()
              .add13(.minor),
          Chord<Note>([.a.flat, .b.flat, .e.flat, .b.flat.flat, .d, .f.flat]),
        );
        expect(
          Note.c.flat.minorTriad.add13(.minor),
          Chord<Note>([.c.flat, .e.flat.flat, .g.flat, .a.flat.flat]),
        );
      });
    });

    group('.add()', () {
      test('adds an Interval to this Chord', () {
        expect(
          Note.c.majorTriad.add(.P4, replaceSizes: const {.third}),
          const Chord<Note>([.c, .f, .g]),
        );
        expect(
          Note.c.majorTriad.add(.M7),
          const Chord<Note>([.c, .e, .g, .b]),
        );
      });

      test('ignores any previous Interval size in this ChordPattern', () {
        expect(
          Chord<Note>([.e, .g.sharp, .b, .d.sharp]).add(.M7),
          Chord<Note>([.e, .g.sharp, .b, .d.sharp]),
        );
        expect(
          const Chord<Note>([.f, .a, .c, .e]).add(.m7),
          Chord<Note>([.f, .a, .c, .e.flat]),
        );
      });
    });

    group('.transposeBy()', () {
      test('transposes this Chord by Interval', () {
        expect(
          ChordPattern.majorTriad.add9(.minor).on(Note.c).transposeBy(.M2),
          Chord<Note>([.d, .f.sharp, .a, .e.flat]),
        );
        expect(
          ChordPattern.minorTriad.add7(.major).on(Note.e.flat).transposeBy(.m3),
          Chord<Note>([.g.flat, .b.flat.flat, .d.flat, .f]),
        );

        expect(
          ChordPattern.augmentedTriad
              .add7(.major)
              .add9()
              .on(Note.g.inOctave(3))
              .transposeBy(.A4),
          Chord([
            Note.c.sharp.inOctave(4),
            Note.e.sharp.inOctave(4),
            Note.g.sharp.sharp.inOctave(4),
            Note.b.sharp.inOctave(4),
            Note.d.sharp.inOctave(5),
          ]),
        );
        expect(
          ChordPattern.augmentedTriad
              .add7(.major)
              .add9()
              .on(Note.g.flat.inOctave(3))
              .transposeBy(.A4),
          Chord([
            Note.c.inOctave(4),
            Note.e.inOctave(4),
            Note.g.sharp.inOctave(4),
            Note.b.inOctave(4),
            Note.d.inOctave(5),
          ]),
        );
        expect(
          ChordPattern.augmentedTriad
              .add7()
              .add9(.minor)
              .on(Note.g.sharp.inOctave(3))
              .transposeBy(.A4),
          Chord([
            Note.c.sharp.sharp.inOctave(4),
            Note.e.sharp.sharp.inOctave(4),
            Note.g.sharp.sharp.sharp.inOctave(4),
            Note.b.sharp.inOctave(4),
            Note.d.sharp.inOctave(5),
          ]),
        );
        expect(
          ChordPattern.augmentedTriad
              .add7(.major)
              .add9()
              .on(Note.g.inOctave(3))
              .transposeBy(.d5),
          Chord([
            Note.d.flat.inOctave(4),
            Note.f.inOctave(4),
            Note.a.inOctave(4),
            Note.c.inOctave(5),
            Note.e.flat.inOctave(5),
          ]),
        );
      });
    });

    group('.toString()', () {
      test('throws UnimplementedError when not implemented', () {
        expect(
          () => const ChordPatternNotation().parseMatch(
            RegExp('a').firstMatch('a')!,
          ),
          throwsUnimplementedError,
        );
      });

      test('returns the string representation of this Chord', () {
        expect(ChordPattern.majorTriad.on(Note.d).toString(), 'D');
        expect(Chord<Note>([.g.sharp, .b, .d.sharp]).toString(), 'G♯-');
        expect(
          ChordPattern.augmentedTriad.add7().on(Note.c.inOctave(3)).toString(),
          'C3+7',
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal Chord instances in a Set', () {
        final collection = {
          const Chord<Note>([.c, .e, .g]),
          ChordPattern.minorTriad.on(Note.g),
          ChordPattern.augmentedTriad.on(Note.d),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const Chord<Note>([.c, .e, .g]),
          ChordPattern.minorTriad.on(Note.g),
          ChordPattern.augmentedTriad.on(Note.d),
        ]);
      });
    });
  });
}
