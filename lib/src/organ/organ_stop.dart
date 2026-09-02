import 'package:meta/meta.dart' show immutable;

import 'pipe_row.dart';

/// An organ stop representation.
@immutable
final class OrganStop {
  /// The name of this [OrganStop].
  final String name;

  /// The disposition of this [OrganStop].
  final List<PipeRow> disposition;

  /// Creates a new [OrganStop].
  const OrganStop({required this.name, this.disposition = const [.eightFeet]});
}
