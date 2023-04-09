import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('KeySignature', () {
    group('.toString()', () {
      test(
        'should return the string representation of this KeySignature',
        () {
          expect(
            const KeySignature(10, Accidental.flat).toString(),
            '7 × ♭, 3 × 𝄫',
          );
          expect(
            const KeySignature(8, Accidental.flat).toString(),
            '7 × ♭, 1 × 𝄫',
          );
          expect(const KeySignature(7, Accidental.flat).toString(), '7 × ♭');
          expect(const KeySignature(6, Accidental.flat).toString(), '6 × ♭');
          expect(const KeySignature(5, Accidental.flat).toString(), '5 × ♭');
          expect(const KeySignature(4, Accidental.flat).toString(), '4 × ♭');
          expect(const KeySignature(3, Accidental.flat).toString(), '3 × ♭');
          expect(const KeySignature(2, Accidental.flat).toString(), '2 × ♭');
          expect(const KeySignature(1, Accidental.flat).toString(), '1 × ♭');
          expect(const KeySignature(0).toString(), '0 × ♮');
          expect(const KeySignature(1, Accidental.sharp).toString(), '1 × ♯');
          expect(const KeySignature(2, Accidental.sharp).toString(), '2 × ♯');
          expect(const KeySignature(3, Accidental.sharp).toString(), '3 × ♯');
          expect(const KeySignature(4, Accidental.sharp).toString(), '4 × ♯');
          expect(const KeySignature(5, Accidental.sharp).toString(), '5 × ♯');
          expect(const KeySignature(6, Accidental.sharp).toString(), '6 × ♯');
          expect(const KeySignature(7, Accidental.sharp).toString(), '7 × ♯');
          expect(
            const KeySignature(8, Accidental.sharp).toString(),
            '7 × ♯, 1 × 𝄪',
          );
          expect(
            const KeySignature(10, Accidental.sharp).toString(),
            '7 × ♯, 3 × 𝄪',
          );
        },
      );
    });
  });
}
