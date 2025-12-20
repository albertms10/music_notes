import 'dart:collection' show SplayTreeSet;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
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
        expect(Note.f.sharp, const Note(.f, .sharp));
        expect(Note.a.sharp, const Note(.a, .sharp));
        expect(Note.e.sharp, const Note(.e, .sharp));
        expect(Note.b.flat.sharp, Note.b);
        expect(Note.g.sharp.sharp, const Note(.g, .doubleSharp));
        expect(Note.c.sharp.sharp.sharp, const Note(.c, .tripleSharp));
      });
    });

    group('.flat', () {
      test('returns this Note flattened by 1 semitone', () {
        expect(Note.e.flat, const Note(.e, .flat));
        expect(Note.a.flat, const Note(.a, .flat));
        expect(Note.d.flat, const Note(.d, .flat));
        expect(Note.g.flat.sharp, Note.g);
        expect(Note.e.flat.flat, const Note(.e, .doubleFlat));
        expect(Note.c.flat.flat.flat, const Note(.c, .tripleFlat));
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
        expect(Note.c.major, const Key(.c, .major));
        expect(Note.a.major, const Key(.a, .major));
        expect(Note.b.flat.major, Key(.b.flat, .major));
        expect(Note.c.sharp.major, Key(.c.sharp, .major));
      });
    });

    group('.minor', () {
      test('returns the minor Key from this Note', () {
        expect(Note.c.minor, const Key(.c, .minor));
        expect(Note.e.minor, const Key(.e, .minor));
        expect(Note.a.flat.minor, Key(.a.flat, .minor));
        expect(Note.d.sharp.minor, Key(.d.sharp, .minor));
      });
    });

    group('.augmentedTriad', () {
      test('returns the augmented triad on this Note', () {
        expect(Note.c.augmentedTriad, Chord<Note>([.c, .e, .g.sharp]));
        expect(Note.a.augmentedTriad, Chord<Note>([.a, .c.sharp, .e.sharp]));
        expect(
          Note.b.augmentedTriad,
          Chord<Note>([.b, .d.sharp, .f.sharp.sharp]),
        );
      });
    });

    group('.majorTriad', () {
      test('returns the major triad on this Note', () {
        expect(Note.c.majorTriad, const Chord<Note>([.c, .e, .g]));
        expect(Note.e.flat.majorTriad, Chord<Note>([.e.flat, .g, .b.flat]));
        expect(Note.b.majorTriad, Chord<Note>([.b, .d.sharp, .f.sharp]));
      });
    });

    group('.minorTriad', () {
      test('returns the minor triad on this Note', () {
        expect(
          Note.d.flat.minorTriad,
          Chord<Note>([.d.flat, .f.flat, .a.flat]),
        );
        expect(Note.g.sharp.minorTriad, Chord<Note>([.g.sharp, .b, .d.sharp]));
        expect(Note.a.minorTriad, const Chord<Note>([.a, .c, .e]));
      });
    });

    group('.diminishedTriad', () {
      test('returns the diminished triad on this Note', () {
        expect(Note.e.diminishedTriad, Chord<Note>([.e, .g, .b.flat]));
        expect(
          Note.g.flat.diminishedTriad,
          Chord<Note>([.g.flat, .b.flat.flat, .d.flat.flat]),
        );
        expect(Note.b.diminishedTriad, const Chord<Note>([.b, .d, .f]));
      });
    });

    group('.respellByNoteName()', () {
      test('returns this Note respelled by NoteName', () {
        expect(Note.c.sharp.respellByNoteName(.d), Note.d.flat);
        expect(Note.e.flat.respellByNoteName(.d), Note.d.sharp);
        expect(Note.e.sharp.respellByNoteName(.f), Note.f);
        expect(Note.f.flat.respellByNoteName(.e), Note.e);
        expect(Note.c.respellByNoteName(.b), Note.b.sharp);
        expect(Note.c.respellByNoteName(.d), Note.d.flat.flat);
        expect(Note.b.respellByNoteName(.c), Note.c.flat);
        expect(Note.b.respellByNoteName(.a), Note.a.sharp.sharp);
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
          const Note(.a, Accidental(-4)),
        );
        expect(
          Note.f.respellByOrdinalDistance(3),
          const Note(.b, Accidental(-6)),
        );
        expect(
          Note.f.respellByOrdinalDistance(4),
          const Note(.c, Accidental(5)),
        );
        expect(
          Note.f.respellByOrdinalDistance(-3),
          const Note(.c, Accidental(5)),
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
        expect(Note.a.sharp.respellByAccidental(.flat), Note.b.flat);
        expect(Note.g.flat.respellByAccidental(.sharp), Note.f.sharp);
        expect(Note.c.flat.respellByAccidental(.natural), Note.b);
        expect(Note.b.sharp.respellByAccidental(.natural), Note.c);
        expect(Note.f.flat.respellByAccidental(.natural), Note.e);
        expect(Note.e.sharp.respellByAccidental(.natural), Note.f);
        expect(Note.f.respellByAccidental(.doubleFlat), Note.g.flat.flat);
        expect(Note.a.respellByAccidental(.doubleSharp), Note.g.sharp.sharp);
      });

      test('returns the next closest spelling when no possible respelling', () {
        expect(Note.d.flat.respellByAccidental(.natural), Note.d.flat);
        expect(Note.a.sharp.respellByAccidental(.natural), Note.a.sharp);
        expect(
          Note.b.flat.flat.flat.respellByAccidental(.natural),
          Note.a.flat,
        );
        expect(Note.b.sharp.sharp.respellByAccidental(.natural), Note.c.sharp);

        expect(Note.d.respellByAccidental(.sharp), Note.c.sharp.sharp);
        expect(Note.d.respellByAccidental(.flat), Note.e.flat.flat);
        expect(Note.e.respellByAccidental(.doubleFlat), Note.g.flat.flat.flat);
        expect(
          Note.f.respellByAccidental(.doubleSharp),
          Note.d.sharp.sharp.sharp,
        );
        expect(Note.b.respellByAccidental(.doubleFlat), Note.d.flat.flat.flat);
        expect(
          Note.c.respellByAccidental(.doubleSharp),
          Note.a.sharp.sharp.sharp,
        );
      });
    });

    group('.respelledSimple', () {
      test('returns the simplest spelling for this Note', () {
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

    group('.splitCircleOfFifths', () {
      test('returns the split circle of fifths from this Note', () {
        var (:up, :down) = Note.c.splitCircleOfFifths;
        expect(up.take(6), <Note>[.g, .d, .a, .e, .b, .f.sharp]);
        expect(down.take(6), <Note>[
          .f,
          .b.flat,
          .e.flat,
          .a.flat,
          .d.flat,
          .g.flat,
        ]);

        (:up, :down) = Note.a.splitCircleOfFifths;
        expect(up.take(7), <Note>[
          .e,
          .b,
          .f.sharp,
          .c.sharp,
          .g.sharp,
          .d.sharp,
          .a.sharp,
        ]);
        expect(down.take(7), <Note>[.d, .g, .c, .f, .b.flat, .e.flat, .a.flat]);
      });
    });

    group('.circleOfFifths()', () {
      test('returns the continuous circle of fifths from this Note', () {
        expect(Note.c.circleOfFifths(), <Note>[
          .g.flat,
          .d.flat,
          .a.flat,
          .e.flat,
          .b.flat,
          .f,
          .c,
          .g,
          .d,
          .a,
          .e,
          .b,
          .f.sharp,
        ]);
        expect(Note.a.circleOfFifths(distance: 7), <Note>[
          .a.flat,
          .e.flat,
          .b.flat,
          .f,
          .c,
          .g,
          .d,
          .a,
          .e,
          .b,
          .f.sharp,
          .c.sharp,
          .g.sharp,
          .d.sharp,
          .a.sharp,
        ]);
        expect(Note.e.flat.circleOfFifths(distance: 3), <Note>[
          .g.flat,
          .d.flat,
          .a.flat,
          .e.flat,
          .b.flat,
          .f,
          .c,
        ]);
        expect(
          Note.c.circleOfFifths(distance: 3),
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
        expect(Note.c.fifthsDistanceWith(.c.flat.flat), -14);
        expect(Note.c.fifthsDistanceWith(.g.flat.flat), -13);
        expect(Note.c.fifthsDistanceWith(.d.flat.flat), -12);
        expect(Note.c.fifthsDistanceWith(.a.flat.flat), -11);
        expect(Note.c.fifthsDistanceWith(.e.flat.flat), -10);
        expect(Note.c.fifthsDistanceWith(.b.flat.flat), -9);
        expect(Note.c.fifthsDistanceWith(.f.flat), -8);
        expect(Note.c.fifthsDistanceWith(.c.flat), -7);
        expect(Note.c.fifthsDistanceWith(.g.flat), -6);
        expect(Note.c.fifthsDistanceWith(.d.flat), -5);
        expect(Note.c.fifthsDistanceWith(.a.flat), -4);
        expect(Note.c.fifthsDistanceWith(.e.flat), -3);
        expect(Note.c.fifthsDistanceWith(.b.flat), -2);
        expect(Note.c.fifthsDistanceWith(.f), -1);
        expect(Note.c.fifthsDistanceWith(.c), 0);
        expect(Note.c.fifthsDistanceWith(.g), 1);
        expect(Note.c.fifthsDistanceWith(.d), 2);
        expect(Note.c.fifthsDistanceWith(.a), 3);
        expect(Note.c.fifthsDistanceWith(.e), 4);
        expect(Note.c.fifthsDistanceWith(.b), 5);
        expect(Note.c.fifthsDistanceWith(.f.sharp), 6);
        expect(Note.c.fifthsDistanceWith(.c.sharp), 7);
        expect(Note.c.fifthsDistanceWith(.g.sharp), 8);
        expect(Note.c.fifthsDistanceWith(.d.sharp), 9);
        expect(Note.c.fifthsDistanceWith(.a.sharp), 10);
        expect(Note.c.fifthsDistanceWith(.e.sharp), 11);
        expect(Note.c.fifthsDistanceWith(.b.sharp), 12);
        expect(Note.c.fifthsDistanceWith(.f.sharp.sharp), 13);
        expect(Note.c.fifthsDistanceWith(.c.sharp.sharp), 14);

        expect(Note.a.flat.fifthsDistanceWith(.d.flat), -1);
        expect(Note.a.flat.fifthsDistanceWith(.e.flat), 1);
        expect(Note.a.flat.fifthsDistanceWith(.d), 6);
        expect(Note.a.flat.fifthsDistanceWith(.c.sharp), 11);

        expect(Note.f.sharp.fifthsDistanceWith(.d.sharp.sharp), 10);
        expect(Note.f.sharp.fifthsDistanceWith(.f), -7);
        expect(Note.f.sharp.fifthsDistanceWith(.d.flat), -11);
        expect(Note.f.sharp.fifthsDistanceWith(.g.flat.flat), -19);
      });
    });

    group('.interval()', () {
      test('returns the Interval between this Note and other', () {
        expect(Note.c.interval(.c), Interval.P1);
        expect(Note.c.interval(.c.sharp), Interval.A1);
        expect(Note.f.flat.interval(.f), Interval.A1);

        expect(Note.b.sharp.interval(.c), Interval.d2);
        expect(Note.c.interval(.d.flat.flat), Interval.d2);
        expect(Note.f.flat.interval(.g.flat.flat), Interval.m2);
        expect(Note.c.interval(.d.flat), Interval.m2);
        expect(Note.c.interval(.d), Interval.M2);
        expect(Note.c.interval(.d.sharp), Interval.A2);

        expect(Note.c.interval(.e.flat.flat), Interval.d3);
        expect(Note.c.interval(.e.flat), Interval.m3);
        expect(Note.c.interval(.e), Interval.M3);
        expect(Note.g.interval(.b), Interval.M3);
        expect(Note.b.flat.interval(.d), Interval.M3);
        expect(Note.c.interval(.e.sharp), Interval.A3);

        expect(Note.c.interval(.f.flat), Interval.d4);
        expect(Note.c.interval(.f), Interval.P4);
        expect(Note.g.sharp.interval(.c.sharp), Interval.P4);
        expect(Note.a.flat.interval(.d), Interval.A4);
        expect(Note.c.interval(.f.sharp), Interval.A4);

        expect(Note.c.interval(.g.flat), Interval.d5);
        expect(Note.c.interval(.g), Interval.P5);
        expect(Note.c.interval(.g.sharp), Interval.A5);

        expect(Note.c.interval(.a.flat.flat), Interval.d6);
        expect(Note.c.interval(.a.flat), Interval.m6);
        expect(Note.c.interval(.a), Interval.M6);
        expect(Note.c.interval(.a.sharp), Interval.A6);

        expect(Note.c.interval(.b.flat.flat), Interval.d7);
        expect(Note.c.interval(.b.flat), Interval.m7);
        expect(Note.c.interval(.b), Interval.M7);
        expect(Note.b.interval(.a.sharp), Interval.M7);

        expect(skip: true, Note.c.interval(.b.sharp), Interval.A7);
      });
    });

    group('.transposeBy()', () {
      test('transposes this Note by Interval', () {
        expect(Note.c.transposeBy(.d1), Note.c.flat);
        expect(Note.c.transposeBy(-Interval.d1), Note.c.sharp);
        expect(Note.c.transposeBy(.P1), Note.c);
        expect(Note.c.transposeBy(-Interval.P1), Note.c);
        expect(Note.c.transposeBy(.A1), Note.c.sharp);
        expect(Note.c.transposeBy(-Interval.A1), Note.c.flat);

        expect(Note.c.transposeBy(.d2), Note.d.flat.flat);
        expect(Note.c.transposeBy(-Interval.d2), Note.b.sharp);
        expect(Note.c.transposeBy(.m2), Note.d.flat);
        expect(Note.c.transposeBy(-Interval.m2), Note.b);
        expect(Note.c.transposeBy(.M2), Note.d);
        expect(Note.c.transposeBy(-Interval.M2), Note.b.flat);
        expect(Note.c.transposeBy(.A2), Note.d.sharp);
        expect(Note.c.transposeBy(-Interval.A2), Note.b.flat.flat);

        expect(Note.e.transposeBy(.m3), Note.g);
        expect(Note.e.transposeBy(-Interval.m3), Note.c.sharp);
        expect(Note.e.transposeBy(.M3), Note.g.sharp);
        expect(Note.e.transposeBy(-Interval.M3), Note.c);
        expect(Note.a.flat.transposeBy(.m3), Note.c.flat);
        expect(Note.a.flat.transposeBy(-Interval.m3), Note.f);
        expect(Note.a.flat.transposeBy(.M3), Note.c);
        expect(Note.a.flat.transposeBy(-Interval.M3), Note.f.flat);

        expect(Note.f.transposeBy(.d4), Note.b.flat.flat);
        expect(Note.f.transposeBy(-Interval.d4), Note.c.sharp);
        expect(Note.f.transposeBy(.P4), Note.b.flat);
        expect(Note.f.transposeBy(-Interval.P4), Note.c);
        expect(Note.f.transposeBy(.A4), Note.b);
        expect(Note.f.transposeBy(-Interval.A4), Note.c.flat);
        expect(Note.a.transposeBy(.d4), Note.d.flat);
        expect(Note.a.transposeBy(-Interval.d4), Note.e.sharp);
        expect(Note.a.transposeBy(.P4), Note.d);
        expect(Note.a.transposeBy(-Interval.P4), Note.e);
        expect(Note.a.transposeBy(.A4), Note.d.sharp);
        expect(Note.a.transposeBy(-Interval.A4), Note.e.flat);

        expect(Note.d.transposeBy(.d5), Note.a.flat);
        expect(Note.d.transposeBy(-Interval.d5), Note.g.sharp);
        expect(Note.d.transposeBy(.P5), Note.a);
        expect(Note.d.transposeBy(-Interval.P5), Note.g);
        expect(Note.d.transposeBy(.A5), Note.a.sharp);
        expect(Note.d.transposeBy(-Interval.A5), Note.g.flat);

        expect(Note.d.transposeBy(.m6), Note.b.flat);
        expect(Note.d.transposeBy(-Interval.m6), Note.f.sharp);
        expect(Note.d.transposeBy(.M6), Note.b);
        expect(Note.d.transposeBy(-Interval.M6), Note.f);
        expect(Note.f.sharp.transposeBy(.m6), Note.d);
        expect(Note.f.sharp.transposeBy(-Interval.m6), Note.a.sharp);
        expect(Note.f.sharp.transposeBy(.M6), Note.d.sharp);
        expect(Note.f.sharp.transposeBy(-Interval.M6), Note.a);

        expect(Note.c.transposeBy(.m7), Note.b.flat);
        expect(Note.c.transposeBy(-Interval.m7), Note.d);
        expect(Note.c.transposeBy(.M7), Note.b);
        expect(Note.c.transposeBy(-Interval.M7), Note.d.flat);
        expect(Note.c.transposeBy(.A7), Note.b.sharp);
        expect(Note.c.transposeBy(-Interval.A7), Note.d.flat.flat);

        expect(Note.c.transposeBy(.d8), Note.c.flat);
        expect(Note.c.transposeBy(.P8), Note.c);
        expect(Note.c.transposeBy(.A8), Note.c.sharp);

        expect(Note.c.transposeBy(.m9), Note.d.flat);
        expect(Note.c.transposeBy(.M9), Note.d);

        expect(Note.c.transposeBy(.d11), Note.f.flat);
        expect(Note.c.transposeBy(.P11), Note.f);
        expect(Note.c.transposeBy(.A11), Note.f.sharp);

        expect(Note.c.transposeBy(.m13), Note.a.flat);
        expect(Note.c.transposeBy(.M13), Note.a);

        expect(Note.c.transposeBy(const .perfect(Size(15))), Note.c);
        expect(Note.c.transposeBy(const .perfect(Size(22))), Note.c);
        expect(Note.c.transposeBy(const .perfect(Size(29))), Note.c);
        expect(Note.c.transposeBy(const ImperfectSize(30).minor), Note.d.flat);
        expect(Note.c.transposeBy(const ImperfectSize(30).major), Note.d);
        expect(Note.c.transposeBy(const .perfect(Size(32))), Note.f);
        expect(
          Note.c.transposeBy(const PerfectSize(32).augmented),
          Note.f.sharp,
        );
        expect(
          Note.c.transposeBy(const PerfectSize(33).diminished),
          Note.g.flat,
        );
      });
    });

    group('.toClass()', () {
      test('creates a new PitchClass from semitones', () {
        expect(Note.c.toClass(), PitchClass.c);
        expect(Note.d.sharp.toClass(), PitchClass.dSharp);
        expect(Note.e.flat.toClass(), PitchClass.dSharp);
        expect(Note.e.sharp.toClass(), PitchClass.f);
        expect(Note.c.flat.flat.toClass(), PitchClass.aSharp);
      });
    });

    group('.hashCode', () {
      test('ignores equal Note instances in a Set', () {
        final collection = <Note>{.c, .a.flat, .g.sharp};
        collection.addAll(collection);
        expect(collection.toList(), <Note>[.c, .a.flat, .g.sharp]);
      });
    });

    group('.compareTo()', () {
      test('sorts Notes in a collection', () {
        final orderedSet = SplayTreeSet<Note>.of({
          .a.flat,
          .c,
          .e.flat,
          .d,
          .d.sharp,
          .g.flat,
          .c.flat,
          .g,
          .g.sharp,
          .b.sharp,
        });
        expect(orderedSet.toList(), <Note>[
          .c.flat,
          .c,
          .d,
          .d.sharp,
          .e.flat,
          .g.flat,
          .g,
          .g.sharp,
          .a.flat,
          .b.sharp,
        ]);
      });

      test('sorts Notes in a collection by fifths distance', () {
        final orderedSet = SplayTreeSet<Note>.of({
          .d,
          .a.flat,
          .c,
          .b.flat,
          .g.sharp,
          .b.sharp,
        }, Note.compareByFifthsDistance);
        expect(orderedSet.toList(), <Note>[
          .a.flat,
          .b.flat,
          .c,
          .d,
          .g.sharp,
          .b.sharp,
        ]);
      });
    });
  });

  group('EnglishNoteNotation', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Note.parse(''), throwsFormatException);
        expect(() => Note.parse('n'), throwsFormatException);
        expect(() => Note.parse('x'), throwsFormatException);
      });

      test('parses source as a Note', () {
        expect(Note.parse('d'), Note.d);
        expect(Note.parse('g'), Note.g);
        expect(Note.parse('cn'), Note.c);
        expect(Note.parse('Bb'), Note.b.flat);
        expect(Note.parse('bb'), Note.b.flat);
        expect(Note.parse('f♯'), Note.f.sharp);
        expect(Note.parse('d#'), Note.d.sharp);
        expect(Note.parse('A♭'), Note.a.flat);
        expect(Note.parse('abb'), Note.a.flat.flat);
        expect(Note.parse('cx'), Note.c.sharp.sharp);
        expect(Note.parse('e#x'), Note.e.sharp.sharp.sharp);

        expect(Note.parse('d-sharp'), Note.d.sharp);
        expect(Note.parse('g flat'), Note.g.flat);
        expect(Note.parse('E natural'), Note.e);
        expect(Note.parse('A-double flat'), Note.a.flat.flat);
        expect(Note.parse('F-triple sharp'), Note.f.sharp.sharp.sharp);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Note', () {
        expect(Note.c.toString(), 'C');
        expect(Note.e.toString(), 'E');
        expect(Note.b.flat.toString(), 'B♭');
        expect(Note.f.sharp.toString(), 'F♯');
        expect(Note.d.flat.toString(), 'D♭');
        expect(Note.a.sharp.sharp.toString(), 'A𝄪');
        expect(Note.g.flat.flat.flat.toString(), 'G𝄫♭');
        expect(Note.c.sharp.sharp.sharp.toString(), 'C𝄪♯');

        const showNatural = EnglishNoteNotation.showNatural;
        expect(Note.c.toString(formatter: showNatural), 'C♮');
        expect(Note.a.toString(formatter: showNatural), 'A♮');
        expect(Note.e.sharp.toString(formatter: showNatural), 'E♯');
        expect(Note.b.flat.flat.toString(formatter: showNatural), 'B𝄫');

        const textual = EnglishNoteNotation();
        expect(Note.c.toString(formatter: textual), 'C');
        expect(Note.c.sharp.toString(formatter: textual), 'C-sharp');
        expect(Note.d.flat.toString(formatter: textual), 'D-flat');
        expect(
          Note.b.flat.flat.toString(formatter: textual),
          'B-double flat',
        );
        expect(
          Note.f.sharp.sharp.toString(formatter: textual),
          'F-double sharp',
        );
        expect(
          Note.g.sharp.sharp.sharp.toString(formatter: textual),
          'G-triple sharp',
        );
      });
    });
  });

  group('GermanNoteNotation', () {
    const formatter = GermanNoteNotation();
    const chain = [formatter];

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Note.parse('', chain: chain), throwsFormatException);
        expect(() => Note.parse('X', chain: chain), throwsFormatException);
        expect(() => Note.parse('cs', chain: chain), throwsFormatException);
        expect(() => Note.parse('aes', chain: chain), throwsFormatException);
        expect(
          () => Note.parse('bisis', chain: chain),
          throwsFormatException,
        );
        expect(() => Note.parse('Bis', chain: chain), throwsFormatException);
        expect(() => Note.parse('hes', chain: chain), throwsFormatException);
        expect(
          () => Note.parse('Heses', chain: chain),
          throwsFormatException,
        );
      });

      test('parses source as a Note', () {
        expect(Note.parse('b', chain: chain), Note.b.flat);
        expect(Note.parse('Cis', chain: chain), Note.c.sharp);
        expect(Note.parse('Des', chain: chain), Note.d.flat);
        expect(Note.parse('geses', chain: chain), Note.g.flat.flat);
        expect(Note.parse('H', chain: chain), Note.b);
        expect(Note.parse('hisis', chain: chain), Note.b.sharp.sharp);
        expect(Note.parse('His', chain: chain), Note.b.sharp);
        expect(Note.parse('bes', chain: chain), Note.b.flat.flat);
        expect(Note.parse('Beses', chain: chain), Note.b.flat.flat.flat);
        expect(Note.parse('As', chain: chain), Note.a.flat);
        expect(Note.parse('ais', chain: chain), Note.a.sharp);
        expect(Note.parse('Es', chain: chain), Note.e.flat);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Note', () {
        expect(Note.c.flat.flat.toString(formatter: formatter), 'Ceses');
        expect(Note.c.flat.toString(formatter: formatter), 'Ces');
        expect(Note.c.toString(formatter: formatter), 'C');
        expect(Note.c.sharp.toString(formatter: formatter), 'Cis');
        expect(Note.c.sharp.sharp.toString(formatter: formatter), 'Cisis');

        expect(Note.d.flat.flat.toString(formatter: formatter), 'Deses');
        expect(Note.d.flat.toString(formatter: formatter), 'Des');
        expect(Note.d.toString(formatter: formatter), 'D');
        expect(Note.d.sharp.toString(formatter: formatter), 'Dis');
        expect(Note.d.sharp.sharp.toString(formatter: formatter), 'Disis');

        expect(Note.e.flat.flat.toString(formatter: formatter), 'Eses');
        expect(Note.e.flat.toString(formatter: formatter), 'Es');
        expect(Note.e.toString(formatter: formatter), 'E');
        expect(Note.e.sharp.toString(formatter: formatter), 'Eis');
        expect(Note.e.sharp.sharp.toString(formatter: formatter), 'Eisis');

        expect(Note.f.flat.flat.toString(formatter: formatter), 'Feses');
        expect(Note.f.flat.toString(formatter: formatter), 'Fes');
        expect(Note.f.toString(formatter: formatter), 'F');
        expect(Note.f.sharp.toString(formatter: formatter), 'Fis');
        expect(Note.f.sharp.sharp.toString(formatter: formatter), 'Fisis');

        expect(Note.g.flat.flat.toString(formatter: formatter), 'Geses');
        expect(Note.g.flat.toString(formatter: formatter), 'Ges');
        expect(Note.g.toString(formatter: formatter), 'G');
        expect(Note.g.sharp.toString(formatter: formatter), 'Gis');
        expect(Note.g.sharp.sharp.toString(formatter: formatter), 'Gisis');

        expect(Note.a.flat.flat.toString(formatter: formatter), 'Ases');
        expect(Note.a.flat.toString(formatter: formatter), 'As');
        expect(Note.a.toString(formatter: formatter), 'A');
        expect(Note.a.sharp.toString(formatter: formatter), 'Ais');
        expect(Note.a.sharp.sharp.toString(formatter: formatter), 'Aisis');

        expect(Note.b.flat.flat.toString(formatter: formatter), 'Heses');
        expect(Note.b.flat.toString(formatter: formatter), 'B');
        expect(Note.b.toString(formatter: formatter), 'H');
        expect(Note.b.sharp.toString(formatter: formatter), 'His');
        expect(Note.b.sharp.sharp.toString(formatter: formatter), 'Hisis');
      });
    });
  });

  group('RomanceNoteNotation', () {
    const textual = RomanceNoteNotation();
    const symbol = RomanceNoteNotation.symbol();
    const chain = [textual, symbol];

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Note.parse('', chain: chain), throwsFormatException);
        expect(() => Note.parse('X', chain: chain), throwsFormatException);
        expect(() => Note.parse('C', chain: chain), throwsFormatException);
      });

      test('parses source as a Note', () {
        expect(Note.parse('Do'), Note.c);
        expect(Note.parse('Re'), Note.d);
        expect(Note.parse('Mi'), Note.e);
        expect(Note.parse('Fa'), Note.f);
        expect(Note.parse('Sol'), Note.g);
        expect(Note.parse('La'), Note.a);
        expect(Note.parse('Si'), Note.b);
        expect(Note.parse('Do♯'), Note.c.sharp);
        expect(Note.parse('Re♭'), Note.d.flat);
        expect(Note.parse('Solx'), Note.g.sharp.sharp);
        expect(Note.parse('dobb'), Note.c.flat.flat);
        expect(Note.parse('la♯'), Note.a.sharp);

        expect(Note.parse('re diesis'), Note.d.sharp);
        expect(Note.parse('Sol bemolle'), Note.g.flat);
        expect(Note.parse('mi naturale'), Note.e);
        expect(Note.parse('La doppio bemolle'), Note.a.flat.flat);
        expect(Note.parse('Fa triplo diesis'), Note.f.sharp.sharp.sharp);
      });
    });

    group('.toString()', () {
      test('returns the Romance string representation of this Note', () {
        expect(Note.c.toString(formatter: symbol), 'Do');
        expect(Note.c.sharp.toString(formatter: symbol), 'Do♯');
        expect(Note.d.toString(formatter: symbol), 'Re');
        expect(Note.d.flat.toString(formatter: symbol), 'Re♭');
        expect(Note.e.toString(formatter: symbol), 'Mi');
        expect(Note.b.flat.toString(formatter: symbol), 'Si♭');
        expect(Note.f.sharp.toString(formatter: symbol), 'Fa♯');
        expect(Note.a.sharp.sharp.toString(formatter: symbol), 'La𝄪');
        expect(Note.g.flat.flat.toString(formatter: symbol), 'Sol𝄫');

        const showNatural = RomanceNoteNotation.showNatural;
        expect(Note.c.toString(formatter: showNatural), 'Do♮');
        expect(Note.a.toString(formatter: showNatural), 'La♮');
        expect(Note.e.sharp.toString(formatter: showNatural), 'Mi♯');
        expect(Note.b.flat.flat.toString(formatter: showNatural), 'Si𝄫');

        expect(Note.e.toString(formatter: textual), 'Mi');
        expect(Note.c.sharp.toString(formatter: textual), 'Do diesis');
        expect(Note.d.flat.toString(formatter: textual), 'Re bemolle');
        expect(
          Note.b.flat.flat.toString(formatter: textual),
          'Si doppio bemolle',
        );
        expect(
          Note.f.sharp.sharp.toString(formatter: textual),
          'Fa doppio diesis',
        );
        expect(
          Note.g.sharp.sharp.sharp.toString(formatter: textual),
          'Sol triplo diesis',
        );
      });
    });
  });

  group('Notes', () {
    group('.flat', () {
      test('flattens all notes in this list', () {
        expect(const <Note>[].flat, const <Note>[]);
        expect(<Note>[.a, .b.flat, .c.sharp, .d.sharp.sharp].flat, <Note>[
          .a.flat,
          .b.flat.flat,
          .c,
          .d.sharp,
        ]);
      });
    });

    group('.sharp', () {
      test('sharpens all notes in this list', () {
        expect(const <Note>[].sharp, const <Note>[]);
        expect(<Note>[.g, .b.flat, .a.sharp, .b.flat.flat].sharp, <Note>[
          .g.sharp,
          .b,
          .a.sharp.sharp,
          .b.flat,
        ]);
      });
    });

    group('.natural', () {
      test('makes all notes in this list natural', () {
        expect(const <Note>[].natural, const <Note>[]);
        expect(<Note>[.a, .b.flat, .c.sharp, .f.flat.flat].natural, <Note>[
          .a,
          .b,
          .c,
          .f,
        ]);
      });
    });

    group('.inOctave()', () {
      test('creates a Pitch at octave for each Note in this list', () {
        expect(const <Note>[].inOctave(2), const <Note>[]);

        expect([Note.f.sharp].inOctave(5), [Note.f.sharp.inOctave(5)]);

        expect(const <Note>[.c, .e, .g].inOctave(4), [
          Note.c.inOctave(4),
          Note.e.inOctave(4),
          Note.g.inOctave(4),
        ]);

        expect(<Note>[.d.flat, .f.sharp, .b].inOctave(2), [
          Note.d.flat.inOctave(2),
          Note.f.sharp.inOctave(2),
          Note.b.inOctave(2),
        ]);

        expect(<Note>[.a.sharp, .c.sharp, .e.flat].inOctave(-1), [
          Note.a.sharp.inOctave(-1),
          Note.c.sharp.inOctave(-1),
          Note.e.flat.inOctave(-1),
        ]);
      });
    });
  });
}
