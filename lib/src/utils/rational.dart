import 'package:meta/meta.dart' show immutable;

import 'num_extension.dart';

/// A rational representation with numerator and denominator.
@immutable
final class Rational implements Comparable<Rational> {
  /// The numerator of this [Rational].
  final int _numerator;

  /// The denominator of this [Rational].
  final int _denominator;

  /// Creates a new [Rational] from [_numerator] and [_denominator].
  const Rational(this._numerator, [this._denominator = 1])
      : assert(_denominator != 0, 'The denominator cannot be zero.');

  /// A [Rational] of value zero.
  static const zero = Rational(0);

  /// Creates a new [Rational] from [wholePart], [numerator],
  /// and [_denominator].
  const Rational.fromMixed(
    int wholePart, [
    int numerator = 0,
    this._denominator = 1,
  ])  : assert(numerator >= 0, 'The numerator cannot be negative.'),
        assert(_denominator != 0, 'The denominator cannot be zero.'),
        _numerator = ((wholePart < 0 ? -wholePart : wholePart) * _denominator +
                numerator) *
            (wholePart < 0 ? -1 : 1);

  static final _regExp = RegExp(r'^(-?\d+)\s*(?:(\d+)/(\d+))?$');

  static const _defaultTolerance = 100;

  /// Parses source as a [Rational].
  factory Rational.parse(String source) {
    final match = _regExp.firstMatch(source);
    if (match == null || match[0] == null) {
      return throw FormatException('Invalid Ratio', source);
    }

    final integer = int.parse(match[1]!);
    if (match[2] == null) return Rational.fromMixed(integer);

    final numerator = int.parse(match[2]!);
    final denominator = int.parse(match[3]!);

    return Rational.fromMixed(integer, numerator, denominator);
  }

  /// Creates a new [Rational] from [number] and [tolerance].
  factory Rational.fromDouble(
    double number, {
    int tolerance = _defaultTolerance,
  }) {
    assert(!tolerance.isNegative, 'Tolerance must be positive.');

    if (number == 0) return Rational.zero;

    final sign = number.nonZeroSign;
    final absNumber = number.abs();

    final wholePart = absNumber.floor();
    final fractionalPart = absNumber - wholePart;

    var bestNumerator = 1;
    var bestDenominator = 1;
    var minError = (fractionalPart - (bestNumerator / bestDenominator)).abs();

    for (var denominator = 1; denominator <= tolerance; denominator++) {
      final numerator = (fractionalPart * denominator).round();
      final approximation = numerator / denominator;
      final error = (fractionalPart - approximation).abs();

      if (error < minError) {
        bestNumerator = numerator;
        bestDenominator = denominator;
        minError = error;
      }
    }

    final numerator = sign * (wholePart * bestDenominator + bestNumerator);

    return Rational(numerator, bestDenominator);
  }

  /// The simplified version of this [Rational].
  Rational get simple {
    final divisor = _numerator.gcd(_denominator);

    return Rational(
      _denominator.nonZeroSign * (_numerator ~/ divisor),
      _denominator.abs() ~/ divisor,
    );
  }

  /// This [Rational] as a [double].
  double toDouble() => _numerator / _denominator;

  /// Truncates this [Rational] to an integer and returns the result as an
  /// [int].
  int toInt() => toDouble().toInt();

  @override
  String toString() {
    final absNumerator = _numerator.abs();
    final wholePart = absNumerator ~/ _denominator;
    final remainder = absNumerator % _denominator;

    return (_numerator.isNegative ? '-' : '') +
        (remainder == 0
            ? '$wholePart'
            : wholePart == 0
                ? '$remainder/$_denominator'
                : '$wholePart $remainder/$_denominator');
  }

  /// Adds this [Rational] to [other].
  ///
  /// ```dart
  /// const Rational(2, 3) + const Rational(4, 3) == const Rational(2)
  /// const Rational(4, 5) + const Rational(-2, 3) == const Rational(2, 15)
  /// ```
  Rational operator +(Rational other) => Rational(
        _numerator * other._denominator + _denominator * other._numerator,
        _denominator * other._denominator,
      );

  /// Subtracts [other] from this [Rational].
  ///
  /// ```dart
  /// const Rational(2, 3) - const Rational(4, 3) == const Rational(-2, 3)
  /// const Rational(4, 5) - const Rational(-2, 3) == const Rational(22, 15)
  /// ```
  Rational operator -(Rational other) => Rational(
        _numerator * other._denominator - _denominator * other._numerator,
        _denominator * other._denominator,
      );

  /// Multiplies this [Rational] with [other].
  ///
  /// ```dart
  /// const Rational(2, 3) * const Rational(4, 3) == const Rational(8, 9)
  /// const Rational(4, 5) * const Rational(-2, 3) == const Rational(-8, 15)
  /// ```
  Rational operator *(Rational other) => Rational(
        _numerator * other._numerator,
        _denominator * other._denominator,
      );

  /// Divides this [Rational] with [other].
  ///
  /// ```dart
  /// const Rational(2, 3) / const Rational(4, 3) == const Rational(1, 2)
  /// const Rational(4, 5) / const Rational(-2, 3) == const Rational(-6, 5)
  /// ```
  Rational operator /(Rational other) => Rational(
        _numerator * other._denominator,
        _denominator * other._numerator,
      );

  /// Negates this [Rational].
  ///
  /// ```dart
  /// -const Rational(2, 3) == const Rational(-2, 3)
  /// -const Rational(-4, 5) == const Rational(4, 5)
  /// ```
  Rational operator -() => Rational(-_numerator, _denominator);

  @override
  bool operator ==(Object other) =>
      (other is num && other == toDouble()) ||
      (other is Rational && other.toDouble() == toDouble());

  @override
  int get hashCode => toDouble().hashCode;

  @override
  int compareTo(Rational other) {
    final diff = this - other;
    if (diff._numerator > 0) return 1;
    if (diff._numerator < 0) return -1;
    return 0;
  }
}

/// An organ pipe height extension.
extension OrganPipeHeight on Rational {
  /// The reference height of an organ pipe.
  static const reference = Rational.fromMixed(8);
}
