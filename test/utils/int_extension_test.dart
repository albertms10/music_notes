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

        expect(0.incrementBy(1), 1);
        expect(0.incrementBy(-1), -1);
      });
    });

    group('.nonZeroMod()', () {
      test('should return the correct non-zero modulo for a given int', () {
        expect(9.nonZeroMod(3), 3);
        expect(7.nonZeroMod(7), 7);
        expect(0.nonZeroMod(5), 5);
      });
    });
  });
}
