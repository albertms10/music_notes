import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('PositionedNote', () {
    group('.parse()', () {
      test('should throw a FormatException when source is invalid', () {
        expect(() => PositionedNote.parse('x'), throwsFormatException);
        expect(() => PositionedNote.parse('invalid'), throwsFormatException);
      });

      test('should parse source as a PositionedNote and return its value', () {
        expect(PositionedNote.parse('A4'), Note.a.inOctave(4));
        expect(PositionedNote.parse('d3'), Note.d.inOctave(3));
        expect(PositionedNote.parse('C-1'), Note.c.inOctave(-1));
        expect(PositionedNote.parse('bb-1'), Note.b.flat.inOctave(-1));
        expect(PositionedNote.parse('G#6'), Note.g.sharp.inOctave(6));
        expect(PositionedNote.parse('Bx12'), Note.b.sharp.sharp.inOctave(12));

        expect(PositionedNote.parse('C͵͵͵'), Note.c.inOctave(-1));
        expect(PositionedNote.parse('C,,'), Note.c.inOctave(0));
        expect(PositionedNote.parse('Gb,'), Note.g.flat.inOctave(1));
        expect(PositionedNote.parse('A'), Note.a.inOctave(2));
        expect(PositionedNote.parse('f'), Note.f.inOctave(3));
        expect(PositionedNote.parse("d#'"), Note.d.sharp.inOctave(4));
        expect(PositionedNote.parse("ebb''"), Note.e.flat.flat.inOctave(5));
        expect(PositionedNote.parse('gx′′′'), Note.g.sharp.sharp.inOctave(6));

        expect(
          PositionedNote.parse(Note.b.flat.flat.inOctave(-2).scientificName),
          Note.b.flat.flat.inOctave(-2),
        );
        expect(
          PositionedNote.parse(Note.a.sharp.inOctave(7).helmholtzName),
          Note.a.sharp.inOctave(7),
        );
      });
    });

    group('.octaveFromSemitones', () {
      test(
        'should return the octave that corresponds to the semitones from root '
        'height',
        () {
          expect(PositionedNote.octaveFromSemitones(-35), -3);
          expect(PositionedNote.octaveFromSemitones(-23), -2);
          expect(PositionedNote.octaveFromSemitones(-11), -1);
          expect(PositionedNote.octaveFromSemitones(-1), -1);
          // TODO(albertms10): Should 0 be considered a correct argument?
          expect(PositionedNote.octaveFromSemitones(0), 0);
          expect(PositionedNote.octaveFromSemitones(1), 0);
          expect(PositionedNote.octaveFromSemitones(13), 1);
          expect(PositionedNote.octaveFromSemitones(25), 2);
          expect(PositionedNote.octaveFromSemitones(34), 2);
          expect(PositionedNote.octaveFromSemitones(58), 4);
        },
      );
    });

    group('.semitones', () {
      test('should return the semitones of this PositionedNote from C0', () {
        expect(Note.c.inOctave(-4).semitones, -47);
        expect(Note.a.inOctave(-4).semitones, -38);
        expect(Note.c.inOctave(-3).semitones, -35);
        expect(Note.c.inOctave(-2).semitones, -23);
        expect(Note.c.inOctave(-1).semitones, -11);
        expect(Note.d.inOctave(-1).semitones, -9);
        expect(Note.e.inOctave(-1).semitones, -7);
        expect(Note.f.inOctave(-1).semitones, -6);
        expect(Note.g.inOctave(-1).semitones, -4);
        expect(Note.a.inOctave(-1).semitones, -2);
        expect(Note.b.inOctave(-1).semitones, 0);
        expect(Note.c.inOctave(0).semitones, 1);
        expect(Note.d.inOctave(0).semitones, 3);
        expect(Note.e.inOctave(0).semitones, 5);
        expect(Note.f.sharp.inOctave(0).semitones, 7);
        expect(Note.g.flat.inOctave(0).semitones, 7);
        expect(Note.a.inOctave(0).semitones, 10);
        expect(Note.b.inOctave(0).semitones, 12);
        expect(Note.c.inOctave(1).semitones, 13);
        expect(Note.c.inOctave(2).semitones, 25);
        expect(Note.a.inOctave(2).semitones, 34);
        expect(Note.c.inOctave(3).semitones, 37);
        expect(Note.a.inOctave(4).semitones, 58);
      });
    });

    group('.difference()', () {
      test(
        'should return the difference in semitones with another PositionedNote',
        () {
          expect(Note.c.inOctave(4).difference(Note.c.inOctave(4)), 0);
          expect(Note.e.sharp.inOctave(4).difference(Note.f.inOctave(4)), 0);
          expect(Note.c.inOctave(4).difference(Note.d.flat.inOctave(4)), 1);
          expect(Note.c.inOctave(4).difference(Note.c.sharp.inOctave(4)), 1);
          expect(Note.b.inOctave(4).difference(Note.c.inOctave(5)), 1);
          expect(Note.f.inOctave(4).difference(Note.g.inOctave(4)), 2);
          expect(Note.f.inOctave(4).difference(Note.a.flat.inOctave(4)), 3);
          expect(Note.e.inOctave(4).difference(Note.a.flat.inOctave(4)), 4);
          expect(Note.a.inOctave(4).difference(Note.d.inOctave(5)), 5);
          expect(Note.d.inOctave(4).difference(Note.a.flat.inOctave(4)), 6);
          expect(
            Note.e.flat.inOctave(4).difference(Note.b.flat.inOctave(4)),
            7,
          );
          expect(
            Note.d.sharp.inOctave(4).difference(Note.a.sharp.inOctave(4)),
            7,
          );
          expect(Note.d.inOctave(4).difference(Note.a.sharp.inOctave(4)), 8);
          expect(
            Note.c.sharp.inOctave(4).difference(Note.b.flat.inOctave(4)),
            9,
          );
          expect(Note.c.sharp.inOctave(4).difference(Note.b.inOctave(4)), 10);
          expect(Note.d.flat.inOctave(4).difference(Note.b.inOctave(4)), 10);
          expect(Note.c.inOctave(4).difference(Note.b.inOctave(4)), 11);
        },
      );
    });

    group('.augmentedTriad', () {
      test('should return the augmented triad on this PositionedNote', () {
        expect(
          Note.c.inOctave(4).augmentedTriad,
          Chord([
            Note.c.inOctave(4),
            Note.e.inOctave(4),
            Note.g.sharp.inOctave(4),
          ]),
        );
        expect(
          Note.a.inOctave(3).augmentedTriad,
          Chord([
            Note.a.inOctave(3),
            Note.c.sharp.inOctave(4),
            Note.e.sharp.inOctave(4),
          ]),
        );
        expect(
          Note.b.inOctave(5).augmentedTriad,
          Chord([
            Note.b.inOctave(5),
            Note.d.sharp.inOctave(6),
            Note.f.sharp.sharp.inOctave(6),
          ]),
        );
      });
    });

    group('.majorTriad', () {
      test('should return the major triad on this PositionedNote', () {
        expect(
          Note.c.inOctave(4).majorTriad,
          Chord([
            Note.c.inOctave(4),
            Note.e.inOctave(4),
            Note.g.inOctave(4),
          ]),
        );
        expect(
          Note.e.flat.inOctave(3).majorTriad,
          Chord([
            Note.e.flat.inOctave(3),
            Note.g.inOctave(3),
            Note.b.flat.inOctave(3),
          ]),
        );
        expect(
          Note.b.inOctave(3).majorTriad,
          Chord([
            Note.b.inOctave(3),
            Note.d.sharp.inOctave(4),
            Note.f.sharp.inOctave(4),
          ]),
        );
      });
    });

    group('.minorTriad', () {
      test('should return the minor triad on this PositionedNote', () {
        expect(
          Note.d.flat.inOctave(5).minorTriad,
          Chord([
            Note.d.flat.inOctave(5),
            Note.f.flat.inOctave(5),
            Note.a.flat.inOctave(5),
          ]),
        );
        expect(
          Note.g.sharp.inOctave(4).minorTriad,
          Chord([
            Note.g.sharp.inOctave(4),
            Note.b.inOctave(4),
            Note.d.sharp.inOctave(5),
          ]),
        );
        expect(
          Note.a.inOctave(3).minorTriad,
          Chord([
            Note.a.inOctave(3),
            Note.c.inOctave(4),
            Note.e.inOctave(4),
          ]),
        );
      });
    });

    group('.diminishedTriad', () {
      test('should return the diminished triad on this PositionedNote', () {
        expect(
          Note.e.inOctave(4).diminishedTriad,
          Chord([
            Note.e.inOctave(4),
            Note.g.inOctave(4),
            Note.b.flat.inOctave(4),
          ]),
        );
        expect(
          Note.g.flat.inOctave(2).diminishedTriad,
          Chord([
            Note.g.flat.inOctave(2),
            Note.b.flat.flat.inOctave(2),
            Note.d.flat.flat.inOctave(3),
          ]),
        );
        expect(
          Note.b.inOctave(5).diminishedTriad,
          Chord([
            Note.b.inOctave(5),
            Note.d.inOctave(6),
            Note.f.inOctave(6),
          ]),
        );
      });
    });

    group('.interval()', () {
      test(
        'should return the Interval between this PositionedNote and other',
        () {
          expect(Note.c.inOctave(4).interval(Note.c.inOctave(4)), Interval.P1);
          expect(
            Note.c.inOctave(3).interval(Note.c.sharp.inOctave(3)),
            Interval.A1,
          );
          expect(
            Note.f.flat.inOctave(2).interval(Note.f.inOctave(2)),
            Interval.A1,
          );

          expect(
            Note.c.inOctave(3).interval(Note.d.flat.flat.inOctave(3)),
            Interval.d2,
          );
          expect(
            Note.f.flat.inOctave(4).interval(Note.g.flat.flat.inOctave(4)),
            Interval.m2,
          );
          expect(
            Note.c.inOctave(5).interval(Note.d.flat.inOctave(5)),
            Interval.m2,
          );
          expect(Note.c.inOctave(4).interval(Note.d.inOctave(4)), Interval.M2);
          expect(Note.d.inOctave(4).interval(Note.c.inOctave(4)), -Interval.M2);
          expect(
            Note.c.inOctave(4).interval(Note.d.sharp.inOctave(4)),
            Interval.A2,
          );

          expect(
            Note.c.inOctave(4).interval(Note.e.flat.flat.inOctave(4)),
            Interval.d3,
          );
          expect(
            Note.c.inOctave(4).interval(Note.e.flat.inOctave(4)),
            Interval.m3,
          );
          expect(Note.c.inOctave(4).interval(Note.e.inOctave(4)), Interval.M3);
          expect(Note.g.inOctave(4).interval(Note.b.inOctave(4)), Interval.M3);
          expect(
            Note.b.flat.inOctave(4).interval(Note.d.inOctave(5)),
            Interval.M3,
          );
          expect(
            Note.c.inOctave(4).interval(Note.e.sharp.inOctave(4)),
            Interval.A3,
          );

          expect(
            Note.c.inOctave(4).interval(Note.f.flat.inOctave(4)),
            Interval.d4,
          );
          expect(Note.c.inOctave(4).interval(Note.f.inOctave(4)), Interval.P4);
          expect(
            Note.g.sharp.inOctave(4).interval(Note.c.sharp.inOctave(5)),
            Interval.P4,
          );
          expect(
            Note.a.flat.inOctave(4).interval(Note.d.inOctave(5)),
            Interval.A4,
          );
          expect(
            Note.c.inOctave(4).interval(Note.f.sharp.inOctave(4)),
            Interval.A4,
          );

          expect(
            Note.c.inOctave(4).interval(Note.g.flat.inOctave(4)),
            Interval.d5,
          );
          expect(Note.c.inOctave(4).interval(Note.g.inOctave(4)), Interval.P5);
          expect(
            Note.c.inOctave(4).interval(Note.g.sharp.inOctave(4)),
            Interval.A5,
          );

          expect(
            Note.c.inOctave(4).interval(Note.a.flat.flat.inOctave(4)),
            Interval.d6,
          );
          expect(
            Note.c.inOctave(4).interval(Note.a.flat.inOctave(4)),
            Interval.m6,
          );
          expect(Note.c.inOctave(4).interval(Note.a.inOctave(4)), Interval.M6);
          expect(
            Note.c.inOctave(4).interval(Note.a.sharp.inOctave(4)),
            Interval.A6,
          );

          expect(
            Note.c.inOctave(4).interval(Note.b.flat.flat.inOctave(4)),
            Interval.d7,
          );
          expect(
            Note.c.inOctave(4).interval(Note.b.flat.inOctave(4)),
            Interval.m7,
          );
          expect(Note.c.inOctave(4).interval(Note.b.inOctave(4)), Interval.M7);
          expect(
            Note.b.inOctave(4).interval(Note.a.sharp.inOctave(5)),
            Interval.M7,
          );

          expect(Note.c.inOctave(3).interval(Note.c.inOctave(4)), Interval.P8);
          expect(
            Note.c.inOctave(3).interval(Note.c.inOctave(5)),
            const Interval.perfect(15, PerfectQuality.perfect),
          );

          expect(
            Note.c.inOctave(3).interval(Note.c.inOctave(6)),
            const Interval.perfect(22, PerfectQuality.perfect),
          );

          expect(
            Note.c.inOctave(2).interval(Note.c.inOctave(6)),
            const Interval.perfect(29, PerfectQuality.perfect),
          );

          // TODO(albertms10): add test case for:
          //  `Note.c.inOctave(4).interval(Note.b.sharp.inOctave(4))`.
        },
      );
    });

    group('.transposeBy()', () {
      test('should return this PositionedNote transposed by Interval', () {
        expect(
          Note.c.inOctave(4).transposeBy(Interval.d1),
          Note.c.flat.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.d1),
          Note.c.sharp.inOctave(4),
        );
        expect(Note.c.inOctave(3).transposeBy(Interval.P1), Note.c.inOctave(3));
        expect(
          Note.c.inOctave(3).transposeBy(-Interval.P1),
          Note.c.inOctave(3),
        );
        expect(
          Note.c.inOctave(5).transposeBy(Interval.A1),
          Note.c.sharp.inOctave(5),
        );
        expect(
          Note.c.inOctave(5).transposeBy(-Interval.A1),
          Note.c.flat.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.d2),
          Note.d.flat.flat.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.d2),
          Note.b.sharp.inOctave(3),
        );
        expect(
          Note.c.inOctave(6).transposeBy(Interval.m2),
          Note.d.flat.inOctave(6),
        );
        expect(
          Note.c.inOctave(6).transposeBy(-Interval.m2),
          Note.b.inOctave(5),
        );
        expect(
          Note.c.inOctave(-1).transposeBy(Interval.M2),
          Note.d.inOctave(-1),
        );
        expect(
          Note.c.inOctave(-1).transposeBy(-Interval.M2),
          Note.b.flat.inOctave(-2),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A2),
          Note.d.sharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.A2),
          Note.b.flat.flat.inOctave(3),
        );

        expect(Note.e.inOctave(2).transposeBy(Interval.m3), Note.g.inOctave(2));
        expect(
          Note.e.inOctave(2).transposeBy(-Interval.m3),
          Note.c.sharp.inOctave(2),
        );
        expect(
          Note.e.inOctave(4).transposeBy(Interval.M3),
          Note.g.sharp.inOctave(4),
        );
        expect(
          Note.e.inOctave(4).transposeBy(-Interval.M3),
          Note.c.inOctave(4),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(Interval.m3),
          Note.c.flat.inOctave(5),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(-Interval.m3),
          Note.f.inOctave(4),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(Interval.M3),
          Note.c.inOctave(5),
        );
        expect(
          Note.a.flat.inOctave(4).transposeBy(-Interval.M3),
          Note.f.flat.inOctave(4),
        );

        expect(
          Note.f.inOctave(4).transposeBy(Interval.d4),
          Note.b.flat.flat.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.d4),
          Note.c.sharp.inOctave(4),
        );
        expect(
          Note.f.inOctave(3).transposeBy(Interval.P4),
          Note.b.flat.inOctave(3),
        );
        expect(
          Note.f.inOctave(3).transposeBy(-Interval.P4),
          Note.c.inOctave(3),
        );
        expect(Note.f.inOctave(4).transposeBy(Interval.A4), Note.b.inOctave(4));
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.A4),
          Note.c.flat.inOctave(4),
        );
        expect(
          Note.a.inOctave(6).transposeBy(Interval.d4),
          Note.d.flat.inOctave(7),
        );
        expect(
          Note.a.inOctave(6).transposeBy(-Interval.d4),
          Note.e.sharp.inOctave(6),
        );
        expect(
          Note.a.inOctave(-2).transposeBy(Interval.P4),
          Note.d.inOctave(-1),
        );
        expect(
          Note.a.inOctave(-2).transposeBy(-Interval.P4),
          Note.e.inOctave(-2),
        );
        expect(
          Note.a.inOctave(7).transposeBy(Interval.A4),
          Note.d.sharp.inOctave(8),
        );
        expect(
          Note.a.inOctave(7).transposeBy(-Interval.A4),
          Note.e.flat.inOctave(7),
        );

        expect(
          Note.d.inOctave(4).transposeBy(Interval.d5),
          Note.a.flat.inOctave(4),
        );
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.d5),
          Note.g.sharp.inOctave(3),
        );
        expect(Note.d.inOctave(1).transposeBy(Interval.P5), Note.a.inOctave(1));
        expect(
          Note.d.inOctave(1).transposeBy(-Interval.P5),
          Note.g.inOctave(0),
        );
        expect(
          Note.d.inOctave(2).transposeBy(Interval.A5),
          Note.a.sharp.inOctave(2),
        );
        expect(
          Note.d.inOctave(2).transposeBy(-Interval.A5),
          Note.g.flat.inOctave(1),
        );

        expect(
          Note.d.inOctave(4).transposeBy(Interval.m6),
          Note.b.flat.inOctave(4),
        );
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.m6),
          Note.f.sharp.inOctave(3),
        );
        expect(
          Note.d.inOctave(-2).transposeBy(Interval.M6),
          Note.b.inOctave(-2),
        );
        expect(
          Note.d.inOctave(-2).transposeBy(-Interval.M6),
          Note.f.inOctave(-3),
        );
        expect(
          Note.f.sharp.inOctave(4).transposeBy(Interval.m6),
          Note.d.inOctave(5),
        );
        expect(
          Note.f.sharp.inOctave(4).transposeBy(-Interval.m6),
          Note.a.sharp.inOctave(3),
        );
        expect(
          Note.f.sharp.inOctave(-1).transposeBy(Interval.M6),
          Note.d.sharp.inOctave(0),
        );
        expect(
          Note.f.sharp.inOctave(-1).transposeBy(-Interval.M6),
          Note.a.inOctave(-2),
        );

        expect(
          Note.c.inOctave(0).transposeBy(Interval.m7),
          Note.b.flat.inOctave(0),
        );
        expect(
          Note.c.inOctave(0).transposeBy(-Interval.m7),
          Note.d.inOctave(-1),
        );
        expect(Note.c.inOctave(4).transposeBy(Interval.M7), Note.b.inOctave(4));
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.M7),
          Note.d.flat.inOctave(3),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A7),
          Note.b.sharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.A7),
          Note.d.flat.flat.inOctave(3),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.d8),
          Note.c.flat.inOctave(5),
        );
        expect(Note.c.inOctave(4).transposeBy(Interval.P8), Note.c.inOctave(5));
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A8),
          Note.c.sharp.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.m9),
          Note.d.flat.inOctave(5),
        );
        expect(Note.c.inOctave(4).transposeBy(Interval.M9), Note.d.inOctave(5));

        expect(
          Note.c.inOctave(4).transposeBy(Interval.d11),
          Note.f.flat.inOctave(5),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.P11),
          Note.f.inOctave(5),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.A11),
          Note.f.sharp.inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.m13),
          Note.a.flat.inOctave(5),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.M13),
          Note.a.inOctave(5),
        );

        expect(
          Note.c
              .inOctave(4)
              .transposeBy(const Interval.perfect(15, PerfectQuality.perfect)),
          Note.c.inOctave(6),
        );

        expect(
          Note.c
              .inOctave(4)
              .transposeBy(const Interval.perfect(22, PerfectQuality.perfect)),
          Note.c.inOctave(7),
        );

        expect(
          Note.c
              .inOctave(4)
              .transposeBy(const Interval.perfect(29, PerfectQuality.perfect)),
          Note.c.inOctave(8),
        );
      });
    });

    group('.equalTemperamentFrequency()', () {
      test(
        'should return the Frequency of this PositionedNote from 440 Hz',
        () {
          expect(
            Note.c.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(261.63, 0.01),
          );
          expect(
            Note.c.sharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(277.18, 0.01),
          );
          expect(
            Note.d.flat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(277.18, 0.01),
          );
          expect(
            Note.d.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(293.66, 0.01),
          );
          expect(
            Note.d.sharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(311.13, 0.01),
          );
          expect(
            Note.e.flat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(311.13, 0.01),
          );
          expect(
            Note.e.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(329.63, 0.01),
          );
          expect(
            Note.f.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(349.23, 0.01),
          );
          expect(
            Note.f.sharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(369.99, 0.01),
          );
          expect(
            Note.g.flat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(369.99, 0.01),
          );
          expect(
            Note.g.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(392, 0.01),
          );
          expect(
            Note.g.sharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(415.3, 0.01),
          );
          expect(
            Note.a.flat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(415.3, 0.01),
          );
          expect(Note.a.inOctave(4).equalTemperamentFrequency().hertz, 440);
          expect(
            Note.a.sharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(466.16, 0.01),
          );
          expect(
            Note.b.flat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(466.16, 0.01),
          );
          expect(
            Note.b.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(493.88, 0.01),
          );
        },
      );

      test(
        'should return the Frequency of this PositionedNote from 438 Hz',
        () {
          const frequency = Frequency(438);
          expect(
            Note.c
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(260.44, 0.01),
          );
          expect(
            Note.c.sharp
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(275.92, 0.01),
          );
          expect(
            Note.d.flat
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(275.92, 0.01),
          );
          expect(
            Note.d
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(292.33, 0.01),
          );
          expect(
            Note.d.sharp
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(309.71, 0.01),
          );
          expect(
            Note.e.flat
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(309.71, 0.01),
          );
          expect(
            Note.e
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(328.13, 0.01),
          );
          expect(
            Note.f
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(347.64, 0.01),
          );
          expect(
            Note.f.sharp
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(368.31, 0.01),
          );
          expect(
            Note.g.flat
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(368.31, 0.01),
          );
          expect(
            Note.g
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(390.21, 0.01),
          );
          expect(
            Note.g.sharp
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(413.42, 0.01),
          );
          expect(
            Note.a.flat
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(413.42, 0.01),
          );
          expect(
            Note.a
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            438,
          );
          expect(
            Note.a.sharp
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(464.04, 0.01),
          );
          expect(
            Note.b.flat
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(464.04, 0.01),
          );
          expect(
            Note.b
                .inOctave(4)
                .equalTemperamentFrequency(frequency: frequency)
                .hertz,
            closeTo(491.64, 0.01),
          );
        },
      );

      test(
        'should return the Frequency of this PositionedNote from 256 Hz (C4)',
        () {
          const frequency = Frequency(256);
          expect(
            Note.c
                .inOctave(4)
                .equalTemperamentFrequency(
                  frequency: frequency,
                  reference: Note.c.inOctave(4),
                )
                .hertz,
            256,
          );
          expect(
            Note.a
                .inOctave(4)
                .equalTemperamentFrequency(
                  frequency: frequency,
                  reference: Note.c.inOctave(4),
                )
                .hertz,
            closeTo(430.53, 0.01),
          );
        },
      );
    });

    group('.scientificName', () {
      test(
        'should return the scientific pitch notation name for this '
        'PositionedNote',
        () {
          expect(Note.g.sharp.inOctave(-1).scientificName, 'G♯-1');
          expect(Note.d.inOctave(0).scientificName, 'D0');
          expect(Note.b.flat.inOctave(1).scientificName, 'B♭1');
          expect(Note.g.inOctave(2).scientificName, 'G2');
          expect(Note.a.inOctave(3).scientificName, 'A3');
          expect(Note.c.inOctave(4).scientificName, 'C4');
          expect(Note.c.sharp.inOctave(4).scientificName, 'C♯4');
          expect(Note.a.inOctave(4).scientificName, 'A4');
          expect(Note.f.sharp.inOctave(5).scientificName, 'F♯5');
          expect(Note.e.inOctave(7).scientificName, 'E7');
        },
      );
    });

    group('.helmholtzName', () {
      test(
        'should return the Helmholtz pitch notation name for this '
        'PositionedNote',
        () {
          expect(Note.g.sharp.inOctave(-1).helmholtzName, 'G♯͵͵͵');
          expect(Note.d.inOctave(0).helmholtzName, 'D͵͵');
          expect(Note.b.flat.inOctave(1).helmholtzName, 'B♭͵');
          expect(Note.g.inOctave(2).helmholtzName, 'G');
          expect(Note.a.inOctave(3).helmholtzName, 'a');
          expect(Note.c.inOctave(4).helmholtzName, 'c′');
          expect(Note.c.sharp.inOctave(4).helmholtzName, 'c♯′');
          expect(Note.a.inOctave(4).helmholtzName, 'a′');
          expect(Note.f.sharp.inOctave(5).helmholtzName, 'f♯′′');
          expect(Note.e.inOctave(7).helmholtzName, 'e′′′′');
        },
      );
    });

    group('.toString()', () {
      test(
        'should return the string representation of this PositionedNote',
        () {
          expect(Note.d.sharp.inOctave(0).toString(), 'D♯0');
          expect(Note.e.flat.inOctave(2).toString(), 'E♭2');
          expect(Note.a.inOctave(4).toString(), 'A4');
          expect(Note.f.sharp.inOctave(4).toString(), 'F♯4');
          expect(Note.g.inOctave(7).toString(), 'G7');
        },
      );
    });

    group('.hashCode', () {
      test('should return the same hashCode for equal PositionedNotes', () {
        expect(Note.c.inOctave(4).hashCode, Note.c.inOctave(4).hashCode);
        expect(
          const PositionedNote(Note.a, 3).hashCode,
          const PositionedNote(Note.a, 3).hashCode,
        );
      });

      test(
        'should return different hashCodes for different PositionedNotes',
        () {
          expect(
            Note.c.inOctave(4).hashCode,
            isNot(equals(Note.c.inOctave(5).hashCode)),
          );
          expect(
            const PositionedNote(Note.a, 3).hashCode,
            isNot(equals(const PositionedNote(Note.b, 3).hashCode)),
          );
          expect(
            Note.d.inOctave(6).hashCode,
            isNot(equals(Note.c.inOctave(5).hashCode)),
          );
        },
      );

      test('should ignore equal PositionedNote instances in a Set', () {
        final collection = {
          Note.c.inOctave(4),
          Note.a.flat.inOctave(2),
          Note.d.inOctave(4),
          Note.g.sharp.inOctave(5),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.c.inOctave(4),
          Note.a.flat.inOctave(2),
          Note.d.inOctave(4),
          Note.g.sharp.inOctave(5),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort PositionedNote items in a collection', () {
        final orderedSet = SplayTreeSet<PositionedNote>.of([
          Note.a.flat.inOctave(4),
          Note.b.flat.inOctave(5),
          Note.c.inOctave(4),
          Note.d.inOctave(2),
          Note.g.sharp.inOctave(4),
          Note.b.sharp.inOctave(4),
        ]);
        expect(orderedSet.toList(), [
          Note.d.inOctave(2),
          Note.c.inOctave(4),
          Note.b.sharp.inOctave(4),
          Note.g.sharp.inOctave(4),
          Note.a.flat.inOctave(4),
          Note.b.flat.inOctave(5),
        ]);
      });
    });
  });
}
