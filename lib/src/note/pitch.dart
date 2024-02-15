import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../harmony/chord.dart';
import '../harmony/chord_pattern.dart';
import '../interval/interval.dart';
import '../music.dart';
import '../scalable.dart';
import '../tuning/cent.dart';
import '../tuning/equal_temperament.dart';
import '../tuning/tuning_system.dart';
import 'accidental.dart';
import 'base_note.dart';
import 'closest_pitch.dart';
import 'frequency.dart';
import 'note.dart';
import 'pitch_class.dart';

/// A note in the octave range.
///
/// ---
/// See also:
/// * [Note].
/// * [PitchClass].
/// * [Frequency].
/// * [ClosestPitch].
@immutable
final class Pitch extends Scalable<Pitch> implements Comparable<Pitch> {
  /// The note inside the octave.
  final Note note;

  /// The octave where the [note] is positioned.
  final int octave;

  /// Creates a new [Pitch] from [note] and [octave].
  const Pitch(this.note, {required this.octave});

  static const _superPrime = '′';
  static const _superPrimeAlt = "'";
  static const _subPrime = '͵';
  static const _subPrimeAlt = ',';

  static const _primeSymbols = [
    _superPrime,
    _superPrimeAlt,
    _subPrime,
    _subPrimeAlt,
  ];

  static final _scientificNotationRegExp = RegExp(r'^(.+?)([-]?\d+)$');
  static final _helmholtzNotationRegExp =
      RegExp('(^[A-Ga-g${Accidental.symbols.join()}]+)'
          '(${[for (final symbol in _primeSymbols) '$symbol+'].join('|')})?\$');

  /// Parse [source] as a [Pitch] and return its value.
  ///
  /// If the [source] string does not contain a valid [Pitch], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Pitch.parse('F#3') == Note.f.sharp.inOctave(3)
  /// Pitch.parse("c'") == Note.c.inOctave(4)
  /// Pitch.parse('z') // throws a FormatException
  /// ```
  factory Pitch.parse(String source) {
    final scientificNotationMatch =
        _scientificNotationRegExp.firstMatch(source);
    if (scientificNotationMatch != null) {
      return Pitch(
        Note.parse(scientificNotationMatch[1]!),
        octave: int.parse(scientificNotationMatch[2]!),
      );
    }

    final helmholtzNotationMatch = _helmholtzNotationRegExp.firstMatch(source);
    if (helmholtzNotationMatch != null) {
      const middleOctave = 3;
      final notePart = helmholtzNotationMatch[1]!;
      final primes = helmholtzNotationMatch[2]?.split('');
      final octave = notePart[0].isUpperCase
          ? switch (primes?.first) {
              '' || null => middleOctave - 1,
              _subPrime || _subPrimeAlt => middleOctave - primes!.length - 1,
              _ => throw FormatException('Invalid Pitch', source),
            }
          : switch (primes?.first) {
              '' || null => middleOctave,
              _superPrime || _superPrimeAlt => middleOctave + primes!.length,
              _ => throw FormatException('Invalid Pitch', source),
            };

      return Pitch(Note.parse(notePart), octave: octave);
    }

    throw FormatException('Invalid Pitch', source);
  }

  /// Returns the [octave] that corresponds to the semitones from root height.
  ///
  /// Example:
  /// ```dart
  /// Pitch.octaveFromSemitones(1) == 0
  /// Pitch.octaveFromSemitones(34) == 2
  /// Pitch.octaveFromSemitones(49) == 4
  /// ```
  static int octaveFromSemitones(int semitones) =>
      (semitones / chromaticDivisions).floor();

