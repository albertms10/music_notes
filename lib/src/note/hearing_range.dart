import '../range.dart';
import 'frequency.dart';

/// A representation of a hearing range.
///
/// See [Hearing range](https://en.wikipedia.org/wiki/Hearing_range).
extension HearingRange on Range<Frequency> {
  /// The human hearing range.
  static const human = (from: 20, to: 20_000) as Range<Frequency>;

  /// Whether [frequency] is audible in this [HearingRange].
  bool isAudibleAt(Frequency frequency) => frequency >= from && frequency <= to;

  /// Formats this [HearingRange] as a string.
  String format() => '${from.format()} ≤ f ≤ ${to.format()}';
}
