import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('NumExtension', () {
    group('.toDeltaString()', () {
      test('returns a delta string representation of this num', () {
        expect(1.1.toDeltaString(), '+1.1');
        expect(0.toDeltaString(), '+0');
        expect((-5).toDeltaString(), '-5');
        expect((-10.02).toDeltaString(), '-10.02');
      });
    });

    group('.nonZeroSign', () {
      test('returns the non-zero sign of this num', () {
        expect(5.nonZeroSign, 1);
        expect(345.2345.nonZeroSign, 1);
        expect(0.nonZeroSign, 1);
        expect((-2).nonZeroSign, -1);
        expect((-2.56).nonZeroSign, -1);
      });
    });
  });
}
