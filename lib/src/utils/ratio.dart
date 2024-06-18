import 'package:meta/meta.dart' show immutable;

/// A mixed number representation.
@immutable
final class Ratio implements Comparable<Ratio> {
  /// The numerator of the fraction part.
  final int numerator;

  /// The denominator of the fraction part.
  final int denominator;

  /// Creates a new [Ratio] from [numerator] and [denominator].
  const Ratio(this.numerator, this.denominator)
      : assert(denominator != 0, 'The denominator cannot be zero.');

  /// Creates a new [Ratio] from [wholePart], [numerator], and [denominator].
  const Ratio.fromMixed(
    int wholePart, [
    int numerator = 0,
    this.denominator = 1,
  ])  : assert(denominator != 0, 'The denominator cannot be zero.'),
        numerator = wholePart * denominator + numerator;

  /// The reference height of an organ pipe.
  static const reference = Ratio.fromMixed(8);

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
    assert(!number.isNegative, 'Number must be positive.');
    assert(!tolerance.isNegative, 'Tolerance must be positive.');

    final wholePart = number.floor();
    final fracPart = number - wholePart;

    // Approximate the fractional part to a fraction.
    var gcdValue = 1;
    var bestNumerator = 1;
    var bestDenominator = 1;
    var bestError = double.infinity;

    for (var denominator = 1; denominator <= tolerance; ++denominator) {
      final numerator = (fracPart * denominator).round();
      final error = (fracPart - numerator / denominator).abs();
      if (error < bestError) {
        bestError = error;
        bestNumerator = numerator;
        bestDenominator = denominator;
        gcdValue = bestNumerator.gcd(bestDenominator);
      }
      if (error == 0) break;
    }

    // Simplify the fraction.
    bestNumerator ~/= gcdValue;
    bestDenominator ~/= gcdValue;

    // Handle cases where the fractional part is 0 or 1.
    if (bestNumerator == bestDenominator) {
      return Ratio.fromMixed(wholePart + 1);
    }

    return Ratio.fromMixed(wholePart, bestNumerator, bestDenominator);
  }

  /// The simplified version of this [Ratio].
  Ratio get simple => Ratio.fromDouble(toDouble());

  /// This [Ratio] as a [double].
  double toDouble() => numerator / denominator;

  @override
  String toString() {
    final wholePart = numerator ~/ denominator;
    final remainder = numerator % denominator;

    return remainder == 0
        ? '$wholePart'
        : wholePart == 0
            ? '$remainder/$denominator'
            : '$wholePart $remainder/$denominator';
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
