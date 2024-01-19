import 'package:music_notes/utils/iterable_extension.dart';
import 'package:test/test.dart';

void main() {
  group('IterableNumExtension', () {
    group('.closestTo()', () {
      test('throws an exception when this Iterable is empty', () {
        expect(() => const <num>[].closestTo(1), throwsStateError);
      });

      test('returns the closest number to target in this Iterable', () {
        expect(const [5].closestTo(1), 5);
        expect(const [5].closestTo(-1), 5);
        expect(const [-5, 5].closestTo(0), -5);
        expect(const [2, 5, 6, 8, 10].closestTo(7), 6);
      });
    });
  });
}