  /// Returns the number of semitones of this [Pitch] from C0 (root).
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).semitones == 57
  /// Note.b.sharp.inOctave(3).semitones == 48
  /// Note.c.inOctave(4).semitones == 48
  /// Note.c.inOctave(0).semitones == 0
  /// ```
  @override
  int get semitones => note.semitones + octave * chromaticDivisions;

  static const _lowerMidiPitch = Pitch(Note.c, octave: -1);
  static const _higherMidiPitch = Pitch(Note.g, octave: 9);

  /// Returns the MIDI number (an integer from 0 to 127) of this [Pitch],
  /// or `null` for pitches out of the MIDI range.
  ///
  /// See [MIDI](https://en.wikipedia.org/wiki/MIDI) and
  /// [Musical note](https://en.wikipedia.org/wiki/Musical_note#Scientific_versus_Helmholtz_pitch_notation).
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(-1).midiNumber == 0
  /// Note.a.inOctave(4).midiNumber == 69
  /// Note.g.inOctave(9).midiNumber == 127
  /// Note.a.flat.inOctave(9).midiNumber == null
  /// ```
  int? get midiNumber => switch (this) {
        < _lowerMidiPitch || > _higherMidiPitch => null,
        _ => semitones + chromaticDivisions,
      };

  /// Returns the difference in semitones between this [Pitch] and
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).difference(Note.d.inOctave(4)) == 2
  /// Note.e.flat.inOctave(4).difference(Note.b.flat.inOctave(4)) == 7
  /// Note.a.inOctave(4).difference(Note.g.inOctave(4)) == -2
  /// ```
  @override
  int difference(Pitch other) => other.semitones - semitones;

  /// Returns the [ChordPattern.diminishedTriad] on this [Pitch].
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
  Chord<Pitch> get diminishedTriad => ChordPattern.diminishedTriad.on(this);

  /// Returns the [ChordPattern.minorTriad] on this [Pitch].
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
  Chord<Pitch> get minorTriad => ChordPattern.minorTriad.on(this);

  /// Returns the [ChordPattern.majorTriad] on this [Pitch].
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
  Chord<Pitch> get majorTriad => ChordPattern.majorTriad.on(this);

  /// Returns the [ChordPattern.augmentedTriad] on this [Pitch].
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
  Chord<Pitch> get augmentedTriad => ChordPattern.augmentedTriad.on(this);

  /// Returns this [Pitch] respelled by [baseNote] while keeping the
  /// same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.b.sharp.inOctave(4).respellByBaseNote(BaseNote.c)
  ///   == Note.c.inOctave(5)
  /// Note.f.inOctave(5).respellByBaseNote(BaseNote.e)
  ///   == Note.e.sharp.inOctave(5)
  /// Note.g.inOctave(3).respellByBaseNote(BaseNote.a)
  ///   == Note.a.flat.flat.inOctave(3)
  /// ```
  Pitch respellByBaseNote(BaseNote baseNote) {
    final respelledNote = note.respellByBaseNote(baseNote);

    return Pitch(
      respelledNote,
      octave: octaveFromSemitones(
        _semitonesWithoutAccidental(semitones, respelledNote),
      ),
    );
  }

  /// Returns this [Pitch] respelled by [BaseNote.ordinal] distance
  /// while keeping the same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.inOctave(4).respellByBaseNoteDistance(-1)
  ///   == Note.f.sharp.inOctave(4)
  /// Note.e.sharp.inOctave(4).respellByBaseNoteDistance(2)
  ///   == Note.g.flat.flat.inOctave(4)
  /// ```
  Pitch respellByBaseNoteDistance(int distance) =>
      respellByBaseNote(BaseNote.fromOrdinal(note.baseNote.ordinal + distance));

  /// Returns this [Pitch] respelled upwards while keeping the same
  /// number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.inOctave(4).respelledUpwards == Note.a.flat.inOctave(4)
  /// Note.e.sharp.inOctave(4).respelledUpwards == Note.f.inOctave(4)
  /// ```
  Pitch get respelledUpwards => respellByBaseNoteDistance(1);

  /// Returns this [Pitch] respelled downwards while keeping the same
  /// number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.inOctave(4).respelledDownwards == Note.f.sharp.inOctave(4)
  /// Note.c.inOctave(4).respelledDownwards == Note.b.sharp.inOctave(4)
  /// ```
  Pitch get respelledDownwards => respellByBaseNoteDistance(-1);

  /// Returns this [Pitch] respelled by [accidental] while keeping the
  /// same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat.inOctave(4).respellByAccidental(Accidental.sharp)
  ///   == Note.d.sharp.inOctave(4)
  /// Note.b.inOctave(4).respellByAccidental(Accidental.flat)
  ///   == Note.c.flat.inOctave(5)
  /// Note.g.inOctave(4).respellByAccidental(Accidental.sharp) == null
  /// ```
  Pitch? respellByAccidental(Accidental accidental) {
    final respelledNote = note.respellByAccidental(accidental);
    if (respelledNote == null) return null;

    return Pitch(
      respelledNote,
      octave: octaveFromSemitones(
        _semitonesWithoutAccidental(semitones, respelledNote),
      ),
    );
  }

  /// Returns this [Pitch] with the simplest [Accidental] spelling
  /// while keeping the same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.e.sharp.inOctave(4).respelledSimple == Note.f.inOctave(4)
  /// Note.d.flat.flat.inOctave(4).respelledSimple == Note.c.inOctave(4)
  /// Note.f.sharp.sharp.sharp.inOctave(4).respelledSimple
  ///   == Note.g.sharp.inOctave(4)
  /// ```
  Pitch get respelledSimple =>
      respellByAccidental(Accidental.natural) ??
      respellByAccidental(Accidental(note.accidental.semitones.sign))!;

  /// We don’t want to take the accidental into account when
  /// calculating the octave height, as it depends on the note name.
  /// This correctly handles cases with the same number of semitones
  /// but in different octaves (e.g., B♯3 but C4, C♭4 but B3).
  int _semitonesWithoutAccidental(int semitones, Note referenceNote) =>
      semitones - referenceNote.accidental.semitones;

  /// Transposes this [Pitch] by [interval].
  ///
  /// Example:
  /// ```dart
  /// Note.g.inOctave(4).transposeBy(Interval.P5) == Note.d.inOctave(5)
  /// Note.d.flat.inOctave(2).transposeBy(-Interval.M2)
  ///   == Note.c.flat.inOctave(2)
  /// ```
  @override
  Pitch transposeBy(Interval interval) {
    final transposedNote = note.transposeBy(interval);

    return Pitch(
      transposedNote,
      octave: octaveFromSemitones(
        _semitonesWithoutAccidental(
          semitones + interval.semitones,
          transposedNote,
        ),
      ),
    );
  }

  /// Returns the exact interval between this [Pitch] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.g.inOctave(4).interval(Note.d.inOctave(5)) == Interval.P5
  /// Note.a.flat.inOctave(3).interval(Note.d.inOctave(4)) == Interval.A4
  /// ```
  @override
  Interval interval(Pitch other) {
    final ordinalDelta = other.note.baseNote.ordinal - note.baseNote.ordinal;
    final intervalSize = ordinalDelta + ordinalDelta.nonZeroSign;
    final octaveShift =
        (7 + (intervalSize.isNegative ? 2 : 0)) * (other.octave - octave);

    return Interval.fromSemitones(
      intervalSize + octaveShift,
      difference(other),
    );
  }

  /// Returns the [Frequency] of this [Pitch] from [referenceFrequency] and
  /// [tuningSystem].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).frequency() == const Frequency(440)
  /// Note.c.inOctave(4).frequency() == const Frequency(261.63)
  ///
  /// Note.b.flat.inOctave(4).frequency(
  ///   referenceFrequency: const Frequency(438),
  /// ) == const Frequency(464.04)
  ///
  /// Note.a.inOctave(4).frequency(
  ///   referenceFrequency: const Frequency(256),
  ///   tuningSystem:
  ///       EqualTemperament.edo12(referencePitch: Note.c.inOctave(4)),
  /// ) == const Frequency(430.54)
  /// ```
  ///
  /// This method and [Frequency.closestPitch] are inverses of each other for a
  /// specific `pitch`.
  ///
  /// ```dart
  /// final pitch = Note.a.inOctave(5);
  /// pitch.frequency().closestPitch().pitch == pitch;
  /// ```
  Frequency frequency({
    Frequency referenceFrequency = const Frequency(440),
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
  }) =>
      referenceFrequency * tuningSystem.ratio(this).value;

  /// Returns the string representation of this [Pitch] based on [system].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).toString() == 'C4'
  /// Note.a.inOctave(3).toString() == 'A3'
  /// Note.b.flat.inOctave(1).toString() == 'B♭1'
  ///
  /// Note.c.inOctave(4).toString(system: PitchNotation.helmholtz) == 'c′'
  /// Note.a.inOctave(3).toString(system: PitchNotation.helmholtz) == 'a'
  /// Note.b.flat.inOctave(1).toString(system: PitchNotation.helmholtz)
  ///   == 'B♭͵'
  /// ```
  @override
  String toString({PitchNotation system = PitchNotation.scientific}) =>
      system.pitch(this);

  /// Adds [cents] to this [Pitch], creating a new [ClosestPitch].
  ///
  /// Example:
  /// ```dart
  /// (Note.f.sharp.inOctave(4) + const Cent(4.1)).toString() == 'F♯4+4'
  /// (Note.e.flat.inOctave(3) + const Cent(-27.8)).toString() == 'E♭3-28'
  /// ```
  ClosestPitch operator +(Cent cents) => ClosestPitch(this, cents: cents);

  /// Subtracts [cents] from this [Pitch], creating a new [ClosestPitch].
  ///
  /// Example:
  /// ```dart
  /// (Note.g.flat.inOctave(5) - const Cent(16.01)).toString() == 'G♭5-16'
  /// (Note.c.inOctave(4) - const Cent(-6)).toString() == 'C4+6'
  /// ```
  ClosestPitch operator -(Cent cents) => ClosestPitch(this, cents: -cents);

  /// Whether this [Pitch] is lower than [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4) < Note.c.inOctave(5) == true
  /// Note.a.inOctave(5) < Note.g.inOctave(4) == false
  /// Note.d.inOctave(4) < Note.d.inOctave(4) == false
  /// ```
  bool operator <(Pitch other) => semitones < other.semitones;

  /// Whether this [Pitch] is lower than or equal to [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4) <= Note.c.inOctave(5) == true
  /// Note.a.inOctave(5) <= Note.g.inOctave(4) == false
  /// Note.d.inOctave(4) <= Note.d.inOctave(4) == true
  /// ```
  bool operator <=(Pitch other) => semitones <= other.semitones;

  /// Whether this [Pitch] is higher than [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(5) > Note.c.inOctave(4) == true
  /// Note.a.inOctave(4) > Note.g.inOctave(5) == false
  /// Note.d.inOctave(4) > Note.d.inOctave(4) == false
  /// ```
  bool operator >(Pitch other) => semitones > other.semitones;

  /// Whether this [Pitch] is higher than or equal to [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(5) >= Note.c.inOctave(4) == true
  /// Note.a.inOctave(4) >= Note.g.inOctave(5) == false
  /// Note.d.inOctave(4) >= Note.d.inOctave(4) == true
  /// ```
  bool operator >=(Pitch other) => semitones >= other.semitones;

  @override
  bool operator ==(Object other) =>
      other is Pitch && note == other.note && octave == other.octave;

  @override
  int get hashCode => Object.hash(note, octave);

  @override
  int compareTo(Pitch other) => compareMultiple([
        () => octave.compareTo(other.octave),
        () => note.compareTo(other.note),
      ]);
}

