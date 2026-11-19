import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/music_notes.dart';

/// A keyboard representation.
@immutable
final class Keyboard {
  /// The key extension of this [Keyboard].
  final Range<Pitch> extension;

  /// Creates a new [Keyboard].
  const Keyboard({this.extension = defaultExtension});

  /// The default [Keyboard] extension.
  static const Range<Pitch> defaultExtension = (
    from: Pitch(.c, octave: 2),
    to: Pitch(.g, octave: 6),
  );
}
