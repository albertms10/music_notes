// Copyright (c) 2024, Albert Mañosa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart' show immutable;

import '../tuning/equal_temperament.dart';
import '../tuning/ratio.dart';
import '../tuning/tuning_system.dart';
import 'closest_pitch.dart';
import 'hearing_range.dart';
import 'pitch.dart';
import 'pitch_class.dart';

/// Represents an absolute pitch, a physical frequency.
///
/// ---
/// See also:
/// * [Pitch].
/// * [ClosestPitch].
@immutable
extension type const Frequency._(num hertz) implements num {
  /// Creates a new [Frequency] instance from [hertz].
  const Frequency(this.hertz) : assert(hertz >= 0, 'Hertz must be positive.');

  /// The symbol for the Hertz unit.
  static const hertzUnitSymbol = 'Hz';

  /// Whether this [Frequency] is inside the [HearingRange.human].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(880).isHumanAudible == true
  /// Note.a.inOctave(4).frequency().isHumanAudible == true
  /// Note.g.inOctave(12).frequency().isHumanAudible == false
  /// ```
  bool get isHumanAudible => HearingRange.human.isAudible(this);

  /// The [ClosestPitch] to this [Frequency] from [referenceFrequency] and
  /// [tuningSystem].
  ///
  /// Example:
  /// ```dart
  /// const Frequency(467).closestPitch()
  ///   == Note.a.sharp.inOctave(4) + const Cent(3.1028)
  ///
  /// const Frequency(260).closestPitch()
  ///   == Note.c.inOctave(4) - const Cent(10.7903)
  /// ```
  ///
  /// This method and [ClosestPitch.frequency] are inverses of each other for a
  /// specific input `frequency`.
  ///
  /// ```dart
  /// const frequency = Frequency(415);
  /// frequency.closestPitch().frequency() == frequency;
  /// ```
  ClosestPitch closestPitch({
    Frequency referenceFrequency = const Frequency(440),
    TuningSystem tuningSystem = const EqualTemperament.edo12(),
  }) {
    final cents = Ratio(hertz / referenceFrequency).cents;
    final semitones =
        tuningSystem.referencePitch.semitones + (cents / 100).round();

    final closestPitch = PitchClass(semitones)
        .resolveClosestSpelling()
        .inOctave(Pitch.octaveFromSemitones(semitones));

    final closestPitchFrequency = closestPitch.frequency(
      referenceFrequency: referenceFrequency,
      tuningSystem: tuningSystem,
    );
    final hertzDelta = hertz - closestPitchFrequency;

    // Whether `closestPitch` is closer to the upwards spelling (so, positive
    // `hertzDelta`), e.g. `Accidental.flat` instead of `Accidental.sharp`.
    final isCloserToUpwardsSpelling =
        closestPitch.note.accidental.isSharp && !hertzDelta.isNegative;

    return ClosestPitch(
      isCloserToUpwardsSpelling ? closestPitch.respelledUpwards : closestPitch,
      cents: Ratio(hertz / closestPitchFrequency).cents,
    );
  }

  /// The harmonic at [index] from this [Frequency], including negative
  /// values as part of the [undertone series](https://en.wikipedia.org/wiki/Undertone_series).
  ///
  /// Example:
  /// ```dart
  /// const Frequency(220).harmonic(1) == const Frequency(440)
  /// const Frequency(880).harmonic(-3) == const Frequency(220)
  ///
  /// Note.c.inOctave(1).frequency().harmonic(3).closestPitch()
  ///   == Note.e.inOctave(3) - const Cent(14)
  /// ```
  Frequency harmonic(int index) => Frequency(
        index.isNegative ? hertz / (index.abs() + 1) : hertz * (index + 1),
      );

  /// The [Set] of [harmonics series](https://en.wikipedia.org/wiki/Harmonic_series_(music))
  /// [upToIndex] from this [Frequency].
  ///
  /// Example:
  /// ```dart
  /// Note.a.inOctave(3).frequency().harmonics(upToIndex: 2)
  ///   == {const Frequency(220), const Frequency(440), const Frequency(660)}
  ///
  /// Note.a.inOctave(5).frequency().harmonics(upToIndex: -2)
  ///   == {const Frequency(880), const Frequency(440), const Frequency(293.33)}
  ///
  /// Note.c.inOctave(1).frequency().harmonics(upToIndex: 7).closestPitches
  ///     .toString() == '{C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4}'
  /// ```
  ///
  /// ---
  /// See also:
  /// - [FrequencyIterableExtension.closestPitches].
  Set<Frequency> harmonics({required int upToIndex}) => {
        for (var i = 0; i <= upToIndex.abs(); i++) harmonic(i * upToIndex.sign),
      };

  /// This [Frequency] formatted as a string.
  ///
  /// Example:
  /// ```dart
  /// const Frequency(440).format() == '440 Hz'
  /// const Frequency(466.16).format() == '466.16 Hz'
  /// ```
  String format() => '$hertz $hertzUnitSymbol';
}

/// A [Frequency] Iterable extension.
extension FrequencyIterableExtension on Iterable<Frequency> {
  /// The set of [ClosestPitch] for each [Frequency] element.
  ///
  /// Example:
  /// ```dart
  /// Note.c.inOctave(1).frequency().harmonics(upToIndex: 7).closestPitches
  ///     .toString() == '{C1, C2, G2+2, C3, E3-14, G3+2, A♯3-31, C4}'
  /// ```
  Set<ClosestPitch> get closestPitches =>
      map((frequency) => frequency.closestPitch()).toSet();
}
