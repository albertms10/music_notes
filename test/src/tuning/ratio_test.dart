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
        expect(edo12.ratioFromSemitones().cents.value, closeTo(100, 0.01));
        expect(edo12.ratioFromSemitones(6).cents.value, closeTo(600, 0.01));
        expect(edo12.ratioFromSemitones(12).cents.value, closeTo(1200, 0.01));

        const edo19 = EqualTemperament.edo19();
        expect(edo19.ratioFromSemitones().cents.value, closeTo(63.16, 0.01));
        expect(edo19.ratioFromSemitones(10).cents.value, closeTo(631.58, 0.01));
        expect(edo19.ratioFromSemitones(19).cents.value, closeTo(1200, 0.01));
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Ratio', () {
        expect(const Ratio(1).toString(), '1');
        expect(const Ratio(1.059463).toString(), '1.059463');
      });
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal Ratios', () {
        // ignore: prefer_const_constructors
        expect(Ratio(1).hashCode, Ratio(1).hashCode);
        // ignore: prefer_const_constructors
        expect(Ratio(1.414062).hashCode, Ratio(1.414062).hashCode);
      });

      test('returns different hashCodes for different Ratios', () {
        expect(const Ratio(1).hashCode, isNot(equals(const Ratio(2).hashCode)));
        expect(
          const Ratio(1.892345).hashCode,
          isNot(equals(const Ratio(1.89234509).hashCode)),
        );
      });
    });
  });
}
