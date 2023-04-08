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
  int get accidentals => exactFifthsDistance(
        Tonality.fromAccidentals(0, mode).note,
        note,
      ).abs();

  /// Returns the [Accidental] of this [Tonality]’s key signature.
  ///
  /// Examples:
  /// ```dart
  /// const Tonality(Note.e, Modes.major).accidental == Accidental.sharp
  /// const Tonality(Note.f, Modes.minor).accidental == Accidental.flat
  /// ```
  Accidental get accidental => exactFifthsDistance(
            Tonality.fromAccidentals(0, mode).note,
            note,
          ) >
          0
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
                Qualities.minor,
                descending: mode == Modes.major,
              ).semitones,
            )
            .note(accidental),
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
        exactFifthsDistance(
          Tonality.fromAccidentals(0, mode).note,
          note,
        ),
      );

  @override
  String toString() => '${mode.name} $note';

  @override
  bool operator ==(Object other) =>
      other is Tonality && note == other.note && mode == other.mode;

  @override
  int get hashCode => hash2(note, mode);

  @override
  int compareTo(covariant Tonality other) => compareMultiple([
        () => accidental.semitones.compareTo(other.accidental.semitones),
        () => accidentals.compareTo(other.accidentals),
      ]);
}
