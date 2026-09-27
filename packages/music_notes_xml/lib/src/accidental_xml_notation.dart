import 'package:collection/collection.dart';
import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'xml_notation_system.dart';

/// The MusicXML `<accidental>` notation system for [Accidental], expressed
/// as the visual `accidental-value` word (e.g. `sharp`, `flat`).
///
/// Only the subset of the `accidental-value` enumeration that has a direct
/// [Accidental] counterpart is supported (triple flat through triple
/// sharp).
///
/// See the [accidental element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/accidental/).
final class AccidentalXmlNotation extends XmlNotationSystem<Accidental> {
  /// Creates a new [AccidentalXmlNotation].
  const AccidentalXmlNotation();

  @override
  String get elementName => 'accidental';

  static const _values = {
    -3: 'triple-flat',
    -2: 'flat-flat',
    -1: 'flat',
    0: 'natural',
    1: 'sharp',
    2: 'double-sharp',
    3: 'triple-sharp',
  };

  /// Example:
  /// ```dart
  /// const AccidentalXmlNotation().parseElement(
  ///   XmlDocument.parse('<accidental>double-sharp</accidental>').rootElement,
  /// ) == Accidental.doubleSharp
  /// ```
  @override
  Accidental parseElement(XmlElement element) {
    final word = element.innerText.trim().toLowerCase();
    final semitones =
        _values.entries.firstWhereOrNull((entry) => entry.value == word)?.key ??
        (throw FormatException('Unsupported accidental-value', word));

    return Accidental(semitones);
  }

  /// Example:
  /// ```dart
  /// const AccidentalXmlNotation().format(Accidental.flat).toXmlString()
  ///   == '<accidental>flat</accidental>'
  /// ```
  @override
  XmlElement format(Accidental value) {
    final word =
        _values[value.semitones] ??
        (throw ArgumentError.value(
          value,
          'value',
          'No MusicXML accidental-value for this Accidental',
        ));

    return XmlElement(XmlName(elementName), [], [XmlText(word)]);
  }
}
