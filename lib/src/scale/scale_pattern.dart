import 'package:collection/collection.dart' show UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../enharmonic.dart';
import '../harmony/chord_pattern.dart';
import '../interval/interval.dart';
import '../note/pitch_class.dart';
import '../scalable.dart';
import '../tuning/equal_temperament.dart';
import 'scale.dart';
import 'scale_degree.dart';

/// A set of musical intervals that conform a musical scale.
///
/// See [Scale (music)](https://en.wikipedia.org/wiki/Scale_(music)).
///
/// ---
/// See also:
/// * [Scale].
@immutable
final class ScalePattern {
  final List<Interval> _intervalSteps;

  /// The interval steps that define this [ScalePattern].
  List<Interval> get intervalSteps => UnmodifiableListView(_intervalSteps);

  /// The descending interval steps that define this [ScalePattern].
  /// If null, the result is the same as calling `_intervalSteps.reversed`.
  final List<Interval>? _descendingIntervalSteps;

  /// The descending interval steps that define this [ScalePattern].
  List<Interval> get descendingIntervalSteps =>
      UnmodifiableListView(_descendingIntervalSteps ?? _intervalSteps.reversed);

  /// Creates a new [ScalePattern] from [_intervalSteps] and optional
  /// [_descendingIntervalSteps].
  const ScalePattern(this._intervalSteps, [this._descendingIntervalSteps]);

  /// ![C Ionian scale](https://upload.wikimedia.org/score/p/2/p2fun2296uif26uyy61yxjli7ocfq9d/p2fun229.png).
  static const ionian = ScalePattern([.M2, .M2, .m2, .M2, .M2, .M2, .m2]);

  /// ![C Dorian scale](https://upload.wikimedia.org/score/g/y/gydc9ka2vd8tdso0yv7qf15vu7axtr8/gydc9ka2.png).
  static const dorian = ScalePattern([.M2, .m2, .M2, .M2, .M2, .m2, .M2]);

  /// ![C Phrygian scale](https://upload.wikimedia.org/score/o/l/oljahwegklc7tqhe1gpekwo6sro4xkm/oljahweg.png).
  static const phrygian = ScalePattern([.m2, .M2, .M2, .M2, .m2, .M2, .M2]);

  /// ![C Lydian scale](https://upload.wikimedia.org/score/0/c/0cg9y4ajzy2jwu8s2887oaq4fwkwbqs/0cg9y4aj.png).
  static const lydian = ScalePattern([.M2, .M2, .M2, .m2, .M2, .M2, .m2]);

  /// ![C Lydian augmented scale](https://upload.wikimedia.org/score/3/b/3b5vj7v08y1yuemdmewgxuuid25oezn/3b5vj7v0.png).
  static const lydianAugmented = ScalePattern([
    .M2,
    .M2,
    .M2,
    .M2,
    .m2,
    .M2,
    .m2,
  ]);

  /// ![C Mixolydian scale](https://upload.wikimedia.org/score/s/j/sjbifo4dqsa0aozgvdr38c2z8qq3f9k/sjbifo4d.png).
  static const mixolydian = ScalePattern([.M2, .M2, .m2, .M2, .M2, .m2, .M2]);

  /// ![C Aeolian scale](https://upload.wikimedia.org/score/c/s/cseytu8cn39n7a6wp4j23dfqjdnsan7/cseytu8c.png).
  static const aeolian = ScalePattern([.M2, .m2, .M2, .M2, .m2, .M2, .M2]);

  /// ![C Locrian scale](https://upload.wikimedia.org/score/a/5/a54xaj67nftcpgw3wgsaxqjcfnwram5/a54xaj67.png).
  static const locrian = ScalePattern([.m2, .M2, .M2, .m2, .M2, .M2, .M2]);

  /// ![C Major scale](https://upload.wikimedia.org/score/1/4/149hxowm0jnjun0byp4xzvq7h12ndfg/149hxowm.png).
  static const major = ionian;

  /// ![C Natural minor scale](https://upload.wikimedia.org/score/h/k/hkrek1madm24z0ssu3s37ddrohklugf/hkrek1ma.png).
  static const naturalMinor = aeolian;

  /// ![C Harmonic minor scale](https://upload.wikimedia.org/score/7/3/73zt4ivl6l561j0n2a1qp68d51l2yug/73zt4ivl.png).
  static const harmonicMinor = ScalePattern([
    .M2,
    .m2,
    .M2,
    .M2,
    .m2,
    .A2,
    .m2,
  ]);

