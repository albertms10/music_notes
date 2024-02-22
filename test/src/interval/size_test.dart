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
  });
}
