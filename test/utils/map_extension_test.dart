import 'package:music_notes/utils/map_extension.dart';
import 'package:test/test.dart';

void main() {
  group('MapExtension', () {
    group('.recordEntries', () {
      test('should return the record entries of this Map', () {
        expect(const <num, String>{}.recordEntries, const <(num, String)>[]);
        expect(
          const <String, bool>{'a': false}.recordEntries,
          const <(String, bool)>[('a', false)],
        );
        expect(
          const {1: 'Mercury', 2: 'Venus', 3: 'Earth', 4: 'Mars'}.recordEntries,
          const [(1, 'Mercury'), (2, 'Venus'), (3, 'Earth'), (4, 'Mars')],
        );
      });
    });
  });
}
