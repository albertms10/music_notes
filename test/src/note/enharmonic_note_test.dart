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
            const Note(BaseNote.b, Accidental.sharp),
            Note.c,
            const Note(BaseNote.d, Accidental.doubleFlat),
          });
          expect(EnharmonicNote.cSharp.spellings, {Note.cSharp, Note.dFlat});
          expect(EnharmonicNote.d.spellings, {
            const Note(BaseNote.c, Accidental.doubleSharp),
            Note.d,
            const Note(BaseNote.e, Accidental.doubleFlat),
          });
          expect(EnharmonicNote.dSharp.spellings, {Note.dSharp, Note.eFlat});
          expect(EnharmonicNote.e.spellings, {
            const Note(BaseNote.d, Accidental.doubleSharp),
            Note.e,
            const Note(BaseNote.f, Accidental.flat),
          });
          expect(EnharmonicNote.f.spellings, {
            const Note(BaseNote.e, Accidental.sharp),
            Note.f,
            const Note(BaseNote.g, Accidental.doubleFlat),
          });
          expect(EnharmonicNote.fSharp.spellings, {Note.fSharp, Note.gFlat});
          expect(EnharmonicNote.g.spellings, {
            const Note(BaseNote.f, Accidental.doubleSharp),
            Note.g,
            const Note(BaseNote.a, Accidental.doubleFlat),
          });
          expect(EnharmonicNote.gSharp.spellings, {Note.gSharp, Note.aFlat});
          expect(EnharmonicNote.a.spellings, {
            const Note(BaseNote.g, Accidental.doubleSharp),
            Note.a,
            const Note(BaseNote.b, Accidental.doubleFlat),
          });
          expect(EnharmonicNote.aSharp.spellings, {Note.aSharp, Note.bFlat});
          expect(EnharmonicNote.b.spellings, {
            const Note(BaseNote.a, Accidental.doubleSharp),
            Note.b,
            const Note(BaseNote.c, Accidental.flat),
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
            const Note(BaseNote.b, Accidental.sharp),
          );
          expect(
            EnharmonicNote.c.resolveSpelling(Accidental.doubleFlat),
            const Note(BaseNote.d, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.cSharp.resolveSpelling(), Note.cSharp);
          expect(
            EnharmonicNote.cSharp.resolveSpelling(Accidental.flat),
            Note.dFlat,
          );

          expect(EnharmonicNote.d.resolveSpelling(), Note.d);
          expect(
            EnharmonicNote.d.resolveSpelling(Accidental.doubleSharp),
            const Note(BaseNote.c, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.d.resolveSpelling(Accidental.doubleFlat),
            const Note(BaseNote.e, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.dSharp.resolveSpelling(), Note.dSharp);
          expect(
            EnharmonicNote.dSharp.resolveSpelling(Accidental.flat),
            Note.eFlat,
          );

          expect(EnharmonicNote.e.resolveSpelling(), Note.e);
          expect(
            EnharmonicNote.e.resolveSpelling(Accidental.doubleSharp),
            const Note(BaseNote.d, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.e.resolveSpelling(Accidental.flat),
            const Note(BaseNote.f, Accidental.flat),
          );

          expect(EnharmonicNote.f.resolveSpelling(), Note.f);
          expect(
            EnharmonicNote.f.resolveSpelling(Accidental.sharp),
            const Note(BaseNote.e, Accidental.sharp),
          );
          expect(
            EnharmonicNote.f.resolveSpelling(Accidental.doubleFlat),
            const Note(BaseNote.g, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.fSharp.resolveSpelling(), Note.fSharp);
          expect(
            EnharmonicNote.fSharp.resolveSpelling(Accidental.flat),
            Note.gFlat,
          );

          expect(EnharmonicNote.g.resolveSpelling(), Note.g);
          expect(
            EnharmonicNote.g.resolveSpelling(Accidental.doubleSharp),
            const Note(BaseNote.f, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.g.resolveSpelling(Accidental.doubleFlat),
            const Note(BaseNote.a, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.gSharp.resolveSpelling(), Note.gSharp);
          expect(
            EnharmonicNote.gSharp.resolveSpelling(Accidental.flat),
            Note.aFlat,
          );

          expect(EnharmonicNote.a.resolveSpelling(), Note.a);
          expect(
            EnharmonicNote.a.resolveSpelling(Accidental.doubleSharp),
            const Note(BaseNote.g, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.a.resolveSpelling(Accidental.doubleFlat),
            const Note(BaseNote.b, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.aSharp.resolveSpelling(), Note.aSharp);
          expect(
            EnharmonicNote.aSharp.resolveSpelling(Accidental.flat),
            Note.bFlat,
          );

          expect(EnharmonicNote.b.resolveSpelling(), Note.b);
          expect(
            EnharmonicNote.b.resolveSpelling(Accidental.doubleSharp),
            const Note(BaseNote.a, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.b.resolveSpelling(Accidental.flat),
            const Note(BaseNote.c, Accidental.flat),
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
            const Note(BaseNote.b, Accidental.sharp),
          );
          expect(
            EnharmonicNote.c.resolveClosestSpelling(Accidental.doubleFlat),
            const Note(BaseNote.d, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.cSharp.resolveClosestSpelling(), Note.cSharp);
          expect(
            EnharmonicNote.cSharp.resolveClosestSpelling(Accidental.flat),
            Note.dFlat,
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
            Note.cSharp,
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
