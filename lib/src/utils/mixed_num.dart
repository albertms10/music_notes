import 'package:meta/meta.dart' show immutable;

/// A mixed number representation.
@immutable
final class MixedNum implements Comparable<MixedNum> {
  /// The whole part.
  final int integer;

  /// The numerator of the fraction part.
  final int numerator;

  /// The denominator of the fraction part.
  final int denominator;

  /// Creates a new [MixedNum] from [integer], [numerator], and [denominator].
  const MixedNum(this.integer, [this.numerator = 0, this.denominator = 1])
      : assert(
          integer >= 0,
          'The whole part must be greater or equal than zero.',
        ),
        assert(
          numerator >= 0,
          'The denominator must be greater or equal than zero.',
        ),
        assert(
          denominator > 0,
          'The denominator must be greater than zero.',
        );

  /// The reference height of an organ pipe.
  static const reference = MixedNum(8);

  static final _regExp = RegExp(r'^(-?\d+)\s*(?:(\d+)/(\d+))?$');

  /// Parses source as a [MixedNum].
  factory MixedNum.parse(String source) {
    final match = _regExp.firstMatch(source);
    if (match == null || match[0] == null) {
      throw FormatException('Invalid MixedNum', source);
    }

    final integer = int.parse(match[1]!);
    if (match[2] == null) return MixedNum(integer);

    final numerator = int.parse(match[2]!);
    final denominator = int.parse(match[3]!);

    return MixedNum(integer, numerator, denominator);
  }

  /// Creates a new [MixedNum] from [number] and [tolerance].
  factory MixedNum.fromDouble(double number, {int tolerance = 100}) {
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
    if (bestNumerator == bestDenominator) return MixedNum(wholePart + 1);

    return MixedNum(wholePart, bestNumerator, bestDenominator);
  }

  /// The simplified version of this [MixedNum].
  MixedNum get simple => MixedNum.fromDouble(toDouble());

  /// This [MixedNum] as a [double].
  double toDouble() => integer + _fractionPart;

  double get _fractionPart => numerator / denominator;

  @override
  String toString() => _fractionPart == 0
      ? '$integer'
      : integer == 0
          ? '$numerator/$denominator'
          : '$integer $numerator/$denominator';

  @override
  bool operator ==(Object other) =>
      (other is num && other == toDouble()) ||
      (other is MixedNum && other.toDouble() == toDouble());

  @override
  int get hashCode => toDouble().hashCode;

  @override
  int compareTo(MixedNum other) => toDouble().compareTo(other.toDouble());
}
