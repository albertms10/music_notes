part of '../../music_notes.dart';

@immutable
final class Tonality implements Comparable<Tonality> {
  final Note note;
  final TonalMode mode;

  const Tonality(this.note, this.mode);

  factory Tonality.fromAccidentals(
    int accidentals,
    TonalMode mode, [
    Accidental accidental = Accidental.natural,
  ]) =>
      Tonality(
        Note.fromTonalityAccidentals(accidentals, mode, accidental),
        mode,
      );

  /// Returns the [TonalMode.major] or [TonalMode.minor] relative [Tonality]
  /// of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Note.d.minor.relative == Note.f.major
  /// Note.bFlat.major.relative == Note.g.minor
  /// ```
  Tonality get relative => Tonality(
        note.transposeBy(
          Interval.minorThird.descending(isDescending: mode == TonalMode.major),
        ),
        mode.opposite,
      );

  /// Returns the [KeySignature] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.keySignature == const KeySignature(0)
  /// Note.a.major.keySignature == const KeySignature(3, Accidental.sharp)
  /// Note.gFlat.major.keySignature == const KeySignature(6, Accidental.flat)
  /// ```
  KeySignature get keySignature => KeySignature.fromDistance(
        Tonality.fromAccidentals(0, mode).note.exactFifthsDistance(note),
      );

  /// Returns the scale notes of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Note.c.major.scaleNotes
  ///   == const [Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///        Note.c]
  ///
  /// Note.e.minor.scaleNotes
  ///   == const [Note.e, Note.fSharp, Note.g, Note.a, Note.b, Note.d, Note.d,
  ///        Note.e]
  /// ```
  List<Note> get scaleNotes => mode.scale.fromNote(note);

  @override
  String toString() => '$note ${mode.name}';

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
