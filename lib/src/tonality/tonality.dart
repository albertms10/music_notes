part of '../../music_notes.dart';

@immutable
class Tonality implements Comparable<Tonality> {
  final Note note;
  final Modes mode;

  const Tonality(this.note, this.mode);

  factory Tonality.fromAccidentals(
    int accidentals,
    Modes mode, [
    Accidental accidental = Accidental.natural,
  ]) =>
      Tonality(
        Note.fromTonalityAccidentals(accidentals, mode, accidental),
        mode,
      );

  /// Returns the number of [accidentals] of this [Tonality].
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note.b, Modes.major).accidentals == 5
  /// const Tonality(Note.g, Modes.minor).accidentals == 2
  /// ```
  int get accidentals =>
      Tonality.fromAccidentals(0, mode).note.exactFifthsDistance(note).abs();

  /// Returns the [Accidental] of this [Tonality]’s key signature.
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note.e, Modes.major).accidental == Accidental.sharp
  /// const Tonality(Note.f, Modes.minor).accidental == Accidental.flat
  /// ```
  Accidental get accidental =>
      Tonality.fromAccidentals(0, mode).note.exactFifthsDistance(note) > 0
          ? Accidental.sharp
          : Accidental.flat;

  /// Returns the [Modes.major] or [Modes.minor] relative [Tonality]
  /// of this [Tonality].
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note.d, Modes.minor).relative
  ///   == const Tonality(Note.f, Modes.major)
  ///
  /// const Tonality(Note.bFlat, Modes.major).relative
  ///   == const Tonality(Note.g, Modes.minor)
  /// ```
  Tonality get relative => Tonality(
        EnharmonicNote(note.semitones)
            .transposeBy(
              Interval(
                Intervals.third,
                ImperfectQuality.minor,
                descending: mode == Modes.major,
              ).semitones,
            )
            .toNote(accidental),
        mode.opposite,
      );

  /// Returns the [KeySignature] of this [Tonality].
  ///
  /// Example:
  /// ```dart
  /// const Tonality(Note.a, Modes.major).keySignature
  ///   == const KeySignature(3, Accidental.sharp)
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
