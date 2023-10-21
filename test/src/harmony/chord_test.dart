import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Chord', () {
    group('.root', () {
      test('should return the root of this Chord', () {
        expect(ChordPattern.majorTriad.on(Note.f).root, Note.f);
        expect(
          Chord([Note.d.inOctave(3), Note.f.inOctave(3), Note.a.inOctave(3)])
              .root,
          Note.d.inOctave(3),
        );
      });
    });

    group('.pattern', () {
      test('should return the ChordPattern for this Chord', () {
        expect(
          ChordPattern.majorTriad.on(Note.c).pattern,
          ChordPattern.majorTriad,
        );
        expect(
          const Chord([Note.a, Note.c, Note.e, Note.g]).pattern,
          ChordPattern.minorTriad.add7(),
        );
        expect(
          Chord([
            Note.a.flat.inOctave(4),
            Note.c.inOctave(5),
            Note.e.inOctave(5),
            Note.g.inOctave(5),
          ]).pattern,
          ChordPattern.augmentedTriad.add7(ImperfectQuality.major),
        );
        expect(
          const Chord([Note.c, Note.e, Note.g, Note.b, Note.d, Note.f]).pattern,
          ChordPattern.majorTriad.add7(ImperfectQuality.major).add9().add11(),
        );
      });
    });

    group('.modifiers', () {
      test('should return the list of modifiers from the root note', () {
        expect(Note.c.majorTriad.modifiers, const <Interval>[]);
        expect(
          Note.d.majorTriad.add6().add9().modifiers,
          const [Note.b, Note.e],
        );
        expect(
          Note.e.flat.diminishedTriad.sus2().add7().add13().modifiers,
          [Note.d.flat, Note.c],
        );
      });
    });

    group('.augmented', () {
      test('should return a new Chord with an augmented root triad', () {
        expect(Note.c.majorTriad.augmented, Note.c.augmentedTriad);
        expect(
          Note.f.majorTriad.add7().add9().augmented,
          Chord([Note.f, Note.a, Note.c.sharp, Note.e.flat, Note.g]),
        );
      });
    });

    group('.major', () {
      test('should return a new Chord with a major root triad', () {
        expect(Note.g.minorTriad.major, Note.g.majorTriad);
        expect(
          Note.a.flat.minorTriad.add7().add9().major,
          Chord([Note.a.flat, Note.c, Note.e.flat, Note.g.flat, Note.b.flat]),
        );
      });
    });

    group('.minor', () {
      test('should return a new Chord with a minor root triad', () {
        expect(Note.f.sharp.augmentedTriad.minor, Note.f.sharp.minorTriad);
        expect(
          Note.a.majorTriad.add7().add9().minor,
          const Chord([Note.a, Note.c, Note.e, Note.g, Note.b]),
        );
      });
    });

    group('.diminished', () {
      test('should return a new Chord with a diminished root triad', () {
        expect(Note.g.flat.majorTriad.diminished, Note.g.flat.diminishedTriad);
        expect(
          Note.g.sharp.augmentedTriad.add7().add9().diminished,
          Chord([Note.g.sharp, Note.b, Note.d, Note.f.sharp, Note.a.sharp]),
        );
      });
    });

    group('.sus2()', () {
      test('should turn this Chord into a suspended 2nd Chord', () {
        expect(Note.c.majorTriad.sus2(), const Chord([Note.c, Note.d, Note.g]));
        expect(
          Note.d.minorTriad.sus4().sus2(),
          const Chord([Note.d, Note.e, Note.a]),
        );
        expect(
          Note.a.majorTriad.sus2().sus2(),
          const Chord([Note.a, Note.b, Note.e]),
        );
        expect(
          Note.f.sharp.minorTriad.add7().sus2(),
          Chord([Note.f.sharp, Note.g.sharp, Note.c.sharp, Note.e]),
        );
      });
    });

    group('.sus4()', () {
      test('should turn this Chord into a suspended 4th Chord', () {
        expect(
          Note.d.flat.majorTriad.sus4(),
          Chord([Note.d.flat, Note.g.flat, Note.a.flat]),
        );
        expect(
          Note.f.minorTriad.sus2().sus4(),
          Chord([Note.f, Note.b.flat, Note.c]),
        );
        expect(
          Note.e.majorTriad.sus4().sus4(),
          const Chord([Note.e, Note.a, Note.b]),
        );
        expect(
          Note.g.minorTriad.add7().sus4(),
          const Chord([Note.g, Note.c, Note.d, Note.f]),
        );
      });
    });

    group('.add6()', () {
      test('should add a 6th Interval to this Chord', () {
        expect(
          Note.c.majorTriad.add6(),
          const Chord([Note.c, Note.e, Note.g, Note.a]),
        );
        expect(
          Note.e.majorTriad.sus2().add6(),
          Chord([Note.e, Note.f.sharp, Note.b, Note.c.sharp]),
        );
        expect(
          Note.f.minorTriad.sus2().add6(ImperfectQuality.minor),
          Chord([Note.f, Note.g, Note.c, Note.d.flat]),
        );
        expect(
          Note.f.sharp.minorTriad.add6(ImperfectQuality.minor).add9(),
          Chord([Note.f.sharp, Note.a, Note.c.sharp, Note.d, Note.g.sharp]),
        );
      });
    });

    group('.add7()', () {
      test('should add a 7th Interval to this Chord', () {
        expect(
          Note.a.majorTriad.add7(),
          Chord([Note.a, Note.c.sharp, Note.e, Note.g]),
        );
        expect(
          Note.a.minorTriad.sus2().add7(),
          const Chord([Note.a, Note.b, Note.e, Note.g]),
        );
        expect(
          Note.b.majorTriad.sus2().add7(ImperfectQuality.major),
          Chord([Note.b, Note.c.sharp, Note.f.sharp, Note.a.sharp]),
        );
        expect(
          Note.c.minorTriad.add7(ImperfectQuality.major),
          Chord([Note.c, Note.e.flat, Note.g, Note.b]),
        );
      });
    });

    group('.add9()', () {
      test('should add a 9th Interval to this Chord', () {
        expect(
          Note.d.majorTriad.add9(),
          Chord([Note.d, Note.f.sharp, Note.a, Note.e]),
        );
        expect(
          Note.d.sharp.minorTriad.sus4().add9(),
          Chord([Note.d.sharp, Note.g.sharp, Note.a.sharp, Note.e.sharp]),
        );
        expect(
          Note.f.majorTriad.sus2().add9(ImperfectQuality.minor),
          Chord([Note.f, Note.g, Note.c, Note.g.flat]),
        );
        expect(
          Note.g.flat.minorTriad.add9(ImperfectQuality.minor),
          Chord([Note.g.flat, Note.b.flat.flat, Note.d.flat, Note.a.flat.flat]),
        );
      });
    });

    group('.add11()', () {
      test('should add an 11th Interval to this Chord', () {
        expect(
          Note.g.majorTriad.add11(),
          const Chord([Note.g, Note.b, Note.d, Note.c]),
        );
        expect(
          Note.c.sharp.minorTriad.add7().add9().add11(),
          Chord([
            Note.c.sharp,
            Note.e,
            Note.g.sharp,
            Note.b,
            Note.d.sharp,
            Note.f.sharp,
          ]),
        );
        expect(
          Note.d.majorTriad
              .sus2()
              .add9(ImperfectQuality.minor)
              .add11(PerfectQuality.diminished),
          Chord([Note.d, Note.e, Note.a, Note.e.flat, Note.g.flat]),
        );
        expect(
          Note.c.flat.minorTriad.add11(PerfectQuality.augmented),
          Chord([Note.c.flat, Note.e.flat.flat, Note.g.flat, Note.f]),
        );
      });
    });

    group('.add13()', () {
      test('should add an 13th Interval to this Chord', () {
        expect(
          Note.a.sharp.diminishedTriad.add13(),
          Chord([Note.a.sharp, Note.c.sharp, Note.e, Note.f.sharp.sharp]),
        );
        expect(
          Note.g.minorTriad.add7().add9().add11().add13(),
          Chord([Note.g, Note.b.flat, Note.d, Note.f, Note.a, Note.c, Note.e]),
        );
        expect(
          Note.a.flat.majorTriad
              .add9(ImperfectQuality.minor)
              .add11(PerfectQuality.augmented)
              .sus2()
              .add13(ImperfectQuality.minor),
          Chord([
            Note.a.flat,
            Note.b.flat,
            Note.e.flat,
            Note.b.flat.flat,
            Note.d,
            Note.f.flat,
          ]),
        );
        expect(
          Note.c.flat.minorTriad.add13(ImperfectQuality.minor),
          Chord([Note.c.flat, Note.e.flat.flat, Note.g.flat, Note.a.flat.flat]),
        );
      });
    });

    group('.add()', () {
      test('should add an Interval to this Chord', () {
        expect(
          Note.c.majorTriad.add(Interval.P4, replaceSizes: const {3}),
          const Chord([Note.c, Note.f, Note.g]),
        );
        expect(
          Note.c.majorTriad.add(Interval.M7),
          const Chord([Note.c, Note.e, Note.g, Note.b]),
        );
      });

      test('should ignore any previous Interval size in this ChordPattern', () {
        expect(
          Chord([Note.e, Note.g.sharp, Note.b, Note.d.sharp]).add(Interval.M7),
          Chord([Note.e, Note.g.sharp, Note.b, Note.d.sharp]),
        );
        expect(
          const Chord([Note.f, Note.a, Note.c, Note.e]).add(Interval.m7),
          Chord([Note.f, Note.a, Note.c, Note.e.flat]),
        );
      });
    });

    group('.transposeBy()', () {
      test('should return this Chord transposed by Interval', () {
        expect(
          ChordPattern.majorTriad
              .add9(ImperfectQuality.minor)
              .on(Note.c)
              .transposeBy(Interval.M2),
          Chord([Note.d, Note.f.sharp, Note.a, Note.e.flat]),
        );
        expect(
          ChordPattern.minorTriad
              .add7(ImperfectQuality.major)
              .on(Note.e.flat)
              .transposeBy(Interval.m3),
          Chord([Note.g.flat, Note.b.flat.flat, Note.d.flat, Note.f]),
        );

        expect(
          ChordPattern.augmentedTriad
              .add7(ImperfectQuality.major)
              .add9()
              .on(Note.g.inOctave(3))
              .transposeBy(Interval.A4),
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
              .add7(ImperfectQuality.major)
              .add9()
              .on(Note.g.flat.inOctave(3))
              .transposeBy(Interval.A4),
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
              .add9(ImperfectQuality.minor)
              .on(Note.g.sharp.inOctave(3))
              .transposeBy(Interval.A4),
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
              .add7(ImperfectQuality.major)
              .add9()
              .on(Note.g.inOctave(3))
              .transposeBy(Interval.d5),
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
      test('should return the string representation of this Chord', () {
        expect(
          ChordPattern.majorTriad.on(Note.d).toString(),
          'D maj. (D F♯ A)',
        );
        expect(
          Chord([Note.g.sharp, Note.b, Note.d.sharp]).toString(),
          'G♯ min. (G♯ B D♯)',
        );
        expect(
          ChordPattern.augmentedTriad.add7().on(Note.c.inOctave(3)).toString(),
          'C3 aug. (C3 E3 G♯3 B♭3)',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Chord instances in a Set', () {
        final collection = {
          const Chord([Note.c, Note.e, Note.g]),
          ChordPattern.minorTriad.on(Note.g),
          ChordPattern.augmentedTriad.on(Note.d),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          const Chord([Note.c, Note.e, Note.g]),
          ChordPattern.minorTriad.on(Note.g),
          ChordPattern.augmentedTriad.on(Note.d),
        ]);
      });
    });
  });
}
