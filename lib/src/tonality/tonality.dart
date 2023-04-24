part of '../../music_notes.dart';

@immutable
class Tonality implements Comparable<Tonality> {
  final Note note;
  final Modes mode;

  const Tonality(this.note, this.mode);

  static const cMajor = Tonality(Note.c, Modes.major);
  static const cMinor = Tonality(Note.c, Modes.minor);

  static const cSharpMajor = Tonality(Note.cSharp, Modes.major);
  static const cSharpMinor = Tonality(Note.cSharp, Modes.minor);
  static const dFlatMajor = Tonality(Note.dFlat, Modes.major);

  static const dMajor = Tonality(Note.d, Modes.major);
  static const dMinor = Tonality(Note.d, Modes.minor);

  static const dSharpMinor = Tonality(Note.dSharp, Modes.minor);
  static const eFlatMajor = Tonality(Note.eFlat, Modes.major);
  static const eFlatMinor = Tonality(Note.eFlat, Modes.minor);

  static const eMajor = Tonality(Note.e, Modes.major);
  static const eMinor = Tonality(Note.e, Modes.minor);

  static const fMajor = Tonality(Note.f, Modes.major);
  static const fMinor = Tonality(Note.f, Modes.minor);

  static const fSharpMajor = Tonality(Note.fSharp, Modes.major);
  static const fSharpMinor = Tonality(Note.fSharp, Modes.minor);
  static const gFlatMajor = Tonality(Note.gFlat, Modes.major);

  static const gMajor = Tonality(Note.g, Modes.major);
  static const gMinor = Tonality(Note.g, Modes.minor);

  static const gSharpMinor = Tonality(Note.gSharp, Modes.minor);
  static const aFlatMajor = Tonality(Note.aFlat, Modes.major);
  static const aFlatMinor = Tonality(Note.aFlat, Modes.minor);

  static const aMajor = Tonality(Note.a, Modes.major);
  static const aMinor = Tonality(Note.a, Modes.minor);

  static const aSharpMinor = Tonality(Note.aSharp, Modes.minor);
  static const bFlatMajor = Tonality(Note.bFlat, Modes.major);
  static const bFlatMinor = Tonality(Note.bFlat, Modes.minor);

  static const bMajor = Tonality(Note.b, Modes.major);
  static const bMinor = Tonality(Note.b, Modes.minor);

  factory Tonality.fromAccidentals(
    int accidentals,
    Modes mode, [
    Accidental accidental = Accidental.natural,
  ]) =>
      Tonality(
        Note.fromTonalityAccidentals(accidentals, mode, accidental),
        mode,
      );

  /// Returns the [Modes.major] or [Modes.minor] relative [Tonality]
  /// of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Tonality.dMinor.relative == Tonality.fMajor
  /// Tonality.bFlatMajor.relative == Tonality.gMinor
  /// ```
  Tonality get relative => Tonality(
        EnharmonicNote(note.semitones)
            .transposeBy(
              Interval.imperfect(
                3 * (mode == Modes.major ? -1 : 1),
                ImperfectQuality.minor,
              ),
            )
            .toClosestNote(keySignature.accidental),
        mode.opposite,
      );

  /// Returns the [KeySignature] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Tonality.cMajor.keySignature == const KeySignature(0)
  /// Tonality.aMajor.keySignature == const KeySignature(3, Accidental.sharp)
  /// Tonality.gFlatMajor.keySignature == const KeySignature(6, Accidental.flat)
  /// ```
  KeySignature get keySignature => KeySignature.fromDistance(
        Tonality.fromAccidentals(0, mode).note.exactFifthsDistance(note),
      );

  @override
  String toString() => '$note ${mode.name}';

  @override
  bool operator ==(Object other) =>
      other is Tonality && note == other.note && mode == other.mode;

  @override
  int get hashCode => hash2(note, mode);

  @override
  int compareTo(covariant Tonality other) => compareMultiple([
        () => note.compareTo(other.note),
        () => mode.name.compareTo(other.mode.name),
      ]);
}
