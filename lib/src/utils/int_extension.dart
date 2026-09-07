import 'num_extension.dart';

/// Integer arithmetic tuned for signed, one-indexed musical distances (e.g.
/// [Accidental] semitones, fifths distances), where zero either never
/// occurs or must be replaced with a full-cycle value.
extension IntExtension on int {
  /// This [int]'s magnitude increased by [step] while its sign is kept
  /// (or flipped, if [step] is negative enough to cross zero).
  ///
  /// Unlike plain addition, this always moves further from zero for a
  /// positive [step] regardless of this [int]'s sign, which is what lets
  /// [KeySignature.incrementBy] add sharps to a flat-side signature (and
  /// vice versa) by magnitude rather than by raw arithmetic.
  ///
  /// Example:
  /// ```dart
  /// 1.incrementBy(1) == 2
  /// (-1).incrementBy(1) == -2
  /// 10.incrementBy(-2) == 8
  /// (-10).incrementBy(-2) == -8
  /// ```
  int incrementBy(int step) => (abs() + step) * nonZeroSign;

  /// This [int] modulo [n], except a would-be `0` result is reported as
  /// [n] instead — useful for one-indexed cycles (like the seven letter
  /// names of [NoteName]) where "zero" really means "a full cycle back".
  ///
  /// Example:
  /// ```dart
  /// 9.nonZeroMod(3) == 3
  /// 7.nonZeroMod(7) == 7
  /// 0.nonZeroMod(5) == 5
  /// ```
  int nonZeroMod(int n) {
    final mod = this % n;

    return mod == 0 ? n : mod;
  }
}
