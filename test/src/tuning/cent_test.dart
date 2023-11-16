import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Cent', () {
    group('.ratio', () {
      test('should return the Ratio for this Cent', () {
        expect(const Cent(0).ratio, const Ratio(1));
        expect(const Cent(-63.16).ratio, const Ratio(0.9641748254592175));
        expect(const Cent(100).ratio, const Ratio(1.0594630943592953));
        expect(const Cent(600).ratio, const Ratio(1.4142135623730951));
        expect(const Cent(631.58).ratio, const Ratio(1.4402474132432592));
        expect(const Cent(1200).ratio, const Ratio(2));
      });
    });
  });
}
