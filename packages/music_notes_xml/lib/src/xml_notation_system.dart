import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'pitch_xml_notation.dart';

/// An abstract representation of a notation system for parsing and
/// formatting [V] from and to a MusicXML [XmlElement].
///
/// Mirrors [StringNotationSystem] producing and consuming structured XML
/// nodes instead of plain strings, matching the relevant fragment of the
/// [MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/) schema.
///
/// As with [StringNotationSystem], [parse] and [format] should be inverses
/// of each other: `parse(format(value))` should return a value equal to the
/// original value.
abstract class XmlNotationSystem<V> extends NotationSystem<V, XmlElement> {
  /// Creates a new [XmlNotationSystem].
  const XmlNotationSystem();

  /// The local name of the root element this system parses and formats
  /// (e.g. `'pitch'`, `'key'`, `'harmony'`).
  String get elementName;

  /// Parses [source] as [V].
  ///
  /// Throws a [FormatException] if [source]'s tag name does not match
  /// [elementName]. Delegates the actual content parsing to [parseElement].
  @override
  V parse(XmlElement source) {
    if (source.name.local != elementName) {
      throw FormatException(
        'Expected <$elementName> element, got <${source.name.local}>',
        source,
      );
    }

    return parseElement(source);
  }

  /// Parses [element] as [V].
  ///
  /// Unlike [parse], this does not check the element’s tag name, which lets
  /// composite systems (e.g. [PitchXmlNotation]) reuse a sub-system’s
  /// [parseElement] on a differently-named child element (e.g. `<root-step>`
  /// reusing the `<step>` parser).
  V parseElement(XmlElement element);

  /// Formats [value] as an [XmlElement] named [elementName].
  @override
  XmlElement format(V value);
}
