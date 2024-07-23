// ignore_for_file: constant_identifier_names

import 'package:meta/meta.dart' show immutable;

import 'num_extension.dart';

/// An exact ratio representation with numerator and denominator.
@immutable
final class Ratio implements Comparable<Ratio> {
  /// The numerator of the fraction part.
  final int numerator;

  /// The denominator of the fraction part.
  final int denominator;

  /// Creates a new [Ratio] from [numerator] and [denominator].
  const Ratio(this.numerator, [this.denominator = 1])
      : assert(denominator != 0, 'The denominator cannot be zero.');

  /// A [Ratio] of value zero.
  static const zero = Ratio(0);

  /// Creates a new [Ratio] from [wholePart], [numerator], and [denominator].
  const Ratio.fromMixed(
    int wholePart, [
    int numerator = 0,
    this.denominator = 1,
  ])  : assert(numerator >= 0, 'The numerator cannot be negative.'),
        assert(denominator != 0, 'The denominator cannot be zero.'),
        numerator = ((wholePart < 0 ? -wholePart : wholePart) * denominator +
                numerator) *
            (wholePart < 0 ? -1 : 1);

  static final _regExp = RegExp(r'^(-?\d+)\s*(?:(\d+)/(\d+))?$');

  /// Parses source as a [Ratio].
  factory Ratio.parse(String source) {
    final match = _regExp.firstMatch(source);
    if (match == null || match[0] == null) {
      throw FormatException('Invalid Ratio', source);
    }

    final integer = int.parse(match[1]!);
    if (match[2] == null) return Ratio.fromMixed(integer);

    final numerator = int.parse(match[2]!);
    final denominator = int.parse(match[3]!);

    return Ratio.fromMixed(integer, numerator, denominator);
  }

  /// Creates a new [Ratio] from [number] and [tolerance].
  factory Ratio.fromDouble(double number, {int tolerance = 100}) {
    assert(!tolerance.isNegative, 'Tolerance must be positive.');

    if (number == 0) return Ratio.zero;

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

    return Ratio(numerator, bestDenominator);
  }

  /// The simplified version of this [Ratio].
  Ratio get simple => Ratio.fromDouble(toDouble());

  /// This [Ratio] as a [double].
  double toDouble() => numerator / denominator;

  @override
  String toString() {
    final absNumerator = numerator.abs();
    final wholePart = absNumerator ~/ denominator;
    final remainder = absNumerator % denominator;

    return (numerator.isNegative ? '-' : '') +
        (remainder == 0
            ? '$wholePart'
            : wholePart == 0
                ? '$remainder/$denominator'
                : '$wholePart $remainder/$denominator');
  }

  @override
  bool operator ==(Object other) =>
      (other is num && other == toDouble()) ||
      (other is Ratio && other.toDouble() == toDouble());

  @override
  int get hashCode => toDouble().hashCode;

  @override
  int compareTo(Ratio other) => toDouble().compareTo(other.toDouble());
}

/// An organ pipe height extension.
extension OrganPipeHeight on Ratio {
  /// The reference height [Ratio] of an organ pipe.
  static const reference = Ratio.fromMixed(8);
}
