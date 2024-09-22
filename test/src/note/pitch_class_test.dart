import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('PitchClass', () {
    group('constructor', () {
      test('creates a new PitchClass from semitones', () {
        // ignore: use_named_constants test
        expect(const PitchClass(-2), PitchClass.aSharp);
        // ignore: use_named_constants test
        expect(const PitchClass(13), PitchClass.cSharp);
      });
    });

    group('.spellings()', () {
      test('returns the correct Note spellings for this PitchClass', () {
        expect(PitchClass.c.spellings(), {Note.c});
        expect(
          PitchClass.c.spellings(distance: 1),
          {Note.b.sharp, Note.c, Note.d.flat.flat},
        );

        expect(PitchClass.cSharp.spellings(), {Note.c.sharp, Note.d.flat});
        expect(
          PitchClass.cSharp.spellings(distance: 1),
          {
            Note.b.sharp.sharp,
            Note.c.sharp,
            Note.d.flat,
            Note.e.flat.flat.flat,
          },
        );

        expect(PitchClass.d.spellings(), {Note.d});
        expect(
          PitchClass.d.spellings(distance: 1),
          {Note.c.sharp.sharp, Note.d, Note.e.flat.flat},
        );

        expect(PitchClass.dSharp.spellings(), {Note.d.sharp, Note.e.flat});
        expect(
          PitchClass.dSharp.spellings(distance: 1),
          {
            Note.c.sharp.sharp.sharp,
            Note.d.sharp,
            Note.e.flat,
            Note.f.flat.flat,
          },
        );

        expect(PitchClass.e.spellings(), {Note.e});
        expect(
          PitchClass.e.spellings(distance: 1),
          {Note.d.sharp.sharp, Note.e, Note.f.flat},
        );

        expect(PitchClass.f.spellings(), {Note.f});
        expect(
          PitchClass.f.spellings(distance: 1),
          {Note.e.sharp, Note.f, Note.g.flat.flat},
        );

        expect(PitchClass.fSharp.spellings(), {Note.f.sharp, Note.g.flat});
        expect(
          PitchClass.fSharp.spellings(distance: 1),
          {
            Note.e.sharp.sharp,
            Note.f.sharp,
            Note.g.flat,
            Note.a.flat.flat.flat,
          },
        );

        expect(PitchClass.g.spellings(), {Note.g});
        expect(
          PitchClass.g.spellings(distance: 1),
          {Note.f.sharp.sharp, Note.g, Note.a.flat.flat},
        );

        expect(PitchClass.gSharp.spellings(), {Note.g.sharp, Note.a.flat});
        expect(
          PitchClass.gSharp.spellings(distance: 1),
          {
            Note.f.sharp.sharp.sharp,
            Note.g.sharp,
            Note.a.flat,
            Note.b.flat.flat.flat,
          },
        );

        expect(PitchClass.a.spellings(), {Note.a});
        expect(
          PitchClass.a.spellings(distance: 1),
          {Note.g.sharp.sharp, Note.a, Note.b.flat.flat},
        );

        expect(PitchClass.aSharp.spellings(), {Note.a.sharp, Note.b.flat});
        expect(
          PitchClass.aSharp.spellings(distance: 1),
          {
            Note.g.sharp.sharp.sharp,
            Note.a.sharp,
            Note.b.flat,
            Note.c.flat.flat,
          },
        );

        expect(PitchClass.b.spellings(), {Note.b});
        expect(
          PitchClass.b.spellings(distance: 1),
          {Note.a.sharp.sharp, Note.b, Note.c.flat},
        );
      });
    });

    group('.resolveSpelling()', () {
      test('returns the Note that matches with Accidental', () {
        expect(PitchClass.c.resolveSpelling(), Note.c);
        expect(PitchClass.c.resolveSpelling(Accidental.sharp), Note.b.sharp);
        expect(
          PitchClass.c.resolveSpelling(Accidental.doubleFlat),
          Note.d.flat.flat,
        );

        expect(PitchClass.cSharp.resolveSpelling(), Note.c.sharp);
        expect(PitchClass.cSharp.resolveSpelling(Accidental.flat), Note.d.flat);

        expect(PitchClass.d.resolveSpelling(), Note.d);
        expect(
          PitchClass.d.resolveSpelling(Accidental.doubleSharp),
          Note.c.sharp.sharp,
        );
        expect(
          PitchClass.d.resolveSpelling(Accidental.doubleFlat),
          Note.e.flat.flat,
        );

        expect(PitchClass.dSharp.resolveSpelling(), Note.d.sharp);
        expect(PitchClass.dSharp.resolveSpelling(Accidental.flat), Note.e.flat);

        expect(PitchClass.e.resolveSpelling(), Note.e);
        expect(
          PitchClass.e.resolveSpelling(Accidental.doubleSharp),
          Note.d.sharp.sharp,
        );
        expect(PitchClass.e.resolveSpelling(Accidental.flat), Note.f.flat);

        expect(PitchClass.f.resolveSpelling(), Note.f);
        expect(PitchClass.f.resolveSpelling(Accidental.sharp), Note.e.sharp);
        expect(
          PitchClass.f.resolveSpelling(Accidental.doubleFlat),
          Note.g.flat.flat,
        );

        expect(PitchClass.fSharp.resolveSpelling(), Note.f.sharp);
        expect(PitchClass.fSharp.resolveSpelling(Accidental.flat), Note.g.flat);

        expect(PitchClass.g.resolveSpelling(), Note.g);
        expect(
          PitchClass.g.resolveSpelling(Accidental.doubleSharp),
          Note.f.sharp.sharp,
        );
        expect(
          PitchClass.g.resolveSpelling(Accidental.doubleFlat),
          Note.a.flat.flat,
        );

        expect(PitchClass.gSharp.resolveSpelling(), Note.g.sharp);
        expect(PitchClass.gSharp.resolveSpelling(Accidental.flat), Note.a.flat);

        expect(PitchClass.a.resolveSpelling(), Note.a);
        expect(
          PitchClass.a.resolveSpelling(Accidental.doubleSharp),
          Note.g.sharp.sharp,
        );
        expect(
          PitchClass.a.resolveSpelling(Accidental.doubleFlat),
          Note.b.flat.flat,
        );

        expect(PitchClass.aSharp.resolveSpelling(), Note.a.sharp);
        expect(PitchClass.aSharp.resolveSpelling(Accidental.flat), Note.b.flat);

        expect(PitchClass.b.resolveSpelling(), Note.b);
        expect(
          PitchClass.b.resolveSpelling(Accidental.doubleSharp),
          Note.a.sharp.sharp,
        );
        expect(PitchClass.b.resolveSpelling(Accidental.flat), Note.c.flat);
      });

      test(
        'throws an ArgumentError when withAccidental does not match with '
        'any Note',
        () {
          expect(
            () => PitchClass.cSharp.resolveSpelling(Accidental.natural),
            throwsArgumentError,
          );
          expect(
            () => PitchClass.c.resolveSpelling(Accidental.flat),
            throwsArgumentError,
          );
          expect(
            () => PitchClass.d.resolveSpelling(Accidental.sharp),
            throwsArgumentError,
          );
          expect(
            () => PitchClass.a.resolveSpelling(Accidental.tripleFlat),
            throwsArgumentError,
          );
        },
      );
    });

    group('.resolveClosestSpelling()', () {
      test('returns the Note that matches with the preferred Accidental', () {
        expect(PitchClass.c.resolveClosestSpelling(), Note.c);
        expect(
          PitchClass.c.resolveClosestSpelling(Accidental.sharp),
          Note.b.sharp,
        );
        expect(
          PitchClass.c.resolveClosestSpelling(Accidental.doubleFlat),
          Note.d.flat.flat,
        );

        expect(PitchClass.cSharp.resolveClosestSpelling(), Note.c.sharp);
        expect(
          PitchClass.cSharp.resolveClosestSpelling(Accidental.flat),
          Note.d.flat,
        );

        // ... Similar to `.resolveSpelling()`.
      });

      test(
        'returns the closest Note where a similar call to .resolveSpelling() '
        'would throw',
        () {
          expect(
            PitchClass.cSharp.resolveClosestSpelling(Accidental.natural),
            Note.c.sharp,
          );
          expect(PitchClass.c.resolveClosestSpelling(Accidental.flat), Note.c);
          expect(PitchClass.d.resolveClosestSpelling(Accidental.sharp), Note.d);
          expect(
            PitchClass.a.resolveClosestSpelling(Accidental.tripleFlat),
            Note.a,
          );
        },
      );
    });

    group('.interval()', () {
      test('returns the Interval between this PitchClass and other', () {
        expect(PitchClass.c.interval(PitchClass.c), Interval.P1);
        expect(PitchClass.c.interval(PitchClass.cSharp), Interval.m2);

        expect(PitchClass.c.interval(PitchClass.d), Interval.M2);

        expect(PitchClass.c.interval(PitchClass.dSharp), Interval.m3);
        expect(PitchClass.c.interval(PitchClass.e), Interval.M3);
        expect(PitchClass.g.interval(PitchClass.b), Interval.M3);
        expect(PitchClass.aSharp.interval(PitchClass.d), Interval.M3);

        expect(PitchClass.c.interval(PitchClass.f), Interval.P4);
        expect(PitchClass.gSharp.interval(PitchClass.cSharp), Interval.P4);
        expect(PitchClass.gSharp.interval(PitchClass.d), Interval.A4);
        expect(PitchClass.c.interval(PitchClass.fSharp), -Interval.A4);

        expect(PitchClass.c.interval(PitchClass.g), -Interval.P4);
        expect(PitchClass.c.interval(PitchClass.gSharp), -Interval.M3);

        expect(PitchClass.c.interval(PitchClass.a), -Interval.m3);
        expect(PitchClass.c.interval(PitchClass.aSharp), -Interval.M2);

        expect(PitchClass.c.interval(PitchClass.b), -Interval.m2);
        expect(PitchClass.b.interval(PitchClass.aSharp), -Interval.m2);
      });
    });

    group('.difference()', () {
      test('returns the difference in semitones with another PitchClass', () {
        expect(PitchClass.d.difference(PitchClass.gSharp), -6);
        expect(PitchClass.dSharp.difference(PitchClass.aSharp), -5);
        expect(PitchClass.d.difference(PitchClass.aSharp), -4);
        expect(PitchClass.cSharp.difference(PitchClass.aSharp), -3);
        expect(PitchClass.cSharp.difference(PitchClass.b), -2);
        expect(PitchClass.c.difference(PitchClass.b), -1);
        expect(PitchClass.c.difference(PitchClass.c), 0);
        expect(PitchClass.c.difference(PitchClass.cSharp), 1);
        expect(PitchClass.b.difference(PitchClass.c), 1);
        expect(PitchClass.f.difference(PitchClass.g), 2);
        expect(PitchClass.f.difference(PitchClass.gSharp), 3);
        expect(PitchClass.e.difference(PitchClass.gSharp), 4);
        expect(PitchClass.a.difference(PitchClass.d), 5);
        expect(PitchClass.a.difference(PitchClass.dSharp), 6);
      });
    });

    group('.transposeBy()', () {
      test('transposes this PitchClass by Interval', () {
        expect(PitchClass.c.transposeBy(Interval.d1), PitchClass.b);
        expect(PitchClass.c.transposeBy(-Interval.d1), PitchClass.cSharp);
        expect(PitchClass.c.transposeBy(Interval.P1), PitchClass.c);
        expect(PitchClass.c.transposeBy(-Interval.P1), PitchClass.c);
        expect(PitchClass.c.transposeBy(Interval.A1), PitchClass.cSharp);
        expect(PitchClass.c.transposeBy(-Interval.A1), PitchClass.b);

        expect(PitchClass.c.transposeBy(Interval.d2), PitchClass.c);
        expect(PitchClass.c.transposeBy(-Interval.d2), PitchClass.c);
        expect(PitchClass.c.transposeBy(Interval.m2), PitchClass.cSharp);
        expect(PitchClass.c.transposeBy(-Interval.m2), PitchClass.b);

        expect(PitchClass.fSharp.transposeBy(Interval.M3), PitchClass.aSharp);
        expect(PitchClass.fSharp.transposeBy(-Interval.P4), PitchClass.cSharp);

        expect(PitchClass.g.transposeBy(Interval.P8), PitchClass.g);
      });
    });

    group('operator *()', () {
      test(
        'returns the pitch-class multiplication modulo 12 of this PitchClass',
        () {
          expect(PitchClass.cSharp * 7, PitchClass.g);
          expect(PitchClass.d * 5, PitchClass.aSharp);

          expect(
            ScalePattern.chromatic
                .on(PitchClass.c)
                .degrees
                .map((note) => note * 7),
            Interval.P5.circleFrom(PitchClass.c, distance: 12),
          );
          expect(
            ScalePattern.chromatic
                .on(PitchClass.c)
                .degrees
                .map((note) => note * 5),
            Interval.P5.circleFrom(PitchClass.c, distance: -12),
          );
        },
      );
    });

    group('.toString()', () {
      test(
        'returns the enharmonic spellings string representation of '
        'this PitchClass',
        () {
          expect(PitchClass.c.toString(), '{C}');
          expect(PitchClass.cSharp.toString(), '{C♯|D♭}');
          expect(PitchClass.d.toString(), '{D}');
          expect(PitchClass.dSharp.toString(), '{D♯|E♭}');
          expect(PitchClass.e.toString(), '{E}');
          expect(PitchClass.f.toString(), '{F}');
          expect(PitchClass.fSharp.toString(), '{F♯|G♭}');
          expect(PitchClass.g.toString(), '{G}');
          expect(PitchClass.gSharp.toString(), '{G♯|A♭}');
          expect(PitchClass.a.toString(), '{A}');
          expect(PitchClass.aSharp.toString(), '{A♯|B♭}');
          expect(PitchClass.b.toString(), '{B}');
        },
      );

      test('returns the integer string representation of this PitchClass', () {
        expect(
          PitchClass.c.toString(system: PitchClassNotation.integer),
          '0',
        );
        expect(
          PitchClass.cSharp.toString(system: PitchClassNotation.integer),
          '1',
        );
        expect(
          PitchClass.d.toString(system: PitchClassNotation.integer),
          '2',
        );
        expect(
          PitchClass.dSharp.toString(system: PitchClassNotation.integer),
          '3',
        );
        expect(
          PitchClass.e.toString(system: PitchClassNotation.integer),
          '4',
        );
        expect(
          PitchClass.f.toString(system: PitchClassNotation.integer),
          '5',
        );
        expect(
          PitchClass.fSharp.toString(system: PitchClassNotation.integer),
          '6',
        );
        expect(
          PitchClass.g.toString(system: PitchClassNotation.integer),
          '7',
        );
        expect(
          PitchClass.gSharp.toString(system: PitchClassNotation.integer),
          '8',
        );
        expect(
          PitchClass.a.toString(system: PitchClassNotation.integer),
          '9',
        );
        expect(
          PitchClass.aSharp.toString(system: PitchClassNotation.integer),
          't',
        );
        expect(
          PitchClass.b.toString(system: PitchClassNotation.integer),
          'e',
        );
      });

      test(
        'returns the string representation extending PitchClassNotation',
        () {
          expect(
            () => PitchClass.aSharp.toString(system: _SubPitchClassNotation()),
            throwsUnimplementedError,
          );
        },
      );
    });

    group('.hashCode', () {
      test('ignores equal PitchClass instances in a Set', () {
        final collection = {PitchClass.f, PitchClass.aSharp};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [PitchClass.f, PitchClass.aSharp],
        );
      });
    });

    group('.compareTo()', () {
      test('sorts PitchClasses in a collection', () {
        final orderedSet = SplayTreeSet<PitchClass>.of({
          PitchClass.fSharp,
          PitchClass.c,
          PitchClass.d,
        });
        expect(orderedSet.toList(), const [
          PitchClass.c,
          PitchClass.d,
          PitchClass.fSharp,
        ]);
      });
    });
  });
}

class _SubPitchClassNotation extends PitchClassNotation {
  @override
  String pitchClass(PitchClass pitchClass) => throw UnimplementedError();
}
