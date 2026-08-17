import '../notation_system/notation_system.dart';
import 'size.dart';

/// A notation system for [Size].
final class SizeNotation extends StringNotationSystem<Size> {
  /// Creates a new [SizeNotation].
  const SizeNotation();

  static const _pattern = r'(?<size>-?\d+)';

  @override
  String get pattern => _pattern;

  @override
  Size parseMatch(RegExpMatch match) => Size(.parse(match.namedGroup('size')!));

  @override
  String format(Size size) => '$size';
}
