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

    group('.toString()', () {
      test('should return the string representation of this Cent', () {
        expect(const Cent(100).toString(), '100 ¢');
        expect(const Cent(701.955).toString(), '701.955 ¢');
      });
    });

    group('operator -()', () {
      test('should return the negation of this Cent', () {
        expect(-const Cent(100), const Cent(-100));
        expect(-const Cent(-701.955), const Cent(701.955));
      });
    });

    group('.hashCode', () {
      test('should return the same hashCode for equal Cents', () {
        // ignore: prefer_const_constructors
        expect(Cent(100).hashCode, Cent(100).hashCode);
        // ignore: prefer_const_constructors
        expect(Cent(34.67982).hashCode, Cent(34.67982).hashCode);
      });

      test('should return different hashCodes for different Cents', () {
        expect(
          const Cent(0).hashCode,
          isNot(equals(const Cent(1200).hashCode)),
        );
        expect(
          const Cent(34.3578).hashCode,
          isNot(equals(const Cent(34.35789).hashCode)),
        );
      });
    });
  });
}
