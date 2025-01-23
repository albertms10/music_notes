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

    group('.nearestFromSemitones()', () {
      test('returns the Size corresponding exactly to the given semitones', () {
        expect(Size.nearestFromSemitones(-12), -Size.octave);
        expect(Size.nearestFromSemitones(-5), -Size.fourth);
        expect(Size.nearestFromSemitones(-3), -Size.third);
        expect(Size.nearestFromSemitones(-1), -Size.second);
        expect(Size.nearestFromSemitones(0), Size.unison);
        expect(Size.nearestFromSemitones(1), Size.second);
        expect(Size.nearestFromSemitones(3), Size.third);
        expect(Size.nearestFromSemitones(5), Size.fourth);
        expect(Size.nearestFromSemitones(7), Size.fifth);
        expect(Size.nearestFromSemitones(8), Size.sixth);
        expect(Size.nearestFromSemitones(10), Size.seventh);
        expect(Size.nearestFromSemitones(12), Size.octave);
        expect(Size.nearestFromSemitones(13), Size.ninth);
        expect(Size.nearestFromSemitones(15), Size.tenth);
        expect(Size.nearestFromSemitones(17), Size.eleventh);
        expect(Size.nearestFromSemitones(19), Size.twelfth);
        expect(Size.nearestFromSemitones(20), Size.thirteenth);
        expect(Size.nearestFromSemitones(22), const Size(14));
        expect(Size.nearestFromSemitones(24), const Size(15));
        expect(Size.nearestFromSemitones(36), const Size(22));
        expect(Size.nearestFromSemitones(48), const Size(29));
      });

      test(
        'returns the nearest Size when no Size'
        ' corresponds exactly to the given semitones',
        () {
          expect(Size.nearestFromSemitones(-4), -Size.third);
          expect(Size.nearestFromSemitones(-2), -Size.second);
          expect(Size.nearestFromSemitones(2), Size.second);
          expect(Size.nearestFromSemitones(4), Size.third);
          expect(Size.nearestFromSemitones(6), Size.fourth);
          expect(Size.nearestFromSemitones(9), Size.sixth);
          expect(Size.nearestFromSemitones(11), Size.seventh);
          expect(Size.nearestFromSemitones(14), Size.ninth);
          expect(Size.nearestFromSemitones(-20), -Size.thirteenth);
        },
      );
    });

    group('.isPerfect', () {
      test('returns whether this Size is perfect', () {
        expect(const Size(-43).isPerfect, isTrue);
        expect(const Size(-42).isPerfect, isFalse);
        expect(const Size(-41).isPerfect, isFalse);
        expect(const Size(-40).isPerfect, isTrue);
        expect(const Size(-39).isPerfect, isTrue);
        expect(const Size(-38).isPerfect, isFalse);
        expect(const Size(-37).isPerfect, isFalse);

        expect(const Size(-36).isPerfect, isTrue);
        expect(const Size(-35).isPerfect, isFalse);
        expect(const Size(-34).isPerfect, isFalse);
        expect(const Size(-33).isPerfect, isTrue);
        expect(const Size(-32).isPerfect, isTrue);
        expect(const Size(-31).isPerfect, isFalse);
        expect(const Size(-30).isPerfect, isFalse);

        expect(const Size(-29).isPerfect, isTrue);
        expect(const Size(-28).isPerfect, isFalse);
        expect(const Size(-27).isPerfect, isFalse);
        expect(const Size(-26).isPerfect, isTrue);
        expect(const Size(-25).isPerfect, isTrue);
        expect(const Size(-24).isPerfect, isFalse);
        expect(const Size(-23).isPerfect, isFalse);

        expect(const Size(-22).isPerfect, isTrue);
        expect(const Size(-21).isPerfect, isFalse);
        expect(const Size(-20).isPerfect, isFalse);
        expect(const Size(-19).isPerfect, isTrue);
        expect(const Size(-18).isPerfect, isTrue);
        expect(const Size(-17).isPerfect, isFalse);
        expect(const Size(-16).isPerfect, isFalse);

        expect(const Size(-15).isPerfect, isTrue);
        expect(const Size(-14).isPerfect, isFalse);
        expect((-Size.thirteenth).isPerfect, isFalse);
        expect((-Size.twelfth).isPerfect, isTrue);
        expect((-Size.eleventh).isPerfect, isTrue);
        expect((-Size.tenth).isPerfect, isFalse);
        expect((-Size.ninth).isPerfect, isFalse);

        expect((-Size.octave).isPerfect, isTrue);
        expect((-Size.seventh).isPerfect, isFalse);
        expect((-Size.sixth).isPerfect, isFalse);
        expect((-Size.fifth).isPerfect, isTrue);
        expect((-Size.fourth).isPerfect, isTrue);
        expect((-Size.third).isPerfect, isFalse);
        expect((-Size.second).isPerfect, isFalse);
        expect((-Size.unison).isPerfect, isTrue);

        expect(Size.unison.isPerfect, isTrue);
        expect(Size.second.isPerfect, isFalse);
        expect(Size.third.isPerfect, isFalse);
        expect(Size.fourth.isPerfect, isTrue);
        expect(Size.fifth.isPerfect, isTrue);
        expect(Size.sixth.isPerfect, isFalse);
        expect(Size.seventh.isPerfect, isFalse);
        expect(Size.octave.isPerfect, isTrue);

        expect(Size.ninth.isPerfect, isFalse);
        expect(Size.tenth.isPerfect, isFalse);
        expect(Size.eleventh.isPerfect, isTrue);
        expect(Size.twelfth.isPerfect, isTrue);
        expect(Size.thirteenth.isPerfect, isFalse);
        expect(const Size(14).isPerfect, isFalse);
        expect(const Size(15).isPerfect, isTrue);

        expect(const Size(16).isPerfect, isFalse);
        expect(const Size(17).isPerfect, isFalse);
        expect(const Size(18).isPerfect, isTrue);
        expect(const Size(19).isPerfect, isTrue);
        expect(const Size(20).isPerfect, isFalse);
        expect(const Size(21).isPerfect, isFalse);
        expect(const Size(22).isPerfect, isTrue);

        expect(const Size(23).isPerfect, isFalse);
        expect(const Size(24).isPerfect, isFalse);
        expect(const Size(25).isPerfect, isTrue);
        expect(const Size(26).isPerfect, isTrue);
        expect(const Size(27).isPerfect, isFalse);
        expect(const Size(28).isPerfect, isFalse);
        expect(const Size(29).isPerfect, isTrue);

        expect(const Size(30).isPerfect, isFalse);
        expect(const Size(31).isPerfect, isFalse);
        expect(const Size(32).isPerfect, isTrue);
        expect(const Size(33).isPerfect, isTrue);
        expect(const Size(34).isPerfect, isFalse);
        expect(const Size(35).isPerfect, isFalse);
        expect(const Size(36).isPerfect, isTrue);

        expect(const Size(37).isPerfect, isFalse);
        expect(const Size(38).isPerfect, isFalse);
        expect(const Size(39).isPerfect, isTrue);
        expect(const Size(40).isPerfect, isTrue);
        expect(const Size(41).isPerfect, isFalse);
        expect(const Size(42).isPerfect, isFalse);
        expect(const Size(43).isPerfect, isTrue);
      });
    });

    group('.perfect', () {
      test('returns the perfect Interval from this Size', () {
        expect(Size.unison.perfect, Interval.P1);
        expect(Size.fourth.perfect, Interval.P4);
        expect((-Size.fifth).perfect, -Interval.P5);

        expect(Size.twelfth.inversion.perfect, Interval.P4);
        expect(Size.twelfth.simple.perfect, Interval.P5);
      });
    });

    group('.major', () {
      test('returns the major Interval from this Size', () {
        expect(Size.second.major, Interval.M2);
        expect(Size.sixth.major, Interval.M6);
        expect((-Size.ninth).major, -Interval.M9);

        expect(Size.thirteenth.inversion.major, Interval.M3);
        expect(Size.thirteenth.simple.major, Interval.M6);
      });
    });

    group('.minor', () {
      test('returns the minor Interval from this Size', () {
        expect(Size.third.minor, Interval.m3);
        expect(Size.seventh.minor, Interval.m7);
        expect((-Size.sixth).minor, -Interval.m6);

        expect(Size.ninth.inversion.minor, Interval.m7);
        expect(Size.ninth.simple.minor, Interval.m2);
      });
    });

    group('.diminished', () {
      test('returns the diminished Interval from this Size', () {
        expect(Size.second.diminished, Interval.d2);
        expect(Size.fifth.diminished, Interval.d5);
        expect((-Size.seventh).diminished, -Interval.d7);

        expect(Size.eleventh.inversion.diminished, Interval.d5);
        expect(Size.eleventh.simple.diminished, Interval.d4);
      });
    });

    group('.augmented', () {
      test('returns the augmented Interval from this Size', () {
        expect(Size.third.augmented, Interval.A3);
        expect(Size.fourth.augmented, Interval.A4);
        expect((-Size.sixth).augmented, -Interval.A6);

        expect(Size.twelfth.inversion.augmented, Interval.A4);
        expect(Size.twelfth.simple.augmented, Interval.A5);
      });
    });

    group('.simple', () {
      test('returns the simplified version of this Size', () {
        expect(Size.unison.simple, Size.unison);
        expect(Size.second.simple, Size.second);
        expect(Size.third.simple, Size.third);
        expect(Size.fourth.simple, Size.fourth);
        expect(Size.fifth.simple, Size.fifth);
        expect(Size.sixth.simple, Size.sixth);
        expect(Size.seventh.simple, Size.seventh);
        expect(Size.octave.simple, Size.octave);

        expect(Size.ninth.simple, Size.second);
        expect(Size.tenth.simple, Size.third);
        expect(Size.eleventh.simple, Size.fourth);
        expect(Size.twelfth.simple, Size.fifth);
        expect(Size.thirteenth.simple, Size.sixth);
        expect(const Size(14).simple, Size.seventh);
        expect(const Size(15).simple, Size.octave);

        expect(const Size(16).simple, Size.second);
        expect(const Size(17).simple, Size.third);
        expect(const Size(18).simple, Size.fourth);
        expect(const Size(19).simple, Size.fifth);
        expect(const Size(20).simple, Size.sixth);
        expect(const Size(21).simple, Size.seventh);
        expect(const Size(22).simple, Size.octave);

        expect(const Size(23).simple, Size.second);
        expect(const Size(24).simple, Size.third);
        expect(const Size(25).simple, Size.fourth);
        expect(const Size(26).simple, Size.fifth);
        expect(const Size(27).simple, Size.sixth);
        expect(const Size(28).simple, Size.seventh);
        expect(const Size(29).simple, Size.octave);

        expect(const Size(30).simple, Size.second);
        expect(const Size(31).simple, Size.third);
        expect(const Size(32).simple, Size.fourth);
        expect(const Size(33).simple, Size.fifth);
        expect(const Size(34).simple, Size.sixth);
        expect(const Size(35).simple, Size.seventh);
        expect(const Size(36).simple, Size.octave);

        expect(const Size(37).simple, Size.second);
        expect(const Size(38).simple, Size.third);
        expect(const Size(39).simple, Size.fourth);
        expect(const Size(40).simple, Size.fifth);
        expect(const Size(41).simple, Size.sixth);
        expect(const Size(42).simple, Size.seventh);
        expect(const Size(43).simple, Size.octave);
      });
    });
  });
}
