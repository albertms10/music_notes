import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('IntIntervalExtension', () {
    group('.fromSemitones()', () {
      test(
        'should return the int interval with the corresponding semitones',
        () {
          expect(IntIntervalExtension.fromSemitones(0), 1);
          expect(IntIntervalExtension.fromSemitones(1), 2);
          expect(IntIntervalExtension.fromSemitones(3), 3);
          expect(IntIntervalExtension.fromSemitones(5), 4);
          expect(IntIntervalExtension.fromSemitones(7), 5);
          expect(IntIntervalExtension.fromSemitones(8), 6);
          expect(IntIntervalExtension.fromSemitones(10), 7);
          expect(IntIntervalExtension.fromSemitones(12), 8);
          expect(IntIntervalExtension.fromSemitones(13), 2);
          expect(IntIntervalExtension.fromSemitones(-2), 7);
        },
      );

      test(
        'should return null when no int interval correspond to the given '
        'semitones',
        () {
          expect(IntIntervalExtension.fromSemitones(-1), isNull);
          expect(IntIntervalExtension.fromSemitones(2), isNull);
          expect(IntIntervalExtension.fromSemitones(4), isNull);
          expect(IntIntervalExtension.fromSemitones(6), isNull);
          expect(IntIntervalExtension.fromSemitones(9), isNull);
          expect(IntIntervalExtension.fromSemitones(11), isNull);
        },
      );
    });

    group('.semitones', () {
      test('should return the number of semitones of this int interval', () {
        expect(1.semitones, 0);
        expect(2.semitones, 1);
        expect(3.semitones, 3);
        expect(4.semitones, 5);
        expect(5.semitones, 7);
        expect(6.semitones, 8);
        expect(7.semitones, 10);
        expect(8.semitones, 12);
        expect(9.semitones, 13);
      });
    });

    group('.isPerfect', () {
      test('should return whether this int interval is perfect', () {
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
      test('should return whether this int interval is compound', () {
        expect(1.isCompound, isFalse);
        expect(5.isCompound, isFalse);
        expect(8.isCompound, isFalse);
        expect(9.isCompound, isTrue);
        expect(13.isCompound, isTrue);
      });
    });

    group('.isDissonant', () {
      test('should return whether this int interval is dissonant', () {
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
      test('should return the simplified int interval', () {
        expect(2.simplified, 2);
        expect(4.simplified, 4);
        expect(8.simplified, 8);
        expect(10.simplified, 3);
        expect(13.simplified, 6);
      });
    });
  });
}