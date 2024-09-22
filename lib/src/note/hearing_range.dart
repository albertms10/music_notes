import 'package:meta/meta.dart' show immutable;

import 'frequency.dart';

/// A representation of a hearing range.
///
/// See [Hearing range](https://en.wikipedia.org/wiki/Hearing_range).
@immutable
class HearingRange {
  /// The lowest bound of this [HearingRange].
  final Frequency min;

  /// The highest bound of this [HearingRange].
  final Frequency max;

  /// Creates a new [HearingRange].
  const HearingRange({required this.min, required this.max});

  /// The human hearing range.
  static const human = HearingRange(min: Frequency(20), max: Frequency(20000));

  /// Whether [frequency] is audible in this [HearingRange].
  bool isAudibleAt(Frequency frequency) => frequency >= min && frequency <= max;

  @override
  String toString() => '${min.format()} ≤ f ≤ ${max.format()}';

  @override
  bool operator ==(Object other) =>
      other is HearingRange && min == other.min && max == other.max;

  @override
  int get hashCode => Object.hash(min, max);
}
