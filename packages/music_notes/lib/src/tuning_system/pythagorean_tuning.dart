import 'just_intonation.dart';

/// A representation of the three-limit (a.k.a. Pythagorean) tuning formatter.
///
/// See [Pythagorean tuning](https://en.wikipedia.org/wiki/Pythagorean_tuning).
class PythagoreanTuning extends JustIntonation {
  /// Creates a new [PythagoreanTuning] from [fork].
  const PythagoreanTuning({super.fork});

  /// See [Pythagorean comma](https://en.wikipedia.org/wiki/Pythagorean_comma).
  num get pythagoreanComma => ratio(fork.pitch.transposeBy(.d2.descending));
}
