import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Cent', () {
    group('.fromRatio()', () {
      test('returns the Cent value for ratio', () {
        expect(Cent.fromRatio(0.12), const Cent(-3670.6724268642824));
        expect(Cent.fromRatio(1), const Cent(0));
        expect(Cent.fromRatio(3 / 2), const Cent(701.9550008653874));
        expect(Cent.fromRatio(9 / 8), const Cent(203.91000173077484));
        expect(Cent.fromRatio(2), const Cent(1200));
        expect(Cent.fromRatio(4), const Cent(2400));

        const edo12 = EqualTemperament.edo12();
        expect(Cent.fromRatio(edo12.ratioFromSemitones(1)), closeTo(100, 0.01));
        expect(Cent.fromRatio(edo12.ratioFromSemitones(6)), closeTo(600, 0.01));
        expect(
          Cent.fromRatio(edo12.ratioFromSemitones(12)),
          closeTo(1200, 0.01),
        );

        const edo19 = EqualTemperament.edo19();
        expect(
          Cent.fromRatio(edo19.ratioFromSemitones(1)),
          closeTo(63.16, 0.01),
        );
        expect(
          Cent.fromRatio(edo19.ratioFromSemitones(10)),
          closeTo(631.58, 0.01),
        );
        expect(
          Cent.fromRatio(edo19.ratioFromSemitones(19)),
          closeTo(1200, 0.01),
        );
      });
    });

    group('.ratio', () {
      test('returns the ratio for this Cent', () {
        expect(const Cent(0).ratio, 1);
        expect(const Cent(-63.16).ratio, 0.9641748254592175);
        expect(const Cent(100).ratio, 1.0594630943592953);
        expect(const Cent(600).ratio, 1.4142135623730951);
        expect(const Cent(631.58).ratio, 1.4402474132432592);
        expect(const Cent(1200).ratio, 2);
      });
    });

    group('.format()', () {
      test('returns this Cent formatted as a string', () {
        expect(const Cent(700).format(), '700 ¢');
        expect(const Cent(701.95).format(), '701.95 ¢');
      });
    });

    group('operator -()', () {
      test('returns the negation of this Cent', () {
        expect(-const Cent(100), const Cent(-100));
        expect(-const Cent(-701.955), const Cent(701.955));
      });
    });
  });
}