  /// ![C Melodic minor scale](https://upload.wikimedia.org/score/9/2/92i6sjg41ji8y1ab881a1pcq1u3hr0p/92i6sjg4.png).
  static const melodicMinor = ScalePattern(
    [.M2, .m2, .M2, .M2, .M2, .M2, .m2],
    [.M2, .M2, .m2, .M2, .M2, .m2, .M2],
  );

  /// See [Chromatic scale](https://en.wikipedia.org/wiki/Chromatic_scale).
  ///
  /// ![C Chromatic scale](https://upload.wikimedia.org/score/m/u/mu2yiewo9c4oa1bzfg20dg3ltwd5iu3/mu2yiewo.png).
  static const chromatic = ScalePattern([
    .A1,
    .m2,
    .A1,
    .m2,
    .m2,
    .A1,
    .m2,
    .A1,
    .m2,
    .A1,
    .m2,
    .m2,
  ]);

  /// See [Whole-tone scale](https://en.wikipedia.org/wiki/Whole-tone_scale).
  ///
  /// ![C Whole-tone scale](https://upload.wikimedia.org/score/l/c/lcqo121bdjjfsvvxcp86l59yaa46v8o/lcqo121b.png).
  static const wholeTone = ScalePattern([.M2, .M2, .M2, .M2, .M2, .d3]);

  /// See [Pentatonic scale](https://en.wikipedia.org/wiki/Pentatonic_scale).
  ///
  /// ![C Major pentatonic scale](https://upload.wikimedia.org/score/j/7/j7cn43w4nuz0j5imzs8ijatkfxh1x0h/j7cn43w4.png).
  static const majorPentatonic = ScalePattern([.M2, .M2, .m3, .M2, .m3]);

  /// See [Pentatonic scale](https://en.wikipedia.org/wiki/Pentatonic_scale).
  ///
  /// ![A Minor pentatonic scale](https://upload.wikimedia.org/score/s/c/sc9aoxty66zu9ccwp6qclwcuuai6pjz/sc9aoxty.png).
  static const minorPentatonic = ScalePattern([.m3, .M2, .M2, .m3, .M2]);

  /// See [Octatonic scale](https://en.wikipedia.org/wiki/Octatonic_scale).
  ///
  /// ![C Octatonic scale](https://upload.wikimedia.org/score/0/7/07sm4b4dbpp5ynvdfuedj2e87e14ym3/07sm4b4d.png).
  ///
  /// ![C Octatonic scale](https://upload.wikimedia.org/score/3/k/3k5luxd4mjag2z377hvt9gg3njf0882/3k5luxd4.png).
  static const octatonic = ScalePattern([
    .M2,
    .m2,
    .M2,
    .m2,
    .M2,
    .m2,
    .M2,
    .m2,
  ]);

  /// See [Double harmonic scale](https://en.wikipedia.org/wiki/Double_harmonic_scale).
  ///
  /// ![C Double harmonic scale](https://upload.wikimedia.org/score/r/f/rf4xfu7bhu0k9n0ccidte6yjngjswnm/rf4xfu7b.png).
  static const doubleHarmonicMajor = ScalePattern([
    .m2,
    .A2,
    .m2,
    .M2,
    .m2,
    .A2,
    .m2,
  ]);

  /// Creates a new [ScalePattern] from the given [chordPattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.fromChordPattern(.majorTriad) == .major
  /// ScalePattern.fromChordPattern(.minorTriad) == .naturalMinor
  /// ```
  factory ScalePattern.fromChordPattern(ChordPattern chordPattern) {
    if (chordPattern.isAugmented) return lydianAugmented;
    if (chordPattern.isMajor) return major;
    if (chordPattern.isMinor) return naturalMinor;
    if (chordPattern.isDiminished) return locrian;

    // TODO(albertms10): add support for other triad constructions.
    return major;
  }

  /// Creates a new [ScalePattern] from a binary [sequence] in integer form.
  ///
  /// This method and [ScalePattern.toBinary] are inverses of each other.
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.fromBinary(101010110101.b) == .major
  /// ScalePattern.fromBinary(111111111111.b) == .chromatic
  /// ScalePattern.fromBinary(1010010101.b) == .majorPentatonic
  /// ScalePattern.fromBinary(101010101101.b, 10110101101.b) == .melodicMinor
  /// ```
  factory ScalePattern.fromBinary(int sequence, [int? descendingSequence]) {
    assert(sequence > 0, 'Sequence must be greater than 0');

    final degrees = [
      for (var i = 0; i < chromaticDivisions; i++)
        if (sequence.bitAt(i) != 0) PitchClass(i),
      PitchClass.c,
    ];
    final descendingDegrees = descendingSequence == null
        ? null
        : [
            PitchClass.c,
            for (var i = chromaticDivisions - 1; i >= 0; i--)
              if (descendingSequence.bitAt(i) != 0) PitchClass(i),
          ];

    return Scale(degrees, descendingDegrees).pattern;
  }

