import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'xml_notation_system.dart';

/// The MusicXML `<kind>` notation system for [ChordPattern], covering the
/// triad- and seventh-chord subset of the `kind-value` enumeration.
///
/// Extended (9th/11th/13th) and altered `kind-value`s (e.g.
/// `major-11th`, `suspended-second`) are not covered.
///
/// See the [kind element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/kind/).
final class ChordPatternXmlNotation extends XmlNotationSystem<ChordPattern> {
  /// Creates a new [ChordPatternXmlNotation].
  const ChordPatternXmlNotation();

  @override
  String get elementName => 'kind';

  /// Example:
  /// ```dart
  /// const ChordPatternXmlNotation().parseElement(
  ///   XmlDocument.parse('<kind>dominant</kind>').rootElement,
  /// ) == ChordPattern.majorTriad.add7()
  /// ```
  @override
  ChordPattern parseElement(XmlElement element) {
    final word = element.innerText.trim().toLowerCase();

    return switch (word) {
      'major' => .majorTriad,
      'minor' => .minorTriad,
      'augmented' => .augmentedTriad,
      'diminished' => .diminishedTriad,
      'dominant' => .majorTriad.add7(),
      'major-seventh' => .majorTriad.add7(.major),
      'minor-seventh' => .minorTriad.add7(),
      'diminished-seventh' => .diminishedTriad.add7(.diminished),
      'half-diminished' => .diminishedTriad.add7(),
      'augmented-seventh' => .augmentedTriad.add7(),
      _ => throw FormatException('Unsupported kind-value', word),
    };
  }

  /// Example:
  /// ```dart
  /// const ChordPatternXmlNotation().format(ChordPattern.minorTriad.add7())
  ///     .toXmlString() == '<kind>minor-seventh</kind>'
  /// ```
  @override
  XmlElement format(ChordPattern value) {
    final seventh = value.at(.seventh);
    final word = switch (value) {
      _ when value.isDiminished && seventh == null => 'diminished',
      _
          when value.isDiminished &&
              seventh!.quality == ImperfectQuality.diminished =>
        'diminished-seventh',
      _ when value.isDiminished => 'half-diminished',
      _ when value.isAugmented && seventh != null => 'augmented-seventh',
      _ when value.isAugmented => 'augmented',
      _ when value.isMajor && seventh?.quality == ImperfectQuality.major =>
        'major-seventh',
      _ when value.isMajor && seventh != null => 'dominant',
      _ when value.isMajor => 'major',
      _ when value.isMinor && seventh != null => 'minor-seventh',
      _ when value.isMinor => 'minor',
      _ => throw ArgumentError.value(
        value,
        'value',
        'Unsupported ChordPattern for MusicXML <kind>',
      ),
    };

    return XmlElement(XmlName(elementName), [], [XmlText(word)]);
  }
}
