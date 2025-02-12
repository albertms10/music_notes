import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../comparators.dart';
import '../enharmonic.dart';
import '../harmony/chord.dart';
import '../harmony/chord_pattern.dart';
import '../interval/interval.dart';
import '../interval/size.dart';
import '../music.dart';
import '../respellable.dart';
import '../scalable.dart';
import '../tuning/cent.dart';
import '../tuning/equal_temperament.dart';
import '../tuning/temperature.dart';
import '../tuning/tuning_fork.dart';
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
final class Pitch extends Scalable<Pitch>
    with Comparators<Pitch>, RespellableScalable<Pitch>
    implements Comparable<Pitch> {
  /// The note inside the octave.
  final Note note;

  /// The octave where the [note] is positioned.
  final int octave;

  /// Creates a new [Pitch] from [note] and [octave].
  const Pitch(this.note, {required this.octave});

  /// The reference [Pitch].
  static const reference = Pitch(Note.a, octave: referenceOctave);

  /// The reference octave.
  static const referenceOctave = 4;

  static const _superPrime = '′';
  static const _superDoublePrime = '″';
  static const _superTriplePrime = '‴';
  static const _superQuadruplePrime = '⁗';
  static const _superPrimeAlt = "'";
  static const _subPrime = '͵';
  static const _subPrimeAlt = ',';

  static const _compoundPrimeSymbols = [
    _superDoublePrime,
    _superTriplePrime,
    _superQuadruplePrime,
  ];
  static const _primeSymbols = [
    _superPrime,
    _superPrimeAlt,
    _subPrime,
    _subPrimeAlt,
  ];

  static final _scientificNotationRegExp = RegExp(r'^(.+?)([-]?\d+)$');
  static final _helmholtzNotationRegExp = RegExp(
    '(^(?:${[for (final BaseNote(:name) in BaseNote.values) name].join('|')})[${Accidental.symbols.join()}]*)(${[..._compoundPrimeSymbols, for (final symbol in _primeSymbols) '$symbol+'].join('|')})?\$',
    caseSensitive: false,
  );

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
    final scientificNotationMatch = _scientificNotationRegExp.firstMatch(
      source,
    );
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
      final octave =
          notePart[0].isUpperCase
              ? switch (primes?.first) {
                '' || null => middleOctave - 1,
                _subPrime || _subPrimeAlt => middleOctave - primes!.length - 1,
                _ =>
                  throw FormatException(
                    'Invalid Pitch',
                    source,
                    notePart.length,
                  ),
              }
              : switch (primes?.first) {
                '' || null => middleOctave,
                _superPrime || _superPrimeAlt => middleOctave + primes!.length,
                _superDoublePrime => middleOctave + 2,
                _superTriplePrime => middleOctave + 3,
                _superQuadruplePrime => middleOctave + 4,
                _ =>
                  throw FormatException(
                    'Invalid Pitch',
                    source,
                    notePart.length,
                  ),
              };

      return Pitch(Note.parse(notePart), octave: octave);
    }

    throw FormatException('Invalid Pitch', source);
  }

  /// The [octave] that corresponds to the semitones from root height.
  ///
  /// Example:
  /// ```dart
  /// Pitch.octaveFromSemitones(1) == 0
  /// Pitch.octaveFromSemitones(34) == 2
  /// Pitch.octaveFromSemitones(49) == 4
  /// ```
  static int octaveFromSemitones(int semitones) =>
      (semitones / chromaticDivisions).floor();

  /// The number of semitones of this [Pitch] from C0 (root).
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

  /// The MIDI number (an integer from 0 to 127) of this [Pitch],
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
  int? get midiNumber {
    if (this case < _lowerMidiPitch || > _higherMidiPitch) return null;

    return semitones + chromaticDivisions;
  }

  /// The difference in semitones between this [Pitch] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).difference(Note.d.inOctave(4)) == 2
  /// Note.e.flat.inOctave(4).difference(Note.b.flat.inOctave(4)) == 7
  /// Note.a.inOctave(4).difference(Note.g.inOctave(4)) == -2
  /// ```
  @override
  int difference(Pitch other) => other.semitones - semitones;

  /// The [ChordPattern.diminishedTriad] on this [Pitch].
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

  /// The [ChordPattern.minorTriad] on this [Pitch].
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

  /// The [ChordPattern.majorTriad] on this [Pitch].
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

  /// The [ChordPattern.augmentedTriad] on this [Pitch].
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

  /// This [Pitch] respelled by [baseNote] while keeping the
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
  @override
  Pitch respellByBaseNote(BaseNote baseNote) {
    final respelledNote = note.respellByBaseNote(baseNote);

    return Pitch(
      respelledNote,
      octave: octaveFromSemitones(
        _semitonesWithoutAccidental(semitones, respelledNote),
      ),
    );
  }

  /// This [Pitch] respelled by [BaseNote.ordinal] distance while keeping the
  /// same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.inOctave(4).respellByOrdinalDistance(-1)
  ///   == Note.f.sharp.inOctave(4)
  /// Note.e.sharp.inOctave(4).respellByOrdinalDistance(2)
  ///   == Note.g.flat.flat.inOctave(4)
  /// ```
  @override
  Pitch respellByOrdinalDistance(int distance) =>
      respellByBaseNote(BaseNote.fromOrdinal(note.baseNote.ordinal + distance));

  /// This [Pitch] respelled upwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.sharp.inOctave(4).respelledUpwards == Note.a.flat.inOctave(4)
  /// Note.e.sharp.inOctave(4).respelledUpwards == Note.f.inOctave(4)
  /// ```
  @override
  Pitch get respelledUpwards => super.respelledUpwards;

  /// This [Pitch] respelled downwards while keeping the same number of
  /// [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.g.flat.inOctave(4).respelledDownwards == Note.f.sharp.inOctave(4)
  /// Note.c.inOctave(4).respelledDownwards == Note.b.sharp.inOctave(4)
  /// ```
  @override
  Pitch get respelledDownwards => super.respelledDownwards;

  /// This [Pitch] respelled by [accidental] while keeping the same number of
  /// [semitones].
  ///
  /// When no respelling is possible with [accidental], the next closest
  /// spelling is returned.
  ///
  /// Example:
  /// ```dart
  /// Note.e.flat.inOctave(4).respellByAccidental(Accidental.sharp)
  ///   == Note.d.sharp.inOctave(4)
  /// Note.b.inOctave(4).respellByAccidental(Accidental.flat)
  ///   == Note.c.flat.inOctave(5)
  /// Note.g.inOctave(4).respellByAccidental(Accidental.sharp)
  ///   == Note.f.sharp.sharp.inOctave(4)
  /// ```
  @override
  Pitch respellByAccidental(Accidental accidental) {
    final respelledNote = note.respellByAccidental(accidental);

    return Pitch(
      respelledNote,
      octave: octaveFromSemitones(
        _semitonesWithoutAccidental(semitones, respelledNote),
      ),
    );
  }

  /// This [Pitch] with the simplest [Accidental] spelling while keeping the
  /// same number of [semitones].
  ///
  /// Example:
  /// ```dart
  /// Note.e.sharp.inOctave(4).respelledSimple == Note.f.inOctave(4)
  /// Note.d.flat.flat.inOctave(4).respelledSimple == Note.c.inOctave(4)
  /// Note.f.sharp.sharp.sharp.inOctave(4).respelledSimple
  ///   == Note.g.sharp.inOctave(4)
  /// ```
  @override
  Pitch get respelledSimple => super.respelledSimple;

  /// We don’t want to take the accidental into account when
  /// calculating the octave height, as it depends on the note name.
  /// This correctly handles cases with the same number of semitones
  /// but in different octaves (e.g., B♯3 but C4, or C♭4 but B3).
  static int _semitonesWithoutAccidental(int semitones, Note referenceNote) =>
      semitones - referenceNote.accidental.semitones;

  @override
  bool isEnharmonicWith(Enharmonic<PitchClass> other) =>
      semitones == other.semitones;

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

  /// The interval between this [Pitch] and [other].
  ///
  /// Example:
  /// ```dart
  /// Note.g.inOctave(4).interval(Note.d.inOctave(5)) == Interval.P5
  /// Note.a.flat.inOctave(3).interval(Note.d.inOctave(4)) == Interval.A4
  /// Note.c.inOctave(5).interval(Note.b.inOctave(4)) == -Interval.m2
  /// ```
  @override
  Interval interval(Pitch other) {
    final ordinalDelta = other.note.baseNote.ordinal - note.baseNote.ordinal;
    final sizeDelta = ordinalDelta + 7 * (other.octave - octave);

    return Interval.fromSizeAndSemitones(
      Size(sizeDelta.abs() + 1),
      difference(other).abs(),
    ).descending(sizeDelta < 0);
  }

  /// The [Frequency] of this [Pitch] from [tuningSystem] and [temperature].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(4).frequency() == const Frequency(440)
  /// Note.c.inOctave(4).frequency() == const Frequency(261.63)
  ///
  /// Note.b.flat.inOctave(4).frequency(
  ///   tuningSystem: EqualTemperament.edo12(
  ///     fork: Pitch.reference.at(const Frequency(438)),
  ///   ),
  /// ) == const Frequency(464.04)
  ///
  /// Note.a.inOctave(4).frequency(
  ///   tuningSystem: const EqualTemperament.edo12(fork: TuningFork.c256),
  /// ) == const Frequency(430.54)
  ///
  /// Note.a.inOctave(4).frequency(temperature: const Celsius(18))
  ///   == const Frequency(438.46)
  /// Note.a.inOctave(4).frequency(temperature: const Celsius(24))
  ///   == const Frequency(443.08)
  /// ```
  ///
  /// This method and [Frequency.closestPitch] are inverses of each other for a
  /// specific `pitch`.
  ///
  /// ```dart
  /// final reference = Note.a.inOctave(5);
  /// reference.frequency().closestPitch().pitch == reference;
  /// ```
  Frequency frequency({
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
    Celsius temperature = Celsius.reference,
    Celsius referenceTemperature = Celsius.reference,
  }) => Frequency(
    tuningSystem.fork.frequency * tuningSystem.ratio(this),
  ).at(temperature, referenceTemperature);

  /// Creates a new [TuningFork] from this [Pitch] at a given [frequency].
  ///
  /// Example:
  /// ```dart
  /// Pitch.reference.at(const Frequency(440)) == TuningFork.a440
  /// Note.c.inOctave(4).at(const Frequency(256)) == TuningFork.c256
  /// ```
  TuningFork at(Frequency frequency) => TuningFork(this, frequency);

  /// The [ClosestPitch] set of harmonics series from this [Pitch] from
  /// [tuningSystem], [temperature], and whether [undertone].
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(1).harmonics().take(16).toSet().toString()
  ///   == '{C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4, D4+4, '
  ///     'E4-14, F♯4-49, G4+2, A♭4+41, A♯4-31, B4-12, C5}'
  /// ```
  Iterable<ClosestPitch> harmonics({
    bool undertone = false,
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
    Celsius temperature = Celsius.reference,
    Celsius referenceTemperature = Celsius.reference,
  }) => frequency(
        tuningSystem: tuningSystem,
        // we deliberately omit the temperature here, as the subsequent call to
        // `Frequency.closestPitch` will already take it into account.
      )
      .harmonics(undertone: undertone)
      .map(
        (frequency) =>
            frequency
                .closestPitch(
                  tuningSystem: tuningSystem,
                  temperature: temperature,
                  referenceTemperature: referenceTemperature,
                )
                .respelledSimple,
      );

  /// The string representation of this [Pitch] based on [system].
  ///
  /// See [PitchNotation] for all system implementations.
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(4).toString() == 'C4'
  /// Note.a.inOctave(3).toString() == 'A3'
  /// Note.b.flat.inOctave(1).toString() == 'B♭1'
  ///
  /// Note.c.inOctave(4).toString(system: PitchNotation.helmholtz) == 'c′'
  /// Note.a.inOctave(3).toString(system: PitchNotation.helmholtz) == 'a'
  /// Note.b.flat.inOctave(1).toString(system: PitchNotation.helmholtz) == 'B♭͵'
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
  static const helmholtz = HelmholtzPitchNotation.english;

  /// The string representation for [pitch].
  String pitch(Pitch pitch);
}

