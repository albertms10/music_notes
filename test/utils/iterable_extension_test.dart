import 'package:music_notes/music_notes.dart';
import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('IterableExtension', () {
    group('.closestTo()', () {
      test('throws an exception when this Iterable is empty', () {
        expect(() => const <num>[].closestTo(1), throwsStateError);
      });

      test('throws an ArgumentError when difference is required', () {
        expect(
          () => [DateTime(2025, 1, 2), DateTime(2023, 12, 15)]
              .closestTo(DateTime.now()),
          throwsArgumentError,
        );
      });

      test('returns the closest element to target in this Iterable', () {
        expect(const [5].closestTo(1), 5);
        expect(const [5].closestTo(-1), 5);
        expect(const [-5, 5].closestTo(0), -5);
        expect(const [2, 5, 6, 8, 10].closestTo(7), 6);
        expect(
          [DateTime(2025, 1, 2), DateTime(2023, 12, 15)].closestTo(
            DateTime(2024),
            (a, b) => b.millisecondsSinceEpoch - a.millisecondsSinceEpoch,
          ),
          DateTime(2023, 12, 15),
        );
        expect(
          [Note.c, Note.e, Note.f.sharp, Note.a]
              .closestTo(Note.g, (a, b) => b.semitones - a.semitones),
          Note.f.sharp,
        );
      });
    });
  });
}
