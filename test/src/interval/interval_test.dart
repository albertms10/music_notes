import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('constructor', () {
      test('should throw an assertion error when arguments are incorrect', () {
        expect(
          () => Interval.perfect(0, PerfectQuality.perfect),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => Interval.imperfect(0, ImperfectQuality.minor),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => Interval.perfect(2, PerfectQuality.diminished),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => Interval.imperfect(5, ImperfectQuality.augmented),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.fromSemitones()', () {
      test('should create a new Interval from semitones', () {
        expect(Interval.fromSemitones(1, -1), Interval.d1);
        expect(Interval.fromSemitones(-1, 1), -Interval.d1);
        expect(Interval.fromSemitones(1, 0), Interval.P1);
        expect(Interval.fromSemitones(-1, 0), -Interval.P1);
        expect(Interval.fromSemitones(1, 1), Interval.A1);
        expect(Interval.fromSemitones(-1, -1), -Interval.A1);

        expect(Interval.fromSemitones(2, 0), Interval.d2);
        expect(Interval.fromSemitones(-2, 0), -Interval.d2);
        expect(Interval.fromSemitones(2, 1), Interval.m2);
        expect(Interval.fromSemitones(-2, -1), -Interval.m2);
        expect(Interval.fromSemitones(2, 2), Interval.M2);
        expect(Interval.fromSemitones(-2, -2), -Interval.M2);
        expect(Interval.fromSemitones(2, 3), Interval.A2);
        expect(Interval.fromSemitones(-2, -3), -Interval.A2);

        expect(Interval.fromSemitones(3, 2), Interval.d3);
        expect(Interval.fromSemitones(-3, -2), -Interval.d3);
        expect(Interval.fromSemitones(3, 3), Interval.m3);
        expect(Interval.fromSemitones(-3, -3), -Interval.m3);
        expect(Interval.fromSemitones(3, 4), Interval.M3);
        expect(Interval.fromSemitones(-3, -4), -Interval.M3);
        expect(Interval.fromSemitones(3, 5), Interval.A3);
        expect(Interval.fromSemitones(-3, -5), -Interval.A3);

        expect(Interval.fromSemitones(4, 4), Interval.d4);
        expect(Interval.fromSemitones(-4, -4), -Interval.d4);
        expect(Interval.fromSemitones(4, 5), Interval.P4);
        expect(Interval.fromSemitones(-4, -5), -Interval.P4);
        expect(Interval.fromSemitones(4, 6), Interval.A4);
        expect(Interval.fromSemitones(-4, -6), -Interval.A4);

        expect(Interval.fromSemitones(5, 6), Interval.d5);
        expect(Interval.fromSemitones(-5, -6), -Interval.d5);
        expect(Interval.fromSemitones(5, 7), Interval.P5);
        expect(Interval.fromSemitones(-5, -7), -Interval.P5);
        expect(Interval.fromSemitones(5, 8), Interval.A5);
        expect(Interval.fromSemitones(-5, -8), -Interval.A5);

        expect(Interval.fromSemitones(6, 8), Interval.m6);
        expect(Interval.fromSemitones(-6, -8), -Interval.m6);
        expect(Interval.fromSemitones(6, 9), Interval.M6);
        expect(Interval.fromSemitones(-6, -9), -Interval.M6);

        expect(Interval.fromSemitones(7, 10), Interval.m7);
        expect(Interval.fromSemitones(-7, -10), -Interval.m7);
        expect(Interval.fromSemitones(7, 11), Interval.M7);
        expect(Interval.fromSemitones(-7, -11), -Interval.M7);

        expect(Interval.fromSemitones(8, 11), Interval.d8);
        expect(Interval.fromSemitones(-8, -11), -Interval.d8);
        expect(Interval.fromSemitones(8, 12), Interval.P8);
        expect(Interval.fromSemitones(-8, -12), -Interval.P8);
        expect(Interval.fromSemitones(8, 13), Interval.A8);
        expect(Interval.fromSemitones(-8, -13), -Interval.A8);
      });
    });

    group('.fromSemitonesQuality()', () {
      test('should return the correct Interval from semitones and Quality', () {
        expect(Interval.fromSemitonesQuality(3), Interval.m3);
        expect(Interval.fromSemitonesQuality(6), Interval.A4);
        expect(
          Interval.fromSemitonesQuality(6, PerfectQuality.augmented),
          Interval.A4,
        );
        expect(
          Interval.fromSemitonesQuality(6, PerfectQuality.diminished),
          Interval.d5,
        );
      });
    });

    group('.parse()', () {
      test('should throw a FormatException when source is invalid', () {
        expect(() => Interval.parse('x'), throwsFormatException);
        expect(() => Interval.parse('x4'), throwsFormatException);
        expect(() => Interval.parse('x6'), throwsFormatException);
      });

      test('should parse source as an Interval and return its value', () {
        expect(
          Interval.parse('AA4'),
          const Interval.perfect(4, PerfectQuality.doublyAugmented),
        );
        expect(Interval.parse('A5'), Interval.A5);
        expect(Interval.parse('P1'), Interval.P1);
        expect(
          Interval.parse('P22'),
          const Interval.perfect(22, PerfectQuality.perfect),
        );
        expect(Interval.parse('d5'), Interval.d5);
        expect(
          Interval.parse('dd8'),
          const Interval.perfect(8, PerfectQuality.doublyDiminished),
        );

        expect(
          Interval.parse('AA3'),
          const Interval.imperfect(3, ImperfectQuality.doublyAugmented),
        );
        expect(Interval.parse('A6'), Interval.A6);
        expect(Interval.parse('M3'), Interval.M3);
        expect(
          Interval.parse('M16'),
          const Interval.imperfect(16, ImperfectQuality.major),
        );
        expect(Interval.parse('m2'), Interval.m2);
        expect(Interval.parse('d7'), Interval.d7);
        expect(
          Interval.parse('dd9'),
          const Interval.imperfect(9, ImperfectQuality.doublyDiminished),
        );
      });
    });

    group('.semitones', () {
      test('should return the number of semitones of this Interval', () {
        expect(Interval.d1.semitones, -1);
        expect(Interval.P1.semitones, 0);
        expect((-Interval.P1).semitones, 0);
        expect(Interval.A1.semitones, 1);

        expect(Interval.d2.semitones, 0);
        expect(Interval.m2.semitones, 1);
        expect((-Interval.m2).semitones, -1);
        expect(Interval.M2.semitones, 2);
        expect(Interval.A2.semitones, 3);

        expect(Interval.d3.semitones, 2);
        expect(Interval.m3.semitones, 3);
        expect(Interval.M3.semitones, 4);
        expect(Interval.A3.semitones, 5);

        expect(Interval.d4.semitones, 4);
        expect(Interval.P4.semitones, 5);
        expect((-Interval.P4).semitones, -5);
        expect(Interval.A4.semitones, 6);

        expect(Interval.d5.semitones, 6);
        expect(Interval.P5.semitones, 7);
        expect(Interval.A5.semitones, 8);

        expect((-Interval.d6).semitones, -7);
        expect(Interval.d6.semitones, 7);
        expect(Interval.m6.semitones, 8);
        expect(Interval.M6.semitones, 9);
        expect(Interval.A6.semitones, 10);

        expect(Interval.d7.semitones, 9);
        expect(Interval.m7.semitones, 10);
        expect(Interval.M7.semitones, 11);
        expect(Interval.A7.semitones, 12);

        expect(Interval.d8.semitones, 11);
        expect(Interval.P8.semitones, 12);
        expect(Interval.A8.semitones, 13);
        expect((-Interval.A8).semitones, -13);

        expect(Interval.m9.semitones, 13);
        expect(Interval.M9.semitones, 14);

        expect((-Interval.d11).semitones, -16);
        expect(Interval.P11.semitones, 17);
        expect(Interval.A11.semitones, 18);

        expect(Interval.m13.semitones, 20);
        expect((-Interval.M13).semitones, -21);

        expect(
          const Interval.perfect(15, PerfectQuality.perfect).semitones,
          24,
        );

        expect(
          const Interval.perfect(22, PerfectQuality.perfect).semitones,
          36,
        );

        expect(
          const Interval.perfect(29, PerfectQuality.perfect).semitones,
          48,
        );
      });
    });

    group('.isDescending', () {
      test('should return whether this Interval is descending', () {
        expect(Interval.m3.isDescending, isFalse);
        expect((-Interval.P5).isDescending, isTrue);
        expect(Interval.d1.isDescending, isFalse);
        expect(Interval.M9.isDescending, isFalse);
        expect(
          const Interval.perfect(-4, PerfectQuality.doublyAugmented)
              .isDescending,
          isTrue,
        );
      });
    });

    group('.descending()', () {
      test(
        'should return the descending Interval based on isDescending',
        () {
          expect(Interval.M2.descending(), -Interval.M2);
          expect(Interval.m3.descending(isDescending: false), Interval.m3);
          expect((-Interval.m6).descending(isDescending: false), Interval.m6);
          expect((-Interval.P8).descending(), -Interval.P8);
        },
      );

      test(
        'should return a copy of this Interval based on isDescending',
        () {
          const ascendingInterval = Interval.P4;
          expect(
            identical(ascendingInterval.descending(), ascendingInterval),
            isFalse,
          );

          final descendingInterval = -Interval.m3;
          expect(
            identical(descendingInterval.descending(), descendingInterval),
            isFalse,
          );
        },
      );
    });

    group('.inverted', () {
      test('should return the inverted of this Interval', () {
        expect(Interval.d1.inverted, Interval.A8);
        expect(Interval.P1.inverted, Interval.P8);
        expect(Interval.A1.inverted, Interval.d8);
        expect(Interval.m2.inverted, Interval.M7);
        expect(Interval.M2.inverted, Interval.m7);
        expect(Interval.m3.inverted, Interval.M6);
        expect(Interval.M3.inverted, Interval.m6);
        expect(Interval.d4.inverted, Interval.A5);
        expect(Interval.A4.inverted, Interval.d5);
        expect(Interval.d5.inverted, Interval.A4);
        expect(Interval.A5.inverted, Interval.d4);
        expect(Interval.m6.inverted, Interval.M3);
        expect(Interval.M6.inverted, Interval.m3);
        expect(Interval.m7.inverted, Interval.M2);
        expect(Interval.M7.inverted, Interval.m2);
        expect(Interval.d8.inverted, Interval.A1);
        expect(Interval.P8.inverted, Interval.P1);
        expect(Interval.A8.inverted, Interval.d1);
      });
    });

    group('.simplified', () {
      test('should return the simplified of this Interval', () {
        expect(Interval.P1.simplified, Interval.P1);
        expect(Interval.M3.simplified, Interval.M3);
        expect(Interval.P8.simplified, Interval.P8);
        expect(Interval.A8.simplified, Interval.A8);
        expect(Interval.m9.simplified, Interval.m2);
        expect(Interval.P11.simplified, Interval.P4);
        expect(Interval.M13.simplified, Interval.M6);
      });
    });

    group('.respellBySize()', () {
      test('should return this Interval respelled by size', () {
        expect(Interval.A4.respellBySize(5), Interval.d5);
        expect(Interval.d5.respellBySize(4), Interval.A4);
        expect(Interval.M2.respellBySize(3), Interval.d3);
        expect(
          Interval.M3.respellBySize(5),
          const Interval.perfect(5, PerfectQuality.triplyDiminished),
        );
        expect(Interval.P1.respellBySize(2), Interval.d2);
        expect(Interval.m2.respellBySize(1), Interval.A1);

        expect((-Interval.M3).respellBySize(-4), -Interval.d4);
        expect((-Interval.d5).respellBySize(-4), -Interval.A4);
        expect(
          (-Interval.P4).respellBySize(-5),
          const Interval.perfect(-5, PerfectQuality.doublyDiminished),
        );
      });
    });

    group('.distanceBetween()', () {
      test('should return the distance between two Scalable instances', () {
        expect(Interval.P5.distanceBetween(Note.c, Note.b.flat.flat), -9);
        expect(Interval.P5.distanceBetween(Note.c, Note.b.flat), -2);
        expect(
          Interval.P5.distanceBetween(EnharmonicNote.d, EnharmonicNote.gSharp),
          6,
        );
        expect(Interval.P5.distanceBetween(Note.c, Note.f.sharp.sharp), 13);

        expect(
          Interval.P4.distanceBetween(EnharmonicNote.dSharp, EnharmonicNote.c),
          -3,
        );
        expect(Interval.P4.distanceBetween(Note.c, Note.c), 0);
        expect(Interval.P4.distanceBetween(Note.c, Note.f), 1);
        expect(
          Interval.P4.distanceBetween(EnharmonicNote.c, EnharmonicNote.aSharp),
          2,
        );
      });
    });

    group('.circleFrom()', () {
      test('should return the circle of this Interval', () {
        expect(Interval.P5.circleFrom(Note.c, distance: 0), const [Note.c]);
        expect(
          Interval.P5.circleFrom(Note.c, distance: 1),
          const [Note.c, Note.g],
        );
        expect(
          Interval.P5.circleFrom(EnharmonicNote.c, distance: 6),
          const [
            EnharmonicNote.c,
            EnharmonicNote.g,
            EnharmonicNote.d,
            EnharmonicNote.a,
            EnharmonicNote.e,
            EnharmonicNote.b,
            EnharmonicNote.fSharp,
          ],
        );
        expect(
          Interval.P5.circleFrom(Note.f.sharp, distance: 8),
          [
            Note.f.sharp,
            Note.c.sharp,
            Note.g.sharp,
            Note.d.sharp,
            Note.a.sharp,
            Note.e.sharp,
            Note.b.sharp,
            Note.f.sharp.sharp,
            Note.c.sharp.sharp,
          ],
        );
        expect(
          Interval.P4.circleFrom(Note.b.flat, distance: 9),
          [
            Note.b.flat,
            Note.e.flat,
            Note.a.flat,
            Note.d.flat,
            Note.g.flat,
            Note.c.flat,
            Note.f.flat,
            Note.b.flat.flat,
            Note.e.flat.flat,
            Note.a.flat.flat,
          ],
        );
      });
    });

    group('operator +()', () {
      test('should add other to this Interval', () {
        expect(Interval.P1 + Interval.P1, Interval.P1);
        expect(Interval.P1 + Interval.m2, Interval.m2);
        expect(Interval.m2 + Interval.P1, Interval.m2);
        expect(Interval.P1 + Interval.P5, Interval.P5);

        expect(Interval.m2 + Interval.m2, Interval.d3);
        expect(Interval.m2 + Interval.M2, Interval.m3);
        expect(Interval.m2 + Interval.m3, Interval.d4);
        expect(Interval.m2 + Interval.P4, Interval.d5);

        expect(Interval.M2 + Interval.m3, Interval.P4);
        expect(Interval.M2 + Interval.M3, Interval.A4);
        expect(Interval.M2 + Interval.P4, Interval.P5);

        expect(Interval.P4 + Interval.P4, Interval.m7);
      });
    });

    group('operator -()', () {
      test('should return the negation of this Interval', () {
        expect(
          -Interval.M2,
          const Interval.imperfect(-2, ImperfectQuality.major),
        );
        expect(
          -const Interval.imperfect(-6, ImperfectQuality.minor),
          Interval.m6,
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Interval', () {
        expect(Interval.M2.toString(), 'M2');
        expect((-Interval.m3).toString(), 'desc m3');
        expect(Interval.A4.toString(), 'A4');
        expect((-Interval.P5).toString(), 'desc P5');
        expect(Interval.d7.toString(), 'd7');
        expect((-Interval.d8).toString(), 'desc d8');
        expect(Interval.M9.toString(), 'M9 (M2)');
        expect(
          const Interval.imperfect(-10, ImperfectQuality.minor).toString(),
          'desc m10 (m3)',
        );
        expect(Interval.A11.toString(), 'A11 (A4)');
        expect(
          const Interval.imperfect(-14, ImperfectQuality.major).toString(),
          'desc M14 (M7)',
        );
        expect(
          const Interval.perfect(15, PerfectQuality.perfect).toString(),
          'P15 (P8)',
        );
        expect(
          const Interval.imperfect(-16, ImperfectQuality.diminished).toString(),
          'desc d16 (d2)',
        );
        expect(
          const Interval.perfect(22, PerfectQuality.perfect).toString(),
          'P22 (P8)',
        );

        expect(
          const Interval.perfect(5, PerfectQuality(-4)).toString(),
          '[-4]5',
        );
        expect(
          const Interval.imperfect(10, ImperfectQuality(6)).toString(),
          '[+6]10 ([+6]3)',
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Interval instances in a Set', () {
        final collection = {Interval.M2, Interval.d3, Interval.P4};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [Interval.M2, Interval.d3, Interval.P4],
        );
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Interval items in a collection', () {
        final orderedSet = SplayTreeSet<Interval>.of(const [
          Interval.m2,
          Interval.P8,
          Interval.P1,
          Interval.A1,
        ]);
        expect(orderedSet.toList(), const [
          Interval.P1,
          Interval.A1,
          Interval.m2,
          Interval.P8,
        ]);
      });
    });
  });
}