/// The abstraction for [Pitch] notation systems.
@immutable
abstract class PitchNotation {
  /// Creates a new [PitchNotation].
  const PitchNotation();

  /// The scientific [PitchNotation] system.
  static const scientific = ScientificPitchNotation();

  /// The Helmholtz [PitchNotation] system.
  static const helmholtz = HelmholtzPitchNotation();

  /// Returns the string representation for [pitch].
  String pitch(Pitch pitch);
}

/// See [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation).
final class ScientificPitchNotation extends PitchNotation {
  /// Creates a new [ScientificPitchNotation].
  const ScientificPitchNotation();

  @override
  String pitch(Pitch pitch) => '${pitch.note}${pitch.octave}';
}

/// See [Helmholtz’s pitch notation](https://en.wikipedia.org/wiki/Helmholtz_pitch_notation).
final class HelmholtzPitchNotation extends PitchNotation {
  /// Creates a new [HelmholtzPitchNotation].
  const HelmholtzPitchNotation();

  @override
  String pitch(Pitch pitch) {
    final accidental = pitch.note.accidental;
    final accidentalSymbol = accidental.isNatural ? '' : accidental.symbol;

    if (pitch.octave >= 3) {
      return '${pitch.note.baseNote.name}$accidentalSymbol'
          '${Pitch._superPrime * (pitch.octave - 3)}';
    }

    return '${pitch.note.baseNote.name.toUpperCase()}$accidentalSymbol'
        '${Pitch._subPrime * (pitch.octave - 2).abs()}';
  }
}
