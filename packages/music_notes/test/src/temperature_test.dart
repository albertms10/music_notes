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
  });
}
