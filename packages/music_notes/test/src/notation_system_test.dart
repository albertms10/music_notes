import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('NotationSystem', () {
    group('.firstMatchingParser()', () {
      test('returns the first parser in the chain that matches source', () {
        const chain = [EnglishNoteNotation(), GermanNoteNotation()];
        expect(chain.firstMatchingParser('C'), const EnglishNoteNotation());
        expect(chain.firstMatchingParser('h'), const GermanNoteNotation());
        expect(chain.firstMatchingParser('Do'), isNull);
      });
    });
  });
}
