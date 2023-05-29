part of '../../music_notes.dart';

/// A note octave in the octave range.
final class PositionedNote
    implements Comparable<PositionedNote>, Scalable<PositionedNote> {
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
  /// Note.e.flat.inOctave(4).difference(Note.b.flat.inOctave(4)) == 7
  /// Note.a.inOctave(4).difference(Note.g.inOctave(4)) == -2
  /// ```
  int difference(PositionedNote other) => other.semitones - semitones;

  /// Returns the [ChordPattern.augmentedTriad] on this [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.d.flat.inOctave(4).augmentedTriad
  ///   == Chord([
  ///        Note.d.flat.inOctave(4),
  ///        Note.f.inOctave(4),
  ///        Note.a.inOctave(4),
  ///      ])
  ///
  /// Note.g.inOctave(5).augmentedTriad
  ///   == Chord([
  ///        Note.g.inOctave(5),
  ///        Note.b.inOctave(5),
  ///        Note.d.sharp.inOctave(6),
  ///      ])
  /// ```
  Chord<PositionedNote> get augmentedTriad =>
      ChordPattern.augmentedTriad.on(this);

  /// Returns the [ChordPattern.majorTriad] on this [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.d.inOctave(3).majorTriad
  ///   == Chord([
  ///        Note.d.inOctave(3),
  ///        Note.f.sharp.inOctave(3),
  ///        Note.a.inOctave(3),
  ///      ])
  ///
  /// Note.a.flat.inOctave(4).majorTriad
  ///   == Chord([
  ///        Note.a.flat.inOctave(4),
  ///        Note.c.inOctave(5),
  ///        Note.e.flat.inOctave(5),
  ///      ])
  /// ```
  Chord<PositionedNote> get majorTriad => ChordPattern.majorTriad.on(this);

  /// Returns the [ChordPattern.minorTriad] on this [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.e.inOctave(4).minorTriad
  ///   == Chord([
  ///        Note.e.inOctave(4),
  ///        Note.g.inOctave(4),
  ///        Note.b.inOctave(4),
  ///      ])
  ///
  /// Note.f.sharp.inOctave(3).minorTriad
  ///   == Chord([
  ///        Note.f.sharp.inOctave(3),
  ///        Note.a.inOctave(3),
  ///        Note.c.sharp.inOctave(4)
  ///      ])
  /// ```
  Chord<PositionedNote> get minorTriad => ChordPattern.minorTriad.on(this);

  /// Returns the [ChordPattern.diminishedTriad] on this [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(3).diminishedTriad
  ///   == Chord([
  ///        Note.a.inOctave(3),
  ///        Note.c.inOctave(4),
  ///        Note.e.flat.inOctave(4),
  ///      ])
  ///
  /// Note.b.inOctave(3).diminishedTriad
  ///   == Chord([
  ///        Note.b.inOctave(3),
  ///        Note.d.inOctave(4),
  ///        Note.f.inOctave(4),
  ///      ])
  /// ```
  Chord<PositionedNote> get diminishedTriad =>
      ChordPattern.diminishedTriad.on(this);

  /// Returns a transposed [PositionedNote] by [interval]
  /// from this [PositionedNote].
  ///
  /// Example:
  /// ```dart
  /// Note.g.inOctave(4).transposeBy(Interval.perfectFifth)
  ///   == Note.d.inOctave(5)
  /// Note.d.flat.inOctave(2).transposeBy(-Interval.majorSecond)
  ///   == Note(BaseNote.c, Accidental.flat).inOctave(2)
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

  /// Returns the exact interval between this [PositionedNote] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.g.inOctave(4).interval(Note.d.inOctave(5)) == Interval.perfectFifth
  /// Note.d.inOctave(3).interval(Note.a.flat.inOctave(4))
  ///   == Interval.diminishedFifth
  /// ```
  @override
  Interval interval(PositionedNote other) {
    final ordinalDelta = other.note.baseNote.ordinal - note.baseNote.ordinal;
    final ordinalDeltaSign = ordinalDelta.isNegative ? -1 : 1;
    final intervalSize = ordinalDelta + ordinalDeltaSign;
    final octaveShift =
        (7 + (intervalSize.isNegative ? 2 : 0)) * (other.octave - octave);

    return Interval.fromSemitones(
      intervalSize + octaveShift,
      difference(other),
    );
  }

  /// Returns the equal temperament [Frequency] of this [PositionedNote] from
  /// the [reference] frequency and [note].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).equalTemperamentFrequency() == const Frequency(440)
  /// Note.c.inOctave(4).equalTemperamentFrequency() == const Frequency(261.63)
  ///
  /// Note.b.flat.inOctave(4).equalTemperamentFrequency(const Frequency(338))
  ///   == const Frequency(464.04)
  ///
  /// Note.c.inOctave(4).equalTemperamentFrequency(
  ///   const Frequency(256),
  ///   Note.c.inOctave(4),
  /// ) == const Frequency(256)
  /// ```
  Frequency equalTemperamentFrequency([
    Frequency reference = const Frequency(440),
    PositionedNote note = const PositionedNote(Note.a),
  ]) =>
      reference * math.pow(sqrt12_2, note.difference(this));

  /// Returns the string representation of this [Note] following the
  /// [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation).
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).scientificName == 'C4'
  /// Note.a.inOctave(3).scientificName == 'A3'
  /// Note.b.flat.inOctave(1).scientificName == 'B♭1'
  /// ```
  String get scientificName => '${note.baseNote.name.toUpperCase()}'
      '${note.accidental != Accidental.natural ? note.accidental.symbol : ''}'
      '$octave';

  /// Returns the string representation of this [Note] following
  /// [Helmholtz’s pitch notation](https://en.wikipedia.org/wiki/Helmholtz_pitch_notation).
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).helmholtzName == 'c′'
  /// Note.a.inOctave(3).helmholtzName == 'a'
  /// Note.b.flat.inOctave(1).helmholtzName == 'B♭͵'
  /// ```
  String get helmholtzName {
    final accidentalSymbol =
        note.accidental != Accidental.natural ? note.accidental.symbol : '';

    if (octave >= 3) {
      const superPrime = '′';

      return '${note.baseNote.name}$accidentalSymbol'
          '${superPrime * (octave - 3)}';
    }

    const subPrime = '͵';

    return '${note.baseNote.name.toUpperCase()}$accidentalSymbol'
        '${subPrime * (octave - 2).abs()}';
  }

  @override
  String toString() => scientificName;

  @override
  bool operator ==(Object other) =>
      other is PositionedNote && note == other.note && octave == other.octave;

  @override
  int get hashCode => Object.hash(note, octave);

  @override
  int compareTo(PositionedNote other) => compareMultiple([
        () => octave.compareTo(other.octave),
        () => note.compareTo(other.note),
      ]);
}
