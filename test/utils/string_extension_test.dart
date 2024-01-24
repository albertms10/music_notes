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

    group('.isLowerCase', () {
      test('returns whether this String is lower-cased', () {
        expect('A'.isLowerCase, isFalse);
        expect('ABC'.isLowerCase, isFalse);
        expect('a'.isLowerCase, isTrue);
        expect('abc'.isLowerCase, isTrue);
        expect('Abc'.isLowerCase, isFalse);
      });
    });
  });
}
