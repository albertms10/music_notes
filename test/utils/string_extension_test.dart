import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('StringExtension', () {
    group('.isUpperCase', () {
      test('returns whether this String is upper-cased', () {
        expect('A'.isUpperCase, isTrue);
        expect('ABC'.isUpperCase, isTrue);
        expect('a'.isUpperCase, isFalse);
        expect('abc'.isUpperCase, isFalse);
        expect('Abc'.isUpperCase, isFalse);
      });
    });

    group('.toUpperFirst()', () {
      test('converts the first letter of the string to uppercase', () {
        expect(''.toUpperFirst(), '');
        expect('a'.toUpperFirst(), 'A');
        expect('?'.toUpperFirst(), '?');
        expect('hello world'.toUpperFirst(), 'Hello world');
        expect('HELLO WORLD'.toUpperFirst(), 'Hello world');
        expect('hELLO wORLD'.toUpperFirst(), 'Hello world');
      });
    });
  });
}
