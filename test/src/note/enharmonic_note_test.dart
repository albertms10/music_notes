import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicNote', () {
    group('constructor', () {
      test(
        'should throw an assertion error when arguments are incorrect',
        () {
          expect(() => EnharmonicNote(-2), throwsA(isA<AssertionError>()));
          expect(() => EnharmonicNote(13), throwsA(isA<AssertionError>()));
        },
      );
    });

    group('.spellings', () {
      test(
        'should return the correct Note spellings for this EnharmonicNote',
        () {
          expect(EnharmonicNote.c.spellings, {
            Note.b.sharp,
            Note.c,
            Note.d.flat.flat,
          });
          expect(EnharmonicNote.cSharp.spellings, {Note.c.sharp, Note.d.flat});
          expect(EnharmonicNote.d.spellings, {
            Note.c.sharp.sharp,
            Note.d,
            Note.e.flat.flat,
          });
          expect(EnharmonicNote.dSharp.spellings, {Note.d.sharp, Note.e.flat});
          expect(EnharmonicNote.e.spellings, {
            Note.d.sharp.sharp,
            Note.e,
            Note.f.flat,
          });
          expect(EnharmonicNote.f.spellings, {
            Note.e.sharp,
            Note.f,
            Note.g.flat.flat,
          });
          expect(EnharmonicNote.fSharp.spellings, {Note.f.sharp, Note.g.flat});
          expect(EnharmonicNote.g.spellings, {
            Note.f.sharp.sharp,
            Note.g,
            Note.a.flat.flat,
          });
          expect(EnharmonicNote.gSharp.spellings, {Note.g.sharp, Note.a.flat});
          expect(EnharmonicNote.a.spellings, {
            Note.g.sharp.sharp,
            Note.a,
            Note.b.flat.flat,
          });
          expect(EnharmonicNote.aSharp.spellings, {Note.a.sharp, Note.b.flat});
          expect(EnharmonicNote.b.spellings, {
            Note.a.sharp.sharp,
            Note.b,
            Note.c.flat,
          });
        },
      );
    });

    group('.resolveSpelling()', () {
      test(
        'should return the Note that matches with the accidental',
        () {
          expect(EnharmonicNote.c.resolveSpelling(), Note.c);
          expect(
            EnharmonicNote.c.resolveSpelling(Accidental.sharp),
            Note.b.sharp,
          );
          expect(
            EnharmonicNote.c.resolveSpelling(Accidental.doubleFlat),
            Note.d.flat.flat,
          );

          expect(EnharmonicNote.cSharp.resolveSpelling(), Note.c.sharp);
          expect(
            EnharmonicNote.cSharp.resolveSpelling(Accidental.flat),
            Note.d.flat,
          );

          expect(EnharmonicNote.d.resolveSpelling(), Note.d);
          expect(
            EnharmonicNote.d.resolveSpelling(Accidental.doubleSharp),
            Note.c.sharp.sharp,
          );
          expect(
            EnharmonicNote.d.resolveSpelling(Accidental.doubleFlat),
            Note.e.flat.flat,
          );

          expect(EnharmonicNote.dSharp.resolveSpelling(), Note.d.sharp);
          expect(
            EnharmonicNote.dSharp.resolveSpelling(Accidental.flat),
            Note.e.flat,
          );

          expect(EnharmonicNote.e.resolveSpelling(), Note.e);
          expect(
            EnharmonicNote.e.resolveSpelling(Accidental.doubleSharp),
            Note.d.sharp.sharp,
          );
          expect(
            EnharmonicNote.e.resolveSpelling(Accidental.flat),
            Note.f.flat,
          );

          expect(EnharmonicNote.f.resolveSpelling(), Note.f);
          expect(
            EnharmonicNote.f.resolveSpelling(Accidental.sharp),
            Note.e.sharp,
          );
          expect(
            EnharmonicNote.f.resolveSpelling(Accidental.doubleFlat),
            Note.g.flat.flat,
          );

          expect(EnharmonicNote.fSharp.resolveSpelling(), Note.f.sharp);
          expect(
            EnharmonicNote.fSharp.resolveSpelling(Accidental.flat),
            Note.g.flat,
          );

          expect(EnharmonicNote.g.resolveSpelling(), Note.g);
          expect(
            EnharmonicNote.g.resolveSpelling(Accidental.doubleSharp),
            Note.f.sharp.sharp,
          );
          expect(
            EnharmonicNote.g.resolveSpelling(Accidental.doubleFlat),
            Note.a.flat.flat,
          );

          expect(EnharmonicNote.gSharp.resolveSpelling(), Note.g.sharp);
          expect(
            EnharmonicNote.gSharp.resolveSpelling(Accidental.flat),
            Note.a.flat,
          );

          expect(EnharmonicNote.a.resolveSpelling(), Note.a);
          expect(
            EnharmonicNote.a.resolveSpelling(Accidental.doubleSharp),
            Note.g.sharp.sharp,
          );
          expect(
            EnharmonicNote.a.resolveSpelling(Accidental.doubleFlat),
            Note.b.flat.flat,
          );

          expect(EnharmonicNote.aSharp.resolveSpelling(), Note.a.sharp);
          expect(
            EnharmonicNote.aSharp.resolveSpelling(Accidental.flat),
            Note.b.flat,
          );

          expect(EnharmonicNote.b.resolveSpelling(), Note.b);
          expect(
            EnharmonicNote.b.resolveSpelling(Accidental.doubleSharp),
            Note.a.sharp.sharp,
          );
          expect(
            EnharmonicNote.b.resolveSpelling(Accidental.flat),
            Note.c.flat,
          );
        },
      );

      test(
        'should throw an ArgumentError when withAccidental does not match with '
        'any Note',
        () {
          expect(
            () => EnharmonicNote.cSharp.resolveSpelling(Accidental.natural),
            throwsArgumentError,
          );
          expect(
            () => EnharmonicNote.c.resolveSpelling(Accidental.flat),
            throwsArgumentError,
          );
          expect(
            () => EnharmonicNote.d.resolveSpelling(Accidental.sharp),
            throwsArgumentError,
          );
          expect(
            () => EnharmonicNote.a.resolveSpelling(Accidental.tripleFlat),
            throwsArgumentError,
          );
        },
      );
    });

    group('.resolveClosestSpelling()', () {
      test(
        'should return the Note that matches with the preferred accidental',
        () {
          expect(EnharmonicNote.c.resolveClosestSpelling(), Note.c);
          expect(
            EnharmonicNote.c.resolveClosestSpelling(Accidental.sharp),
            Note.b.sharp,
          );
          expect(
            EnharmonicNote.c.resolveClosestSpelling(Accidental.doubleFlat),
            Note.d.flat.flat,
          );

          expect(EnharmonicNote.cSharp.resolveClosestSpelling(), Note.c.sharp);
          expect(
            EnharmonicNote.cSharp.resolveClosestSpelling(Accidental.flat),
            Note.d.flat,
          );

          // ... Similar to `.resolveSpelling()`.
        },
      );

      test(
        'should return the closest Note where a similar call to '
        '.resolveSpelling() would throw',
        () {
          expect(
            EnharmonicNote.cSharp.resolveClosestSpelling(Accidental.natural),
            Note.c.sharp,
          );
          expect(
            EnharmonicNote.c.resolveClosestSpelling(Accidental.flat),
            Note.c,
          );
          expect(
            EnharmonicNote.d.resolveClosestSpelling(Accidental.sharp),
            Note.d,
          );
          expect(
            EnharmonicNote.a.resolveClosestSpelling(Accidental.tripleFlat),
            Note.a,
          );
        },
      );
    });

    group('.interval()', () {
      test('should return the Interval between this Note and other', () {
        expect(
          EnharmonicNote.c.interval(EnharmonicNote.c),
          Interval.perfectUnison,
        );
        expect(
          EnharmonicNote.c.interval(EnharmonicNote.cSharp),
          Interval.minorSecond,
        );

        expect(
          EnharmonicNote.c.interval(EnharmonicNote.d),
          Interval.majorSecond,
        );

        expect(
          EnharmonicNote.c.interval(EnharmonicNote.dSharp),
          Interval.minorThird,
        );
        expect(
          EnharmonicNote.c.interval(EnharmonicNote.e),
          Interval.majorThird,
        );
        expect(
          EnharmonicNote.g.interval(EnharmonicNote.b),
          Interval.majorThird,
        );
        expect(
          EnharmonicNote.aSharp.interval(EnharmonicNote.d),
          Interval.majorThird,
        );

        expect(
          EnharmonicNote.c.interval(EnharmonicNote.f),
          Interval.perfectFourth,
        );
        expect(
          EnharmonicNote.gSharp.interval(EnharmonicNote.cSharp),
          Interval.perfectFourth,
        );
        expect(
          EnharmonicNote.gSharp.interval(EnharmonicNote.d),
          Interval.augmentedFourth,
        );
        expect(
          EnharmonicNote.c.interval(EnharmonicNote.fSharp),
          Interval.augmentedFourth,
        );

        expect(
          EnharmonicNote.c.interval(EnharmonicNote.g),
          Interval.perfectFifth,
        );
        expect(
          EnharmonicNote.c.interval(EnharmonicNote.gSharp),
          Interval.minorSixth,
        );

        expect(
          EnharmonicNote.c.interval(EnharmonicNote.a),
          Interval.majorSixth,
        );
        expect(
          EnharmonicNote.c.interval(EnharmonicNote.aSharp),
          Interval.minorSeventh,
        );

        expect(
          EnharmonicNote.c.interval(EnharmonicNote.b),
          Interval.majorSeventh,
        );
        expect(
          EnharmonicNote.b.interval(EnharmonicNote.aSharp),
          Interval.majorSeventh,
        );
      });
    });

    group('.transposeBy()', () {
      test('should return this EnharmonicNote transposed by Interval', () {
        expect(
          EnharmonicNote.c.transposeBy(Interval.diminishedUnison),
          EnharmonicNote.b,
        );
        expect(
          EnharmonicNote.c.transposeBy(-Interval.diminishedUnison),
          EnharmonicNote.cSharp,
        );
        expect(
          EnharmonicNote.c.transposeBy(Interval.perfectUnison),
          EnharmonicNote.c,
        );
        expect(
          EnharmonicNote.c.transposeBy(-Interval.perfectUnison),
          EnharmonicNote.c,
        );
        expect(
          EnharmonicNote.c.transposeBy(Interval.augmentedUnison),
          EnharmonicNote.cSharp,
        );
        expect(
          EnharmonicNote.c.transposeBy(-Interval.augmentedUnison),
          EnharmonicNote.b,
        );

        expect(
          EnharmonicNote.c.transposeBy(Interval.diminishedSecond),
          EnharmonicNote.c,
        );
        expect(
          EnharmonicNote.c.transposeBy(-Interval.diminishedSecond),
          EnharmonicNote.c,
        );
        expect(
          EnharmonicNote.c.transposeBy(Interval.minorSecond),
          EnharmonicNote.cSharp,
        );
        expect(
          EnharmonicNote.c.transposeBy(-Interval.minorSecond),
          EnharmonicNote.b,
        );

        expect(
          EnharmonicNote.fSharp.transposeBy(Interval.majorThird),
          EnharmonicNote.aSharp,
        );

        expect(
          EnharmonicNote.fSharp.transposeBy(-Interval.perfectFourth),
          EnharmonicNote.cSharp,
        );

        expect(
          EnharmonicNote.g.transposeBy(Interval.perfectOctave),
          EnharmonicNote.g,
        );
      });
    });

    group('.shortestFifthsDistance()', () {
      test('should return the shortest fifths distance from other', () {
        expect(EnharmonicNote.c.shortestFifthsDistance(EnharmonicNote.c), 0);
        expect(EnharmonicNote.c.shortestFifthsDistance(EnharmonicNote.e), 4);
        expect(
          EnharmonicNote.fSharp.shortestFifthsDistance(EnharmonicNote.a),
          -3,
        );
        expect(
          EnharmonicNote.dSharp.shortestFifthsDistance(EnharmonicNote.g),
          4,
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal EnharmonicNote instances in a Set', () {
        final collection = {EnharmonicNote.f, EnharmonicNote.aSharp};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [EnharmonicNote.f, EnharmonicNote.aSharp],
        );
      });
    });

    group('.compareTo()', () {
      test('should correctly sort EnharmonicNote items in a collection', () {
        final orderedSet = SplayTreeSet<EnharmonicNote>.of(const [
          EnharmonicNote.fSharp,
          EnharmonicNote.c,
          EnharmonicNote.d,
        ]);
        expect(orderedSet.toList(), const [
          EnharmonicNote.c,
          EnharmonicNote.d,
          EnharmonicNote.fSharp,
        ]);
      });
    });
  });
}
