import 'package:meta/meta.dart' show immutable;

import 'pipe_row.dart';

/// An organ stop representation.
@immutable
final class OrganStop {
  /// The name of this [OrganStop].
  final String name;

  /// The composition of this [OrganStop].
  final List<PipeRow> composition;

  /// Creates a new [OrganStop].
  const OrganStop({required this.name, this.composition = const [.eightFeet]});
}
