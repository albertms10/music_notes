import 'package:music_notes/utils/iterable_extension.dart';
import 'package:test/test.dart';

void main() {
  group('IterableNumExtension', () {
    group('.closestTo()', () {
      test('should throw an exception when this Iterable is empty', () {
        expect(() => const <num>[].closestTo(1), throwsStateError);
      });

      test('should throw an ArgumentError when toNum is required', () {
        expect(
          () => [DateTime(2025, 1, 2), DateTime(2023, 12, 15)]
              .closestTo(DateTime.now()),
          throwsArgumentError,
        );
      });

      test('should return the closest number to target in this Iterable', () {
        expect(const [5].closestTo(1), 5);
        expect(const [5].closestTo(-1), 5);
        expect(const [-5, 5].closestTo(0), -5);
        expect(const [2, 5, 6, 8, 10].closestTo(7), 6);
        expect(
          [DateTime(2025, 1, 2), DateTime(2023, 12, 15)]
              .closestTo(DateTime(2024), (date) => date.millisecondsSinceEpoch),
          DateTime(2023, 12, 15),
        );
      });
    });
  });
}
