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

    group('EnharmonicSpellingsPitchClassNotation', () {
      group('.parse()', () {
        test('throws a FormatException when source is invalid', () {
          expect(() => PitchClass.parse(''), throwsFormatException);
          expect(() => PitchClass.parse('D'), throwsFormatException);
          expect(() => PitchClass.parse('z'), throwsFormatException);
          expect(() => PitchClass.parse('{}'), throwsFormatException);
          expect(() => PitchClass.parse('{z}'), throwsFormatException);
        });

        test('parses source as a PitchClass', () {
          expect(PitchClass.parse('{C}'), PitchClass.c);
          expect(PitchClass.parse('{c}'), PitchClass.c);
          expect(PitchClass.parse('{b#}'), PitchClass.c);
          expect(PitchClass.parse('{C♯|D♭}'), PitchClass.cSharp);
          expect(PitchClass.parse('{D♯|E♭}'), PitchClass.dSharp);
          expect(PitchClass.parse('{d♯}'), PitchClass.dSharp);
          expect(PitchClass.parse('{E}'), PitchClass.e);
          expect(PitchClass.parse('{F}'), PitchClass.f);
          expect(PitchClass.parse('{F#|Gb}'), PitchClass.fSharp);
          expect(PitchClass.parse('{G}'), PitchClass.g);
          expect(PitchClass.parse('{ab}'), PitchClass.gSharp);
          expect(PitchClass.parse('{G♯|A♭}'), PitchClass.gSharp);
          expect(PitchClass.parse('{A}'), PitchClass.a);
          expect(PitchClass.parse('{A♯|B♭}'), PitchClass.aSharp);
          expect(PitchClass.parse('{B}'), PitchClass.b);
        });
      });

      group('.toString()', () {
        test('returns the string representation of this PitchClass', () {
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
        });
      });
    });

    group('IntegerPitchClassNotation', () {
      group('.parse()', () {
        test('throws a FormatException when source is invalid', () {
          expect(() => PitchClass.parse(''), throwsFormatException);
          expect(() => PitchClass.parse('z'), throwsFormatException);
          expect(() => PitchClass.parse('{}'), throwsFormatException);
          expect(() => PitchClass.parse('T'), throwsFormatException);
        });

        test('parses source as a PitchClass', () {
          expect(PitchClass.parse('0'), PitchClass.c);
          expect(PitchClass.parse('1'), PitchClass.cSharp);
          expect(PitchClass.parse('2'), PitchClass.d);
          expect(PitchClass.parse('3'), PitchClass.dSharp);
          expect(PitchClass.parse('4'), PitchClass.e);
          expect(PitchClass.parse('5'), PitchClass.f);
          expect(PitchClass.parse('6'), PitchClass.fSharp);
          expect(PitchClass.parse('7'), PitchClass.g);
          expect(PitchClass.parse('8'), PitchClass.gSharp);
          expect(PitchClass.parse('9'), PitchClass.a);
          expect(PitchClass.parse('t'), PitchClass.aSharp);
          expect(PitchClass.parse('e'), PitchClass.b);
        });
      });

      group('.toString()', () {
        test('returns the string representation of this PitchClass', () {
          const formatter = IntegerPitchClassNotation();
          expect(PitchClass.c.toString(formatter: formatter), '0');
          expect(PitchClass.cSharp.toString(formatter: formatter), '1');
          expect(PitchClass.d.toString(formatter: formatter), '2');
          expect(PitchClass.dSharp.toString(formatter: formatter), '3');
          expect(PitchClass.e.toString(formatter: formatter), '4');
          expect(PitchClass.f.toString(formatter: formatter), '5');
          expect(PitchClass.fSharp.toString(formatter: formatter), '6');
          expect(PitchClass.g.toString(formatter: formatter), '7');
          expect(PitchClass.gSharp.toString(formatter: formatter), '8');
          expect(PitchClass.a.toString(formatter: formatter), '9');
          expect(PitchClass.aSharp.toString(formatter: formatter), 't');
          expect(PitchClass.b.toString(formatter: formatter), 'e');
        });
      });
    });

    group('.spellings()', () {
      test('returns the correct Note spellings for this PitchClass', () {
        expect(PitchClass.c.spellings(), {Note.c});
        expect(PitchClass.c.spellings(distance: 1), <Note>{
          .b.sharp,
          .c,
          .d.flat.flat,
        });

        expect(PitchClass.cSharp.spellings(), <Note>{.c.sharp, .d.flat});
        expect(PitchClass.cSharp.spellings(distance: 1), <Note>{
          .b.sharp.sharp,
          .c.sharp,
          .d.flat,
          .e.flat.flat.flat,
        });

        expect(PitchClass.d.spellings(), {Note.d});
        expect(PitchClass.d.spellings(distance: 1), <Note>{
          .c.sharp.sharp,
          .d,
          .e.flat.flat,
        });

        expect(PitchClass.dSharp.spellings(), <Note>{.d.sharp, .e.flat});
        expect(PitchClass.dSharp.spellings(distance: 1), <Note>{
          .c.sharp.sharp.sharp,
          .d.sharp,
          .e.flat,
          .f.flat.flat,
        });

        expect(PitchClass.e.spellings(), {Note.e});
        expect(PitchClass.e.spellings(distance: 1), <Note>{
          .d.sharp.sharp,
          .e,
          .f.flat,
        });

        expect(PitchClass.f.spellings(), {Note.f});
        expect(PitchClass.f.spellings(distance: 1), <Note>{
          .e.sharp,
          .f,
          .g.flat.flat,
        });

        expect(PitchClass.fSharp.spellings(), <Note>{.f.sharp, .g.flat});
        expect(PitchClass.fSharp.spellings(distance: 1), <Note>{
          .e.sharp.sharp,
          .f.sharp,
          .g.flat,
          .a.flat.flat.flat,
        });

        expect(PitchClass.g.spellings(), {Note.g});
        expect(PitchClass.g.spellings(distance: 1), <Note>{
          .f.sharp.sharp,
          .g,
          .a.flat.flat,
        });

        expect(PitchClass.gSharp.spellings(), <Note>{.g.sharp, .a.flat});
        expect(PitchClass.gSharp.spellings(distance: 1), <Note>{
          .f.sharp.sharp.sharp,
          .g.sharp,
          .a.flat,
          .b.flat.flat.flat,
        });

        expect(PitchClass.a.spellings(), {Note.a});
        expect(PitchClass.a.spellings(distance: 1), <Note>{
          .g.sharp.sharp,
          .a,
          .b.flat.flat,
        });

        expect(PitchClass.aSharp.spellings(), <Note>{.a.sharp, .b.flat});
        expect(PitchClass.aSharp.spellings(distance: 1), <Note>{
          .g.sharp.sharp.sharp,
          .a.sharp,
          .b.flat,
          .c.flat.flat,
        });

        expect(PitchClass.b.spellings(), {Note.b});
        expect(PitchClass.b.spellings(distance: 1), <Note>{
          .a.sharp.sharp,
          .b,
          .c.flat,
        });
      });
    });

    group('.resolveSpelling()', () {
      test('returns the Note that matches with Accidental', () {
        expect(PitchClass.c.resolveSpelling(), Note.c);
        expect(PitchClass.c.resolveSpelling(.sharp), Note.b.sharp);
        expect(PitchClass.c.resolveSpelling(.doubleFlat), Note.d.flat.flat);

        expect(PitchClass.cSharp.resolveSpelling(), Note.c.sharp);
        expect(PitchClass.cSharp.resolveSpelling(.flat), Note.d.flat);

        expect(PitchClass.d.resolveSpelling(), Note.d);
        expect(PitchClass.d.resolveSpelling(.doubleSharp), Note.c.sharp.sharp);
        expect(PitchClass.d.resolveSpelling(.doubleFlat), Note.e.flat.flat);

        expect(PitchClass.dSharp.resolveSpelling(), Note.d.sharp);
        expect(PitchClass.dSharp.resolveSpelling(.flat), Note.e.flat);

        expect(PitchClass.e.resolveSpelling(), Note.e);
        expect(PitchClass.e.resolveSpelling(.doubleSharp), Note.d.sharp.sharp);
        expect(PitchClass.e.resolveSpelling(.flat), Note.f.flat);

        expect(PitchClass.f.resolveSpelling(), Note.f);
        expect(PitchClass.f.resolveSpelling(.sharp), Note.e.sharp);
        expect(PitchClass.f.resolveSpelling(.doubleFlat), Note.g.flat.flat);

        expect(PitchClass.fSharp.resolveSpelling(), Note.f.sharp);
        expect(PitchClass.fSharp.resolveSpelling(.flat), Note.g.flat);

        expect(PitchClass.g.resolveSpelling(), Note.g);
        expect(PitchClass.g.resolveSpelling(.doubleSharp), Note.f.sharp.sharp);
        expect(PitchClass.g.resolveSpelling(.doubleFlat), Note.a.flat.flat);

        expect(PitchClass.gSharp.resolveSpelling(), Note.g.sharp);
        expect(PitchClass.gSharp.resolveSpelling(.flat), Note.a.flat);

        expect(PitchClass.a.resolveSpelling(), Note.a);
        expect(PitchClass.a.resolveSpelling(.doubleSharp), Note.g.sharp.sharp);
        expect(PitchClass.a.resolveSpelling(.doubleFlat), Note.b.flat.flat);

        expect(PitchClass.aSharp.resolveSpelling(), Note.a.sharp);
        expect(PitchClass.aSharp.resolveSpelling(.flat), Note.b.flat);

        expect(PitchClass.b.resolveSpelling(), Note.b);
        expect(PitchClass.b.resolveSpelling(.doubleSharp), Note.a.sharp.sharp);
        expect(PitchClass.b.resolveSpelling(.flat), Note.c.flat);
      });

      test('throws an ArgumentError when withAccidental does not match with '
          'any Note', () {
        expect(
          () => PitchClass.cSharp.resolveSpelling(.natural),
          throwsArgumentError,
        );
        expect(() => PitchClass.c.resolveSpelling(.flat), throwsArgumentError);
        expect(() => PitchClass.d.resolveSpelling(.sharp), throwsArgumentError);
        expect(
          () => PitchClass.a.resolveSpelling(.tripleFlat),
          throwsArgumentError,
        );
      });
    });

    group('.resolveClosestSpelling()', () {
      test('returns the Note that matches with the preferred Accidental', () {
        expect(PitchClass.c.resolveClosestSpelling(), Note.c);
        expect(PitchClass.c.resolveClosestSpelling(.sharp), Note.b.sharp);
        expect(
          PitchClass.c.resolveClosestSpelling(.doubleFlat),
          Note.d.flat.flat,
        );

        expect(PitchClass.cSharp.resolveClosestSpelling(), Note.c.sharp);
        expect(PitchClass.cSharp.resolveClosestSpelling(.flat), Note.d.flat);

        // ... Similar to `.resolveSpelling()`.
      });

      test(
        'returns the closest Note where a similar call to .resolveSpelling() '
        'would throw',
        () {
          expect(
            PitchClass.cSharp.resolveClosestSpelling(.natural),
            Note.c.sharp,
          );
          expect(PitchClass.c.resolveClosestSpelling(.flat), Note.c);
          expect(PitchClass.d.resolveClosestSpelling(.sharp), Note.d);
          expect(PitchClass.a.resolveClosestSpelling(.tripleFlat), Note.a);
        },
      );
    });

    group('.interval()', () {
      test('returns the Interval between this PitchClass and other', () {
        expect(PitchClass.c.interval(.c), Interval.P1);
        expect(PitchClass.c.interval(.cSharp), Interval.m2);

        expect(PitchClass.c.interval(.d), Interval.M2);

        expect(PitchClass.c.interval(.dSharp), Interval.m3);
        expect(PitchClass.c.interval(.e), Interval.M3);
        expect(PitchClass.g.interval(.b), Interval.M3);
        expect(PitchClass.aSharp.interval(.d), Interval.M3);

        expect(PitchClass.c.interval(.f), Interval.P4);
        expect(PitchClass.gSharp.interval(.cSharp), Interval.P4);
        expect(PitchClass.gSharp.interval(.d), Interval.A4);
        expect(PitchClass.c.interval(.fSharp), -Interval.A4);

        expect(PitchClass.c.interval(.g), -Interval.P4);
        expect(PitchClass.c.interval(.gSharp), -Interval.M3);

        expect(PitchClass.c.interval(.a), -Interval.m3);
        expect(PitchClass.c.interval(.aSharp), -Interval.M2);

        expect(PitchClass.c.interval(.b), -Interval.m2);
        expect(PitchClass.b.interval(.aSharp), -Interval.m2);
      });
    });

    group('.difference()', () {
      test('returns the difference in semitones with another PitchClass', () {
        expect(PitchClass.d.difference(.gSharp), -6);
        expect(PitchClass.dSharp.difference(.aSharp), -5);
        expect(PitchClass.d.difference(.aSharp), -4);
        expect(PitchClass.cSharp.difference(.aSharp), -3);
        expect(PitchClass.cSharp.difference(.b), -2);
        expect(PitchClass.c.difference(.b), -1);
        expect(PitchClass.c.difference(.c), 0);
        expect(PitchClass.c.difference(.cSharp), 1);
        expect(PitchClass.b.difference(.c), 1);
        expect(PitchClass.f.difference(.g), 2);
        expect(PitchClass.f.difference(.gSharp), 3);
        expect(PitchClass.e.difference(.gSharp), 4);
        expect(PitchClass.a.difference(.d), 5);
        expect(PitchClass.a.difference(.dSharp), 6);
      });
    });

    group('.respelledUpwards', () {
      test('no-op for PitchClass', () {
        expect(PitchClass.c.respelledUpwards, PitchClass.c);
        expect(PitchClass.fSharp.respelledUpwards, PitchClass.fSharp);
      });
    });

    group('.respelledDownwards', () {
      test('no-op for PitchClass', () {
        expect(PitchClass.d.respelledDownwards, PitchClass.d);
        expect(PitchClass.aSharp.respelledDownwards, PitchClass.aSharp);
      });
    });

    group('.respelledSimple', () {
      test('no-op for PitchClass', () {
        expect(PitchClass.e.respelledSimple, PitchClass.e);
        expect(PitchClass.dSharp.respelledSimple, PitchClass.dSharp);
      });
    });

    group('.transposeBy()', () {
      test('transposes this PitchClass by Interval', () {
        expect(PitchClass.c.transposeBy(.d1), PitchClass.b);
        expect(PitchClass.c.transposeBy(-Interval.d1), PitchClass.cSharp);
        expect(PitchClass.c.transposeBy(.P1), PitchClass.c);
        expect(PitchClass.c.transposeBy(-Interval.P1), PitchClass.c);
        expect(PitchClass.c.transposeBy(.A1), PitchClass.cSharp);
        expect(PitchClass.c.transposeBy(-Interval.A1), PitchClass.b);

        expect(PitchClass.c.transposeBy(.d2), PitchClass.c);
        expect(PitchClass.c.transposeBy(-Interval.d2), PitchClass.c);
        expect(PitchClass.c.transposeBy(.m2), PitchClass.cSharp);
        expect(PitchClass.c.transposeBy(-Interval.m2), PitchClass.b);

        expect(PitchClass.fSharp.transposeBy(.M3), PitchClass.aSharp);
        expect(PitchClass.fSharp.transposeBy(-Interval.P4), PitchClass.cSharp);

        expect(PitchClass.g.transposeBy(.P8), PitchClass.g);
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
            Interval.P5.circleFrom(PitchClass.c).take(13),
          );
          expect(
            ScalePattern.chromatic
                .on(PitchClass.c)
                .degrees
                .map((note) => note * 5),
            (-Interval.P5).circleFrom(PitchClass.c).take(13),
          );
        },
      );
    });

    group('.hashCode', () {
      test('ignores equal PitchClass instances in a Set', () {
        final collection = <PitchClass>{.f, .aSharp};
        collection.addAll(collection);
        expect(collection.toList(), const <PitchClass>[.f, .aSharp]);
      });
    });

    group('.compareTo()', () {
      test('sorts PitchClasses in a collection', () {
        final orderedSet = SplayTreeSet<PitchClass>.of({.fSharp, .c, .d});
        expect(orderedSet.toList(), const <PitchClass>[.c, .d, .fSharp]);
      });
    });
  });
}
