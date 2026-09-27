import 'package:collection/collection.dart';
import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'xml_notation_system.dart';

/// The MusicXML `<mode>` notation system for [Mode], covering both
/// [TonalMode] (`major`, `minor`) and [ModalMode] (`dorian`, `phrygian`,
/// `lydian`, `mixolydian`, `aeolian`, `locrian`, `ionian`).
///
/// See the [mode element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/mode/).
final class ModeXmlNotation extends XmlNotationSystem<Mode> {
  /// Creates a new [ModeXmlNotation].
  const ModeXmlNotation();

  @override
  String get elementName => 'mode';

  /// Example:
  /// ```dart
  /// const ModeXmlNotation().parseElement(
  ///   XmlDocument.parse('<mode>dorian</mode>').rootElement,
  /// ) == ModalMode.dorian
  /// ```
  @override
  Mode parseElement(XmlElement element) {
    final word = element.innerText.trim().toLowerCase();

    return switch (word) {
      'major' => TonalMode.major,
      'minor' => TonalMode.minor,
      _ =>
        ModalMode.values.firstWhereOrNull((mode) => mode.name == word) ??
            (throw FormatException('Unsupported mode', word)),
    };
  }

  /// Example:
  /// ```dart
  /// const ModeXmlNotation().format(TonalMode.major).toXmlString()
  ///   == '<mode>major</mode>'
  /// ```
  @override
  XmlElement format(Mode value) =>
      XmlElement(XmlName(elementName), [], [XmlText(value.name)]);
}
