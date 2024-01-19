part of '../../music_notes.dart';

/// A musical tonality.
///
/// ---
/// See also:
/// * [Note].
/// * [Mode].
@immutable
final class Tonality implements Comparable<Tonality> {
  /// The tonal center representing this [Tonality].
  final Note note;

  /// The mode representing this [Tonality].
  final TonalMode mode;

  /// Creates a new [Tonality] from [note] and [mode].
  const Tonality(this.note, this.mode);

  /// Returns the [TonalMode.major] or [TonalMode.minor] relative [Tonality]
  /// of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.relative == Note.f.major
  /// Note.b.flat.major.relative == Note.g.minor
  /// ```
  Tonality get relative => Tonality(
        note.transposeBy(
          Interval.m3.descending(isDescending: mode == TonalMode.major),
        ),
        mode.opposite,
      );

  /// Returns the [TonalMode.major] or [TonalMode.minor] parallel [Tonality]
  /// of this [Tonality].
  ///
  /// See [Parallel key](https://en.wikipedia.org/wiki/Parallel_key).
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.parallel == Note.d.major
  /// Note.b.flat.major.parallel == Note.b.flat.minor
  /// ```
  Tonality get parallel => Tonality(note, mode.opposite);

  /// Returns the [KeySignature] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.keySignature == KeySignature.empty
  /// Note.a.major.keySignature == KeySignature.fromDistance(3)
  /// Note.g.flat.major.keySignature == KeySignature.fromDistance(-6)
  /// ```
  KeySignature get keySignature => KeySignature.fromDistance(
        KeySignature.empty.tonality(mode)!.note.fifthsDistanceWith(note),
      );

  /// Returns the scale notes of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scale == const Scale([Note.c, Note.d, Note.e, Note.f, Note.g,
  ///   Note.a, Note.b, Note.c])
  ///
  /// Note.e.minor.scale == Scale([Note.e, Note.f.sharp, Note.g, Note.a, Note.b,
  ///   Note.d, Note.d, Note.e])
  /// ```
  Scale<Note> get scale => mode.scale.on(note);

  @override
  String toString({NoteNotation system = NoteNotation.english}) =>
      system.tonality(this);

  @override
  bool operator ==(Object other) =>
      other is Tonality && note == other.note && mode == other.mode;

  @override
  int get hashCode => Object.hash(note, mode);

  @override
  int compareTo(Tonality other) => compareMultiple([
        () => note.compareTo(other.note),
        () => mode.name.compareTo(other.mode.name),
      ]);
}
