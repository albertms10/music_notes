import 'package:meta/meta.dart' show immutable;

import 'num_extension.dart';

/// An exact fraction of two integers, used wherever floating-point error
/// would corrupt a musically meaningful ratio — most notably
/// [FiveLimitTuning]'s just-intonation pitch-class ratios, which are
/// products of small whole numbers (like `3/2` for a pure fifth) that
/// `double` division would only ever approximate.
@immutable
final class Rational implements Comparable<Rational> {
  /// The numerator of this [Rational].
  final int _numerator;

  /// The denominator of this [Rational].
  final int _denominator;

  /// Creates a new [Rational] equal to `numerator / denominator`.
  ///
  /// Example:
  /// ```dart
  /// const Rational(3, 2) // a pure fifth's frequency ratio
  /// ```
  const Rational(this._numerator, [this._denominator = 1])
    : assert(_denominator != 0, 'The denominator cannot be zero.');

  /// A [Rational] of value zero.
  static const zero = Rational(0);

  /// Creates a new [Rational] from a mixed number: [wholePart] plus the
  /// fraction `numerator / _denominator` (e.g. `1 1/2`).
  const Rational.fromMixed(
    int wholePart, [
    int numerator = 0,
    this._denominator = 1,
  ]) : assert(numerator >= 0, 'The numerator cannot be negative.'),
       assert(_denominator != 0, 'The denominator cannot be zero.'),
       _numerator =
           ((wholePart < 0 ? -wholePart : wholePart) * _denominator +
               numerator) *
           (wholePart < 0 ? -1 : 1);

  static final _regExp = RegExp(
    r'^(?<integer>-?\d+)'
    r'(?:(?:\s+(?<numerator>\d+)/(?<denominator>\d+))'
    r'|(?:/(?<fractionDenominator>\d+)))?$',
  );

  /// Parses [source] as a [Rational], accepting a bare integer (`3`), an
  /// improper fraction (`3/4`), or a mixed number (`1 1/2`).
  ///
  /// Example:
  /// ```dart
  /// Rational.parse('1 1/2') == const Rational.fromMixed(1, 1, 2)
  /// Rational.parse('3/4') == const Rational(3, 4)
  /// Rational.parse('-35/4') == const Rational.fromMixed(-8, 3, 4)
  /// ```
  factory Rational.parse(String source) {
    final match =
        _regExp.firstMatch(source) ??
        (throw FormatException('Invalid Ratio', source));

    final integer = int.parse(match.namedGroup('integer')!);
    final numerator = match.namedGroup('numerator');

    if (numerator != null) {
      final denominator = match.namedGroup('denominator')!;

      return .fromMixed(integer, .parse(numerator), .parse(denominator));
    }

    final denominator = match.namedGroup('fractionDenominator');
    if (denominator == null) return .fromMixed(integer);

    return Rational(integer, .parse(denominator));
  }

  /// The best [Rational] approximation of [number], searching denominators
  /// up to [tolerance] for the closest match to its fractional part.
  ///
  /// Raising [tolerance] trades a coarser (but exact) fraction for a
  /// finer approximation of [number]; see [Rational.fromDouble]'s test
  /// cases for how the chosen denominator shifts as tolerance grows.
  factory Rational.fromDouble(double number, {int tolerance = 100}) {
    assert(!tolerance.isNegative, 'Tolerance must be positive.');

    if (number == 0) return .zero;

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

  (int, int) get _canonical {
    final divisor = _numerator.gcd(_denominator);

    return (
      _denominator.nonZeroSign * (_numerator ~/ divisor),
      _denominator.abs() ~/ divisor,
    );
  }

  /// This [Rational] reduced to lowest terms, with the sign carried on the
  /// numerator.
  Rational get simple {
    final (numerator, denominator) = _canonical;

    return Rational(numerator, denominator);
  }

  /// This [Rational] truncated toward zero to an [int], discarding any
  /// fractional part.
  int toInt() => toDouble().toInt();

  /// This [Rational] converted to a [double], which may lose precision for
  /// denominators that aren't exactly representable in base 2.
  double toDouble() => _numerator / _denominator;

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

  /// The sum of this [Rational] and [other].
  ///
  /// ```dart
  /// const Rational(2, 3) + const Rational(4, 3) == const Rational(2)
  /// const Rational(4, 5) + const Rational(-2, 3) == const Rational(2, 15)
  /// ```
  Rational operator +(Rational other) => Rational(
    _numerator * other._denominator + _denominator * other._numerator,
    _denominator * other._denominator,
  );

  /// The difference between this [Rational] and [other].
  ///
  /// ```dart
  /// const Rational(2, 3) - const Rational(4, 3) == const Rational(-2, 3)
  /// const Rational(4, 5) - const Rational(-2, 3) == const Rational(22, 15)
  /// ```
  Rational operator -(Rational other) => Rational(
    _numerator * other._denominator - _denominator * other._numerator,
    _denominator * other._denominator,
  );

  /// The product of this [Rational] and [other].
  ///
  /// ```dart
  /// const Rational(2, 3) * const Rational(4, 3) == const Rational(8, 9)
  /// const Rational(4, 5) * const Rational(-2, 3) == const Rational(-8, 15)
  /// ```
  Rational operator *(Rational other) => Rational(
    _numerator * other._numerator,
    _denominator * other._denominator,
  );

  /// This [Rational] divided by [other].
  ///
  /// ```dart
  /// const Rational(2, 3) / const Rational(4, 3) == const Rational(1, 2)
  /// const Rational(4, 5) / const Rational(-2, 3) == const Rational(-6, 5)
  /// ```
  Rational operator /(Rational other) => Rational(
    _numerator * other._denominator,
    _denominator * other._numerator,
  );

  /// The negation of this [Rational].
  ///
  /// ```dart
  /// -const Rational(2, 3) == const Rational(-2, 3)
  /// -const Rational(-4, 5) == const Rational(4, 5)
  /// ```
  Rational operator -() => Rational(-_numerator, _denominator);

  /// Whether this [Rational] and [other] represent the same exact value,
  /// regardless of how each fraction happens to be reduced (e.g. `1/2`
  /// equals `2/4`).
  @override
  bool operator ==(Object other) =>
      other is Rational &&
      _numerator * other._denominator == other._numerator * _denominator;

  @override
  int get hashCode {
    final (numerator, denominator) = _canonical;

    return Object.hash(numerator, denominator);
  }

  @override
  int compareTo(Rational other) {
    final diff = this - other;
    if (diff._numerator > 0) return 1;
    if (diff._numerator < 0) return -1;
    return 0;
  }
}

/// [Organ pipe length](https://en.wikipedia.org/wiki/Pipe_organ#Pipe_length)
/// conventions expressed as [Rational] ratios of feet, the traditional way
/// organists name a stop's pitch (e.g. an "8 foot" stop sounds at written
/// pitch, a "4 foot" stop an octave higher).
extension OrganPipeHeight on Rational {
  /// The unison ([Interval.P1]) reference length: an 8-foot pipe.
  static const reference = Rational.fromMixed(8);
}