  /// The binary representation of this [ScalePattern].
  ///
  /// This method and [ScalePattern.fromBinary] are inverses of each other.
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.toBinary() == (101010110101.b, null)
  /// ScalePattern.chromatic.toBinary() == (111111111111.b, null)
  /// ScalePattern.majorPentatonic.toBinary() == (1010010101.b, null)
  /// ScalePattern.melodicMinor.toBinary() == (101010101101.b, 10110101101.b)
  /// ```
  (int sequence, int? descendingSequence) toBinary() {
    final Scale<PitchClass>(:degrees, :descendingDegrees) = on(.c);
    final sequence = degrees.fold(0, _setBit);
    final descendingSequence =
        descendingDegrees.reversed.isEnharmonicWith(degrees)
        ? null
        : descendingDegrees.fold(0, _setBit);

    return (sequence, descendingSequence);
  }

  /// Sets the bit from [sequence] at [scalable] semitones.
  static int _setBit(int sequence, Scalable<PitchClass> scalable) =>
      sequence.setBitAt(scalable.semitones);

  /// The length of this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.minorPentatonic.length == 5
  /// ScalePattern.major.length == 7
  /// ScalePattern.octatonic.length == 8
  /// ScalePattern.chromatic.length == 12
  /// ```
  int get length => degreePatterns.length;

  /// The scale of notes starting from [scalable].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.on(Note.c)
  ///   == const Scale<Note>([.c, .d, .e, .f, .g, .a, .b, .c])
  ///
  /// ScalePattern.naturalMinor.on(Note.a)
  ///   == const Scale<Note>([.a, .b, .c, .d, .e, .f, .g, .a])
  ///
  /// ScalePattern.melodicMinor.on(Note.c)
  ///   == Scale([.c, .d, .e.flat, .f, .g, .a, .b, .c])
  /// ```
  Scale<T> on<T extends Scalable<T>>(T scalable) => Scale(
    _intervalSteps.fold([
      scalable,
    ], (scale, interval) => [...scale, scale.last.transposeBy(interval)]),
    // We iterate over the `reversed` descending step list to make sure
    // both regular and descending scales match, e.g., their octave in
    // `Pitch` lists.
    _descendingIntervalSteps?.reversed
        .fold([
          scalable,
        ], (scale, interval) => [...scale, scale.last.transposeBy(interval)])
        .reversed
        .toList(growable: false),
  );

  /// The mirrored scale version of this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.ionian.mirrored == .phrygian
  /// ScalePattern.dorian.mirrored == .dorian
  /// ScalePattern.locrian.mirrored == .lydian
  /// ```
  ScalePattern get mirrored => ScalePattern(
    descendingIntervalSteps,
    _descendingIntervalSteps != null ? _intervalSteps : null,
  );

  /// The [ChordPattern] for each scale degree in this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.degreePatterns == const <ChordPattern>[
  ///   .majorTriad,
  ///   .minorTriad,
  ///   .minorTriad,
  ///   .majorTriad,
  ///   .majorTriad,
  ///   .minorTriad,
  ///   .diminishedTriad,
  /// ]
  /// ```
  List<ChordPattern> get degreePatterns => [
    for (var i = 1; i <= _intervalSteps.length; i++)
      degreePattern(ScaleDegree(i)),
  ];

  /// The [ChordPattern] for the [scaleDegree] of this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.degreePattern(.i) == .majorTriad
  /// ScalePattern.major.degreePattern(.vii) == .diminishedTriad
  /// ScalePattern.naturalMinor.degreePattern(.iv) == .minorTriad
  /// ```
  ChordPattern degreePattern(ScaleDegree scaleDegree) {
    if (scaleDegree.quality != null) return .fromQuality(scaleDegree.quality!);

    // Deduce the diatonic `ChordPattern` from this `intervalSteps`.
    return .fromIntervalSteps([
      _addNextStepTo(scaleDegree.ordinal),
      _addNextStepTo(scaleDegree.ordinal + 2),
    ]);
  }

