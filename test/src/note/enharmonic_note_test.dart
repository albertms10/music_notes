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

    group('.spellings()', () {
      test(
        'should return the correct Note spellings for this EnharmonicNote',
        () {
          expect(EnharmonicNote.c.spellings(), {Note.c});
          expect(EnharmonicNote.c.spellings(distance: 1), {
            Note.b.sharp,
            Note.c,
            Note.d.flat.flat,
          });

          expect(
            EnharmonicNote.cSharp.spellings(),
            {Note.c.sharp, Note.d.flat},
          );
          expect(
            EnharmonicNote.cSharp.spellings(distance: 1),
            {
              Note.b.sharp.sharp,
              Note.c.sharp,
              Note.d.flat,
              Note.e.flat.flat.flat,
            },
          );

          expect(EnharmonicNote.d.spellings(), {Note.d});
          expect(EnharmonicNote.d.spellings(distance: 1), {
            Note.c.sharp.sharp,
            Note.d,
            Note.e.flat.flat,
          });

          expect(
            EnharmonicNote.dSharp.spellings(),
            {Note.d.sharp, Note.e.flat},
          );
          expect(
            EnharmonicNote.dSharp.spellings(distance: 1),
            {
              Note.c.sharp.sharp.sharp,
              Note.d.sharp,
              Note.e.flat,
              Note.f.flat.flat,
            },
          );

          expect(EnharmonicNote.e.spellings(), {Note.e});
          expect(EnharmonicNote.e.spellings(distance: 1), {
            Note.d.sharp.sharp,
            Note.e,
            Note.f.flat,
          });

          expect(EnharmonicNote.f.spellings(), {Note.f});
          expect(EnharmonicNote.f.spellings(distance: 1), {
            Note.e.sharp,
            Note.f,
            Note.g.flat.flat,
          });

          expect(
            EnharmonicNote.fSharp.spellings(),
            {Note.f.sharp, Note.g.flat},
          );
          expect(
            EnharmonicNote.fSharp.spellings(distance: 1),
            {
              Note.e.sharp.sharp,
              Note.f.sharp,
              Note.g.flat,
              Note.a.flat.flat.flat,
            },
          );

          expect(EnharmonicNote.g.spellings(), {Note.g});
          expect(EnharmonicNote.g.spellings(distance: 1), {
            Note.f.sharp.sharp,
            Note.g,
            Note.a.flat.flat,
          });

          expect(
            EnharmonicNote.gSharp.spellings(),
            {Note.g.sharp, Note.a.flat},
          );
          expect(
            EnharmonicNote.gSharp.spellings(distance: 1),
            {
              Note.f.sharp.sharp.sharp,
              Note.g.sharp,
              Note.a.flat,
              Note.b.flat.flat.flat,
            },
          );

          expect(EnharmonicNote.a.spellings(), {Note.a});
          expect(EnharmonicNote.a.spellings(distance: 1), {
            Note.g.sharp.sharp,
            Note.a,
            Note.b.flat.flat,
          });

          expect(
            EnharmonicNote.aSharp.spellings(),
            {Note.a.sharp, Note.b.flat},
          );
          expect(
            EnharmonicNote.aSharp.spellings(distance: 1),
            {
              Note.g.sharp.sharp.sharp,
              Note.a.sharp,
              Note.b.flat,
              Note.c.flat.flat,
            },
          );

          expect(EnharmonicNote.b.spellings(), {Note.b});
          expect(EnharmonicNote.b.spellings(distance: 1), {
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
        expect(EnharmonicNote.c.interval(EnharmonicNote.c), Interval.P1);
        expect(EnharmonicNote.c.interval(EnharmonicNote.cSharp), Interval.m2);

        expect(EnharmonicNote.c.interval(EnharmonicNote.d), Interval.M2);

        expect(EnharmonicNote.c.interval(EnharmonicNote.dSharp), Interval.m3);
        expect(EnharmonicNote.c.interval(EnharmonicNote.e), Interval.M3);
        expect(EnharmonicNote.g.interval(EnharmonicNote.b), Interval.M3);
        expect(EnharmonicNote.aSharp.interval(EnharmonicNote.d), Interval.M3);

        expect(EnharmonicNote.c.interval(EnharmonicNote.f), Interval.P4);
        expect(
          EnharmonicNote.gSharp.interval(EnharmonicNote.cSharp),
          Interval.P4,
        );
        expect(EnharmonicNote.gSharp.interval(EnharmonicNote.d), Interval.A4);
        expect(EnharmonicNote.c.interval(EnharmonicNote.fSharp), Interval.A4);

        expect(EnharmonicNote.c.interval(EnharmonicNote.g), Interval.P5);
        expect(EnharmonicNote.c.interval(EnharmonicNote.gSharp), Interval.m6);

        expect(EnharmonicNote.c.interval(EnharmonicNote.a), Interval.M6);
        expect(EnharmonicNote.c.interval(EnharmonicNote.aSharp), Interval.m7);

        expect(EnharmonicNote.c.interval(EnharmonicNote.b), Interval.M7);
        expect(EnharmonicNote.b.interval(EnharmonicNote.aSharp), Interval.M7);
      });
    });

    group('.transposeBy()', () {
      test('should return this EnharmonicNote transposed by Interval', () {
        expect(EnharmonicNote.c.transposeBy(Interval.d1), EnharmonicNote.b);
        expect(
          EnharmonicNote.c.transposeBy(-Interval.d1),
          EnharmonicNote.cSharp,
        );
        expect(EnharmonicNote.c.transposeBy(Interval.P1), EnharmonicNote.c);
        expect(EnharmonicNote.c.transposeBy(-Interval.P1), EnharmonicNote.c);
        expect(
          EnharmonicNote.c.transposeBy(Interval.A1),
          EnharmonicNote.cSharp,
        );
        expect(EnharmonicNote.c.transposeBy(-Interval.A1), EnharmonicNote.b);

        expect(EnharmonicNote.c.transposeBy(Interval.d2), EnharmonicNote.c);
        expect(EnharmonicNote.c.transposeBy(-Interval.d2), EnharmonicNote.c);
        expect(
          EnharmonicNote.c.transposeBy(Interval.m2),
          EnharmonicNote.cSharp,
        );
        expect(EnharmonicNote.c.transposeBy(-Interval.m2), EnharmonicNote.b);

        expect(
          EnharmonicNote.fSharp.transposeBy(Interval.M3),
          EnharmonicNote.aSharp,
        );

        expect(
          EnharmonicNote.fSharp.transposeBy(-Interval.P4),
          EnharmonicNote.cSharp,
        );

        expect(EnharmonicNote.g.transposeBy(Interval.P8), EnharmonicNote.g);
      });
    });

    group('operator *', () {
      test(
        'should return the pitch-class multiplication modulo 12 of this '
        'EnharmonicNote',
        () {
          expect(EnharmonicNote.cSharp * 7, EnharmonicNote.g);
          expect(EnharmonicNote.d * 5, EnharmonicNote.aSharp);

          expect(
            ScalePattern.chromatic
                .on(EnharmonicNote.c)
                .degrees
                .map((note) => note * 7),
            Interval.P5.circleFrom(EnharmonicNote.c, distance: 12),
          );
          expect(
            ScalePattern.chromatic
                .on(EnharmonicNote.c)
                .degrees
                .map((note) => note * 5),
            Interval.P5.circleFrom(EnharmonicNote.c, distance: -12),
          );
        },
      );
    });

    group('.toString()', () {
      test('should return a string representation of this EnharmonicNote', () {
        expect(EnharmonicNote.c.toString(), '{C}');
        expect(EnharmonicNote.g.toString(), '{G}');
        expect(EnharmonicNote.dSharp.toString(), '{D♯, E♭}');
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
