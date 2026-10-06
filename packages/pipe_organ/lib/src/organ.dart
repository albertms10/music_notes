import 'package:meta/meta.dart' show immutable;

import 'keyboard.dart';
import 'organ_stop.dart';

/// An organ representation.
@immutable
final class Organ {
  /// The list of keyboards of this [Organ].
  final List<Keyboard> keyboards;

  /// The list of stops of this [Organ].
  final List<OrganStop> stops;

  /// Creates a new [Organ].
  const Organ({
    required this.stops,
    this.keyboards = const [Keyboard()],
  });
}
