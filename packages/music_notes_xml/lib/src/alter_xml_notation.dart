import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'accidental_xml_notation.dart';
import 'xml_notation_system.dart';

/// The MusicXML `<alter>` notation system for [Accidental], expressed as
/// the signed number of semitones from the natural step.
///
/// This is the numeric sibling of [AccidentalXmlNotation], used inside
/// `<pitch>`, `<root>`, and `<bass>` rather than as a standalone visual
/// symbol.
///
/// See the [alter element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/alter/).
final class AlterXmlNotation extends XmlNotationSystem<Accidental> {
  /// Creates a new [AlterXmlNotation].
  const AlterXmlNotation();

  @override
  String get elementName => 'alter';

  /// Example:
  /// ```dart
  /// const AlterXmlNotation().parseElement(
  ///   XmlDocument.parse('<alter>-1</alter>').rootElement,
  /// ) == Accidental.flat
  /// ```
  @override
  Accidental parseElement(XmlElement element) =>
      Accidental(.parse(element.innerText.trim()));

  /// Example:
  /// ```dart
  /// const AlterXmlNotation().format(Accidental.sharp).toXmlString()
  ///   == '<alter>1</alter>'
  /// ```
  @override
  XmlElement format(Accidental value) => XmlElement(XmlName(elementName), [], [
    XmlText('${value.semitones}'),
  ]);
}
