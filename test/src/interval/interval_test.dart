import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('constructor', () {
      test('should throw an assertion error when arguments are incorrect', () {
        expect(
          () => const Interval.perfect(Size.second, PerfectQuality.diminished),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () =>
              const Interval.imperfect(Size.fifth, ImperfectQuality.augmented),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.fromSemitones()', () {
      test('should create a new Interval from semitones', () {
        expect(Interval.fromSemitones(Size.unison, -1), Interval.d1);
        expect(Interval.fromSemitones(-Size.unison, 1), -Interval.d1);
        expect(Interval.fromSemitones(Size.unison, 0), Interval.P1);
        expect(Interval.fromSemitones(-Size.unison, 0), -Interval.P1);
        expect(Interval.fromSemitones(Size.unison, 1), Interval.A1);
        expect(Interval.fromSemitones(-Size.unison, -1), -Interval.A1);

        expect(Interval.fromSemitones(Size.second, 0), Interval.d2);
        expect(Interval.fromSemitones(-Size.second, 0), -Interval.d2);
        expect(Interval.fromSemitones(Size.second, 1), Interval.m2);
        expect(Interval.fromSemitones(-Size.second, -1), -Interval.m2);
        expect(Interval.fromSemitones(Size.second, 2), Interval.M2);
        expect(Interval.fromSemitones(-Size.second, -2), -Interval.M2);
        expect(Interval.fromSemitones(Size.second, 3), Interval.A2);
        expect(Interval.fromSemitones(-Size.second, -3), -Interval.A2);

        expect(Interval.fromSemitones(Size.third, 2), Interval.d3);
        expect(Interval.fromSemitones(-Size.third, -2), -Interval.d3);
        expect(Interval.fromSemitones(Size.third, 3), Interval.m3);
        expect(Interval.fromSemitones(-Size.third, -3), -Interval.m3);
        expect(Interval.fromSemitones(Size.third, 4), Interval.M3);
        expect(Interval.fromSemitones(-Size.third, -4), -Interval.M3);
        expect(Interval.fromSemitones(Size.third, 5), Interval.A3);
        expect(Interval.fromSemitones(-Size.third, -5), -Interval.A3);

        expect(Interval.fromSemitones(Size.fourth, 4), Interval.d4);
        expect(Interval.fromSemitones(-Size.fourth, -4), -Interval.d4);
        expect(Interval.fromSemitones(Size.fourth, 5), Interval.P4);
        expect(Interval.fromSemitones(-Size.fourth, -5), -Interval.P4);
        expect(Interval.fromSemitones(Size.fourth, 6), Interval.A4);
        expect(Interval.fromSemitones(-Size.fourth, -6), -Interval.A4);

        expect(Interval.fromSemitones(Size.fifth, 6), Interval.d5);
        expect(Interval.fromSemitones(-Size.fifth, -6), -Interval.d5);
        expect(Interval.fromSemitones(Size.fifth, 7), Interval.P5);
        expect(Interval.fromSemitones(-Size.fifth, -7), -Interval.P5);
        expect(Interval.fromSemitones(Size.fifth, 8), Interval.A5);
        expect(Interval.fromSemitones(-Size.fifth, -8), -Interval.A5);

        expect(Interval.fromSemitones(Size.sixth, 8), Interval.m6);
        expect(Interval.fromSemitones(-Size.sixth, -8), -Interval.m6);
        expect(Interval.fromSemitones(Size.sixth, 9), Interval.M6);
        expect(Interval.fromSemitones(-Size.sixth, -9), -Interval.M6);

        expect(Interval.fromSemitones(Size.seventh, 10), Interval.m7);
        expect(Interval.fromSemitones(-Size.seventh, -10), -Interval.m7);
        expect(Interval.fromSemitones(Size.seventh, 11), Interval.M7);
        expect(Interval.fromSemitones(-Size.seventh, -11), -Interval.M7);

        expect(Interval.fromSemitones(Size.octave, 11), Interval.d8);
        expect(Interval.fromSemitones(-Size.octave, -11), -Interval.d8);
        expect(Interval.fromSemitones(Size.octave, 12), Interval.P8);
        expect(Interval.fromSemitones(-Size.octave, -12), -Interval.P8);
        expect(Interval.fromSemitones(Size.octave, 13), Interval.A8);
        expect(Interval.fromSemitones(-Size.octave, -13), -Interval.A8);
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
          const Interval.perfect(Size.fourth, PerfectQuality.doublyAugmented),
        );
        expect(Interval.parse('A5'), Interval.A5);
        expect(Interval.parse('P1'), Interval.P1);
        expect(
          Interval.parse('P22'),
          const Interval.perfect(Size(22), PerfectQuality.perfect),
        );
        expect(Interval.parse('d5'), Interval.d5);
        expect(
          Interval.parse('dd8'),
          const Interval.perfect(Size.octave, PerfectQuality.doublyDiminished),
        );

        expect(
          Interval.parse('AA3'),
          const Interval.imperfect(
            Size.third,
            ImperfectQuality.doublyAugmented,
          ),
        );
        expect(Interval.parse('A6'), Interval.A6);
        expect(Interval.parse('M3'), Interval.M3);
        expect(
          Interval.parse('M16'),
          const Interval.imperfect(Size(16), ImperfectQuality.major),
        );
        expect(Interval.parse('m2'), Interval.m2);
        expect(Interval.parse('d7'), Interval.d7);
        expect(
          Interval.parse('dd9'),
          const Interval.imperfect(
            Size.ninth,
            ImperfectQuality.doublyDiminished,
          ),
        );
      });
    });

    group('.sizeFromSemitones()', () {
      test(
        'should return the Interval size corresponding to the given semitones',
        () {
          expect(Interval.sizeFromSemitones(-12), -8);
          expect(Interval.sizeFromSemitones(-5), -4);
          expect(Interval.sizeFromSemitones(-3), -3);
          expect(Interval.sizeFromSemitones(-1), -2);
          expect(Interval.sizeFromSemitones(0), 1);
          expect(Interval.sizeFromSemitones(1), 2);
          expect(Interval.sizeFromSemitones(3), 3);
          expect(Interval.sizeFromSemitones(5), 4);
          expect(Interval.sizeFromSemitones(7), 5);
          expect(Interval.sizeFromSemitones(8), 6);
          expect(Interval.sizeFromSemitones(10), 7);
          expect(Interval.sizeFromSemitones(12), 8);
          expect(Interval.sizeFromSemitones(13), 9);
          expect(Interval.sizeFromSemitones(15), 10);
          expect(Interval.sizeFromSemitones(17), 11);
          expect(Interval.sizeFromSemitones(19), 12);
          expect(Interval.sizeFromSemitones(20), 13);
          expect(Interval.sizeFromSemitones(22), 14);
          expect(Interval.sizeFromSemitones(24), 15);
          expect(Interval.sizeFromSemitones(36), 22);
          expect(Interval.sizeFromSemitones(48), 29);
        },
      );

      test(
        'should return null when no Interval size corresponds to the given '
        'semitones',
        () {
          expect(Interval.sizeFromSemitones(-4), isNull);
          expect(Interval.sizeFromSemitones(-2), isNull);
          expect(Interval.sizeFromSemitones(2), isNull);
          expect(Interval.sizeFromSemitones(4), isNull);
          expect(Interval.sizeFromSemitones(6), isNull);
          expect(Interval.sizeFromSemitones(9), isNull);
          expect(Interval.sizeFromSemitones(11), isNull);
        },
      );
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
          const Interval.perfect(Size(15), PerfectQuality.perfect).semitones,
          24,
        );

        expect(
          const Interval.perfect(Size(22), PerfectQuality.perfect).semitones,
          36,
        );

        expect(
          const Interval.perfect(Size(29), PerfectQuality.perfect).semitones,
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
          const Interval.perfect(-Size.fourth, PerfectQuality.doublyAugmented)
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

          const descendingInterval = -Interval.m3;
          expect(
            identical(descendingInterval.descending(), descendingInterval),
            isFalse,
          );
        },
      );
    });

    group('.inverted', () {
      test('should return the inverted of this Interval', () {
        expect((-Interval.M13).inverted, -Interval.m3);
        expect((-Interval.m13).inverted, -Interval.M3);
        expect((-Interval.P11).inverted, -Interval.P5);
        expect((-Interval.M9).inverted, -Interval.m7);
        expect((-Interval.m9).inverted, -Interval.M7);
        expect((-Interval.A8).inverted, -Interval.d1);
        expect((-Interval.P8).inverted, -Interval.P1);
        expect((-Interval.d8).inverted, -Interval.A1);
        expect((-Interval.M7).inverted, -Interval.m2);
        expect((-Interval.m7).inverted, -Interval.M2);
        expect((-Interval.M6).inverted, -Interval.m3);
        expect((-Interval.m6).inverted, -Interval.M3);
        expect((-Interval.A5).inverted, -Interval.d4);
        expect((-Interval.d5).inverted, -Interval.A4);
        expect((-Interval.A4).inverted, -Interval.d5);
        expect((-Interval.d4).inverted, -Interval.A5);
        expect((-Interval.M3).inverted, -Interval.m6);
        expect((-Interval.m3).inverted, -Interval.M6);
        expect((-Interval.M2).inverted, -Interval.m7);
        expect((-Interval.m2).inverted, -Interval.M7);
        expect((-Interval.A1).inverted, -Interval.d8);
        expect((-Interval.P1).inverted, -Interval.P8);
        expect((-Interval.d1).inverted, -Interval.A8);
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
        expect(Interval.m9.inverted, Interval.M7);
        expect(Interval.M9.inverted, Interval.m7);
        expect(Interval.P11.inverted, Interval.P5);
        expect(Interval.m13.inverted, Interval.M3);
        expect(Interval.M13.inverted, Interval.m3);
      });
    });

    group('.simplified', () {
      test('should return the simplified of this Interval', () {
        expect(
          const Interval.perfect(Size(-22), PerfectQuality.perfect).simplified,
          -Interval.P8,
        );
        expect(
          const Interval.perfect(Size(-15), PerfectQuality.perfect).simplified,
          -Interval.P8,
        );
        expect((-Interval.M13).simplified, -Interval.M6);
        expect((-Interval.P11).simplified, -Interval.P4);
        expect((-Interval.m9).simplified, -Interval.m2);
        expect((-Interval.A8).simplified, -Interval.A8);
        expect((-Interval.P8).simplified, -Interval.P8);
        expect((-Interval.M3).simplified, -Interval.M3);
        expect((-Interval.P1).simplified, -Interval.P1);
        expect(Interval.P1.simplified, Interval.P1);
        expect(Interval.M3.simplified, Interval.M3);
        expect(Interval.P8.simplified, Interval.P8);
        expect(Interval.A8.simplified, Interval.A8);
        expect(Interval.m9.simplified, Interval.m2);
        expect(Interval.P11.simplified, Interval.P4);
        expect(Interval.M13.simplified, Interval.M6);
        expect(
          const Interval.perfect(Size(15), PerfectQuality.perfect).simplified,
          Interval.P8,
        );
        expect(
          const Interval.perfect(Size(22), PerfectQuality.perfect).simplified,
          Interval.P8,
        );
      });
    });

    group('.isCompound', () {
      test('should return whether this Interval is compound', () {
        expect((-Interval.m13).isCompound, isTrue);
        expect((-Interval.M9).isCompound, isTrue);
        expect((-Interval.M7).isCompound, isFalse);
        expect((-Interval.P4).isCompound, isFalse);
        expect((-Interval.P1).isCompound, isFalse);
        expect(Interval.P1.isCompound, isFalse);
        expect(Interval.P5.isCompound, isFalse);
        expect(Interval.P8.isCompound, isFalse);
        expect(Interval.m9.isCompound, isTrue);
        expect(Interval.M13.isCompound, isTrue);
      });
    });

    group('.isDissonant', () {
      test('should return whether this Interval is dissonant', () {
        expect((-Interval.A8).isDissonant, isTrue);
        expect((-Interval.P8).isDissonant, isFalse);
        expect((-Interval.d8).isDissonant, isTrue);
        expect((-Interval.A7).isDissonant, isTrue);
        expect((-Interval.M7).isDissonant, isTrue);
        expect((-Interval.m7).isDissonant, isTrue);
        expect((-Interval.d7).isDissonant, isTrue);
        expect((-Interval.M6).isDissonant, isFalse);
        expect((-Interval.m6).isDissonant, isFalse);
        expect((-Interval.A5).isDissonant, isTrue);
        expect((-Interval.P5).isDissonant, isFalse);
        expect((-Interval.d5).isDissonant, isTrue);
        expect((-Interval.A4).isDissonant, isTrue);
        expect((-Interval.P4).isDissonant, isFalse);
        expect((-Interval.d4).isDissonant, isTrue);
        expect((-Interval.M3).isDissonant, isFalse);
        expect((-Interval.m3).isDissonant, isFalse);
        expect((-Interval.M2).isDissonant, isTrue);
        expect((-Interval.m2).isDissonant, isTrue);
        expect((-Interval.P1).isDissonant, isFalse);
        expect(Interval.d1.isDissonant, isTrue);
        expect(Interval.P1.isDissonant, isFalse);
        expect(Interval.A1.isDissonant, isTrue);
        expect(Interval.m2.isDissonant, isTrue);
        expect(Interval.M2.isDissonant, isTrue);
        expect(Interval.m3.isDissonant, isFalse);
        expect(Interval.M3.isDissonant, isFalse);
        expect(Interval.d4.isDissonant, isTrue);
        expect(Interval.P4.isDissonant, isFalse);
        expect(Interval.A4.isDissonant, isTrue);
        expect(Interval.d5.isDissonant, isTrue);
        expect(Interval.P5.isDissonant, isFalse);
        expect(Interval.A5.isDissonant, isTrue);
        expect(Interval.m6.isDissonant, isFalse);
        expect(Interval.M6.isDissonant, isFalse);
        expect(Interval.d7.isDissonant, isTrue);
        expect(Interval.m7.isDissonant, isTrue);
        expect(Interval.M7.isDissonant, isTrue);
        expect(Interval.A7.isDissonant, isTrue);
        expect(Interval.d8.isDissonant, isTrue);
        expect(Interval.P8.isDissonant, isFalse);
        expect(Interval.A8.isDissonant, isTrue);
      });
    });

    group('.respellBySize()', () {
      test('should return this Interval respelled by size', () {
        expect(Interval.A4.respellBySize(Size.fifth), Interval.d5);
        expect(Interval.d5.respellBySize(Size.fourth), Interval.A4);
        expect(Interval.M2.respellBySize(Size.third), Interval.d3);
        expect(
          Interval.M3.respellBySize(Size.fifth),
          const Interval.perfect(Size.fifth, PerfectQuality.triplyDiminished),
        );
        expect(Interval.P1.respellBySize(Size.second), Interval.d2);
        expect(Interval.m2.respellBySize(Size.unison), Interval.A1);

        expect((-Interval.M3).respellBySize(-Size.fourth), -Interval.d4);
        expect((-Interval.d5).respellBySize(-Size.fourth), -Interval.A4);
        expect(
          (-Interval.P4).respellBySize(-Size.fifth),
          const Interval.perfect(-Size.fifth, PerfectQuality.doublyDiminished),
        );
      });
    });

    group('.distanceBetween()', () {
      test('should return the distance between two Scalable instances', () {
        var (distance, notes: dynamic notes) =
            Interval.P5.distanceBetween(Note.c, Note.b.flat.flat);
        expect(distance, -9);
        expect(notes, [
          Note.c,
          Note.f,
          Note.b.flat,
          Note.e.flat,
          Note.a.flat,
          Note.d.flat,
          Note.g.flat,
          Note.c.flat,
          Note.f.flat,
          Note.b.flat.flat,
        ]);

        (distance, :notes) = Interval.P5.distanceBetween(Note.c, Note.b.flat);
        expect(distance, -2);
        expect(notes, [Note.c, Note.f, Note.b.flat]);

        (distance, :notes) =
            Interval.P5.distanceBetween(PitchClass.d, PitchClass.gSharp);
        expect(distance, 6);
        expect(notes, const [
          PitchClass.d,
          PitchClass.a,
          PitchClass.e,
          PitchClass.b,
          PitchClass.fSharp,
          PitchClass.cSharp,
          PitchClass.gSharp,
        ]);

        (distance, :notes) =
            Interval.P5.distanceBetween(Note.c, Note.f.sharp.sharp);
        expect(distance, 13);
        expect(notes, [
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
          Note.e.sharp,
          Note.b.sharp,
          Note.f.sharp.sharp,
        ]);

        (distance, :notes) =
            Interval.P4.distanceBetween(PitchClass.dSharp, PitchClass.c);
        expect(distance, -3);
        expect(
          notes,
          const [
            PitchClass.dSharp,
            PitchClass.aSharp,
            PitchClass.f,
            PitchClass.c,
          ],
        );

        (distance, :notes) = Interval.P4.distanceBetween(Note.c, Note.c);
        expect(distance, 0);
        expect(notes, const [Note.c]);

        (distance, :notes) = Interval.P4.distanceBetween(Note.c, Note.f);
        expect(distance, 1);
        expect(notes, const [Note.c, Note.f]);

        (distance, :notes) =
            Interval.P4.distanceBetween(PitchClass.c, PitchClass.aSharp);
        expect(distance, 2);
        expect(notes, const [PitchClass.c, PitchClass.f, PitchClass.aSharp]);
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
          Interval.P5.circleFrom(PitchClass.c, distance: 6),
          const [
            PitchClass.c,
            PitchClass.g,
            PitchClass.d,
            PitchClass.a,
            PitchClass.e,
            PitchClass.b,
            PitchClass.fSharp,
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

        expect(
          Interval.P4.circleFrom(Note.c, distance: -7),
          Interval.P5.circleFrom(Note.c, distance: 7),
        );
      });
    });

    group('.toClass()', () {
      test('should create a new IntervalClass from semitones', () {
        expect(Interval.P1.toClass(), IntervalClass.P1);
        expect(Interval.d1.toClass(), IntervalClass.m2);
        expect(Interval.A1.toClass(), IntervalClass.m2);
        expect((-Interval.A1).toClass(), IntervalClass.m2);
        expect(Interval.m2.toClass(), IntervalClass.m2);
        expect(Interval.d4.toClass(), IntervalClass.M3);
        expect((-Interval.A4).toClass(), IntervalClass.tritone);
        expect(Interval.d6.toClass(), IntervalClass.P4);
        expect((-Interval.M6).toClass(), IntervalClass.m3);
        expect(Interval.m7.toClass(), IntervalClass.M2);
        expect((-Interval.M7).toClass(), IntervalClass.m2);
        expect(Interval.P8.toClass(), IntervalClass.P1);
        expect(Interval.P11.toClass(), IntervalClass.P4);
        expect(Interval.M13.toClass(), IntervalClass.m3);
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
          const Interval.imperfect(-Size.second, ImperfectQuality.major),
        );
        expect(
          -const Interval.imperfect(-Size.sixth, ImperfectQuality.minor),
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
          const Interval.imperfect(-Size.tenth, ImperfectQuality.minor)
              .toString(),
          'desc m10 (m3)',
        );
        expect(Interval.A11.toString(), 'A11 (A4)');
        expect(
          const Interval.imperfect(Size(-14), ImperfectQuality.major)
              .toString(),
          'desc M14 (M7)',
        );
        expect(
          const Interval.perfect(Size(15), PerfectQuality.perfect).toString(),
          'P15 (P8)',
        );
        expect(
          const Interval.imperfect(Size(-16), ImperfectQuality.diminished)
              .toString(),
          'desc d16 (d2)',
        );
        expect(
          const Interval.perfect(Size(22), PerfectQuality.perfect).toString(),
          'P22 (P8)',
        );

        expect(
          const Interval.perfect(Size.fifth, PerfectQuality(-4)).toString(),
          'dddd5',
        );
        expect(
          const Interval.imperfect(Size.tenth, ImperfectQuality(6)).toString(),
          'AAAAA10 (AAAAA3)',
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
        final orderedSet = SplayTreeSet<Interval>.of({
          Interval.m2,
          Interval.P8,
          Interval.P1,
          Interval.A1,
        });
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
