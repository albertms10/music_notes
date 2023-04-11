import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Intervals', () {
    group('.fromSemitones()', () {
      test(
        'should return the Intervals enum item with the corresponding '
        'semitones',
        () {
          expect(Intervals.fromSemitones(0), Intervals.unison);
          expect(Intervals.fromSemitones(1), Intervals.second);
          expect(Intervals.fromSemitones(3), Intervals.third);
          expect(Intervals.fromSemitones(5), Intervals.fourth);
          expect(Intervals.fromSemitones(7), Intervals.fifth);
          expect(Intervals.fromSemitones(8), Intervals.sixth);
          expect(Intervals.fromSemitones(10), Intervals.seventh);
          expect(Intervals.fromSemitones(12), Intervals.octave);
          expect(Intervals.fromSemitones(13), Intervals.second);
          expect(Intervals.fromSemitones(-2), Intervals.seventh);
        },
      );

      test(
        'should return null when no Intervals correspond to the given '
        'semitones',
        () {
          expect(Intervals.fromSemitones(-1), isNull);
          expect(Intervals.fromSemitones(2), isNull);
          expect(Intervals.fromSemitones(4), isNull);
          expect(Intervals.fromSemitones(6), isNull);
          expect(Intervals.fromSemitones(9), isNull);
          expect(Intervals.fromSemitones(11), isNull);
        },
      );
    });

    group('.isPerfect', () {
      test('should return whether this Intervals enum item is perfect', () {
        expect(Intervals.unison.isPerfect, isTrue);
        expect(Intervals.second.isPerfect, isFalse);
        expect(Intervals.third.isPerfect, isFalse);
        expect(Intervals.fourth.isPerfect, isTrue);
        expect(Intervals.fifth.isPerfect, isTrue);
        expect(Intervals.sixth.isPerfect, isFalse);
        expect(Intervals.seventh.isPerfect, isFalse);
        expect(Intervals.octave.isPerfect, isTrue);
        expect(Intervals.ninth.isPerfect, isFalse);
        expect(Intervals.eleventh.isPerfect, isTrue);
        expect(Intervals.thirteenth.isPerfect, isFalse);
      });
    });

    group('.isCompound', () {
      test('should return whether this Intervals enum item is compound', () {
        expect(Intervals.unison.isCompound, isFalse);
        expect(Intervals.fifth.isCompound, isFalse);
        expect(Intervals.octave.isCompound, isFalse);
        expect(Intervals.ninth.isCompound, isTrue);
        expect(Intervals.thirteenth.isCompound, isTrue);
      });
    });

    group('.simplified', () {
      test('should return the simplified Intervals enum item', () {
        expect(Intervals.second.simplified, Intervals.second);
        expect(Intervals.fourth.simplified, Intervals.fourth);
        expect(Intervals.octave.simplified, Intervals.octave);
        expect(Intervals.tenth.simplified, Intervals.third);
        expect(Intervals.thirteenth.simplified, Intervals.sixth);
      });
    });
  });
}
