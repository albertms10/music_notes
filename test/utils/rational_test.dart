import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Rational', () {
    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(() => Rational(1, 0), throwsA(isA<AssertionError>()));
        expect(() => Rational(-3, 0), throwsA(isA<AssertionError>()));
      });

      test('creates a new Rational', () {
        expect(const Rational(10, -8), const Rational.fromMixed(-1, 1, 4));
      });
    });

    group('.fromMixed()', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(
          () => Rational.fromMixed(1, 1, 0),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => Rational.fromMixed(-1, 1, 0),
          throwsA(isA<AssertionError>()),
        );
        expect(() => Rational.fromMixed(1, -1), throwsA(isA<AssertionError>()));
      });
    });

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => Rational.parse('x'), throwsFormatException);
        expect(() => Rational.parse('1 /2'), throwsFormatException);
        expect(() => Rational.parse('1/ 2'), throwsFormatException);
        expect(() => Rational.parse('a 1/2'), throwsFormatException);
        expect(() => Rational.parse('3 e/2'), throwsFormatException);
        expect(() => Rational.parse('3 5/o'), throwsFormatException);
        expect(() => Rational.parse('3 5.o'), throwsFormatException);
        expect(() => Rational.parse('1- 1/5'), throwsFormatException);
        expect(() => Rational.parse('1 -1/5'), throwsFormatException);
      });

      test('parses source as a Rational', () {
        expect(Rational.parse('1 1/2'), const Rational.fromMixed(1, 1, 2));
        expect(Rational.parse('-1 2/3'), const Rational.fromMixed(-1, 2, 3));
        expect(Rational.parse('2'), const Rational(2));
        expect(
          skip: 'TODO: allow fraction only.',
          () => Rational.parse('3/4'),
          const Rational(3, 4),
        );
        expect(Rational.parse('5  3/5'), const Rational.fromMixed(5, 3, 5));
        expect(Rational.parse('4 5/4'), const Rational.fromMixed(4, 5, 4));
        expect(
          Rational.parse('32 10/111'),
          const Rational.fromMixed(32, 10, 111),
        );
        expect(Rational.parse('314'), const Rational.fromMixed(314));
        expect(
          skip: 'TODO: allow fraction only.',
          Rational.parse('-35/4'),
          const Rational.fromMixed(-8, 3, 4),
        );
      });
    });

    group('.fromDouble()', () {
      test('creates a new Rational from double', () {
        expect(Rational.fromDouble(0), Rational.zero);
        expect(Rational.fromDouble(-2 / 3), const Rational(-2, 3));
        expect(Rational.fromDouble(0.333), const Rational.fromMixed(0, 1, 3));
        expect(
          Rational.fromDouble(0.33334, tolerance: 10000),
          const Rational.fromMixed(0, 1, 3),
        );
        expect(
          Rational.fromDouble(0.33334, tolerance: 100000),
          const Rational.fromMixed(0, 16667, 50000),
        );
        expect(Rational.fromDouble(1.375), const Rational.fromMixed(1, 3, 8));
        expect(Rational.fromDouble(2.25), const Rational.fromMixed(2, 1, 4));
      });

      test('throws an assertion error when arguments are incorrect', () {
        expect(
          () => Rational.fromDouble(1, tolerance: -1),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.simple', () {
      test('returns the simplified version of this Rational', () {
        expect(
          const Rational.fromMixed(0, 1, 3).simple,
          const Rational.fromMixed(0, 1, 3),
        );
        expect(const Rational.fromMixed(2).simple, const Rational.fromMixed(2));
        expect(
          const Rational.fromMixed(3, 1).simple,
          const Rational.fromMixed(4),
        );
        expect(
          const Rational.fromMixed(1, 5, 2).simple,
          const Rational.fromMixed(3, 1, 2),
        );
      });
    });

    group('.toInt()', () {
      test('returns this Rational as an int', () {
        expect(Rational.zero.toInt(), 0);
        expect(const Rational.fromMixed(2).toInt(), 2);
        expect(const Rational.fromMixed(0, 1, 3).toInt(), 0);
        expect(const Rational.fromMixed(1, 3, 8).toInt(), 1);
        expect(const Rational.fromMixed(-3, 5, 4).toInt(), -4);
      });
    });

    group('.toDouble()', () {
      test('returns this Rational as a double', () {
        expect(Rational.zero.toDouble(), 0);
        expect(const Rational.fromMixed(2).toDouble(), 2);
        expect(const Rational.fromMixed(0, 1, 3).toDouble(), 1 / 3);
        expect(const Rational.fromMixed(1, 3, 8).toDouble(), 1.375);
        expect(const Rational.fromMixed(-3, 5, 4).toDouble(), -4.25);
      });
    });

    group('.toString()', () {
      test('returns the string representation of this Rational', () {
        expect(Rational.zero.toString(), '0');
        expect(const Rational(3).toString(), '3');
        expect(const Rational(-2, 3).toString(), '-2/3');
        expect(const Rational(-3, 2).toString(), '-1 1/2');
        expect(const Rational.fromMixed(0, 1, 3).toString(), '1/3');
        expect(const Rational.fromMixed(3, 5, 4).toString(), '4 1/4');
        expect(const Rational.fromMixed(-3, 5, 4).toString(), '-4 1/4');
      });
    });

    group('.compareTo()', () {
      test('sorts Ratios in a collection', () {
        final orderedSet = SplayTreeSet<Rational>.of({
          .zero,
          const Rational.fromMixed(1, 2, 2),
          const Rational.fromMixed(0, 7, 2),
          const Rational.fromMixed(0, 1, 9),
        });
        expect(orderedSet.toList(), const <Rational>[
          .zero,
          Rational.fromMixed(0, 1, 9),
          Rational.fromMixed(1, 2, 2),
          Rational.fromMixed(0, 7, 2),
        ]);
      });
    });

    group('operator +()', () {
      test('adds other to this Rational', () {
        expect(const Rational(2, 3) + const Rational(4, 3), const Rational(2));
        expect(
          const Rational(4, 5) + const Rational(-2, 3),
          const Rational(2, 15),
        );
        expect(const Rational(1, 2) + const Rational(1, 2), const Rational(1));
        expect(const Rational(-1, 3) + const Rational(1, 3), Rational.zero);
      });
    });

    group('operator -()', () {
      test('subtracts other from this Rational', () {
        expect(
          const Rational(2, 3) - const Rational(4, 3),
          const Rational(-2, 3),
        );
        expect(
          const Rational(4, 5) - const Rational(-2, 3),
          const Rational(22, 15),
        );
        expect(const Rational(1, 2) - const Rational(1, 2), Rational.zero);
        expect(
          const Rational(-1, 3) - const Rational(1, 3),
          const Rational(-2, 3),
        );
      });

      test('negates this Rational', () {
        expect(-const Rational(2, 3), const Rational(-2, 3));
        expect(-const Rational(-4, 5), const Rational(4, 5));
        expect(-const Rational(1), const Rational(-1));
        expect(-Rational.zero, Rational.zero);
      });
    });

    group('operator *()', () {
      test('multiplies this Rational by other', () {
        expect(
          const Rational(2, 3) * const Rational(4, 3),
          const Rational(8, 9),
        );
        expect(
          const Rational(4, 5) * const Rational(-2, 3),
          const Rational(-8, 15),
        );
        expect(const Rational(1, 2) * const Rational(2), const Rational(1));
        expect(const Rational(-1, 3) * const Rational(3), const Rational(-1));
      });
    });

    group('operator /()', () {
      test('divides this Rational by other', () {
        expect(
          const Rational(2, 3) / const Rational(4, 3),
          const Rational(1, 2),
        );
        expect(
          const Rational(4, 5) / const Rational(-2, 3),
          const Rational(-6, 5),
        );
        expect(const Rational(1, 2) / const Rational(1, 2), const Rational(1));
        expect(
          const Rational(-1, 3) / const Rational(3),
          const Rational(-1, 9),
        );
      });
    });
  });
}
