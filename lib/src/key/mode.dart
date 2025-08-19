import 'package:meta/meta.dart' show immutable;
import 'package:music_notes/utils.dart';

import '../notation_system.dart';
import '../scale/scale_pattern.dart';
import 'key.dart';

/// A type of musical scale coupled with a set of characteristic melodic and
/// harmonic behaviors.
///
/// See [Mode (music)](https://en.wikipedia.org/wiki/Mode_(music)).
///
/// ---
/// See also:
/// * [Key].
/// * [ScalePattern].
@immutable
sealed class Mode implements Enum, Comparable<Mode> {
  /// The [ScalePattern] related to this [Mode].
  ScalePattern get scale;

  /// The [Dorian Brightness Quotient](https://mynewmicrophone.com/dorian-brightness-quotient)
  /// is a number we assign to a heptatonic scale that tells us how bright or
  /// dark the scale is relative to [ModalMode.dorian].
  ///
  /// The lower the number, the darker the scale. The higher the number,
  /// the brighter the scale.
  int get brightness;

  /// [Comparator] for [Mode]s.
  static int compare(Mode a, Mode b) => compareMultiple([
    () => a.brightness.compareTo(b.brightness),
    () => a.name.compareTo(b.name),
  ]);
}

/// Modes of a tonal system.
enum TonalMode implements Mode {
  /// See [Major mode](https://en.wikipedia.org/wiki/Major_mode).
  major(ScalePattern.major, brightness: 2),

  /// See [Minor mode](https://en.wikipedia.org/wiki/Minor_mode).
  minor(ScalePattern.naturalMinor, brightness: -1);

  @override
  final ScalePattern scale;

  @override
  final int brightness;

  const TonalMode(this.scale, {required this.brightness});

  /// Parse [source] as a [TonalMode] and return its value.
  factory TonalMode.parse(
    String source, {
    List<Parser<TonalMode>> chain = const [
      EnglishTonalModeNotation(),
      GermanTonalModeNotation(),
      RomanceTonalModeNotation(),
    ],
  }) => chain.parse(source);

  /// The parallel (opposite) of this [TonalMode].
  ///
  /// Example:
  /// ```dart
  /// TonalMode.major.parallel == TonalMode.minor
  /// TonalMode.minor.parallel == TonalMode.major
  /// ```
  TonalMode get parallel => switch (this) {
    TonalMode.major => TonalMode.minor,
    TonalMode.minor => TonalMode.major,
  };

  /// The string representation of this [TonalMode] based on [formatter].
  @override
  String toString({
    Formatter<TonalMode> formatter = const EnglishTonalModeNotation(),
  }) => formatter.format(this);

  @override
  int compareTo(Mode other) => Mode.compare(this, other);
}

/// The English notation system for [TonalMode].
final class EnglishTonalModeNotation extends NotationSystem<TonalMode> {
  /// Creates a new [EnglishTonalModeNotation].
  const EnglishTonalModeNotation();

  static const _major = 'major';
  static const _minor = 'minor';

  @override
  String format(TonalMode tonalMode) => switch (tonalMode) {
    TonalMode.major => _major,
    TonalMode.minor => _minor,
  };

  static final RegExp _regExp = RegExp(
    '(?<mode>$_major|$_minor)',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  TonalMode parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('mode')?.toLowerCase()) {
        _major => TonalMode.major,
        _ /* _minor */ => TonalMode.minor,
      };
}

/// The German notation system for [TonalMode
final class GermanTonalModeNotation extends NotationSystem<TonalMode> {
  /// Creates a new [GermanTonalModeNotation].
  const GermanTonalModeNotation();

  static const _major = 'dur';
  static const _minor = 'moll';

  @override
  String format(TonalMode tonalMode) => switch (tonalMode) {
    TonalMode.major => _major,
    TonalMode.minor => _minor,
  }.toUpperFirst();

  static final RegExp _regExp = RegExp(
    '(?<mode>$_major|$_minor)',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  TonalMode parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('mode')?.toLowerCase()) {
        _major => TonalMode.major,
        _ /* _minor */ => TonalMode.minor,
      };
}

/// The Romance notation system for [TonalMode
final class RomanceTonalModeNotation extends NotationSystem<TonalMode> {
  /// Creates a new [RomanceTonalModeNotation].
  const RomanceTonalModeNotation();

  static const _major = 'maggiore';
  static const _minor = 'minore';

  @override
  String format(TonalMode tonalMode) => switch (tonalMode) {
    TonalMode.major => _major,
    TonalMode.minor => _minor,
  };

  static final RegExp _regExp = RegExp(
    '(?<mode>$_major|$_minor)',
    caseSensitive: false,
  );

  @override
  RegExp get regExp => _regExp;

  @override
  TonalMode parseMatch(RegExpMatch match) =>
      switch (match.namedGroup('mode')?.toLowerCase()) {
        _major => TonalMode.major,
        _ /* _minor */ => TonalMode.minor,
      };
}

/// Modes of a modal system.
enum ModalMode implements Mode {
  /// See [Lydian mode](https://en.wikipedia.org/wiki/Lydian_mode).
  lydian(ScalePattern.lydian, brightness: 3),

  /// See [Ionian mode](https://en.wikipedia.org/wiki/Ionian_mode).
  ionian(ScalePattern.ionian, brightness: 2),

  /// See [Mixolydian mode](https://en.wikipedia.org/wiki/Mixolydian_mode).
  mixolydian(ScalePattern.mixolydian, brightness: 1),

  /// See [Dorian mode](https://en.wikipedia.org/wiki/Dorian_mode).
  dorian(ScalePattern.dorian, brightness: 0),

  /// See [Aeolian mode](https://en.wikipedia.org/wiki/Aeolian_mode).
  aeolian(ScalePattern.aeolian, brightness: -1),

  /// See [Phrygian mode](https://en.wikipedia.org/wiki/Phrygian_mode).
  phrygian(ScalePattern.phrygian, brightness: -2),

  /// See [Locrian mode](https://en.wikipedia.org/wiki/Locrian_mode).
  locrian(ScalePattern.locrian, brightness: -3);

  @override
  final ScalePattern scale;

  @override
  final int brightness;

  const ModalMode(this.scale, {required this.brightness});

  /// The mirrored version of this [ModalMode].
  ///
  /// Follows the DBQ property where the mirrored mode has the opposite
  /// [brightness] value.
  ///
  /// Example:
  /// ```dart
  /// ModalMode.dorian.mirrored == ModalMode.dorian
  /// ModalMode.ionian.mirrored == ModalMode.phrygian
  /// ModalMode.aeolian.mirrored == ModalMode.mixolydian
  /// ```
  ModalMode get mirrored =>
      values.firstWhere((mode) => mode.brightness == -brightness);

  @override
  int compareTo(Mode other) => Mode.compare(this, other);
}
