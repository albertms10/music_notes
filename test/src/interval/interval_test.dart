// To allow testing each constructor with different arguments.
// ignore_for_file: use_named_constants

import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Interval', () {
    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        const major = ImperfectQuality.major;
        final matcher = throwsA(isA<AssertionError>());

        expect(() => Interval.imperfect(const Size(-43), major), matcher);
        expect(() => Interval.perfect(const Size(-42)), matcher);
        expect(() => Interval.perfect(const Size(-41)), matcher);
        expect(() => Interval.imperfect(const Size(-40), major), matcher);
        expect(() => Interval.imperfect(const Size(-39), major), matcher);
        expect(() => Interval.perfect(const Size(-38)), matcher);
        expect(() => Interval.perfect(const Size(-37)), matcher);

        expect(() => Interval.imperfect(const Size(-36), major), matcher);
        expect(() => Interval.perfect(const Size(-35)), matcher);
        expect(() => Interval.perfect(const Size(-34)), matcher);
        expect(() => Interval.imperfect(const Size(-33), major), matcher);
        expect(() => Interval.imperfect(const Size(-32), major), matcher);
        expect(() => Interval.perfect(const Size(-31)), matcher);
        expect(() => Interval.perfect(const Size(-30)), matcher);

        expect(() => Interval.imperfect(const Size(-29), major), matcher);
        expect(() => Interval.perfect(const Size(-28)), matcher);
        expect(() => Interval.perfect(const Size(-27)), matcher);
        expect(() => Interval.imperfect(const Size(-26), major), matcher);
        expect(() => Interval.imperfect(const Size(-25), major), matcher);
        expect(() => Interval.perfect(const Size(-24)), matcher);
        expect(() => Interval.perfect(const Size(-23)), matcher);

        expect(() => Interval.imperfect(const Size(-22), major), matcher);
        expect(() => Interval.perfect(const Size(-21)), matcher);
        expect(() => Interval.perfect(const Size(-20)), matcher);
        expect(() => Interval.imperfect(const Size(-19), major), matcher);
        expect(() => Interval.imperfect(const Size(-18), major), matcher);
        expect(() => Interval.perfect(const Size(-17)), matcher);
        expect(() => Interval.perfect(const Size(-16)), matcher);

        expect(() => Interval.imperfect(const Size(-15), major), matcher);
        expect(() => Interval.perfect(const Size(-14)), matcher);
        expect(() => Interval.perfect(-Size.thirteenth), matcher);
        expect(() => Interval.imperfect(-Size.twelfth, major), matcher);
        expect(() => Interval.imperfect(-Size.eleventh, major), matcher);
        expect(() => Interval.perfect(-Size.tenth), matcher);
        expect(() => Interval.perfect(-Size.ninth), matcher);

        expect(() => Interval.imperfect(-Size.octave, major), matcher);
        expect(() => Interval.perfect(-Size.seventh), matcher);
        expect(() => Interval.perfect(-Size.sixth), matcher);
        expect(() => Interval.imperfect(-Size.fifth, major), matcher);
        expect(() => Interval.imperfect(-Size.fourth, major), matcher);
        expect(() => Interval.perfect(-Size.third), matcher);
        expect(() => Interval.perfect(-Size.second), matcher);
        expect(() => Interval.imperfect(-Size.unison, major), matcher);

        expect(() => Interval.imperfect(Size.unison, major), matcher);
        expect(() => Interval.perfect(Size.second), matcher);
        expect(() => Interval.perfect(Size.third), matcher);
        expect(() => Interval.imperfect(Size.fourth, major), matcher);
        expect(() => Interval.imperfect(Size.fifth, major), matcher);
        expect(() => Interval.perfect(Size.sixth), matcher);
        expect(() => Interval.perfect(Size.seventh), matcher);
        expect(() => Interval.imperfect(Size.octave, major), matcher);

        expect(() => Interval.perfect(Size.ninth), matcher);
        expect(() => Interval.perfect(Size.tenth), matcher);
        expect(() => Interval.imperfect(Size.eleventh, major), matcher);
        expect(() => Interval.imperfect(Size.twelfth, major), matcher);
        expect(() => Interval.perfect(Size.thirteenth), matcher);
        expect(() => Interval.perfect(const Size(14)), matcher);
        expect(() => Interval.imperfect(const Size(15), major), matcher);

        expect(() => Interval.perfect(const Size(16)), matcher);
        expect(() => Interval.perfect(const Size(17)), matcher);
        expect(() => Interval.imperfect(const Size(18), major), matcher);
        expect(() => Interval.imperfect(const Size(19), major), matcher);
        expect(() => Interval.perfect(const Size(20)), matcher);
        expect(() => Interval.perfect(const Size(21)), matcher);
        expect(() => Interval.imperfect(const Size(22), major), matcher);

        expect(() => Interval.perfect(const Size(23)), matcher);
        expect(() => Interval.perfect(const Size(24)), matcher);
        expect(() => Interval.imperfect(const Size(25), major), matcher);
        expect(() => Interval.imperfect(const Size(26), major), matcher);
        expect(() => Interval.perfect(const Size(27)), matcher);
        expect(() => Interval.perfect(const Size(28)), matcher);
        expect(() => Interval.imperfect(const Size(29), major), matcher);

        expect(() => Interval.perfect(const Size(30)), matcher);
        expect(() => Interval.perfect(const Size(31)), matcher);
        expect(() => Interval.imperfect(const Size(32), major), matcher);
        expect(() => Interval.imperfect(const Size(33), major), matcher);
        expect(() => Interval.perfect(const Size(34)), matcher);
        expect(() => Interval.perfect(const Size(35)), matcher);
        expect(() => Interval.imperfect(const Size(36), major), matcher);

        expect(() => Interval.perfect(const Size(37)), matcher);
        expect(() => Interval.perfect(const Size(38)), matcher);
        expect(() => Interval.imperfect(const Size(39), major), matcher);
        expect(() => Interval.imperfect(const Size(40), major), matcher);
        expect(() => Interval.perfect(const Size(41)), matcher);
        expect(() => Interval.perfect(const Size(42)), matcher);
        expect(() => Interval.imperfect(const Size(43), major), matcher);
      });

      test('creates a new Interval from size and quality', () {
        const major = ImperfectQuality.major;
        final matcher = isA<Interval>();

        expect(const Interval.perfect(Size(-43)), matcher);
        expect(const Interval.imperfect(Size(-42), major), matcher);
        expect(const Interval.imperfect(Size(-41), major), matcher);
        expect(const Interval.perfect(Size(-40)), matcher);
        expect(const Interval.perfect(Size(-39)), matcher);
        expect(const Interval.imperfect(Size(-38), major), matcher);
        expect(const Interval.imperfect(Size(-37), major), matcher);

        expect(const Interval.perfect(Size(-36)), matcher);
        expect(const Interval.imperfect(Size(-35), major), matcher);
        expect(const Interval.imperfect(Size(-34), major), matcher);
        expect(const Interval.perfect(Size(-33)), matcher);
        expect(const Interval.perfect(Size(-32)), matcher);
        expect(const Interval.imperfect(Size(-31), major), matcher);
        expect(const Interval.imperfect(Size(-30), major), matcher);

        expect(const Interval.perfect(Size(-29)), matcher);
        expect(const Interval.imperfect(Size(-28), major), matcher);
        expect(const Interval.imperfect(Size(-27), major), matcher);
        expect(const Interval.perfect(Size(-26)), matcher);
        expect(const Interval.perfect(Size(-25)), matcher);
        expect(const Interval.imperfect(Size(-24), major), matcher);
        expect(const Interval.imperfect(Size(-23), major), matcher);

        expect(const Interval.perfect(Size(-22)), matcher);
        expect(const Interval.imperfect(Size(-21), major), matcher);
        expect(const Interval.imperfect(Size(-20), major), matcher);
        expect(const Interval.perfect(Size(-19)), matcher);
        expect(const Interval.perfect(Size(-18)), matcher);
        expect(const Interval.imperfect(Size(-17), major), matcher);
        expect(const Interval.imperfect(Size(-16), major), matcher);

        expect(const Interval.perfect(Size(-15)), matcher);
        expect(const Interval.imperfect(Size(-14), major), matcher);
        expect(Interval.imperfect(-Size.thirteenth, major), matcher);
        expect(Interval.perfect(-Size.twelfth), matcher);
        expect(Interval.perfect(-Size.eleventh), matcher);
        expect(Interval.imperfect(-Size.tenth, major), matcher);
        expect(Interval.imperfect(-Size.ninth, major), matcher);

        expect(Interval.perfect(-Size.octave), matcher);
        expect(Interval.imperfect(-Size.seventh, major), matcher);
        expect(Interval.imperfect(-Size.sixth, major), matcher);
        expect(Interval.perfect(-Size.fifth), matcher);
        expect(Interval.perfect(-Size.fourth), matcher);
        expect(Interval.imperfect(-Size.third, major), matcher);
        expect(Interval.imperfect(-Size.second, major), matcher);
        expect(Interval.perfect(-Size.unison), matcher);

        expect(const Interval.perfect(Size.unison), matcher);
        expect(const Interval.imperfect(Size.second, major), matcher);
        expect(const Interval.imperfect(Size.third, major), matcher);
        expect(const Interval.perfect(Size.fourth), matcher);
        expect(const Interval.perfect(Size.fifth), matcher);
        expect(const Interval.imperfect(Size.sixth, major), matcher);
        expect(const Interval.imperfect(Size.seventh, major), matcher);
        expect(const Interval.perfect(Size.octave), matcher);

        expect(const Interval.imperfect(Size.ninth, major), matcher);
        expect(const Interval.imperfect(Size.tenth, major), matcher);
        expect(const Interval.perfect(Size.eleventh), matcher);
        expect(const Interval.perfect(Size.twelfth), matcher);
        expect(
          const Interval.imperfect(Size.thirteenth, major),
          matcher,
        );
        expect(const Interval.imperfect(Size(14), major), matcher);
        expect(const Interval.perfect(Size(15)), matcher);

        expect(const Interval.imperfect(Size(16), major), matcher);
        expect(const Interval.imperfect(Size(17), major), matcher);
        expect(const Interval.perfect(Size(18)), matcher);
        expect(const Interval.perfect(Size(19)), matcher);
        expect(const Interval.imperfect(Size(20), major), matcher);
        expect(const Interval.imperfect(Size(21), major), matcher);
        expect(const Interval.perfect(Size(22)), matcher);

        expect(const Interval.imperfect(Size(23), major), matcher);
        expect(const Interval.imperfect(Size(24), major), matcher);
        expect(const Interval.perfect(Size(25)), matcher);
        expect(const Interval.perfect(Size(26)), matcher);
        expect(const Interval.imperfect(Size(27), major), matcher);
        expect(const Interval.imperfect(Size(28), major), matcher);
        expect(const Interval.perfect(Size(29)), matcher);

        expect(const Interval.imperfect(Size(30), major), matcher);
        expect(const Interval.imperfect(Size(31), major), matcher);
        expect(const Interval.perfect(Size(32)), matcher);
        expect(const Interval.perfect(Size(33)), matcher);
        expect(const Interval.imperfect(Size(34), major), matcher);
        expect(const Interval.imperfect(Size(35), major), matcher);
        expect(const Interval.perfect(Size(36)), matcher);

        expect(const Interval.imperfect(Size(37), major), matcher);
        expect(const Interval.imperfect(Size(38), major), matcher);
        expect(const Interval.perfect(Size(39)), matcher);
        expect(const Interval.perfect(Size(40)), matcher);
        expect(const Interval.imperfect(Size(41), major), matcher);
        expect(const Interval.imperfect(Size(42), major), matcher);
        expect(const Interval.perfect(Size(43)), matcher);
      });
    });

    group('.fromSizeAndSemitones()', () {
      test('creates a new Interval from size and semitones', () {
        expect(Interval.fromSizeAndSemitones(Size.unison, -1), Interval.d1);
        expect(Interval.fromSizeAndSemitones(-Size.unison, 1), -Interval.d1);
        expect(Interval.fromSizeAndSemitones(Size.unison, 0), Interval.P1);
        expect(Interval.fromSizeAndSemitones(-Size.unison, 0), -Interval.P1);
        expect(Interval.fromSizeAndSemitones(Size.unison, 1), Interval.A1);
        expect(Interval.fromSizeAndSemitones(-Size.unison, -1), -Interval.A1);

        expect(Interval.fromSizeAndSemitones(Size.second, 0), Interval.d2);
        expect(Interval.fromSizeAndSemitones(-Size.second, 0), -Interval.d2);
        expect(Interval.fromSizeAndSemitones(Size.second, 1), Interval.m2);
        expect(Interval.fromSizeAndSemitones(-Size.second, -1), -Interval.m2);
        expect(Interval.fromSizeAndSemitones(Size.second, 2), Interval.M2);
        expect(Interval.fromSizeAndSemitones(-Size.second, -2), -Interval.M2);
        expect(Interval.fromSizeAndSemitones(Size.second, 3), Interval.A2);
        expect(Interval.fromSizeAndSemitones(-Size.second, -3), -Interval.A2);

        expect(Interval.fromSizeAndSemitones(Size.third, 2), Interval.d3);
        expect(Interval.fromSizeAndSemitones(-Size.third, -2), -Interval.d3);
        expect(Interval.fromSizeAndSemitones(Size.third, 3), Interval.m3);
        expect(Interval.fromSizeAndSemitones(-Size.third, -3), -Interval.m3);
        expect(Interval.fromSizeAndSemitones(Size.third, 4), Interval.M3);
        expect(Interval.fromSizeAndSemitones(-Size.third, -4), -Interval.M3);
        expect(Interval.fromSizeAndSemitones(Size.third, 5), Interval.A3);
        expect(Interval.fromSizeAndSemitones(-Size.third, -5), -Interval.A3);

        expect(Interval.fromSizeAndSemitones(Size.fourth, 4), Interval.d4);
        expect(Interval.fromSizeAndSemitones(-Size.fourth, -4), -Interval.d4);
        expect(Interval.fromSizeAndSemitones(Size.fourth, 5), Interval.P4);
        expect(Interval.fromSizeAndSemitones(-Size.fourth, -5), -Interval.P4);
        expect(Interval.fromSizeAndSemitones(Size.fourth, 6), Interval.A4);
        expect(Interval.fromSizeAndSemitones(-Size.fourth, -6), -Interval.A4);

        expect(Interval.fromSizeAndSemitones(Size.fifth, 6), Interval.d5);
        expect(Interval.fromSizeAndSemitones(-Size.fifth, -6), -Interval.d5);
        expect(Interval.fromSizeAndSemitones(Size.fifth, 7), Interval.P5);
        expect(Interval.fromSizeAndSemitones(-Size.fifth, -7), -Interval.P5);
        expect(Interval.fromSizeAndSemitones(Size.fifth, 8), Interval.A5);
        expect(Interval.fromSizeAndSemitones(-Size.fifth, -8), -Interval.A5);

        expect(Interval.fromSizeAndSemitones(Size.sixth, 8), Interval.m6);
        expect(Interval.fromSizeAndSemitones(-Size.sixth, -8), -Interval.m6);
        expect(Interval.fromSizeAndSemitones(Size.sixth, 9), Interval.M6);
        expect(Interval.fromSizeAndSemitones(-Size.sixth, -9), -Interval.M6);

        expect(Interval.fromSizeAndSemitones(Size.seventh, 10), Interval.m7);
        expect(Interval.fromSizeAndSemitones(-Size.seventh, -10), -Interval.m7);
        expect(Interval.fromSizeAndSemitones(Size.seventh, 11), Interval.M7);
        expect(Interval.fromSizeAndSemitones(-Size.seventh, -11), -Interval.M7);

        expect(Interval.fromSizeAndSemitones(Size.octave, 11), Interval.d8);
        expect(Interval.fromSizeAndSemitones(-Size.octave, -11), -Interval.d8);
        expect(Interval.fromSizeAndSemitones(Size.octave, 12), Interval.P8);
        expect(Interval.fromSizeAndSemitones(-Size.octave, -12), -Interval.P8);
        expect(Interval.fromSizeAndSemitones(Size.octave, 13), Interval.A8);
        expect(Interval.fromSizeAndSemitones(-Size.octave, -13), -Interval.A8);
      });
    });

    group('.fromSemitones()', () {
      test('creates a new Interval from semitones', () {
        expect(Interval.fromSemitones(0), Interval.P1);
        expect(Interval.fromSemitones(2), Interval.M2);
        expect(Interval.fromSemitones(-2), -Interval.M2);
        expect(Interval.fromSemitones(3), Interval.m3);
        expect(Interval.fromSemitones(-3), -Interval.m3);
        expect(Interval.fromSemitones(5), Interval.P4);
        expect(Interval.fromSemitones(20), Interval.m13);
        expect(Interval.fromSemitones(-20), -Interval.m13);
      });
    });

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Interval.parse('x'), throwsFormatException);
        expect(() => Interval.parse('x4'), throwsFormatException);
        expect(() => Interval.parse('x6'), throwsFormatException);
        expect(() => Interval.parse('M+6'), throwsFormatException);
        expect(() => Interval.parse('P--6'), throwsFormatException);
        expect(() => Interval.parse('P6'), throwsFormatException);
        expect(() => Interval.parse('m4'), throwsFormatException);
        expect(() => Interval.parse('p5'), throwsFormatException);
        expect(() => Interval.parse('a2'), throwsFormatException);
        expect(() => Interval.parse('D3'), throwsFormatException);
      });

      test('parses source as an Interval', () {
        expect(
          Interval.parse('AA4'),
          const Interval.perfect(Size.fourth, PerfectQuality.doublyAugmented),
        );
        expect(Interval.parse('A5'), Interval.A5);
        expect(Interval.parse('A-1'), -Interval.A1);
        expect(Interval.parse('P1'), Interval.P1);
        expect(Interval.parse('P22'), const Interval.perfect(Size(22)));
        expect(Interval.parse('d5'), Interval.d5);
        expect(Interval.parse('d-5'), -Interval.d5);
        expect(
          Interval.parse('dd8'),
          const Interval.perfect(Size.octave, PerfectQuality.doublyDiminished),
        );
        expect(
          Interval.parse('dd-8'),
          -const Interval.perfect(Size.octave, PerfectQuality.doublyDiminished),
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
        expect(Interval.parse('M-3'), -Interval.M3);
        expect(Interval.parse('M16'), const ImperfectSize(16).major);
        expect(Interval.parse('m2'), Interval.m2);
        expect(Interval.parse('m-2'), -Interval.m2);
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

    group('.semitones', () {
      test('returns the number of semitones of this Interval', () {
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

        expect(const Interval.perfect(Size(15)).semitones, 24);
        expect(const Interval.perfect(Size(22)).semitones, 36);
        expect(const Interval.perfect(Size(29)).semitones, 48);
      });
    });

    group('.isDescending', () {
      test('returns whether this Interval is descending', () {
        expect(Interval.m3.isDescending, isFalse);
        expect((-Interval.P5).isDescending, isTrue);
        expect(Interval.d1.isDescending, isFalse);
        expect(Interval.M9.isDescending, isFalse);
        expect(
          const Interval.perfect(Size(-4), PerfectQuality.doublyAugmented)
              .isDescending,
          isTrue,
        );
      });
    });

    group('.descending()', () {
      test('returns the descending Interval based on isDescending', () {
        expect(Interval.M2.descending(), -Interval.M2);
        expect(Interval.m3.descending(false), Interval.m3);
        expect((-Interval.m6).descending(false), Interval.m6);
        expect((-Interval.P8).descending(), -Interval.P8);
      });

      test('returns a copy of this Interval based on isDescending', () {
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
      });
    });

    group('.inversion', () {
      test('returns the inversion of this Interval', () {
        expect((-Interval.M13).inversion, -Interval.m3);
        expect((-Interval.m13).inversion, -Interval.M3);
        expect((-Interval.P11).inversion, -Interval.P5);
        expect((-Interval.M9).inversion, -Interval.m7);
        expect((-Interval.m9).inversion, -Interval.M7);
        expect((-Interval.A8).inversion, -Interval.d1);
        expect((-Interval.P8).inversion, -Interval.P1);
        expect((-Interval.d8).inversion, -Interval.A1);
        expect((-Interval.M7).inversion, -Interval.m2);
        expect((-Interval.m7).inversion, -Interval.M2);
        expect((-Interval.M6).inversion, -Interval.m3);
        expect((-Interval.m6).inversion, -Interval.M3);
        expect((-Interval.A5).inversion, -Interval.d4);
        expect((-Interval.d5).inversion, -Interval.A4);
        expect((-Interval.A4).inversion, -Interval.d5);
        expect((-Interval.d4).inversion, -Interval.A5);
        expect((-Interval.M3).inversion, -Interval.m6);
        expect((-Interval.m3).inversion, -Interval.M6);
        expect((-Interval.M2).inversion, -Interval.m7);
        expect((-Interval.m2).inversion, -Interval.M7);
        expect((-Interval.A1).inversion, -Interval.d8);
        expect((-Interval.P1).inversion, -Interval.P8);
        expect((-Interval.d1).inversion, -Interval.A8);
        expect(Interval.d1.inversion, Interval.A8);
        expect(Interval.P1.inversion, Interval.P8);
        expect(Interval.A1.inversion, Interval.d8);
        expect(Interval.m2.inversion, Interval.M7);
        expect(Interval.M2.inversion, Interval.m7);
        expect(Interval.m3.inversion, Interval.M6);
        expect(Interval.M3.inversion, Interval.m6);
        expect(Interval.d4.inversion, Interval.A5);
        expect(Interval.A4.inversion, Interval.d5);
        expect(Interval.d5.inversion, Interval.A4);
        expect(Interval.A5.inversion, Interval.d4);
        expect(Interval.m6.inversion, Interval.M3);
        expect(Interval.M6.inversion, Interval.m3);
        expect(Interval.m7.inversion, Interval.M2);
        expect(Interval.M7.inversion, Interval.m2);
        expect(Interval.d8.inversion, Interval.A1);
        expect(Interval.P8.inversion, Interval.P1);
        expect(Interval.A8.inversion, Interval.d1);
        expect(Interval.m9.inversion, Interval.M7);
        expect(Interval.M9.inversion, Interval.m7);
        expect(Interval.P11.inversion, Interval.P5);
        expect(Interval.m13.inversion, Interval.M3);
        expect(Interval.M13.inversion, Interval.m3);
      });
    });

    group('.simple', () {
      test('returns the simplified version of this Interval', () {
        expect(const Interval.perfect(Size(-22)).simple, -Interval.P8);
        expect(const Interval.perfect(Size(-15)).simple, -Interval.P8);
        expect((-Interval.M13).simple, -Interval.M6);
        expect((-Interval.P11).simple, -Interval.P4);
        expect((-Interval.m9).simple, -Interval.m2);
        expect((-Interval.A8).simple, -Interval.A8);
        expect((-Interval.P8).simple, -Interval.P8);
        expect((-Interval.M3).simple, -Interval.M3);
        expect((-Interval.P1).simple, -Interval.P1);
        expect(Interval.P1.simple, Interval.P1);
        expect(Interval.M3.simple, Interval.M3);
        expect(Interval.P8.simple, Interval.P8);
        expect(Interval.A8.simple, Interval.A8);
        expect(Interval.m9.simple, Interval.m2);
        expect(Interval.P11.simple, Interval.P4);
        expect(Interval.M13.simple, Interval.M6);
        expect(const Interval.perfect(Size(15)).simple, Interval.P8);
        expect(const Interval.perfect(Size(22)).simple, Interval.P8);
      });
    });

    group('.isCompound', () {
      test('returns whether this Interval is compound', () {
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
      test('returns whether this Interval is dissonant', () {
        expect((-Interval.A8).isDissonant, isTrue);
        expect((-Interval.P8).isDissonant, isFalse);
        expect((-Interval.d8).isDissonant, isTrue);
        expect((-Interval.A7).isDissonant, isTrue);
        expect((-Interval.M7).isDissonant, isTrue);
        expect((-Interval.m7).isDissonant, isTrue);
        expect((-Interval.d7).isDissonant, isTrue);
        expect((-Interval.A6).isDissonant, isTrue);
        expect((-Interval.M6).isDissonant, isFalse);
        expect((-Interval.m6).isDissonant, isFalse);
        expect((-Interval.d6).isDissonant, isTrue);
        expect((-Interval.A5).isDissonant, isTrue);
        expect((-Interval.P5).isDissonant, isFalse);
        expect((-Interval.d5).isDissonant, isTrue);
        expect((-Interval.A4).isDissonant, isTrue);
        expect((-Interval.P4).isDissonant, isFalse);
        expect((-Interval.d4).isDissonant, isTrue);
        expect((-Interval.A3).isDissonant, isTrue);
        expect((-Interval.M3).isDissonant, isFalse);
        expect((-Interval.m3).isDissonant, isFalse);
        expect((-Interval.d3).isDissonant, isTrue);
        expect((-Interval.A2).isDissonant, isTrue);
        expect((-Interval.M2).isDissonant, isTrue);
        expect((-Interval.m2).isDissonant, isTrue);
        expect((-Interval.d2).isDissonant, isTrue);
        expect((-Interval.P1).isDissonant, isFalse);
        expect(Interval.d1.isDissonant, isTrue);
        expect(Interval.P1.isDissonant, isFalse);
        expect(Interval.A1.isDissonant, isTrue);
        expect(Interval.d2.isDissonant, isTrue);
        expect(Interval.m2.isDissonant, isTrue);
        expect(Interval.M2.isDissonant, isTrue);
        expect(Interval.A2.isDissonant, isTrue);
        expect(Interval.d3.isDissonant, isTrue);
        expect(Interval.m3.isDissonant, isFalse);
        expect(Interval.M3.isDissonant, isFalse);
        expect(Interval.A3.isDissonant, isTrue);
        expect(Interval.d4.isDissonant, isTrue);
        expect(Interval.P4.isDissonant, isFalse);
        expect(Interval.A4.isDissonant, isTrue);
        expect(Interval.d5.isDissonant, isTrue);
        expect(Interval.P5.isDissonant, isFalse);
        expect(Interval.A5.isDissonant, isTrue);
        expect(Interval.d6.isDissonant, isTrue);
        expect(Interval.m6.isDissonant, isFalse);
        expect(Interval.M6.isDissonant, isFalse);
        expect(Interval.A6.isDissonant, isTrue);
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
      test('returns this Interval respelled by size', () {
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
          Interval.perfect(-Size.fifth, PerfectQuality.doublyDiminished),
        );
      });
    });

    group('.respelledUpwards', () {
      test('returns this Interval respelled upwards', () {
        expect(Interval.A4.respelledUpwards, Interval.d5);
        expect(
          Interval.d5.respelledUpwards,
          const Interval.imperfect(
            Size.sixth,
            ImperfectQuality.doublyDiminished,
          ),
        );
        expect(Interval.M2.respelledUpwards, Interval.d3);
        expect(Interval.M3.respelledUpwards, Interval.d4);
        expect(Interval.P1.respelledUpwards, Interval.d2);
        expect(
          Interval.m2.respelledUpwards,
          const Interval.imperfect(
            Size.third,
            ImperfectQuality.doublyDiminished,
          ),
        );

        expect((-Interval.M3).respelledUpwards, -Interval.d4);
        expect(
          (-Interval.d5).respelledUpwards,
          Interval.imperfect(-Size.sixth, ImperfectQuality.doublyDiminished),
        );
        expect(
          (-Interval.P4).respelledUpwards,
          Interval.perfect(-Size.fifth, PerfectQuality.doublyDiminished),
        );
      });
    });

    group('.respelledDownwards', () {
      test('throws an assertion error when the operation is invalid', () {
        expect(
          () => Interval.P1.respelledDownwards,
          throwsA(isA<AssertionError>()),
        );
      });

      test('returns this Interval respelled downwards', () {
        expect(
          Interval.A4.respelledDownwards,
          const Interval.imperfect(
            Size.third,
            ImperfectQuality.doublyAugmented,
          ),
        );
        expect(Interval.d5.respelledDownwards, Interval.A4);
        expect(
          Interval.M2.respelledDownwards,
          const Interval.perfect(
            Size.unison,
            PerfectQuality.doublyAugmented,
          ),
        );
        expect(
          Interval.M3.respelledDownwards,
          const Interval.imperfect(
            Size.second,
            ImperfectQuality.doublyAugmented,
          ),
        );
        expect(Interval.m2.respelledDownwards, Interval.A1);

        expect(
          (-Interval.M3).respelledDownwards,
          Interval.imperfect(-Size.second, ImperfectQuality.doublyAugmented),
        );
        expect((-Interval.d5).respelledDownwards, -Interval.A4);
        expect((-Interval.P4).respelledDownwards, -Interval.A3);
      });
    });

    group('.respelledSimple', () {
      test('returns the simplest spelling for this Interval', () {
        expect(Interval.M2.respelledSimple, Interval.M2);
        expect(Interval.A4.respelledSimple, Interval.A4);
        expect(Interval.d5.respelledSimple, Interval.A4);
        expect(
          const Interval.imperfect(Size.sixth, ImperfectQuality.triplyAugmented)
              .respelledSimple,
          Interval.P8,
        );
        expect(
          const Interval.perfect(Size.fifth, PerfectQuality.triplyDiminished)
              .respelledSimple,
          Interval.M3,
        );

        expect((-Interval.P1).respelledSimple, Interval.P1);
        expect((-Interval.A4).respelledSimple, -Interval.A4);
        expect((-Interval.d5).respelledSimple, -Interval.A4);
        expect(
          Interval.imperfect(-Size.seventh, const ImperfectQuality(-4))
              .respelledSimple,
          -Interval.A4,
        );
        expect(
          Interval.perfect(-Size.fourth, PerfectQuality.doublyAugmented)
              .respelledSimple,
          -Interval.P5,
        );
      });
    });

    group('.circleDistance()', () {
      test('returns the circle distance between two Scalable instances', () {
        var (distance, notes: dynamic notes) =
            Interval.P5.circleDistance(from: Note.c, to: Note.b.flat.flat);
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

        (distance, :notes) =
            Interval.P5.circleDistance(from: Note.c, to: Note.b.flat);
        expect(distance, -2);
        expect(notes, [Note.c, Note.f, Note.b.flat]);

        (distance, :notes) = Interval.P5
            .circleDistance(from: PitchClass.d, to: PitchClass.gSharp);
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
            Interval.P5.circleDistance(from: Note.c, to: Note.f.sharp.sharp);
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

        (distance, :notes) = Interval.P4
            .circleDistance(from: PitchClass.dSharp, to: PitchClass.c);
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

        (distance, :notes) =
            Interval.P4.circleDistance(from: Note.c, to: Note.c);
        expect(distance, 0);
        expect(notes, const [Note.c]);

        (distance, :notes) =
            Interval.P4.circleDistance(from: Note.c, to: Note.f);
        expect(distance, 1);
        expect(notes, const [Note.c, Note.f]);

        (distance, :notes) = Interval.P4
            .circleDistance(from: PitchClass.c, to: PitchClass.aSharp);
        expect(distance, 2);
        expect(notes, const [PitchClass.c, PitchClass.f, PitchClass.aSharp]);
      });
    });

    group('.circleFrom()', () {
      test('returns the circle of this Interval', () {
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
      test('creates a new IntervalClass from semitones', () {
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
      test('adds other to this Interval', () {
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
      test('returns the negation of this Interval', () {
        expect(-Interval.M2, -Size.second.major);
        expect(-const ImperfectSize(-6).minor, Interval.m6);
      });
    });

    group('operator <()', () {
      test('returns whether this Interval is smaller than other', () {
        expect(Interval.m2 < Interval.M3, isTrue);
        expect(-Interval.m6 < Interval.d5, isTrue);
        expect(Interval.A4 < Interval.d5, isTrue);

        expect(Interval.m3 < Interval.m2, isFalse);
        expect(Interval.P4 < Interval.P4, isFalse);
        expect(Interval.M2 < -Interval.P5, isFalse);
      });
    });

    group('operator <=()', () {
      test(
        'returns whether this Interval is smaller than or equal to other',
        () {
          expect(Interval.P1 <= Interval.M3, isTrue);
          expect(Interval.d8 <= Interval.d8, isTrue);
          expect(-Interval.m6 <= Interval.d5, isTrue);
          expect(-Interval.A4 <= Interval.d5, isTrue);

          expect(Interval.m3 <= Interval.m2, isFalse);
          expect(Interval.m2 <= -Interval.A4, isFalse);
        },
      );
    });

    group('operator >()', () {
      test('returns whether this Interval is larger than other', () {
        expect(Interval.M3 > Interval.m2, isTrue);
        expect(Interval.A5 > -Interval.m6, isTrue);
        expect(Interval.d8 > Interval.M7, isTrue);

        expect(Interval.m2 > Interval.m3, isFalse);
        expect(Interval.P4 > Interval.P4, isFalse);
        expect(-Interval.P5 > Interval.M2, isFalse);
      });
    });

    group('operator >=()', () {
      test(
        'returns whether this Interval is larger than or equal to other',
        () {
          expect(Interval.M3 >= Interval.m2, isTrue);
          expect(Interval.P4 >= Interval.P4, isTrue);
          expect(Interval.d8 >= Interval.m7, isTrue);
          expect(Interval.A5 >= -Interval.m6, isTrue);

          expect(Interval.m2 >= Interval.m3, isFalse);
          expect(-Interval.A1 >= Interval.m3, isFalse);
          expect(-Interval.P5 >= Interval.M2, isFalse);
        },
      );
    });

    group('.toString()', () {
      test('returns the string representation of this Interval', () {
        expect(Interval.M2.toString(), 'M2');
        expect((-Interval.m3).toString(), 'm-3');
        expect(Interval.A4.toString(), 'A4');
        expect((-Interval.P5).toString(), 'P-5');
        expect(Interval.d7.toString(), 'd7');
        expect((-Interval.d8).toString(), 'd-8');
        expect(Interval.M9.toString(), 'M9 (M2)');
        expect((-Size.tenth).minor.toString(), 'm-10 (m-3)');
        expect(Interval.A11.toString(), 'A11 (A4)');
        expect(const ImperfectSize(-14).major.toString(), 'M-14 (M-7)');
        expect(const Interval.perfect(Size(15)).toString(), 'P15 (P8)');
        expect(const Size(-16).diminished.toString(), 'd-16 (d-2)');
        expect(const Interval.perfect(Size(22)).toString(), 'P22 (P8)');

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
      test('ignores equal Interval instances in a Set', () {
        final collection = {Interval.M2, Interval.d3, Interval.P4};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [Interval.M2, Interval.d3, Interval.P4],
        );
      });
    });

    group('.compareTo()', () {
      test('sorts Intervals in a collection', () {
        final orderedSet = SplayTreeSet<Interval>.of({
          Interval.m2,
          Interval.P8,
          Interval.d3,
          Interval.P1,
          Interval.A1,
        });
        expect(orderedSet.toList(), const [
          Interval.P1,
          Interval.A1,
          Interval.m2,
          Interval.d3,
          Interval.P8,
        ]);
      });
    });
  });
}
