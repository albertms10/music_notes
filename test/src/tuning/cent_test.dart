import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Cent', () {
    group('.ratio', () {
      test('returns the Ratio for this Cent', () {
        expect(const Cent(0).ratio, const Ratio(1));
        expect(const Cent(-63.16).ratio, const Ratio(0.9641748254592175));
        expect(const Cent(100).ratio, const Ratio(1.0594630943592953));
        expect(const Cent(600).ratio, const Ratio(1.4142135623730951));
        expect(const Cent(631.58).ratio, const Ratio(1.4402474132432592));
        expect(const Cent(1200).ratio, const Ratio(2));
      });
    });

    group('.format()', () {
      test('returns the string format of this Cent', () {
        expect(const Cent(700).format(), '700 ¢');
        expect(const Cent(701.95).format(), '701.95 ¢');
      });
    });

    group('operator -()', () {
      test('returns the negation of this Cent', () {
        expect(-const Cent(100), const Cent(-100));
        expect(-const Cent(-701.955), const Cent(701.955));
      });
    });
  });
}
