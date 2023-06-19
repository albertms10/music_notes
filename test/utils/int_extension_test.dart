import 'package:music_notes/utils/int_extension.dart';
import 'package:test/test.dart';

void main() {
  group('IntExtension', () {
    group('.incrementBy()', () {
      test('should return this int incremented by step', () {
        expect(1.incrementBy(1), 2);
        expect(1.incrementBy(-1), 0);
        expect((-1).incrementBy(1), -2);
        expect((-1).incrementBy(-1), 0);

        expect(10.incrementBy(4), 14);
        expect(10.incrementBy(-4), 6);
        expect((-10).incrementBy(4), -14);
        expect((-10).incrementBy(-4), -6);
      });
    });

    group('.chromaticMod', () {
      test('should return the correct modulus chromatic divisions', () {
        expect(4.chromaticMod, 4);
        expect(14.chromaticMod, 2);
        expect((-5).chromaticMod, 7);
        expect(0.chromaticMod, 0);
        expect(12.chromaticMod, 0);
      });
    });

    group('.chromaticModExcludeZero', () {
      test(
        'should return the correct modulus chromatic divisions excluding zero',
        () {
          expect(15.chromaticModExcludeZero, 3);
          expect(12.chromaticModExcludeZero, 12);
          expect(0.chromaticModExcludeZero, 12);
        },
      );
    });

    group('.nModExcludeZero()', () {
      test(
        'should return the correct modulus excluding zero for a given int',
        () {
          expect(9.nModExcludeZero(3), 3);
          expect(0.nModExcludeZero(5), 5);
          expect(7.nModExcludeZero(7), 7);
        },
      );
    });
  });
}
