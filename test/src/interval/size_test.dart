import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Size', () {
    group('constructor', () {
      test('creates a different Size.unison ascending and descending', () {
        expect(Size.unison, isNot(-Size.unison));
      });
    });

    group('.fromSemitones()', () {
      test('returns the Size corresponding to the given semitones', () {
        expect(Size.fromSemitones(-12), -Size.octave);
        expect(Size.fromSemitones(-5), -Size.fourth);
        expect(Size.fromSemitones(-3), -Size.third);
        expect(Size.fromSemitones(-1), -Size.second);
        expect(Size.fromSemitones(0), Size.unison);
        expect(Size.fromSemitones(1), Size.second);
        expect(Size.fromSemitones(3), Size.third);
        expect(Size.fromSemitones(5), Size.fourth);
        expect(Size.fromSemitones(7), Size.fifth);
        expect(Size.fromSemitones(8), Size.sixth);
        expect(Size.fromSemitones(10), Size.seventh);
        expect(Size.fromSemitones(12), Size.octave);
        expect(Size.fromSemitones(13), Size.ninth);
        expect(Size.fromSemitones(15), Size.tenth);
        expect(Size.fromSemitones(17), Size.eleventh);
        expect(Size.fromSemitones(19), Size.twelfth);
        expect(Size.fromSemitones(20), Size.thirteenth);
        expect(Size.fromSemitones(22), const Size(14));
        expect(Size.fromSemitones(24), const Size(15));
        expect(Size.fromSemitones(36), const Size(22));
        expect(Size.fromSemitones(48), const Size(29));
      });

      test('returns null when no Size corresponds to the given semitones', () {
        expect(Size.fromSemitones(-4), isNull);
        expect(Size.fromSemitones(-2), isNull);
        expect(Size.fromSemitones(2), isNull);
        expect(Size.fromSemitones(4), isNull);
        expect(Size.fromSemitones(6), isNull);
        expect(Size.fromSemitones(9), isNull);
        expect(Size.fromSemitones(11), isNull);
      });
    });

    group('.perfect', () {
      test('returns the perfect Interval from this Size', () {
        expect(Size.unison.perfect, Interval.P1);
        expect(Size.fourth.perfect, Interval.P4);
        expect((-Size.fifth).perfect, -Interval.P5);
        expect(Size.twelfth.simple.perfect, Interval.P5);
      });
    });

    group('.major', () {
      test('returns the major Interval from this Size', () {
        expect(Size.second.major, Interval.M2);
        expect(Size.sixth.major, Interval.M6);
        expect((-Size.ninth).major, -Interval.M9);
        expect(Size.thirteenth.simple.major, Interval.M6);
      });
    });

    group('.minor', () {
      test('returns the minor Interval from this Size', () {
        expect(Size.third.minor, Interval.m3);
        expect(Size.seventh.minor, Interval.m7);
        expect((-Size.sixth).minor, -Interval.m6);
        expect(Size.ninth.simple.minor, Interval.m2);
      });
    });

    group('.diminished', () {
      test('returns the diminished Interval from this Size', () {
        expect(Size.second.diminished, Interval.d2);
        expect(Size.fifth.diminished, Interval.d5);
        expect((-Size.seventh).diminished, -Interval.d7);
        expect(Size.eleventh.simple.diminished, Interval.d4);
      });
    });

    group('.augmented', () {
      test('returns the augmented Interval from this Size', () {
        expect(Size.third.augmented, Interval.A3);
        expect(Size.fourth.augmented, Interval.A4);
        expect((-Size.sixth).augmented, -Interval.A6);
        expect(Size.twelfth.simple.augmented, Interval.A5);
      });
    });
  });
}