/// The scientific [Pitch] notation system.
///
/// See [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation).
final class ScientificPitchNotation extends PitchNotation {
  /// Creates a new [ScientificPitchNotation].
  const ScientificPitchNotation();

  @override
  String pitch(Pitch pitch) => '${pitch.note}${pitch.octave}';
}

/// The Helmholtz [Pitch] notation system.
///
/// See [Helmholtz’s pitch notation](https://en.wikipedia.org/wiki/Helmholtz_pitch_notation).
final class HelmholtzPitchNotation extends PitchNotation {
  /// The [NoteNotation] system for the [Pitch.note] part.
  final NoteNotation noteSystem;

  /// Creates a new [HelmholtzPitchNotation].
  const HelmholtzPitchNotation({this.noteSystem = NoteNotation.english});

  /// The [NoteNotation.english] variant of this [HelmholtzPitchNotation].
  static const english = HelmholtzPitchNotation();

  /// The [NoteNotation.german] variant of this [HelmholtzPitchNotation].
  static const german = HelmholtzPitchNotation(noteSystem: NoteNotation.german);

  /// The [NoteNotation.romance] variant of this [HelmholtzPitchNotation].
  static const romance = HelmholtzPitchNotation(
    noteSystem: NoteNotation.romance,
  );

  static String _symbols(int n) => switch (n) {
    4 => Pitch._superQuadruplePrime,
    3 => Pitch._superTriplePrime,
    2 => Pitch._superDoublePrime,
    < 0 => Pitch._subPrime * n.abs(),
    _ => Pitch._superPrime * n,
  };

  @override
  String pitch(Pitch pitch) {
    final note = pitch.note.toString(system: noteSystem);

    return switch (pitch.octave) {
      >= 3 => '${note.toLowerCase()}${_symbols(pitch.octave - 3)}',
      _ => '$note${_symbols(pitch.octave - 2)}',
    };
  }
}
