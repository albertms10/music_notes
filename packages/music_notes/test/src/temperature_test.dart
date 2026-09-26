import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Temperature', () {
    group('.celsius()', () {
      test('creates a new Temperature from Celsius', () {
        expect(const Temperature.celsius(20), 20);
        expect(const Temperature.celsius(-40), -40);
        expect(const Temperature.celsius(100), 100);
      });
    });

    group('.fahrenheit()', () {
      test('creates a new Temperature from Fahrenheit', () {
        expect(const Temperature.fahrenheit(32), 0);
        expect(const Temperature.fahrenheit(212), 100);
        expect(const Temperature.fahrenheit(-40), -40);
        expect(const Temperature.fahrenheit(68), 20);
      });
    });

    group('.kelvin()', () {
      test('creates a new Temperature from Kelvin', () {
        expect(const Temperature.kelvin(0), -273.15);
        expect(const Temperature.kelvin(273.15), 0);
        expect(const Temperature.kelvin(293.15), 20);
        expect(const Temperature.kelvin(373.15), 100);
      });
    });

    group('.ratio()', () {
      test('is 1 at the reference temperature', () {
        expect(const Temperature.celsius(20).ratio(), 1);
      });

      test('compares two Celsius temperatures', () {
        expect(
          const Temperature.celsius(0).ratio(),
          closeTo(331.3 / 343.3, 1e-10),
        );
      });

      test('is symmetric through the reciprocal', () {
        const a = Temperature.celsius(0);
        const b = Temperature.celsius(20);

        expect(
          a.ratio() * b.ratio(a),
          closeTo(1, 1e-10),
        );
      });

      test('uses the custom reference temperature', () {
        expect(
          const Temperature.celsius(30).ratio(const .celsius(10)),
          closeTo(349.3 / 337.3, 1e-10),
        );
      });

      test('works with temperatures created from other scales', () {
        expect(
          const Temperature.fahrenheit(32).ratio(const .kelvin(293.15)),
          closeTo(331.3 / 343.3, 1e-10),
        );
      });
    });
  });
}
