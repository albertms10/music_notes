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

    group('.transposeBy()', () {
      test('should return this Chord transposed by Interval', () {
        expect(
          ChordPattern.majorTriad
              .add9(ImperfectQuality.minor)
              .on(Note.c)
              .transposeBy(Interval.majorSecond),
          Chord([Note.d, Note.f.sharp, Note.a, Note.e.flat]),
        );
        expect(
          ChordPattern.minorTriad
              .add7(ImperfectQuality.major)
              .on(Note.e.flat)
              .transposeBy(Interval.minorThird),
          Chord([Note.g.flat, Note.b.flat.flat, Note.d.flat, Note.f]),
        );

        expect(
          ChordPattern.augmentedTriad
              .add7(ImperfectQuality.major)
              .add9()
              .on(Note.g.inOctave(3))
              .transposeBy(Interval.augmentedFourth),
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
              .transposeBy(Interval.augmentedFourth),
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
              .transposeBy(Interval.augmentedFourth),
          Chord([
            Note.c.sharp.sharp.inOctave(4),
            // TODO(albertms10): Failing test: should be `.inOctave(4)`.
            Note.e.sharp.sharp.inOctave(3),
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
              .transposeBy(Interval.diminishedFifth),
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
