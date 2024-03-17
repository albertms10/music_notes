import 'dart:collection' show SplayTreeSet;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Note.parse('x'), throwsFormatException);
      });

      test('parses source as a Note and return its value', () {
        expect(Note.parse('d'), Note.d);
        expect(Note.parse('g'), Note.g);
        expect(Note.parse('Bb'), Note.b.flat);
        expect(Note.parse('bb'), Note.b.flat);
        expect(Note.parse('f♯'), Note.f.sharp);
        expect(Note.parse('d#'), Note.d.sharp);
        expect(Note.parse('A♭'), Note.a.flat);
        expect(Note.parse('abb'), Note.a.flat.flat);
        expect(Note.parse('cx'), Note.c.sharp.sharp);
        expect(Note.parse('e#x'), Note.e.sharp.sharp.sharp);
      });
    });

    group('.semitones', () {
      test('returns the semitones value of this Note', () {
        expect(Note.c.flat.semitones, -1);
        expect(Note.c.semitones, 0);
        expect(Note.c.sharp.semitones, 1);
        expect(Note.d.flat.semitones, 1);
        expect(Note.d.semitones, 2);
        expect(Note.d.sharp.semitones, 3);
        expect(Note.e.flat.semitones, 3);
        expect(Note.e.semitones, 4);
        expect(Note.f.semitones, 5);
        expect(Note.f.sharp.semitones, 6);
        expect(Note.g.flat.semitones, 6);
        expect(Note.g.semitones, 7);
        expect(Note.g.sharp.semitones, 8);
        expect(Note.a.flat.semitones, 8);
        expect(Note.a.semitones, 9);
        expect(Note.a.sharp.semitones, 10);
        expect(Note.b.flat.semitones, 10);
        expect(Note.b.semitones, 11);
        expect(Note.b.sharp.semitones, 12);
      });
    });

    group('.difference()', () {
      test('returns the difference in semitones with another Note', () {
        expect(Note.d.difference(Note.a.flat), -6);
        expect(Note.e.flat.difference(Note.b.flat), -5);
        expect(Note.d.sharp.difference(Note.a.sharp), -5);
        expect(Note.d.difference(Note.a.sharp), -4);
        expect(Note.c.sharp.difference(Note.b.flat), -3);
        expect(Note.c.sharp.difference(Note.b), -2);
        expect(Note.d.flat.difference(Note.b), -2);
        expect(Note.c.difference(Note.b), -1);
        expect(Note.c.difference(Note.c), 0);
        expect(Note.e.sharp.difference(Note.f), 0);
        expect(Note.c.difference(Note.d.flat), 1);
        expect(Note.c.difference(Note.c.sharp), 1);
        expect(Note.b.difference(Note.c), 1);
        expect(Note.f.difference(Note.g), 2);
        expect(Note.f.difference(Note.a.flat), 3);
        expect(Note.e.difference(Note.a.flat), 4);
        expect(Note.a.difference(Note.d), 5);
        expect(Note.a.difference(Note.d.sharp), 6);
      });
    });

    group('.sharp', () {
      test('returns this Note sharpened by 1 semitone', () {
        expect(Note.f.sharp, const Note(BaseNote.f, Accidental.sharp));
        expect(Note.a.sharp, const Note(BaseNote.a, Accidental.sharp));
        expect(Note.e.sharp, const Note(BaseNote.e, Accidental.sharp));
        expect(Note.b.flat.sharp, Note.b);
        expect(
          Note.g.sharp.sharp,
          const Note(BaseNote.g, Accidental.doubleSharp),
        );
        expect(
          Note.c.sharp.sharp.sharp,
          const Note(BaseNote.c, Accidental.tripleSharp),
        );
      });
    });

    group('.flat', () {
      test('returns this Note flattened by 1 semitone', () {
        expect(Note.e.flat, const Note(BaseNote.e, Accidental.flat));
        expect(Note.a.flat, const Note(BaseNote.a, Accidental.flat));
        expect(Note.d.flat, const Note(BaseNote.d, Accidental.flat));
        expect(Note.g.flat.sharp, Note.g);
        expect(
          Note.e.flat.flat,
          const Note(BaseNote.e, Accidental.doubleFlat),
        );
        expect(
          Note.c.flat.flat.flat,
          const Note(BaseNote.c, Accidental.tripleFlat),
        );
      });
    });

    group('.natural', () {
      test('returns this Note natural', () {
        expect(Note.e.natural, Note.e);
        expect(Note.a.flat.natural, Note.a);
        expect(Note.f.sharp.natural, Note.f);
        expect(Note.e.sharp.sharp.natural, Note.e);
      });
    });

    group('.major', () {
      test('returns the major Key from this Note', () {
        expect(Note.c.major, const Key(Note.c, TonalMode.major));
        expect(Note.a.major, const Key(Note.a, TonalMode.major));
        expect(Note.b.flat.major, Key(Note.b.flat, TonalMode.major));
        expect(Note.c.sharp.major, Key(Note.c.sharp, TonalMode.major));
      });
    });

    group('.minor', () {
      test('returns the minor Key from this Note', () {
        expect(Note.c.minor, const Key(Note.c, TonalMode.minor));
        expect(Note.e.minor, const Key(Note.e, TonalMode.minor));
        expect(Note.a.flat.minor, Key(Note.a.flat, TonalMode.minor));
        expect(Note.d.sharp.minor, Key(Note.d.sharp, TonalMode.minor));
      });
    });

    group('.augmentedTriad', () {
      test('returns the augmented triad on this Note', () {
        expect(Note.c.augmentedTriad, Chord([Note.c, Note.e, Note.g.sharp]));
        expect(
          Note.a.augmentedTriad,
          Chord([Note.a, Note.c.sharp, Note.e.sharp]),
        );
        expect(
          Note.b.augmentedTriad,
          Chord([Note.b, Note.d.sharp, Note.f.sharp.sharp]),
        );
      });
    });

    group('.majorTriad', () {
      test('returns the major triad on this Note', () {
        expect(Note.c.majorTriad, const Chord([Note.c, Note.e, Note.g]));
        expect(
          Note.e.flat.majorTriad,
          Chord([Note.e.flat, Note.g, Note.b.flat]),
        );
        expect(
          Note.b.majorTriad,
          Chord([Note.b, Note.d.sharp, Note.f.sharp]),
        );
      });
    });

    group('.minorTriad', () {
      test('returns the minor triad on this Note', () {
        expect(
          Note.d.flat.minorTriad,
          Chord([Note.d.flat, Note.f.flat, Note.a.flat]),
        );
        expect(
          Note.g.sharp.minorTriad,
          Chord([Note.g.sharp, Note.b, Note.d.sharp]),
        );
        expect(Note.a.minorTriad, const Chord([Note.a, Note.c, Note.e]));
      });
    });

    group('.diminishedTriad', () {
      test('returns the diminished triad on this Note', () {
        expect(Note.e.diminishedTriad, Chord([Note.e, Note.g, Note.b.flat]));
        expect(
          Note.g.flat.diminishedTriad,
          Chord([Note.g.flat, Note.b.flat.flat, Note.d.flat.flat]),
        );
        expect(Note.b.diminishedTriad, const Chord([Note.b, Note.d, Note.f]));
      });
    });

    group('.respellByBaseNote()', () {
      test('returns this Note respelled by BaseNote', () {
        expect(Note.c.sharp.respellByBaseNote(BaseNote.d), Note.d.flat);
        expect(Note.e.flat.respellByBaseNote(BaseNote.d), Note.d.sharp);
        expect(Note.e.sharp.respellByBaseNote(BaseNote.f), Note.f);
        expect(Note.f.flat.respellByBaseNote(BaseNote.e), Note.e);
        expect(Note.c.respellByBaseNote(BaseNote.b), Note.b.sharp);
        expect(Note.c.respellByBaseNote(BaseNote.d), Note.d.flat.flat);
        expect(Note.b.respellByBaseNote(BaseNote.c), Note.c.flat);
        expect(Note.b.respellByBaseNote(BaseNote.a), Note.a.sharp.sharp);
      });
    });

    group('.respellByOrdinalDistance()', () {
      test('returns this Note respelled by ordinal distance', () {
        expect(Note.c.sharp.respellByOrdinalDistance(1), Note.d.flat);
        expect(Note.d.flat.respellByOrdinalDistance(-1), Note.c.sharp);
        expect(Note.c.respellByOrdinalDistance(1), Note.d.flat.flat);
        expect(Note.d.respellByOrdinalDistance(-1), Note.c.sharp.sharp);
        expect(Note.g.flat.respellByOrdinalDistance(-1), Note.f.sharp);
        expect(Note.e.sharp.respellByOrdinalDistance(2), Note.g.flat.flat);
        expect(Note.f.respellByOrdinalDistance(7), Note.f);

        expect(
          Note.f.respellByOrdinalDistance(2),
          const Note(BaseNote.a, Accidental(-4)),
        );
        expect(
          Note.f.respellByOrdinalDistance(3),
          const Note(BaseNote.b, Accidental(-6)),
        );
        expect(
          Note.f.respellByOrdinalDistance(4),
          const Note(BaseNote.c, Accidental(5)),
        );
        expect(
          Note.f.respellByOrdinalDistance(-3),
          const Note(BaseNote.c, Accidental(5)),
        );
      });
    });

    group('.respelledUpwards', () {
      test('returns this Note respelled upwards', () {
        expect(Note.c.respelledUpwards, Note.d.flat.flat);
        expect(Note.c.sharp.respelledUpwards, Note.d.flat);
        expect(Note.d.flat.respelledUpwards, Note.e.flat.flat.flat);
        expect(Note.c.sharp.sharp.respelledUpwards, Note.d);
        expect(Note.b.sharp.respelledUpwards, Note.c);
      });
    });

    group('.respelledDownwards', () {
      test('returns this Note respelled downwards', () {
        expect(Note.c.respelledDownwards, Note.b.sharp);
        expect(Note.c.sharp.respelledDownwards, Note.b.sharp.sharp);
        expect(Note.d.flat.respelledDownwards, Note.c.sharp);
        expect(Note.d.flat.flat.respelledDownwards, Note.c);
        expect(Note.c.flat.respelledDownwards, Note.b);
      });
    });

    group('.respellByAccidental()', () {
      test('returns this Note respelled by Accidental', () {
        expect(Note.a.sharp.respellByAccidental(Accidental.flat), Note.b.flat);
        expect(Note.g.flat.respellByAccidental(Accidental.sharp), Note.f.sharp);
        expect(Note.c.flat.respellByAccidental(Accidental.natural), Note.b);
        expect(Note.b.sharp.respellByAccidental(Accidental.natural), Note.c);
        expect(Note.f.flat.respellByAccidental(Accidental.natural), Note.e);
        expect(Note.e.sharp.respellByAccidental(Accidental.natural), Note.f);
        expect(
          Note.f.respellByAccidental(Accidental.doubleFlat),
          Note.g.flat.flat,
        );
        expect(
          Note.a.respellByAccidental(Accidental.doubleSharp),
          Note.g.sharp.sharp,
        );
      });

      test('returns the next closest spelling when no possible respelling', () {
        expect(
          Note.d.flat.respellByAccidental(Accidental.natural),
          Note.d.flat,
        );
        expect(
          Note.a.sharp.respellByAccidental(Accidental.natural),
          Note.a.sharp,
        );
        expect(
          Note.b.flat.flat.flat.respellByAccidental(Accidental.natural),
          Note.a.flat,
        );
        expect(
          Note.b.sharp.sharp.respellByAccidental(Accidental.natural),
          Note.c.sharp,
        );

        expect(
          Note.d.respellByAccidental(Accidental.sharp),
          Note.c.sharp.sharp,
        );
        expect(Note.d.respellByAccidental(Accidental.flat), Note.e.flat.flat);
        expect(
          Note.e.respellByAccidental(Accidental.doubleFlat),
          Note.g.flat.flat.flat,
        );
        expect(
          Note.f.respellByAccidental(Accidental.doubleSharp),
          Note.d.sharp.sharp.sharp,
        );
        expect(
          Note.b.respellByAccidental(Accidental.doubleFlat),
          Note.d.flat.flat.flat,
        );
        expect(
          Note.c.respellByAccidental(Accidental.doubleSharp),
          Note.a.sharp.sharp.sharp,
        );
      });
    });

    group('.respelledSimple', () {
      test('returns this Note with the simplest Accidental spelling', () {
        expect(Note.c.respelledSimple, Note.c);
        expect(Note.b.respelledSimple, Note.b);
        expect(Note.d.flat.respelledSimple, Note.d.flat);
        expect(Note.c.sharp.respelledSimple, Note.c.sharp);
        expect(Note.e.sharp.respelledSimple, Note.f);
        expect(Note.c.flat.respelledSimple, Note.b);
        expect(Note.g.sharp.sharp.respelledSimple, Note.a);
        expect(Note.a.flat.flat.flat.respelledSimple, Note.g.flat);
        expect(Note.f.sharp.sharp.sharp.respelledSimple, Note.g.sharp);
      });
    });

    group('.isEnharmonicWith()', () {
      test(
        'returns whether this Note is enharmonically equivalent to other',
        () {
          expect(Note.c.sharp.isEnharmonicWith(Note.d.flat), isTrue);
          expect(Note.b.isEnharmonicWith(Note.c.flat), isTrue);
          expect(Note.b.sharp.isEnharmonicWith(Note.c), isTrue);
          expect(Note.e.isEnharmonicWith(Note.f.flat), isTrue);
          expect(Note.e.sharp.isEnharmonicWith(Note.f), isTrue);
          expect(Note.e.sharp.sharp.isEnharmonicWith(Note.g.flat), isTrue);
          expect(Note.a.flat.flat.isEnharmonicWith(Note.f.sharp.sharp), isTrue);

          expect(Note.c.isEnharmonicWith(Note.b), isFalse);
          expect(Note.f.isEnharmonicWith(Note.g), isFalse);
          expect(Note.a.isEnharmonicWith(Note.d.sharp), isFalse);
        },
      );
    });

    group('.circleOfFifths()', () {
      test('returns the circle of fifths starting from this Note', () {
        var (:sharps, :flats) = Note.c.circleOfFifths();
        expect(
          sharps,
          [Note.g, Note.d, Note.a, Note.e, Note.b, Note.f.sharp],
        );
        expect(flats, [
          Note.f,
          Note.b.flat,
          Note.e.flat,
          Note.a.flat,
          Note.d.flat,
          Note.g.flat,
        ]);

        (:sharps, :flats) = Note.a.circleOfFifths(distance: 7);
        expect(
          sharps,
          [
            Note.e,
            Note.b,
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
          ],
        );
        expect(
          flats,
          [
            Note.d,
            Note.g,
            Note.c,
            Note.f,
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
          ],
        );
      });
    });

    group('.flatCircleOfFifths()', () {
      test('returns the flattened version of the circle of fifths', () {
        expect(Note.c.flatCircleOfFifths(), [
          Note.g.flat,
          Note.d.flat,
          Note.a.flat,
          Note.e.flat,
          Note.b.flat,
          Note.f,
          Note.c,
          Note.g,
          Note.d,
          Note.a,
          Note.e,
          Note.b,
          Note.f.sharp,
        ]);
        expect(Note.a.flatCircleOfFifths(distance: 7), [
          Note.a.flat,
          Note.e.flat,
          Note.b.flat,
          Note.f,
          Note.c,
          Note.g,
          Note.d,
          Note.a,
          Note.e,
          Note.b,
          Note.f.sharp,
          Note.c.sharp,
          Note.g.sharp,
          Note.d.sharp,
          Note.a.sharp,
        ]);
        expect(Note.e.flat.flatCircleOfFifths(distance: 3), [
          Note.g.flat,
          Note.d.flat,
          Note.a.flat,
          Note.e.flat,
          Note.b.flat,
          Note.f,
          Note.c,
        ]);
        expect(
          Note.c.flatCircleOfFifths(distance: 3),
          ScalePattern.dorian
              .on(Note.c)
              .degrees
              .skip(1)
              .sorted(Note.compareByFifthsDistance),
        );
      });
    });

    group('.circleOfFifthsDistance', () {
      test('returns the circle of fifths distance of this Note', () {
        expect(Note.b.flat.flat.flat.circleOfFifthsDistance, -16);
        expect(Note.f.flat.flat.circleOfFifthsDistance, -15);
        expect(Note.c.flat.flat.circleOfFifthsDistance, -14);
        expect(Note.g.flat.flat.circleOfFifthsDistance, -13);
        expect(Note.d.flat.flat.circleOfFifthsDistance, -12);
        expect(Note.a.flat.flat.circleOfFifthsDistance, -11);
        expect(Note.e.flat.flat.circleOfFifthsDistance, -10);
        expect(Note.b.flat.flat.circleOfFifthsDistance, -9);
        expect(Note.f.flat.circleOfFifthsDistance, -8);
        expect(Note.c.flat.circleOfFifthsDistance, -7);
        expect(Note.g.flat.circleOfFifthsDistance, -6);
        expect(Note.d.flat.circleOfFifthsDistance, -5);
        expect(Note.a.flat.circleOfFifthsDistance, -4);
        expect(Note.e.flat.circleOfFifthsDistance, -3);
        expect(Note.b.flat.circleOfFifthsDistance, -2);
        expect(Note.f.circleOfFifthsDistance, -1);
        expect(Note.c.circleOfFifthsDistance, 0);
        expect(Note.g.circleOfFifthsDistance, 1);
        expect(Note.d.circleOfFifthsDistance, 2);
        expect(Note.a.circleOfFifthsDistance, 3);
        expect(Note.e.circleOfFifthsDistance, 4);
        expect(Note.b.circleOfFifthsDistance, 5);
        expect(Note.f.sharp.circleOfFifthsDistance, 6);
        expect(Note.c.sharp.circleOfFifthsDistance, 7);
        expect(Note.g.sharp.circleOfFifthsDistance, 8);
        expect(Note.d.sharp.circleOfFifthsDistance, 9);
        expect(Note.a.sharp.circleOfFifthsDistance, 10);
        expect(Note.e.sharp.circleOfFifthsDistance, 11);
        expect(Note.b.sharp.circleOfFifthsDistance, 12);
        expect(Note.f.sharp.sharp.circleOfFifthsDistance, 13);
        expect(Note.c.sharp.sharp.circleOfFifthsDistance, 14);
        expect(Note.g.sharp.sharp.circleOfFifthsDistance, 15);
        expect(Note.d.sharp.sharp.circleOfFifthsDistance, 16);
      });
    });

    group('.fifthsDistanceWith()', () {
      test('returns the fifths distance between this Note and other', () {
        expect(Note.c.fifthsDistanceWith(Note.c.flat.flat), -14);
        expect(Note.c.fifthsDistanceWith(Note.g.flat.flat), -13);
        expect(Note.c.fifthsDistanceWith(Note.d.flat.flat), -12);
        expect(Note.c.fifthsDistanceWith(Note.a.flat.flat), -11);
        expect(Note.c.fifthsDistanceWith(Note.e.flat.flat), -10);
        expect(Note.c.fifthsDistanceWith(Note.b.flat.flat), -9);
        expect(Note.c.fifthsDistanceWith(Note.f.flat), -8);
        expect(Note.c.fifthsDistanceWith(Note.c.flat), -7);
        expect(Note.c.fifthsDistanceWith(Note.g.flat), -6);
        expect(Note.c.fifthsDistanceWith(Note.d.flat), -5);
        expect(Note.c.fifthsDistanceWith(Note.a.flat), -4);
        expect(Note.c.fifthsDistanceWith(Note.e.flat), -3);
        expect(Note.c.fifthsDistanceWith(Note.b.flat), -2);
        expect(Note.c.fifthsDistanceWith(Note.f), -1);
        expect(Note.c.fifthsDistanceWith(Note.c), 0);
        expect(Note.c.fifthsDistanceWith(Note.g), 1);
        expect(Note.c.fifthsDistanceWith(Note.d), 2);
        expect(Note.c.fifthsDistanceWith(Note.a), 3);
        expect(Note.c.fifthsDistanceWith(Note.e), 4);
        expect(Note.c.fifthsDistanceWith(Note.b), 5);
        expect(Note.c.fifthsDistanceWith(Note.f.sharp), 6);
        expect(Note.c.fifthsDistanceWith(Note.c.sharp), 7);
        expect(Note.c.fifthsDistanceWith(Note.g.sharp), 8);
        expect(Note.c.fifthsDistanceWith(Note.d.sharp), 9);
        expect(Note.c.fifthsDistanceWith(Note.a.sharp), 10);
        expect(Note.c.fifthsDistanceWith(Note.e.sharp), 11);
        expect(Note.c.fifthsDistanceWith(Note.b.sharp), 12);
        expect(Note.c.fifthsDistanceWith(Note.f.sharp.sharp), 13);
        expect(Note.c.fifthsDistanceWith(Note.c.sharp.sharp), 14);

        expect(Note.a.flat.fifthsDistanceWith(Note.d.flat), -1);
        expect(Note.a.flat.fifthsDistanceWith(Note.e.flat), 1);
        expect(Note.a.flat.fifthsDistanceWith(Note.d), 6);
        expect(Note.a.flat.fifthsDistanceWith(Note.c.sharp), 11);

        expect(Note.f.sharp.fifthsDistanceWith(Note.d.sharp.sharp), 10);
        expect(Note.f.sharp.fifthsDistanceWith(Note.f), -7);
        expect(Note.f.sharp.fifthsDistanceWith(Note.d.flat), -11);
        expect(Note.f.sharp.fifthsDistanceWith(Note.g.flat.flat), -19);
      });
    });

    group('.interval()', () {
      test('returns the Interval between this Note and other', () {
        expect(Note.c.interval(Note.c), Interval.P1);
        expect(Note.c.interval(Note.c.sharp), Interval.A1);
        expect(Note.f.flat.interval(Note.f), Interval.A1);

        expect(Note.b.sharp.interval(Note.c), Interval.d2);
        expect(Note.c.interval(Note.d.flat.flat), Interval.d2);
        expect(Note.f.flat.interval(Note.g.flat.flat), Interval.m2);
        expect(Note.c.interval(Note.d.flat), Interval.m2);
        expect(Note.c.interval(Note.d), Interval.M2);
        expect(Note.c.interval(Note.d.sharp), Interval.A2);

        expect(Note.c.interval(Note.e.flat.flat), Interval.d3);
        expect(Note.c.interval(Note.e.flat), Interval.m3);
        expect(Note.c.interval(Note.e), Interval.M3);
        expect(Note.g.interval(Note.b), Interval.M3);
        expect(Note.b.flat.interval(Note.d), Interval.M3);
        expect(Note.c.interval(Note.e.sharp), Interval.A3);

        expect(Note.c.interval(Note.f.flat), Interval.d4);
        expect(Note.c.interval(Note.f), Interval.P4);
        expect(Note.g.sharp.interval(Note.c.sharp), Interval.P4);
        expect(Note.a.flat.interval(Note.d), Interval.A4);
        expect(Note.c.interval(Note.f.sharp), Interval.A4);

        expect(Note.c.interval(Note.g.flat), Interval.d5);
        expect(Note.c.interval(Note.g), Interval.P5);
        expect(Note.c.interval(Note.g.sharp), Interval.A5);

        expect(Note.c.interval(Note.a.flat.flat), Interval.d6);
        expect(Note.c.interval(Note.a.flat), Interval.m6);
        expect(Note.c.interval(Note.a), Interval.M6);
        expect(Note.c.interval(Note.a.sharp), Interval.A6);

        expect(Note.c.interval(Note.b.flat.flat), Interval.d7);
        expect(Note.c.interval(Note.b.flat), Interval.m7);
        expect(Note.c.interval(Note.b), Interval.M7);
        expect(Note.b.interval(Note.a.sharp), Interval.M7);

        expect(skip: true, Note.c.interval(Note.b.sharp), Interval.M7);
      });
    });

    group('.transposeBy()', () {
      test('transposes this Note by Interval', () {
        expect(Note.c.transposeBy(Interval.d1), Note.c.flat);
        expect(Note.c.transposeBy(-Interval.d1), Note.c.sharp);
        expect(Note.c.transposeBy(Interval.P1), Note.c);
        expect(Note.c.transposeBy(-Interval.P1), Note.c);
        expect(Note.c.transposeBy(Interval.A1), Note.c.sharp);
        expect(Note.c.transposeBy(-Interval.A1), Note.c.flat);

        expect(Note.c.transposeBy(Interval.d2), Note.d.flat.flat);
        expect(Note.c.transposeBy(-Interval.d2), Note.b.sharp);
        expect(Note.c.transposeBy(Interval.m2), Note.d.flat);
        expect(Note.c.transposeBy(-Interval.m2), Note.b);
        expect(Note.c.transposeBy(Interval.M2), Note.d);
        expect(Note.c.transposeBy(-Interval.M2), Note.b.flat);
        expect(Note.c.transposeBy(Interval.A2), Note.d.sharp);
        expect(Note.c.transposeBy(-Interval.A2), Note.b.flat.flat);

        expect(Note.e.transposeBy(Interval.m3), Note.g);
        expect(Note.e.transposeBy(-Interval.m3), Note.c.sharp);
        expect(Note.e.transposeBy(Interval.M3), Note.g.sharp);
        expect(Note.e.transposeBy(-Interval.M3), Note.c);
        expect(Note.a.flat.transposeBy(Interval.m3), Note.c.flat);
        expect(Note.a.flat.transposeBy(-Interval.m3), Note.f);
        expect(Note.a.flat.transposeBy(Interval.M3), Note.c);
        expect(Note.a.flat.transposeBy(-Interval.M3), Note.f.flat);

        expect(Note.f.transposeBy(Interval.d4), Note.b.flat.flat);
        expect(Note.f.transposeBy(-Interval.d4), Note.c.sharp);
        expect(Note.f.transposeBy(Interval.P4), Note.b.flat);
        expect(Note.f.transposeBy(-Interval.P4), Note.c);
        expect(Note.f.transposeBy(Interval.A4), Note.b);
        expect(Note.f.transposeBy(-Interval.A4), Note.c.flat);
        expect(Note.a.transposeBy(Interval.d4), Note.d.flat);
        expect(Note.a.transposeBy(-Interval.d4), Note.e.sharp);
        expect(Note.a.transposeBy(Interval.P4), Note.d);
        expect(Note.a.transposeBy(-Interval.P4), Note.e);
        expect(Note.a.transposeBy(Interval.A4), Note.d.sharp);
        expect(Note.a.transposeBy(-Interval.A4), Note.e.flat);

        expect(Note.d.transposeBy(Interval.d5), Note.a.flat);
        expect(Note.d.transposeBy(-Interval.d5), Note.g.sharp);
        expect(Note.d.transposeBy(Interval.P5), Note.a);
        expect(Note.d.transposeBy(-Interval.P5), Note.g);
        expect(Note.d.transposeBy(Interval.A5), Note.a.sharp);
        expect(Note.d.transposeBy(-Interval.A5), Note.g.flat);

        expect(Note.d.transposeBy(Interval.m6), Note.b.flat);
        expect(Note.d.transposeBy(-Interval.m6), Note.f.sharp);
        expect(Note.d.transposeBy(Interval.M6), Note.b);
        expect(Note.d.transposeBy(-Interval.M6), Note.f);
        expect(Note.f.sharp.transposeBy(Interval.m6), Note.d);
        expect(Note.f.sharp.transposeBy(-Interval.m6), Note.a.sharp);
        expect(Note.f.sharp.transposeBy(Interval.M6), Note.d.sharp);
        expect(Note.f.sharp.transposeBy(-Interval.M6), Note.a);

        expect(Note.c.transposeBy(Interval.m7), Note.b.flat);
        expect(Note.c.transposeBy(-Interval.m7), Note.d);
        expect(Note.c.transposeBy(Interval.M7), Note.b);
        expect(Note.c.transposeBy(-Interval.M7), Note.d.flat);
        expect(Note.c.transposeBy(Interval.A7), Note.b.sharp);
        expect(Note.c.transposeBy(-Interval.A7), Note.d.flat.flat);

        expect(Note.c.transposeBy(Interval.d8), Note.c.flat);
        expect(Note.c.transposeBy(Interval.P8), Note.c);
        expect(Note.c.transposeBy(Interval.A8), Note.c.sharp);

        expect(Note.c.transposeBy(Interval.m9), Note.d.flat);
        expect(Note.c.transposeBy(Interval.M9), Note.d);

        expect(Note.c.transposeBy(Interval.d11), Note.f.flat);
        expect(Note.c.transposeBy(Interval.P11), Note.f);
        expect(Note.c.transposeBy(Interval.A11), Note.f.sharp);

        expect(Note.c.transposeBy(Interval.m13), Note.a.flat);
        expect(Note.c.transposeBy(Interval.M13), Note.a);

        expect(Note.c.transposeBy(const Interval.perfect(Size(15))), Note.c);
        expect(Note.c.transposeBy(const Interval.perfect(Size(22))), Note.c);
        expect(Note.c.transposeBy(const Interval.perfect(Size(29))), Note.c);
      });
    });

    group('.toPitchClass()', () {
      test('creates a new PitchClass from semitones', () {
        expect(Note.c.toPitchClass(), PitchClass.c);
        expect(Note.d.sharp.toPitchClass(), PitchClass.dSharp);
        expect(Note.e.flat.toPitchClass(), PitchClass.dSharp);
        expect(Note.e.sharp.toPitchClass(), PitchClass.f);
        expect(Note.c.flat.flat.toPitchClass(), PitchClass.aSharp);
      });
    });

    group('.toString()', () {
      test('returns the English string representation of this Note', () {
        expect(Note.c.toString(), 'C');
        expect(Note.e.toString(), 'E');
        expect(Note.b.flat.toString(), 'B♭');
        expect(Note.f.sharp.toString(), 'F♯');
        expect(Note.d.flat.toString(), 'D♭');
        expect(Note.a.sharp.sharp.toString(), 'A𝄪');
        expect(Note.g.flat.flat.toString(), 'G𝄫');

        const showNatural = EnglishNoteNotation(showNatural: true);
        expect(Note.c.toString(system: showNatural), 'C♮');
        expect(Note.a.toString(system: showNatural), 'A♮');
        expect(Note.e.sharp.toString(system: showNatural), 'E♯');
        expect(Note.b.flat.flat.toString(system: showNatural), 'B𝄫');
      });

      test('returns the German string representation of this Note', () {
        expect(
          Note.c.flat.flat.toString(system: NoteNotation.german),
          'Ceses',
        );
        expect(Note.c.flat.toString(system: NoteNotation.german), 'Ces');
        expect(Note.c.toString(system: NoteNotation.german), 'C');
        expect(Note.c.sharp.toString(system: NoteNotation.german), 'Cis');
        expect(
          Note.c.sharp.sharp.toString(system: NoteNotation.german),
          'Cisis',
        );

        expect(
          Note.d.flat.flat.toString(system: NoteNotation.german),
          'Deses',
        );
        expect(Note.d.flat.toString(system: NoteNotation.german), 'Des');
        expect(Note.d.toString(system: NoteNotation.german), 'D');
        expect(Note.d.sharp.toString(system: NoteNotation.german), 'Dis');
        expect(
          Note.d.sharp.sharp.toString(system: NoteNotation.german),
          'Disis',
        );

        expect(
          Note.e.flat.flat.toString(system: NoteNotation.german),
          'Eses',
        );
        expect(Note.e.flat.toString(system: NoteNotation.german), 'Es');
        expect(Note.e.toString(system: NoteNotation.german), 'E');
        expect(Note.e.sharp.toString(system: NoteNotation.german), 'Eis');
        expect(
          Note.e.sharp.sharp.toString(system: NoteNotation.german),
          'Eisis',
        );

        expect(
          Note.f.flat.flat.toString(system: NoteNotation.german),
          'Feses',
        );
        expect(Note.f.flat.toString(system: NoteNotation.german), 'Fes');
        expect(Note.f.toString(system: NoteNotation.german), 'F');
        expect(Note.f.sharp.toString(system: NoteNotation.german), 'Fis');
        expect(
          Note.f.sharp.sharp.toString(system: NoteNotation.german),
          'Fisis',
        );

        expect(
          Note.g.flat.flat.toString(system: NoteNotation.german),
          'Geses',
        );
        expect(Note.g.flat.toString(system: NoteNotation.german), 'Ges');
        expect(Note.g.toString(system: NoteNotation.german), 'G');
        expect(Note.g.sharp.toString(system: NoteNotation.german), 'Gis');
        expect(
          Note.g.sharp.sharp.toString(system: NoteNotation.german),
          'Gisis',
        );

        expect(
          Note.a.flat.flat.toString(system: NoteNotation.german),
          'Ases',
        );
        expect(Note.a.flat.toString(system: NoteNotation.german), 'As');
        expect(Note.a.toString(system: NoteNotation.german), 'A');
        expect(Note.a.sharp.toString(system: NoteNotation.german), 'Ais');
        expect(
          Note.a.sharp.sharp.toString(system: NoteNotation.german),
          'Aisis',
        );

        expect(
          Note.b.flat.flat.toString(system: NoteNotation.german),
          'Heses',
        );
        expect(Note.b.flat.toString(system: NoteNotation.german), 'B');
        expect(Note.b.toString(system: NoteNotation.german), 'H');
        expect(Note.b.sharp.toString(system: NoteNotation.german), 'His');
        expect(
          Note.b.sharp.sharp.toString(system: NoteNotation.german),
          'Hisis',
        );
      });

      test('returns the Romance string representation of this Note', () {
        expect(Note.c.toString(system: NoteNotation.romance), 'Do');
        expect(Note.c.sharp.toString(system: NoteNotation.romance), 'Do♯');
        expect(Note.d.toString(system: NoteNotation.romance), 'Re');
        expect(Note.d.flat.toString(system: NoteNotation.romance), 'Re♭');
        expect(Note.e.toString(system: NoteNotation.romance), 'Mi');
        expect(Note.b.flat.toString(system: NoteNotation.romance), 'Si♭');
        expect(Note.f.sharp.toString(system: NoteNotation.romance), 'Fa♯');
        expect(
          Note.a.sharp.sharp.toString(system: NoteNotation.romance),
          'La𝄪',
        );
        expect(
          Note.g.flat.flat.toString(system: NoteNotation.romance),
          'Sol𝄫',
        );
      });

      test('returns the string representation extending NoteNotation', () {
        expect(
          () => Note.a.sharp.toString(system: _SubNoteNotation()),
          throwsUnimplementedError,
        );
      });
    });

    group('.hashCode', () {
      test('ignores equal Note instances in a Set', () {
        final collection = {Note.c, Note.a.flat, Note.g.sharp};
        collection.addAll(collection);
        expect(collection.toList(), [Note.c, Note.a.flat, Note.g.sharp]);
      });
    });

    group('.compareTo()', () {
      test('sorts Notes in a collection', () {
        final orderedSet = SplayTreeSet<Note>.of({
          Note.a.flat,
          Note.c,
          Note.e.flat,
          Note.d,
          Note.d.sharp,
          Note.g.flat,
          Note.c.flat,
          Note.g,
          Note.g.sharp,
          Note.b.sharp,
        });
        expect(orderedSet.toList(), [
          Note.c.flat,
          Note.c,
          Note.d,
          Note.d.sharp,
          Note.e.flat,
          Note.g.flat,
          Note.g,
          Note.g.sharp,
          Note.a.flat,
          Note.b.sharp,
        ]);
      });

      test('sorts Notes in a collection by fifths distance', () {
        final orderedSet = SplayTreeSet<Note>.of(
          {
            Note.d,
            Note.a.flat,
            Note.c,
            Note.b.flat,
            Note.g.sharp,
            Note.b.sharp,
          },
          Note.compareByFifthsDistance,
        );
        expect(orderedSet.toList(), [
          Note.a.flat,
          Note.b.flat,
          Note.c,
          Note.d,
          Note.g.sharp,
          Note.b.sharp,
        ]);
      });
    });
  });
}

final class _SubNoteNotation extends NoteNotation {
  @override
  String baseNote(BaseNote baseNote) => throw UnimplementedError();

  @override
  String tonalMode(TonalMode tonalMode) => throw UnimplementedError();

  @override
  String accidental(Accidental accidental) => throw UnimplementedError();
}
