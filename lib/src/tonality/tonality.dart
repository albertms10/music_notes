part of '../../music_notes.dart';

@immutable
class Tonality implements Comparable<Tonality> {
  final Note note;
  final TonalMode mode;

  const Tonality(this.note, this.mode);

  static const cMajor = Tonality(Note.c, TonalMode.major);
  static const cMinor = Tonality(Note.c, TonalMode.minor);

  static const cSharpMajor = Tonality(Note.cSharp, TonalMode.major);
  static const cSharpMinor = Tonality(Note.cSharp, TonalMode.minor);
  static const dFlatMajor = Tonality(Note.dFlat, TonalMode.major);

  static const dMajor = Tonality(Note.d, TonalMode.major);
  static const dMinor = Tonality(Note.d, TonalMode.minor);

  static const dSharpMinor = Tonality(Note.dSharp, TonalMode.minor);
  static const eFlatMajor = Tonality(Note.eFlat, TonalMode.major);
  static const eFlatMinor = Tonality(Note.eFlat, TonalMode.minor);

  static const eMajor = Tonality(Note.e, TonalMode.major);
  static const eMinor = Tonality(Note.e, TonalMode.minor);

  static const fMajor = Tonality(Note.f, TonalMode.major);
  static const fMinor = Tonality(Note.f, TonalMode.minor);

  static const fSharpMajor = Tonality(Note.fSharp, TonalMode.major);
  static const fSharpMinor = Tonality(Note.fSharp, TonalMode.minor);
  static const gFlatMajor = Tonality(Note.gFlat, TonalMode.major);

  static const gMajor = Tonality(Note.g, TonalMode.major);
  static const gMinor = Tonality(Note.g, TonalMode.minor);

  static const gSharpMinor = Tonality(Note.gSharp, TonalMode.minor);
  static const aFlatMajor = Tonality(Note.aFlat, TonalMode.major);
  static const aFlatMinor = Tonality(Note.aFlat, TonalMode.minor);

  static const aMajor = Tonality(Note.a, TonalMode.major);
  static const aMinor = Tonality(Note.a, TonalMode.minor);

  static const aSharpMinor = Tonality(Note.aSharp, TonalMode.minor);
  static const bFlatMajor = Tonality(Note.bFlat, TonalMode.major);
  static const bFlatMinor = Tonality(Note.bFlat, TonalMode.minor);

  static const bMajor = Tonality(Note.b, TonalMode.major);
  static const bMinor = Tonality(Note.b, TonalMode.minor);

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
  /// Tonality.dMinor.relative == Tonality.fMajor
  /// Tonality.bFlatMajor.relative == Tonality.gMinor
  /// ```
  Tonality get relative => Tonality(
        note.transposeBy(
          Interval.imperfect(
            3 * (mode == TonalMode.major ? -1 : 1),
            ImperfectQuality.minor,
          ),
        ),
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

  /// Returns the scale notes of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// Tonality.cMajor.scaleNotes
  ///   == const [Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///        Note.c]
  ///
  /// Tonality.eMinor.scaleNotes
  ///   == const [Note.e, Note.fSharp, Note.g, Note.a, Note.b, Note.d, Note.d,
  ///        Note.e]
  /// ```
  List<Transposable<Note>> get scaleNotes => mode.scale.fromNote(note);

  @override
  String toString() => '$note ${mode.name}';

  @override
  bool operator ==(Object other) =>
      other is Tonality && note == other.note && mode == other.mode;

  @override
  int get hashCode => Object.hash(note, mode);

  @override
  int compareTo(covariant Tonality other) => compareMultiple([
        () => note.compareTo(other.note),
        () => mode.name.compareTo(other.mode.name),
      ]);
}
