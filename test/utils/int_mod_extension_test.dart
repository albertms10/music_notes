import 'package:music_notes/utils/int_mod_extension.dart';
import 'package:test/test.dart';

void main() {
  group('IntModExtension', () {
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
        'should return the correct modulus excluding zero chromatic divisions',
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
