import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'xml_notation_system.dart';

/// The MusicXML `<key>` notation system for [KeySignature], expressed as
/// the `<fifths>` distance.
///
/// Only canonical key signatures round-trip; a non-canonical
/// [KeySignature] (see [KeySignature.isCanonical]) has no `fifths`
/// representation and throws an [ArgumentError] when formatted.
///
/// See the [key element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key/).
final class KeySignatureXmlNotation extends XmlNotationSystem<KeySignature> {
  /// Creates a new [KeySignatureXmlNotation].
  const KeySignatureXmlNotation();

  @override
  String get elementName => 'key';

  /// Example:
  /// ```dart
  /// const KeySignatureXmlNotation().parseElement(
  ///   XmlDocument.parse('<key><fifths>2</fifths></key>').rootElement,
  /// ) == KeySignature.fromDistance(2)
  /// ```
  @override
  KeySignature parseElement(XmlElement element) {
    final fifths =
        element.getElement('fifths') ??
        (throw const FormatException('Missing <fifths> in <key>'));

    return .fromDistance(int.parse(fifths.innerText.trim()));
  }

  /// Example:
  /// ```dart
  /// const KeySignatureXmlNotation().format(KeySignature.fromDistance(-3))
  ///     .toXmlString() == '<key><fifths>-3</fifths></key>'
  /// ```
  @override
  XmlElement format(KeySignature value) {
    final distance =
        value.distance ??
        (throw ArgumentError.value(
          value,
          'value',
          'Non-canonical KeySignature has no fifths representation',
        ));

    return XmlElement(XmlName(elementName), [], [
      XmlElement(XmlName('fifths'), [], [XmlText('$distance')]),
    ]);
  }
}