  Interval _stepFrom(int ordinal) =>
      _intervalSteps[(ordinal - 1) % _intervalSteps.length];

  Interval _addNextStepTo(int ordinal) =>
      _stepFrom(ordinal) + _stepFrom(ordinal + 1);

  /// Excludes [intervals] from this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.exclude({.m2}) == .majorPentatonic
  /// ```
  ScalePattern exclude(Set<Interval> intervals) {
    final steps = <Interval>[];
    for (var i = 0; i < _intervalSteps.length; i++) {
      final interval = _intervalSteps[i];
      if (!intervals.contains(interval)) {
        steps.add(interval);
      } else if (i == _intervalSteps.length - 1) {
        steps[steps.length - 1] = steps.last + interval;
      } else {
        steps.add(_intervalSteps[i + 1] + interval);
        i++;
      }
    }

    return ScalePattern(steps);
  }

  /// Whether this [ScalePattern] is enharmonically equivalent to [other].
  ///
  /// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence).
  ///
  /// Example:
  /// ```dart
  /// const ScalePattern([.m2, .m3, .M2])
  ///   .isEnharmonicWith(ScalePattern([.m2, .A2, .d3])) == true
  /// ```
  bool isEnharmonicWith(ScalePattern other) =>
      _intervalSteps.isEnharmonicWith(other._intervalSteps) &&
      (_descendingIntervalSteps ?? const []).isEnharmonicWith(
        other._descendingIntervalSteps ?? const [],
      );

  /// The name associated with this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.mixolydian.name == 'Mixolydian'
  /// ScalePattern.chromatic.name == 'Chromatic'
  /// ScalePattern.melodicMinor.name == 'Melodic minor'
  /// ```
  String? get name => switch (this) {
    ionian => 'Major (ionian)',
    dorian => 'Dorian',
    phrygian => 'Phrygian',
    lydian => 'Lydian',
    lydianAugmented => 'Lydian augmented',
    mixolydian => 'Mixolydian',
    aeolian => 'Natural minor (aeolian)',
    locrian => 'Locrian',
    harmonicMinor => 'Harmonic minor',
    melodicMinor => 'Melodic minor',
    chromatic => 'Chromatic',
    wholeTone => 'Whole-tone',
    majorPentatonic => 'Major pentatonic',
    minorPentatonic => 'Minor pentatonic',
    octatonic => 'Octatonic',
    doubleHarmonicMajor => 'Double harmonic major',
    _ => null,
  };

  @override
  String toString() {
    final descendingSteps = _descendingIntervalSteps != null
        ? ', ${_descendingIntervalSteps.join(' ')}'
        : '';

    return '$name (${_intervalSteps.join(' ')}$descendingSteps)';
  }

  @override
  bool operator ==(Object other) =>
      other is ScalePattern && isEnharmonicWith(other);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(_intervalSteps.toClass()),
    _descendingIntervalSteps != null
        ? Object.hashAll(_descendingIntervalSteps.toClass())
        : null,
  );
}

extension _BinarySequence on int {
  /// The value of the bit at the specified [index].
  ///
  /// This method checks whether the bit at the given [index]
  /// is set (1) or not (0).
  /// It uses a bitwise AND operation with a mask `1 << index`
  /// to isolate the bit.
  ///
  /// Given 10 is 1010 in binary:
  ///
  /// Example:
  /// ```dart
  /// 1010.b.bitAt(0) == 0000.b // 0
  /// 1010.b.bitAt(1) == 0010.b // 2
  /// 1010.b.bitAt(2) == 0000.b // 0
  /// 1010.b.bitAt(3) == 1000.b // 8
  /// ```
  int bitAt(int index) => this & (1 << index);

  /// Sets the bit at the specified [index] to 1 and returns the new integer.
  ///
  /// This method uses a bitwise OR operation with a mask `1 << index`
  /// to set the specific bit at the given [index] to 1,
  /// leaving all other bits unchanged.
  ///
  /// Given 10 is 1010 in binary:
  ///
  /// Example:
  /// ```dart
  /// 1010.b.setBit(0) == 1011.b // 11
  /// 1010.b.setBit(2) == 1110.b // 14
  /// ```
  int setBitAt(int index) => this | (1 << index);
}

/// A binary sequence int extension.
extension BinarySequence on int {
  /// This [int] as a binary integer.
  int get b => .parse(toString(), radix: 2);
}
