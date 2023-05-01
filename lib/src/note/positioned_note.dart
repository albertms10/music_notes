part of '../../music_notes.dart';

/// A note octave in the octave range.
class PositionedNote extends Note {
  /// The octave where this [PositionedNote] is.
  final int octave;

  /// Creates a new [PositionedNote] from [Note] arguments and [octave].
  const PositionedNote(super.note, [super.accidental, this.octave = 4]);

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

  /// Returns the number of semitones of this [PositionedNote] from the root
  /// height.
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).semitonesFromRootHeight == 49
  /// Note.a.inOctave(2).semitonesFromRootHeight == 34
  /// Note.c.inOctave(0).semitonesFromRootHeight == 1
  /// ```
  int get semitonesFromRootHeight => semitones + octave * chromaticDivisions;

  /// Returns the difference in semitones between this [PositionedNote] and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).difference(Note.d.inOctave(4)) == 2
  /// Note.eFlat.inOctave(4).difference(Note.bFlat.inOctave(4)) == 7
  /// Note.a.inOctave(4).difference(Note.g.inOctave(4)) == -2
  /// ```
  @override
  int difference(covariant PositionedNote other) =>
      other.semitonesFromRootHeight - semitonesFromRootHeight;

  @override
  PositionedNote transposeBy(Interval interval) {
    final transposedNote = super.transposeBy(interval);

    return transposedNote.inOctave(
      octaveFromSemitones(
        semitonesFromRootHeight +
            interval.semitones -
            // We don't want to take the accidental into account when
            // calculating the octave height, as it depends on the note name.
            // This correctly handles the case for, e.g., C♭4 == B3.
            transposedNote.accidental.semitones,
      ),
    );
  }

  /// Returns the equal temperament frequency in Hertzs of this [PositionedNote]
  /// from the A4 note reference.
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).equalTemperamentFrequency() == 440
  /// Note.gSharp.inOctave(4).equalTemperamentFrequency() == 415.3
  /// Note.c.inOctave(4).equalTemperamentFrequency() == 261.63
  /// Note.a.inOctave(4).equalTemperamentFrequency(338) == 338
  /// Note.bFlat.inOctave(4).equalTemperamentFrequency(338) == 464.04
  /// ```
  double equalTemperamentFrequency([double a4Hertzs = 440]) =>
      a4Hertzs * math.pow(sqrt12_2, Note.a.inOctave(4).difference(this));

  /// Whether this [Note] is inside the human hearing range.
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).isHumanAudible == true
  /// Note.d.inOctave(0).isHumanAudible == false
  /// Note.g.inOctave(12).isHumanAudible == false
  /// ```
  bool get isHumanAudible {
    final frequency = equalTemperamentFrequency();
    const minFrequency = 20;
    const maxFrequency = 20000;

    return frequency >= minFrequency && frequency <= maxFrequency;
  }

  /// Returns the string representation of this [Note] following the
  /// [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation).
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).scientificName == 'C4'
  /// Note.a.inOctave(3).scientificName == 'A3'
  /// Note.bFlat.inOctave(1).scientificName == 'B♭1'
  /// ```
  String get scientificName => '${note.name.toUpperCase()}'
      '${accidental != Accidental.natural ? accidental.symbol : ''}'
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
        accidental != Accidental.natural ? accidental.symbol : '';

    if (octave >= 3) {
      const superPrime = '′';

      return '${note.name}$accidentalSymbol${superPrime * (octave - 3)}';
    }

    const subPrime = '͵';

    return '${note.name.toUpperCase()}$accidentalSymbol'
        '${subPrime * (octave - 2).abs()}';
  }

  @override
  String toString() => scientificName;

  @override
  bool operator ==(Object other) =>
      super == other && other is PositionedNote && octave == other.octave;

  @override
  int get hashCode => hash2(super.hashCode, octave);

  @override
  int compareTo(covariant PositionedNote other) => compareMultiple([
        () => octave.compareTo(other.octave),
        () => semitones.compareTo(other.semitones),
        () => note.value.compareTo(other.note.value),
      ]);
}
