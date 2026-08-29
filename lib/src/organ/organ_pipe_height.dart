import 'package:music_notes/utils.dart';

import '../cent/cent.dart';
import '../interval/interval.dart';

/// An organ pipe height extension.
extension OrganPipeHeight on Rational {
  /// The reference height of an organ pipe.
  static const reference = Rational.fromMixed(8);

  /// The tempered [Interval] a rank of `this` length sounds above the
  /// 8' unison.
  ///
  /// Real pipes are voiced to the tempered scale, not the pure physical
  /// ratio, so the raw [Cent] value (which *would* carry the ~2-cent
  /// deviation for fifth-based ranks, e.g. 5 1/3', 2 2/3') is rounded to
  /// the nearest semitone.
  ///
  /// Example:
  /// ```dart
  /// const Rational(8).interval == .P1
  /// const Rational(4).interval == .P8
  /// const Rational.fromMixed(2, 2, 3).interval == .P12
  /// ```
  Interval get interval => .fromSemitones(
    (Cent.fromRatio((reference / this).toDouble()) / Cent.divisionsPerSemitone)
        .round(),
  );
}
