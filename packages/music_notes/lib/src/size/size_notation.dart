import '../notation_system/notation_system.dart';
import 'size.dart';

/// A notation system for [Size].
final class SizeNotation extends StringNotationSystem<Size> {
  /// Creates a new [SizeNotation].
  const SizeNotation();

  static final _regExp = RegExp(r'(?<size>-?\d+)');

  @override
  RegExp get regExp => _regExp;

  @override
  Size parseMatch(RegExpMatch match) => Size(.parse(match.namedGroup('size')!));

  @override
  String format(Size size) => '$size';
}
