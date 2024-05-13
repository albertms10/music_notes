import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('MixedNum', () {
    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(() => MixedNum(1, -2), throwsA(isA<AssertionError>()));
        expect(() => MixedNum(1, 1, 0), throwsA(isA<AssertionError>()));
        expect(() => MixedNum(-1), throwsA(isA<AssertionError>()));
      });
    });

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => MixedNum.parse('x'), throwsFormatException);
        expect(() => MixedNum.parse('a 1/2'), throwsFormatException);
        expect(() => MixedNum.parse('3 e/2'), throwsFormatException);
        expect(() => MixedNum.parse('3 5/o'), throwsFormatException);
        expect(() => MixedNum.parse('3 5.o'), throwsFormatException);
        expect(() => MixedNum.parse('1- 1/5'), throwsFormatException);
        expect(() => MixedNum.parse('1 -1/5'), throwsFormatException);
      });

      test('parses source as a MixedNum', () {
        expect(MixedNum.parse('1 1/2'), const MixedNum(1, 1, 2));
        expect(MixedNum.parse('2'), const MixedNum(2));
        expect(MixedNum.parse('5  3/5'), const MixedNum(5, 3, 5));
        expect(MixedNum.parse('4 5/4'), const MixedNum(4, 5, 4));
        expect(MixedNum.parse('32 10/111'), const MixedNum(32, 10, 111));
      });
    });

    group('.fromDouble()', () {
      test('creates a new MixedNum from double', () {
        expect(MixedNum.fromDouble(0), const MixedNum(0));
        expect(MixedNum.fromDouble(0.333), const MixedNum(0, 1, 3));
        expect(
          MixedNum.fromDouble(0.33334, tolerance: 10000),
          const MixedNum(0, 1, 3),
        );
        expect(
          MixedNum.fromDouble(0.33334, tolerance: 100000),
          const MixedNum(0, 16667, 50000),
        );
        expect(MixedNum.fromDouble(1.375), const MixedNum(1, 3, 8));
      });

      test('throws an assertion error when arguments are incorrect', () {
        expect(() => MixedNum.fromDouble(-1), throwsA(isA<AssertionError>()));
        expect(
          () => MixedNum.fromDouble(1, tolerance: -1),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.simple', () {
      test('returns the simplified version of this MixedNum', () {
        expect(const MixedNum(0, 1, 3).simple, const MixedNum(0, 1, 3));
        expect(const MixedNum(2).simple, const MixedNum(2));
        expect(const MixedNum(3, 1).simple, const MixedNum(4));
        expect(const MixedNum(1, 5, 2).simple, const MixedNum(3, 1, 2));
      });
    });

    group('.toDouble()', () {
      test('returns this MixedNum as a double', () {
        expect(const MixedNum(0).toDouble(), 0);
        expect(const MixedNum(2).toDouble(), 2);
        expect(const MixedNum(0, 1, 3).toDouble(), 1 / 3);
        expect(const MixedNum(1, 3, 8).toDouble(), 1.375);
        expect(const MixedNum(3, 5, 4).toDouble(), 4.25);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this MixedNum', () {
        expect(const MixedNum(0).toString(), '0');
        expect(const MixedNum(3).toString(), '3');
        expect(const MixedNum(0, 1, 3).toString(), '1/3');
        expect(const MixedNum(3, 5, 4).toString(), '3 5/4');
      });
    });

    group('.compareTo()', () {
      test('sorts MixedNums in a collection', () {
        final orderedSet = SplayTreeSet<MixedNum>.of({
          const MixedNum(0),
          const MixedNum(1, 2, 2),
          const MixedNum(0, 7, 2),
          const MixedNum(0, 1, 9),
        });
        expect(orderedSet.toList(), const [
          MixedNum(0),
          MixedNum(0, 1, 9),
          MixedNum(1, 2, 2),
          MixedNum(0, 7, 2),
        ]);
      });
    });
  });
}
