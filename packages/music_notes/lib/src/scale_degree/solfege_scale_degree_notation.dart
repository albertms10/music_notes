import '../accidental/accidental.dart';
import '../notation_system/notation_system.dart';
import 'numeric_scale_degree_notation.dart';
import 'roman_scale_degree_notation.dart';
import 'scale_degree.dart';

/// The movable-do solfège notation system for [ScaleDegree], e.g. `Do`,
/// `Fi`, `Le`.
///
/// This follows the standard 12-syllable chromatic solfège set (Kodály /
/// Curwen tradition):
///
///     Do Di Re Ri Mi Fa Fi Sol Si La Li Ti
///     Do Ti Te La Le Sol Se Fa Mi Me Re Ra
///
/// Only the alterations that actually exist in that set are representable.
///
/// By default this is "Do-based" (fixed-tonic) minor, where Do always
/// names the tonic and a scale's own accidentals (e.g. the ♭6 and ♭7 of
/// natural minor) are just [ScaleDegree.accidental] alterations on the
/// same 7 syllables, exactly as [RomanScaleDegreeNotation] and
/// [NumericScaleDegreeNotation] already treat them. Set [laBased] to
/// `true` for the alternative "La-based" convention, where the syllables
/// themselves rotate so the minor tonic is sung as La.
///
/// Compound/extended degrees (ordinal > 7) are octave-reduced, since
/// solfège has no notion of a "9th": it's just sung as Re.
///
/// See [Movable Do solfège](https://en.wikipedia.org/wiki/Solf%C3%A8ge#Movable_do_solf%C3%A8ge).
///
/// ---
/// See also:
/// * [ScaleDegree].
/// * [RomanScaleDegreeNotation].
/// * [NumericScaleDegreeNotation].
final class SolfegeScaleDegreeNotation
    extends StringNotationSystem<ScaleDegree> {
  /// The 7 natural syllables, indexed 0 (Do) to 6 (Ti).
  static const _baseSyllables = ['Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Ti'];

  /// The raised syllable for each index, or `null` where none exists (Mi
  /// and Ti have no raised form: their upper neighbor, Fa and Do, is
  /// already only a semitone away).
  static const _raisedSyllables = ['Di', 'Ri', null, 'Fi', 'Si', 'Li', null];

  /// The lowered syllable for each index, or `null` where none exists (Do
  /// and Fa have no lowered form: their lower neighbor, Ti and Mi, is
  /// already only a semitone away).
  static const _loweredSyllables = [null, 'Ra', 'Me', null, 'Se', 'Le', 'Te'];

  /// A lookup from lowercase syllable to its (base-table index, accidental).
  static final Map<String, ({int index, Accidental accidental})>
  _syllableLookup = {
    for (var i = 0; i < _baseSyllables.length; i++)
      _baseSyllables[i].toLowerCase(): (index: i, accidental: .natural),
    for (var i = 0; i < _raisedSyllables.length; i++)
      if (_raisedSyllables[i] case final syllable?)
        syllable.toLowerCase(): (index: i, accidental: .sharp),
    for (var i = 0; i < _loweredSyllables.length; i++)
      if (_loweredSyllables[i] case final syllable?)
        syllable.toLowerCase(): (index: i, accidental: .flat),
  };

  /// Whether to use the "La-based" minor convention, where the minor tonic
  /// is sung as La instead of Do.
  ///
  /// Defaults to `false` (Do-based / fixed-tonic minor), which is what
  /// [ScaleDegree.accidental] is already shaped for: a scale's own
  /// alterations (e.g. natural minor's ♭6, ♭7) map directly onto the
  /// lowered syllables. [ScaleDegree] itself carries no mode information,
  /// so this choice has to be made explicitly by the caller rather than
  /// inferred.
  final bool laBased;

  /// Creates a new [SolfegeScaleDegreeNotation].
  const SolfegeScaleDegreeNotation({this.laBased = false});

  /// A [SolfegeScaleDegreeNotation] using the La-based minor convention.
  const SolfegeScaleDegreeNotation.laBased() : laBased = true;

  /// The base-table index (0–6) for [ordinal], octave-reduced and rotated
  /// according to [laBased].
  int _syllableIndex(int ordinal) {
    final reduced = (ordinal - 1) % _baseSyllables.length;

    return laBased ? (reduced + 5) % _baseSyllables.length : reduced;
  }

  @override
  ScaleDegree parse(String source) {
    final (:index, :accidental) =
        _syllableLookup[source.toLowerCase()] ??
        (throw FormatException('Invalid solfège ScaleDegree notation', source));

    final reduced = laBased
        ? (index - 5 + _baseSyllables.length) % _baseSyllables.length
        : index;

    return ScaleDegree(reduced + 1, accidental: accidental);
  }

  @override
  String format(ScaleDegree scaleDegree) {
    final index = _syllableIndex(scaleDegree.ordinal);

    return switch (scaleDegree.accidental) {
      .natural => _baseSyllables[index],
      .sharp =>
        _raisedSyllables[index] ??
            (throw UnsupportedError(
              'No raised solfège syllable for ${_baseSyllables[index]} '
              '(its upper neighbor is already a semitone away)',
            )),
      .flat =>
        _loweredSyllables[index] ??
            (throw UnsupportedError(
              'No lowered solfège syllable for ${_baseSyllables[index]} '
              '(its lower neighbor is already a semitone away)',
            )),
      final accidental => throw UnsupportedError(
        'Accidental $accidental has no solfège representation',
      ),
    };
  }
}
