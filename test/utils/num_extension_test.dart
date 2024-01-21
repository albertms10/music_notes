import 'package:music_notes/utils/num_extension.dart';
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
  });
}
