import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Ratio', () {
    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(() => Ratio(-1), throwsA(isA<AssertionError>()));
        expect(() => Ratio(0), throwsA(isA<AssertionError>()));
      });
    });

    group('.cents', () {
      test('returns the Cent for this Ratio', () {
        expect(const Ratio(0.12).cents, const Cent(-3670.6724268642824));
        expect(const Ratio(1).cents, const Cent(0));
        expect(const Ratio(3 / 2).cents, const Cent(701.9550008653874));
        expect(const Ratio(9 / 8).cents, const Cent(203.91000173077484));
        expect(const Ratio(2).cents, const Cent(1200));
        expect(const Ratio(4).cents, const Cent(2400));

        const edo12 = EqualTemperament.edo12();
        expect(edo12.ratioFromSemitones(1).cents, closeTo(100, 0.01));
        expect(edo12.ratioFromSemitones(6).cents, closeTo(600, 0.01));
        expect(edo12.ratioFromSemitones(12).cents, closeTo(1200, 0.01));

        const edo19 = EqualTemperament.edo19();
        expect(edo19.ratioFromSemitones(1).cents, closeTo(63.16, 0.01));
        expect(edo19.ratioFromSemitones(10).cents, closeTo(631.58, 0.01));
        expect(edo19.ratioFromSemitones(19).cents, closeTo(1200, 0.01));
      });
    });
  });
}
