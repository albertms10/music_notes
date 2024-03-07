import 'package:collection/collection.dart' show UnmodifiableListView;
import 'package:meta/meta.dart' show immutable;

import '../class_mixin.dart';
import '../harmony/chord_pattern.dart';
import '../interval/interval.dart';
import '../scalable.dart';
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
  static const ionian = ScalePattern([
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
  ]);

  /// ![C Dorian scale](https://upload.wikimedia.org/score/g/y/gydc9ka2vd8tdso0yv7qf15vu7axtr8/gydc9ka2.png).
  static const dorian = ScalePattern([
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
  ]);

  /// ![C Phrygian scale](https://upload.wikimedia.org/score/o/l/oljahwegklc7tqhe1gpekwo6sro4xkm/oljahweg.png).
  static const phrygian = ScalePattern([
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
  ]);

  /// ![C Lydian scale](https://upload.wikimedia.org/score/0/c/0cg9y4ajzy2jwu8s2887oaq4fwkwbqs/0cg9y4aj.png).
  static const lydian = ScalePattern([
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
  ]);

  /// ![C Lydian augmented scale](https://upload.wikimedia.org/score/3/b/3b5vj7v08y1yuemdmewgxuuid25oezn/3b5vj7v0.png).
  static const lydianAugmented = ScalePattern([
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.m2,
  ]);

  /// ![C Mixolydian scale](https://upload.wikimedia.org/score/s/j/sjbifo4dqsa0aozgvdr38c2z8qq3f9k/sjbifo4d.png).
  static const mixolydian = ScalePattern([
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
  ]);

  /// ![C Aeolian scale](https://upload.wikimedia.org/score/c/s/cseytu8cn39n7a6wp4j23dfqjdnsan7/cseytu8c.png).
  static const aeolian = ScalePattern([
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
  ]);

  /// ![C Locrian scale](https://upload.wikimedia.org/score/a/5/a54xaj67nftcpgw3wgsaxqjcfnwram5/a54xaj67.png).
  static const locrian = ScalePattern([
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.M2,
  ]);

  /// ![C Major scale](https://upload.wikimedia.org/score/1/4/149hxowm0jnjun0byp4xzvq7h12ndfg/149hxowm.png).
  static const major = ionian;

  /// ![C Natural minor scale](https://upload.wikimedia.org/score/h/k/hkrek1madm24z0ssu3s37ddrohklugf/hkrek1ma.png).
  static const naturalMinor = aeolian;

  /// ![C Harmonic minor scale](https://upload.wikimedia.org/score/7/3/73zt4ivl6l561j0n2a1qp68d51l2yug/73zt4ivl.png).
  static const harmonicMinor = ScalePattern([
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.M2,
    Interval.m2,
    Interval.A2,
    Interval.m2,
  ]);

  /// ![C Melodic minor scale](https://upload.wikimedia.org/score/9/2/92i6sjg41ji8y1ab881a1pcq1u3hr0p/92i6sjg4.png).
  static const melodicMinor = ScalePattern(
    [
      Interval.M2,
      Interval.m2,
      Interval.M2,
      Interval.M2,
      Interval.M2,
      Interval.M2,
      Interval.m2,
    ],
    [
      Interval.M2,
      Interval.M2,
      Interval.m2,
      Interval.M2,
      Interval.M2,
      Interval.m2,
      Interval.M2,
    ],
  );

  /// See [Chromatic scale](https://en.wikipedia.org/wiki/Chromatic_scale).
  ///
  /// ![C Chromatic scale](https://upload.wikimedia.org/score/m/u/mu2yiewo9c4oa1bzfg20dg3ltwd5iu3/mu2yiewo.png).
  static const chromatic = ScalePattern([
    Interval.A1,
    Interval.m2,
    Interval.A1,
    Interval.m2,
    Interval.m2,
    Interval.A1,
    Interval.m2,
    Interval.A1,
    Interval.m2,
    Interval.A1,
    Interval.m2,
    Interval.m2,
  ]);

  /// See [Whole-tone scale](https://en.wikipedia.org/wiki/Whole-tone_scale).
  ///
  /// ![C Whole-tone scale](https://upload.wikimedia.org/score/l/c/lcqo121bdjjfsvvxcp86l59yaa46v8o/lcqo121b.png).
  static const wholeTone = ScalePattern([
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.M2,
    Interval.d3,
  ]);

  /// See [Pentatonic scale](https://en.wikipedia.org/wiki/Pentatonic_scale).
  ///
  /// ![C Major pentatonic scale](https://upload.wikimedia.org/score/j/7/j7cn43w4nuz0j5imzs8ijatkfxh1x0h/j7cn43w4.png).
  static const majorPentatonic = ScalePattern([
    Interval.M2,
    Interval.M2,
    Interval.m3,
    Interval.M2,
    Interval.m3,
  ]);

  /// See [Pentatonic scale](https://en.wikipedia.org/wiki/Pentatonic_scale).
  ///
  /// ![A Minor pentatonic scale](https://upload.wikimedia.org/score/s/c/sc9aoxty66zu9ccwp6qclwcuuai6pjz/sc9aoxty.png).
  static const minorPentatonic = ScalePattern([
    Interval.m3,
    Interval.M2,
    Interval.M2,
    Interval.m3,
    Interval.M2,
  ]);

  /// See [Octatonic scale](https://en.wikipedia.org/wiki/Octatonic_scale).
  ///
  /// ![C Octatonic scale](https://upload.wikimedia.org/score/0/7/07sm4b4dbpp5ynvdfuedj2e87e14ym3/07sm4b4d.png).
  ///
  /// ![C Octatonic scale](https://upload.wikimedia.org/score/3/k/3k5luxd4mjag2z377hvt9gg3njf0882/3k5luxd4.png).
  static const octatonic = ScalePattern([
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.m2,
    Interval.M2,
    Interval.m2,
  ]);

  /// Creates a new [ScalePattern] from the given [chordPattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.fromChordPattern(ChordPattern.majorTriad)
  ///   == ScalePattern.major
  /// ScalePattern.fromChordPattern(ChordPattern.minorTriad)
  ///   == ScalePattern.naturalMinor
  /// ```
  factory ScalePattern.fromChordPattern(ChordPattern chordPattern) {
    if (chordPattern.isAugmented) return lydianAugmented;
    if (chordPattern.isMajor) return major;
    if (chordPattern.isMinor) return naturalMinor;
    if (chordPattern.isDiminished) return locrian;

    // TODO(albertms10): add support for other triad constructions.
    return major;
  }

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
  ///   == const Scale([Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///        Note.c])
  ///
  /// ScalePattern.naturalMinor.on(Note.a)
  ///   == const Scale([Note.a, Note.b, Note.c, Note.d, Note.e, Note.f, Note.g,
  ///        Note.a])
  ///
  /// ScalePattern.melodicMinor.on(Note.c)
  ///   == Scale([Note.c, Note.d, Note.e.flat, Note.f, Note.g, Note.a, Note.b,
  ///        Note.c])
  /// ```
  Scale<T> on<T extends Scalable<T>>(T scalable) => Scale(
        _intervalSteps.fold(
          [scalable],
          (scale, interval) => [...scale, scale.last.transposeBy(interval)],
        ),
        // We iterate over the `reversed` descending step list to make sure
        // both regular and descending scales match, e.g., their octave in
        // `Pitch` lists.
        _descendingIntervalSteps?.reversed
            .fold(
              [scalable],
              (scale, interval) => [...scale, scale.last.transposeBy(interval)],
            )
            .reversed
            .toList(),
      );

  /// The mirrored scale version of this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.ionian.mirrored == ScalePattern.phrygian
  /// ScalePattern.dorian.mirrored == ScalePattern.dorian
  /// ScalePattern.locrian.mirrored == ScalePattern.lydian
  /// ```
  ScalePattern get mirrored => ScalePattern(
        descendingIntervalSteps,
        _descendingIntervalSteps != null ? _intervalSteps : null,
      );

  /// The [ChordPattern] for each scale degree in this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.degreePatterns == const [
  ///   ChordPattern.majorTriad,
  ///   ChordPattern.minorTriad,
  ///   ChordPattern.minorTriad,
  ///   ChordPattern.majorTriad,
  ///   ChordPattern.majorTriad,
  ///   ChordPattern.minorTriad,
  ///   ChordPattern.diminishedTriad,
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
  /// ScalePattern.major.degreePattern(ScaleDegree.i) == ChordPattern.majorTriad
  /// ScalePattern.major.degreePattern(ScaleDegree.vii)
  ///   == ChordPattern.diminishedTriad
  /// ScalePattern.naturalMinor.degreePattern(ScaleDegree.iv)
  ///   == ChordPattern.minorTriad
  /// ```
  ChordPattern degreePattern(ScaleDegree scaleDegree) {
    if (scaleDegree.quality != null) {
      return ChordPattern.fromQuality(scaleDegree.quality!);
    }

    // Deduce the diatonic `ChordPattern` from this `intervalSteps`.
    return ChordPattern.fromIntervalSteps([
      _addNextStepTo(scaleDegree.ordinal),
      _addNextStepTo(scaleDegree.ordinal + 2),
    ]);
  }

  Interval _stepFrom(int ordinal) =>
      _intervalSteps[(ordinal - 1) % _intervalSteps.length];

  Interval _addNextStepTo(int ordinal) =>
      _stepFrom(ordinal) + _stepFrom(ordinal + 1);

  /// Whether this [ScalePattern] is enharmonically equivalent to [other].
  ///
  /// See [Enharmonic equivalence](https://en.wikipedia.org/wiki/Enharmonic_equivalence).
  ///
  /// Example:
  /// ```dart
  /// const ScalePattern([Interval.m2, Interval.m3, Interval.M2])
  ///   .isEnharmonicWith(ScalePattern([Interval.m2, Interval.A2, Interval.d3]))
  ///     == true
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
