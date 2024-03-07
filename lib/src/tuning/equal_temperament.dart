import 'dart:math' as math;

import 'package:collection/collection.dart' show MapEquality;
import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../note/base_note.dart';
import '../note/frequency.dart';
import '../note/note.dart';
import '../note/pitch.dart';
import 'cent.dart';
import 'ratio.dart';
import 'tuning_system.dart';

/// A representation of an equal temperament tuning system.
///
/// See [Equal temperament](https://en.wikipedia.org/wiki/Equal_temperament).
///
/// ---
/// See also:
/// * [TuningSystem].
@immutable
class EqualTemperament extends TuningSystem {
  /// The equal divisions between each [BaseNote] and the next one.
  final Map<BaseNote, int> steps;

  /// Creates a new [EqualTemperament] from [referencePitch] and [steps].
  const EqualTemperament({
    required this.steps,
    super.referencePitch = _defaultReferencePitch,
  });

  /// Creates a new [EqualTemperament] from [edo] and
  /// [referencePitch].
  factory EqualTemperament.edo(
    int edo, {
    Pitch referencePitch = _defaultReferencePitch,
  }) {
    assert(edo > 0, 'Octave divisions must be greater than zero.');
    final baseFrequency = referencePitch.frequency();
    final frequencies = [
      for (var i = 0; i < edo; i++)
        Frequency(baseFrequency * _ratioFromSemitones(i, edo)),
    ];

    final baseNotes = frequencies.map(
      (frequency) => frequency
          .closestPitch()
          .pitch
          // TODO(albertm10): the issue comes with the spelling decision.
          .respelledDownwards
          .respelledSimple
          .note
          .baseNote,
    );
    final divisions = baseNotes.fold(
      <BaseNote, int>{},
      (divisions, baseNote) =>
          divisions..update(baseNote, (value) => value + 1, ifAbsent: () => 1),
    );

    return EqualTemperament(steps: divisions, referencePitch: referencePitch);
  }

  /// See [12 equal temperament](https://en.wikipedia.org/wiki/12_equal_temperament).
  const EqualTemperament.edo12({super.referencePitch = _defaultReferencePitch})
      : steps = const {
          BaseNote.a: 2,
          BaseNote.b: 1,
          BaseNote.c: 2,
          BaseNote.d: 2,
          BaseNote.e: 1,
          BaseNote.f: 2,
          BaseNote.g: 2,
        };

  /// See [19 equal temperament](https://en.wikipedia.org/wiki/19_equal_temperament).
  const EqualTemperament.edo19({super.referencePitch = _defaultReferencePitch})
      : steps = const {
          BaseNote.a: 3,
          BaseNote.b: 2,
          BaseNote.c: 3,
          BaseNote.d: 3,
          BaseNote.e: 2,
          BaseNote.f: 3,
          BaseNote.g: 3,
        };

  static const _defaultReferencePitch = Pitch(Note.a, octave: 4);

  /// The equal divisions of the octave of this [EqualTemperament].
  ///
  /// See [EDO](https://en.xen.wiki/w/EDO).
  int get edo => steps.values.reduce((value, element) => value + element);

  /// The cents for each division step in this [EqualTemperament].
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().cents.toList()
  ///   == const [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100]
  ///       as List<Cent>
  /// ```
  Iterable<Cent> get cents sync* {
    yield const Cent(0);
    final edo = this.edo;
    for (var i = 1; i < edo; i++) {
      yield ratioFromSemitones(i).cents;
    }
  }

  static Ratio _ratioFromSemitones(int semitones, int edo) =>
      Ratio(math.pow(2, semitones / edo));

  /// The [Ratio] from [semitones] for this [EqualTemperament].
  ///
  /// See [Twelfth root of two](https://en.wikipedia.org/wiki/Twelfth_root_of_two).
  ///
  /// Example:
  /// ```dart
  /// const EqualTemperament.edo12().ratioFromSemitones(1) == Ratio(1.059463)
  /// const EqualTemperament.edo19().ratioFromSemitones(1) == Ratio(1.037155)
  /// ```
  Ratio ratioFromSemitones(int semitones) =>
      _ratioFromSemitones(semitones, edo);

  @override
  Ratio ratio(Pitch pitch) =>
      ratioFromSemitones(referencePitch.difference(pitch));

  /// The reference generator cents.
  static const referenceGeneratorCents = Cent(700);

  @override
  Cent get generator => cents.closestTo(referenceGeneratorCents);

  @override
  String toString() =>
      'EDO $edo (${steps.entries.map((entry) => '${entry.key}:${entry.value}').join(' ')})';

  @override
  bool operator ==(Object other) =>
      other is EqualTemperament &&
      const MapEquality<BaseNote, int>().equals(steps, other.steps) &&
      referencePitch == other.referencePitch;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(steps.recordEntries), referencePitch);
}
