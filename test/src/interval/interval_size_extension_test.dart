import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('IntervalSizeExtension', () {
    group('.fromSemitones()', () {
      test(
        'should return the Interval size corresponding to the given semitones',
        () {
          expect(IntervalSizeExtension.fromSemitones(-12), -8);
          expect(IntervalSizeExtension.fromSemitones(-5), -4);
          expect(IntervalSizeExtension.fromSemitones(-3), -3);
          expect(IntervalSizeExtension.fromSemitones(-1), -2);
          expect(IntervalSizeExtension.fromSemitones(0), 1);
          expect(IntervalSizeExtension.fromSemitones(1), 2);
          expect(IntervalSizeExtension.fromSemitones(3), 3);
          expect(IntervalSizeExtension.fromSemitones(5), 4);
          expect(IntervalSizeExtension.fromSemitones(7), 5);
          expect(IntervalSizeExtension.fromSemitones(8), 6);
          expect(IntervalSizeExtension.fromSemitones(10), 7);
          expect(IntervalSizeExtension.fromSemitones(12), 8);
          expect(IntervalSizeExtension.fromSemitones(13), 9);
          expect(IntervalSizeExtension.fromSemitones(15), 10);
          expect(IntervalSizeExtension.fromSemitones(17), 11);
          expect(IntervalSizeExtension.fromSemitones(19), 12);
          expect(IntervalSizeExtension.fromSemitones(20), 13);
          expect(IntervalSizeExtension.fromSemitones(22), 14);
          expect(IntervalSizeExtension.fromSemitones(24), 15);
          expect(IntervalSizeExtension.fromSemitones(36), 22);
          expect(IntervalSizeExtension.fromSemitones(48), 29);
        },
      );

      test(
        'should return null when no Interval size corresponds to the given '
        'semitones',
        () {
          expect(IntervalSizeExtension.fromSemitones(-4), isNull);
          expect(IntervalSizeExtension.fromSemitones(-2), isNull);
          expect(IntervalSizeExtension.fromSemitones(2), isNull);
          expect(IntervalSizeExtension.fromSemitones(4), isNull);
          expect(IntervalSizeExtension.fromSemitones(6), isNull);
          expect(IntervalSizeExtension.fromSemitones(9), isNull);
          expect(IntervalSizeExtension.fromSemitones(11), isNull);
        },
      );
    });

    group('.semitones', () {
      test('should throw an assertion error when size is zero', () {
        expect(() => 0.semitones, throwsA(isA<AssertionError>()));
      });

      test('should return the number of semitones of this Interval size', () {
        expect((-8).semitones, -12);
        expect((-7).semitones, -10);
        expect((-4).semitones, -5);
        expect((-1).semitones, 0);
        expect(1.semitones, 0);
        expect(2.semitones, 1);
        expect(3.semitones, 3);
        expect(4.semitones, 5);
        expect(5.semitones, 7);
        expect(6.semitones, 8);
        expect(7.semitones, 10);
        expect(8.semitones, 12);

        expect(9.semitones, 13);
        expect(10.semitones, 15);
        expect(11.semitones, 17);
        expect(12.semitones, 19);
        expect(13.semitones, 20);
        expect(14.semitones, 22);
        expect(15.semitones, 24);

        expect(16.semitones, 25);
        expect(17.semitones, 27);
        expect(18.semitones, 29);
        expect(19.semitones, 31);
        expect(20.semitones, 32);
        expect(21.semitones, 34);
        expect(22.semitones, 36);

        expect(29.semitones, 48);
      });
    });

    group('.isPerfect', () {
      test('should throw an assertion error when size is zero', () {
        expect(() => 0.isPerfect, throwsA(isA<AssertionError>()));
      });

      test('should return whether this Interval size is perfect', () {
        expect((-13).isPerfect, isFalse);
        expect((-11).isPerfect, isTrue);
        expect((-9).isPerfect, isFalse);
        expect((-8).isPerfect, isTrue);
        expect((-7).isPerfect, isFalse);
        expect((-6).isPerfect, isFalse);
        expect((-5).isPerfect, isTrue);
        expect((-4).isPerfect, isTrue);
        expect((-3).isPerfect, isFalse);
        expect((-2).isPerfect, isFalse);
        expect((-1).isPerfect, isTrue);
        expect(1.isPerfect, isTrue);
        expect(2.isPerfect, isFalse);
        expect(3.isPerfect, isFalse);
        expect(4.isPerfect, isTrue);
        expect(5.isPerfect, isTrue);
        expect(6.isPerfect, isFalse);
        expect(7.isPerfect, isFalse);
        expect(8.isPerfect, isTrue);
        expect(9.isPerfect, isFalse);
        expect(11.isPerfect, isTrue);
        expect(13.isPerfect, isFalse);
      });
    });

    group('.isCompound', () {
      test('should throw an assertion error when size is zero', () {
        expect(() => 0.isCompound, throwsA(isA<AssertionError>()));
      });

      test('should return whether this Interval size is compound', () {
        expect((-14).isCompound, isTrue);
        expect((-10).isCompound, isTrue);
        expect((-8).isCompound, isFalse);
        expect((-4).isCompound, isFalse);
        expect((-1).isCompound, isFalse);
        expect(1.isCompound, isFalse);
        expect(5.isCompound, isFalse);
        expect(8.isCompound, isFalse);
        expect(9.isCompound, isTrue);
        expect(13.isCompound, isTrue);
      });
    });

    group('.isDissonant', () {
      test('should throw an assertion error when size is zero', () {
        expect(() => 0.isDissonant, throwsA(isA<AssertionError>()));
      });

      test('should return whether this Interval size is dissonant', () {
        expect((-14).isDissonant, isTrue);
        expect((-13).isDissonant, isFalse);
        expect((-12).isDissonant, isFalse);
        expect((-11).isDissonant, isFalse);
        expect((-10).isDissonant, isFalse);
        expect((-9).isDissonant, isTrue);
        expect((-8).isDissonant, isFalse);
        expect((-7).isDissonant, isTrue);
        expect((-6).isDissonant, isFalse);
        expect((-5).isDissonant, isFalse);
        expect((-4).isDissonant, isFalse);
        expect((-3).isDissonant, isFalse);
        expect((-2).isDissonant, isTrue);
        expect((-1).isDissonant, isFalse);
        expect(1.isDissonant, isFalse);
        expect(2.isDissonant, isTrue);
        expect(3.isDissonant, isFalse);
        expect(4.isDissonant, isFalse);
        expect(5.isDissonant, isFalse);
        expect(6.isDissonant, isFalse);
        expect(7.isDissonant, isTrue);
        expect(8.isDissonant, isFalse);
        expect(9.isDissonant, isTrue);
        expect(10.isDissonant, isFalse);
        expect(11.isDissonant, isFalse);
        expect(12.isDissonant, isFalse);
        expect(13.isDissonant, isFalse);
        expect(14.isDissonant, isTrue);
      });
    });

    group('.simplified', () {
      test('should throw an assertion error when size is zero', () {
        expect(() => 0.simplified, throwsA(isA<AssertionError>()));
      });

      test('should return the simplified Interval size', () {
        expect((-22).simplified, -8);
        expect((-17).simplified, -3);
        expect((-16).simplified, -2);
        expect((-15).simplified, -8);
        expect((-13).simplified, -6);
        expect((-10).simplified, -3);
        expect((-8).simplified, -8);
        expect((-4).simplified, -4);
        expect((-2).simplified, -2);
        expect(2.simplified, 2);
        expect(4.simplified, 4);
        expect(8.simplified, 8);
        expect(10.simplified, 3);
        expect(13.simplified, 6);
        expect(15.simplified, 8);
        expect(16.simplified, 2);
        expect(17.simplified, 3);
        expect(22.simplified, 8);
      });
    });

    group('.inverted', () {
      test('should throw an assertion error when size is zero', () {
        expect(() => 0.inverted, throwsA(isA<AssertionError>()));
      });

      test('should return the inverted Interval size', () {
        expect((-13).inverted, -3);
        expect((-10).inverted, -6);
        expect((-9).inverted, -7);
        expect((-8).inverted, -1);
        expect((-4).inverted, -5);
        expect((-2).inverted, -7);
        expect(2.inverted, 7);
        expect(4.inverted, 5);
        expect(8.inverted, 1);
        expect(9.inverted, 7);
        expect(10.inverted, 6);
        expect(13.inverted, 3);
      });
    });
  });
}
