part of '../../music_notes.dart';

/// A note octave in the octave range.
final class PositionedNote
    implements Comparable<PositionedNote>, Transposable<PositionedNote> {
  /// Which of the 12 notes inside the octave.
  final Note note;

  /// The octave where the [note] is positioned.
  final int octave;

  /// Creates a new [PositionedNote] from [Note] arguments and [octave].
  const PositionedNote(this.note, [this.octave = 4]);

  /// Returns the [octave] that corresponds to the semitones from root height.
  ///
  /// Example:
  /// ```dart
  /// PositionedNote.octaveFromSemitones(1) == 0
  /// PositionedNote.octaveFromSemitones(34) == 2
  /// PositionedNote.octaveFromSemitones(49) == 4
  /// ```
  static int octaveFromSemitones(int semitones) =>
      ((semitones.abs() - semitones.sign) * semitones.sign / chromaticDivisions)
          .floor();

  /// Returns the number of semitones of this [PositionedNote] from C0 (root).
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).semitones == 58
  /// Note.a.inOctave(2).semitones == 34
  /// Note.c.inOctave(0).semitones == 1
  /// ```
  int get semitones => note.semitones + octave * chromaticDivisions;

  /// Returns the difference in semitones between this [PositionedNote] and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).difference(Note.d.inOctave(4)) == 2
  /// Note.eFlat.inOctave(4).difference(Note.bFlat.inOctave(4)) == 7
  /// Note.a.inOctave(4).difference(Note.g.inOctave(4)) == -2
  /// ```
  int difference(PositionedNote other) => other.semitones - semitones;

  /// Returns a transposed [PositionedNote] by [interval]
  /// from this [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.g.inOctave(4).transposeBy(Interval.perfectFifth)
  ///   == Note.d.inOctave(5)
  /// Note.dFlat.inOctave(2).transposeBy(-Interval.majorSecond)
  ///   == Note(Notes.c, Accidental.flat).inOctave(2)
  /// ```
  @override
  PositionedNote transposeBy(Interval interval) {
    final transposedNote = note.transposeBy(interval);

    return transposedNote.inOctave(
      octaveFromSemitones(
        semitones +
            interval.semitones -
            // We don't want to take the accidental into account when
            // calculating the octave height, as it depends on the note name.
            // This correctly handles cases with the same number of accidentals
            // but different octaves (e.g., C♭4 but B3).
            transposedNote.accidental.semitones,
      ),
    );
  }

  /// Returns the equal temperament [Frequency] of this [PositionedNote] from
  /// the A4 note [reference].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).equalTemperamentFrequency() == const Frequency(440)
  /// Note.gSharp.inOctave(4).equalTemperamentFrequency()
  ///   == const Frequency(415.3)
  /// Note.c.inOctave(4).equalTemperamentFrequency() == const Frequency(261.63)
  /// Note.a.inOctave(4).equalTemperamentFrequency(const Frequency(338))
  ///   == const Frequency(338)
  /// Note.bFlat.inOctave(4).equalTemperamentFrequency(const Frequency(338))
  ///   == const Frequency(464.04)
  /// ```
  Frequency equalTemperamentFrequency([
    Frequency reference = const Frequency(440),
  ]) =>
      Frequency(
        reference.hertz *
            math.pow(sqrt12_2, Note.a.inOctave(4).difference(this)),
      );

  /// Returns the string representation of this [Note] following the
  /// [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation).
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).scientificName == 'C4'
  /// Note.a.inOctave(3).scientificName == 'A3'
  /// Note.bFlat.inOctave(1).scientificName == 'B♭1'
  /// ```
  String get scientificName => '${note.note.name.toUpperCase()}'
      '${note.accidental != Accidental.natural ? note.accidental.symbol : ''}'
      '$octave';

  /// Returns the string representation of this [Note] following
  /// [Helmholtz’s pitch notation](https://en.wikipedia.org/wiki/Helmholtz_pitch_notation).
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).helmholtzName == 'c′'
  /// Note.a.inOctave(3).helmholtzName == 'a'
  /// Note.bFlat.inOctave(1).helmholtzName == 'B♭͵'
  /// ```
  String get helmholtzName {
    final accidentalSymbol =
        note.accidental != Accidental.natural ? note.accidental.symbol : '';

    if (octave >= 3) {
      const superPrime = '′';

      return '${note.note.name}$accidentalSymbol${superPrime * (octave - 3)}';
    }

    const subPrime = '͵';

    return '${note.note.name.toUpperCase()}$accidentalSymbol'
        '${subPrime * (octave - 2).abs()}';
  }

  @override
  String toString() => scientificName;

  @override
  bool operator ==(Object other) =>
      other is PositionedNote && note == other.note && octave == other.octave;

  @override
  int get hashCode => Object.hash(super.hashCode, octave);

  @override
  int compareTo(PositionedNote other) => compareMultiple([
        () => octave.compareTo(other.octave),
        () => note.compareTo(other.note),
      ]);
}
