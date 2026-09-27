import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'xml_notation_system.dart';

/// The MusicXML `<step>` notation system for [NoteName].
///
/// See the [step element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/step/).
final class NoteNameXmlNotation extends XmlNotationSystem<NoteName> {
  /// Creates a new [NoteNameXmlNotation].
  const NoteNameXmlNotation();

  @override
  String get elementName => 'step';

  /// Example:
  /// ```dart
  /// const NoteNameXmlNotation().parseElement(
  ///   XmlDocument.parse('<step>D</step>').rootElement,
  /// ) == NoteName.d
  /// ```
  @override
  NoteName parseElement(XmlElement element) =>
      NoteName.values.byName(element.innerText.trim().toLowerCase());

  /// Example:
  /// ```dart
  /// const NoteNameXmlNotation().format(NoteName.f).toXmlString()
  ///   == '<step>F</step>'
  /// ```
  @override
  XmlElement format(NoteName value) => XmlElement(XmlName(elementName), [], [
    XmlText(value.name.toUpperCase()),
  ]);
}
