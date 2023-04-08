import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Intervals', () {
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
  });
}
