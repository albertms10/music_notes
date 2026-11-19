import '../notation_system/notation_system.dart';
import '../note/note.dart';
import 'german_named_octave_notation.dart';
import 'helmholtz_octave_notation.dart';
import 'scientific_octave_notation.dart';

/// A musical octave, in scientific pitch notation numbering (e.g. `4` for
/// the octave containing middle C).
///
/// This is the single canonical representation from which every other
/// octave notation (Helmholtz marks, German named octaves, numbered
/// Helmholtz, …) is derived through a [StringNotationSystem].
///
/// Because [Octave] `implements int`, any value of this type can be used
/// wherever a plain octave `int` is expected (e.g. [Note.inOctave]), so
/// parsing an octave from any notation and feeding it straight into the
/// rest of the API requires no extra conversion:
///
/// ```dart
/// Note.a.inOctave(Octave.parse('große')) == Note.a.inOctave(.great)
/// ```
extension type const Octave(int number) implements int {
  /// The reference [Octave] (the octave containing middle C).
  static const reference = Octave(4);

  /// The sub-contra octave (_subkontra_).
  static const subContra = Octave(0);

  /// The contra octave (_kontra_).
  static const contra = Octave(1);

  /// The great octave (_große_).
  static const great = Octave(2);

  /// The small octave (_kleine_).
  static const small = Octave(3);

  /// The one-line octave (_eingestrichene_), containing middle C.
  ///
  /// Equivalent to [reference].
  static const oneLine = reference;

  /// The two-line octave (_zweigestrichene_).
  static const twoLine = Octave(5);

  /// The three-line octave (_dreigestrichene_).
  static const threeLine = Octave(6);

  /// The four-line octave (_viergestrichene_).
  static const fourLine = Octave(7);

  /// The five-line octave (_fünfgestrichene_).
  static const fiveLine = Octave(8);

  /// The chain of [StringParser]s used to parse an [Octave].
  static const parsers = [
    ScientificOctaveNotation(),
    GermanNamedOctaveNotation(),
    HelmholtzOctaveNotation.ascii(),
    HelmholtzOctaveNotation(),
  ];

  /// Parse [source] as an [Octave] and return its value.
  ///
  /// If the [source] string does not contain a valid [Octave], a
  /// [FormatException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// Octave.parse('4') == Octave.reference
  /// Octave.parse('-1') == const Octave(-1)
  /// Octave.parse('große') == Octave.great
  /// Octave.parse('z') // throws a FormatException
  /// ```
  factory Octave.parse(
    String source, {
    List<StringParser<Octave>> chain = parsers,
  }) => chain.parse(source);

  /// The string representation of this [Octave] based on [formatter].
  ///
  /// Example:
  /// ```dart
  /// Octave.reference.format() == '4'
  /// Octave.great.format(const GermanNamedOctaveNotation()) == 'große'
  /// ```
  String format([
    StringFormatter<Octave> formatter = const ScientificOctaveNotation(),
  ]) => formatter.format(this);
}
