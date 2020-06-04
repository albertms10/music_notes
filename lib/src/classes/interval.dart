part of music_notes;

class Interval {
  final Intervals interval;
  final Qualities quality;
  final bool descending;

  const Interval(this.interval, this.quality, {this.descending = false})
      : assert(interval != null),
        assert(quality != null);

  Interval.fromDelta(Intervals interval, int delta)
      : this(
          interval,
          interval.isPerfect
              ? QualitiesValues.perfectQualitiesDeltas.toList()[delta]
              : QualitiesValues.qualitiesDeltas.toList()[delta],
        );

  /// Returns the number of semitones of this [Interval].
  /// 
  /// ```dart
  /// Interval(Intervals.Segona, Qualities.Major).semitones == 2
  /// 
  /// Interval(Intervals.Quinta, Qualities.Disminuida).semitones
  ///   == Interval(Intervals.Quarta, Qualities.Augmentada).semitones 
  ///   == 6
  /// ```
  int get semitones =>
      (interval.semitones +
          (interval.isPerfect
                  ? QualitiesValues.perfectQualitiesDeltas
                  : QualitiesValues.qualitiesDeltas)
              .toList()
              .indexOf(quality) -
          1) *
      (descending ? -1 : 1);

  /// Returns the inverted of this [Interval].
  /// 
  /// ```dart
  /// Interval(Intervals.Tercera, Qualities.Menor).inverted
  ///   == Interval(Intervals.Sexta, Qualities.Major)
  /// 
  /// Interval(Intervals.Unison, Qualities.Justa).inverted
  ///   == Interval(Intervals.Octava, Qualities.Justa)
  /// ```
  Interval get inverted => Interval(interval.inverted, quality.inverted);

  @override
  String toString() => '${interval.toText()} ${quality.toText()}';

  @override
  bool operator ==(other) =>
      other is Interval &&
      this.interval == other.interval &&
      this.quality == other.quality;
}
