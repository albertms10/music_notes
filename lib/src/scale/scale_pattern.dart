part of '../../music_notes.dart';

/// A set of musical notes ordered by fundamental frequency or pitch.
///
/// See [Scale (music)](https://en.wikipedia.org/wiki/Scale_(music)).
final class ScalePattern {
  /// The interval steps that define this [ScalePattern].
  final List<Interval> intervalSteps;

  /// The descending interval steps that define this [ScalePattern] (if
  /// different).
  final List<Interval>? _descendingIntervalSteps;

  /// Creates a new [ScalePattern] from [intervalSteps] and optional
  /// [_descendingIntervalSteps].
  const ScalePattern(this.intervalSteps, [this._descendingIntervalSteps]);

  /// ![C Ionian scale](https://upload.wikimedia.org/score/p/2/p2fun2296uif26uyy61yxjli7ocfq9d/p2fun229.png).
  static const ionian = ScalePattern([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
  ]);

  /// ![C Dorian scale](https://upload.wikimedia.org/score/g/y/gydc9ka2vd8tdso0yv7qf15vu7axtr8/gydc9ka2.png).
  static const dorian = ScalePattern([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
  ]);

  /// ![C Phrygian scale](https://upload.wikimedia.org/score/o/l/oljahwegklc7tqhe1gpekwo6sro4xkm/oljahweg.png).
  static const phrygian = ScalePattern([
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);

  /// ![C Lydian scale](https://upload.wikimedia.org/score/0/c/0cg9y4ajzy2jwu8s2887oaq4fwkwbqs/0cg9y4aj.png).
  static const lydian = ScalePattern([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
  ]);

  /// ![C Mixolydian scale](https://upload.wikimedia.org/score/s/j/sjbifo4dqsa0aozgvdr38c2z8qq3f9k/sjbifo4d.png).
  static const mixolydian = ScalePattern([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
  ]);

  /// ![C Aeolian scale](https://upload.wikimedia.org/score/c/s/cseytu8cn39n7a6wp4j23dfqjdnsan7/cseytu8c.png).
  static const aeolian = ScalePattern([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);

  /// ![C Locrian scale](https://upload.wikimedia.org/score/a/5/a54xaj67nftcpgw3wgsaxqjcfnwram5/a54xaj67.png).
  static const locrian = ScalePattern([
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
  ]);

  /// ![C Major scale](https://upload.wikimedia.org/score/1/4/149hxowm0jnjun0byp4xzvq7h12ndfg/149hxowm.png).
  static const major = ionian;

  /// ![C Natural minor scale](https://upload.wikimedia.org/score/h/k/hkrek1madm24z0ssu3s37ddrohklugf/hkrek1ma.png).
  static const naturalMinor = aeolian;

  /// ![C Harmonic minor scale](https://upload.wikimedia.org/score/7/3/73zt4ivl6l561j0n2a1qp68d51l2yug/73zt4ivl.png).
  static const harmonicMinor = ScalePattern([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.augmentedSecond,
    Interval.minorSecond,
  ]);

  /// ![C Melodic minor scale](https://upload.wikimedia.org/score/9/2/92i6sjg41ji8y1ab881a1pcq1u3hr0p/92i6sjg4.png).
  static const melodicMinor = ScalePattern(
    [
      Interval.majorSecond,
      Interval.minorSecond,
      Interval.majorSecond,
      Interval.majorSecond,
      Interval.majorSecond,
      Interval.majorSecond,
      Interval.minorSecond,
    ],
    [
      Interval.majorSecond,
      Interval.majorSecond,
      Interval.minorSecond,
      Interval.majorSecond,
      Interval.majorSecond,
      Interval.minorSecond,
      Interval.majorSecond,
    ],
  );

  /// See [Chromatic scale](https://en.wikipedia.org/wiki/Chromatic_scale).
  ///
  /// ![C Chromatic scale](https://upload.wikimedia.org/score/m/u/mu2yiewo9c4oa1bzfg20dg3ltwd5iu3/mu2yiewo.png).
  static const chromatic = ScalePattern([
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.augmentedUnison,
    Interval.minorSecond,
    Interval.minorSecond,
  ]);

  /// See [Whole-tone scale](https://en.wikipedia.org/wiki/Whole-tone_scale).
  ///
  /// ![C Whole-tone scale](https://upload.wikimedia.org/score/l/c/lcqo121bdjjfsvvxcp86l59yaa46v8o/lcqo121b.png).
  static const wholeTone = ScalePattern([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.diminishedThird,
  ]);

  /// See [Pentatonic scale](https://en.wikipedia.org/wiki/Pentatonic_scale).
  ///
  /// ![C Major pentatonic scale](https://upload.wikimedia.org/score/j/7/j7cn43w4nuz0j5imzs8ijatkfxh1x0h/j7cn43w4.png).
  static const majorPentatonic = ScalePattern([
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorThird,
    Interval.majorSecond,
    Interval.minorThird,
  ]);

  /// See [Pentatonic scale](https://en.wikipedia.org/wiki/Pentatonic_scale).
  ///
  /// ![A Minor pentatonic scale](https://upload.wikimedia.org/score/s/c/sc9aoxty66zu9ccwp6qclwcuuai6pjz/sc9aoxty.png).
  static const minorPentatonic = ScalePattern([
    Interval.minorThird,
    Interval.majorSecond,
    Interval.majorSecond,
    Interval.minorThird,
    Interval.majorSecond,
  ]);

  /// See [Octatonic scale](https://en.wikipedia.org/wiki/Octatonic_scale).
  ///
  /// ![C Octatonic scale](https://upload.wikimedia.org/score/0/7/07sm4b4dbpp5ynvdfuedj2e87e14ym3/07sm4b4d.png).
  ///
  /// ![C Octatonic scale](https://upload.wikimedia.org/score/3/k/3k5luxd4mjag2z377hvt9gg3njf0882/3k5luxd4.png).
  static const octatonic = ScalePattern([
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
    Interval.majorSecond,
    Interval.minorSecond,
  ]);

  /// The descending interval steps that define this [ScalePattern].
  List<Interval> get descendingIntervalSteps =>
      _descendingIntervalSteps ?? intervalSteps.reversed.toList();

  /// Returns the scale of notes starting from [transposable].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.major.fromNote(Note.c)
  ///   == const [Note.c, Note.d, Note.e, Note.f, Note.g, Note.a, Note.b,
  ///        Note.c]
  ///
  /// ScalePattern.naturalMinor.fromNote(Note.a)
  ///   == const [Note.a, Note.b, Note.c, Note.d, Note.e, Note.f, Note.g,
  ///        Note.a]
  ///
  /// ScalePattern.melodicMinor.fromNote(Note.c)
  ///   == [Note.c, Note.d, Note.e.flat, Note.f, Note.g, Note.a, Note.b, Note.c]
  ///
  /// ScalePattern.melodicMinor.fromNote(Note.c, isDescending: true)
  ///   == [Note.c, Note.b.flat, Note.a.flat, Note.g, Note.f, Note.e.flat,
  ///        Note.d, Note.c]
  /// ```
  List<T> fromNote<T extends Transposable<T>>(
    T transposable, {
    bool isDescending = false,
  }) {
    final steps = isDescending ? descendingIntervalSteps : intervalSteps;

    return steps.fold(
      [transposable],
      (scaleNotes, interval) => [
        ...scaleNotes,
        scaleNotes.last.transposeBy(
          interval.descending(isDescending: isDescending),
        ),
      ],
    );
  }

  /// Returns the mirrored scale version of this [ScalePattern].
  ///
  /// Example:
  /// ```dart
  /// ScalePattern.ionian.mirrored == ScalePattern.phrygian
  /// ScalePattern.dorian.mirrored == ScalePattern.dorian
  /// ScalePattern.locrian.mirrored == ScalePattern.lydian
  /// ```
  ScalePattern get mirrored => ScalePattern(intervalSteps.reversed.toList());

  /// Returns the name associated with this [ScalePattern].
  ///
  /// ```dart
  /// ScalePattern.mixolydian.name == 'Mixolydian'
  /// ScalePattern.chromatic.name == 'Chromatic'
  /// ScalePattern.melodicMinor.name == 'Melodic minor'
  /// ```
  String? get name => switch (this) {
        ScalePattern.ionian => 'Major (ionian)',
        ScalePattern.dorian => 'Dorian',
        ScalePattern.phrygian => 'Phrygian',
        ScalePattern.lydian => 'Lydian',
        ScalePattern.mixolydian => 'Mixolydian',
        ScalePattern.aeolian => 'Natural minor (aeolian)',
        ScalePattern.locrian => 'Locrian',
        ScalePattern.harmonicMinor => 'Harmonic minor',
        ScalePattern.melodicMinor => 'Melodic minor',
        ScalePattern.chromatic => 'Chromatic',
        ScalePattern.wholeTone => 'Whole-tone',
        ScalePattern.majorPentatonic => 'Major pentatonic',
        ScalePattern.minorPentatonic => 'Minor pentatonic',
        ScalePattern.octatonic => 'Octatonic',
        _ => null,
      };

  @override
  String toString() {
    final descendingSteps = _descendingIntervalSteps != null
        ? ', ${_descendingIntervalSteps!.join(' ')}'
        : '';

    return '$name (${intervalSteps.join(' ')}$descendingSteps)';
  }

  @override
  bool operator ==(Object other) =>
      other is ScalePattern &&
      const ListEquality<Interval>()
          .equals(intervalSteps, other.intervalSteps) &&
      const ListEquality<Interval>()
          .equals(_descendingIntervalSteps, other._descendingIntervalSteps);

  @override
  int get hashCode => Object.hashAll(intervalSteps);
}
