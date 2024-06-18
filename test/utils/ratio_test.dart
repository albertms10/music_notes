import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Ratio', () {
    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(() => Ratio(1, 0), throwsA(isA<AssertionError>()));
        expect(() => Ratio.fromMixed(1, 1, 0), throwsA(isA<AssertionError>()));
      });
    });

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Ratio.parse('x'), throwsFormatException);
        expect(() => Ratio.parse('1 /2'), throwsFormatException);
        expect(() => Ratio.parse('1/ 2'), throwsFormatException);
        expect(() => Ratio.parse('a 1/2'), throwsFormatException);
        expect(() => Ratio.parse('3 e/2'), throwsFormatException);
        expect(() => Ratio.parse('3 5/o'), throwsFormatException);
        expect(() => Ratio.parse('3 5.o'), throwsFormatException);
        expect(() => Ratio.parse('1- 1/5'), throwsFormatException);
        expect(() => Ratio.parse('1 -1/5'), throwsFormatException);
      });

      test('parses source as a Ratio', () {
        expect(Ratio.parse('1 1/2'), const Ratio.fromMixed(1, 1, 2));
        expect(Ratio.parse('2'), const Ratio(2));
        expect(
          skip: 'TODO: allow fraction only.',
          () => Ratio.parse('3/4'),
          const Ratio(3, 4),
        );
        expect(Ratio.parse('5  3/5'), const Ratio.fromMixed(5, 3, 5));
        expect(Ratio.parse('4 5/4'), const Ratio.fromMixed(4, 5, 4));
        expect(Ratio.parse('32 10/111'), const Ratio.fromMixed(32, 10, 111));
      });
    });

    group('.fromDouble()', () {
      test('creates a new Ratio from double', () {
        expect(Ratio.fromDouble(0), Ratio.zero);
        expect(Ratio.fromDouble(-2 / 3), const Ratio(-2, 3));
        expect(Ratio.fromDouble(0.333), const Ratio.fromMixed(0, 1, 3));
        expect(
          Ratio.fromDouble(0.33334, tolerance: 10000),
          const Ratio.fromMixed(0, 1, 3),
        );
        expect(
          Ratio.fromDouble(0.33334, tolerance: 100000),
          const Ratio.fromMixed(0, 16667, 50000),
        );
        expect(Ratio.fromDouble(1.375), const Ratio.fromMixed(1, 3, 8));
      });

      test('throws an assertion error when arguments are incorrect', () {
        expect(
          () => Ratio.fromDouble(1, tolerance: -1),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.simple', () {
      test('returns the simplified version of this Ratio', () {
        expect(
          const Ratio.fromMixed(0, 1, 3).simple,
          const Ratio.fromMixed(0, 1, 3),
        );
        expect(const Ratio.fromMixed(2).simple, const Ratio.fromMixed(2));
        expect(
          const Ratio.fromMixed(3, 1).simple,
          const Ratio.fromMixed(4),
        );
        expect(
          const Ratio.fromMixed(1, 5, 2).simple,
          const Ratio.fromMixed(3, 1, 2),
        );
      });
    });

    group('.toDouble()', () {
      test('returns this Ratio as a double', () {
        expect(Ratio.zero.toDouble(), 0);
        expect(const Ratio.fromMixed(2).toDouble(), 2);
        expect(const Ratio.fromMixed(0, 1, 3).toDouble(), 1 / 3);
        expect(const Ratio.fromMixed(1, 3, 8).toDouble(), 1.375);
        expect(const Ratio.fromMixed(3, 5, 4).toDouble(), 4.25);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Ratio', () {
        expect(Ratio.zero.toString(), '0');
        expect(const Ratio.fromMixed(3).toString(), '3');
        expect(const Ratio.fromMixed(0, 1, 3).toString(), '1/3');
        expect(const Ratio.fromMixed(3, 5, 4).toString(), '4 1/4');
      });
    });

    group('.compareTo()', () {
      test('sorts Ratios in a collection', () {
        final orderedSet = SplayTreeSet<Ratio>.of({
          Ratio.zero,
          const Ratio.fromMixed(1, 2, 2),
          const Ratio.fromMixed(0, 7, 2),
          const Ratio.fromMixed(0, 1, 9),
        });
        expect(orderedSet.toList(), const [
          Ratio.zero,
          Ratio.fromMixed(0, 1, 9),
          Ratio.fromMixed(1, 2, 2),
          Ratio.fromMixed(0, 7, 2),
        ]);
      });
    });
  });
}
