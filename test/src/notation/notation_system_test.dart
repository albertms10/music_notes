import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('NotationSystem', () {
    group('.matches()', () {
      test('returns whether source is matched by any parser in the chain', () {
        const chain = [EnglishNoteNotation(), GermanNoteNotation()];
        expect(chain.matches('C'), isTrue);
        expect(chain.matches('h'), isTrue);
        expect(chain.matches('Do'), isFalse);
      });
    });
  });
}
