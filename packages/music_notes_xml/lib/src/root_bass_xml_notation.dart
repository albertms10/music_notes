import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'alter_xml_notation.dart';
import 'note_name_xml_notation.dart';
import 'xml_notation_system.dart';

/// The MusicXML `<root>`/`<bass>` notation system for a bare [Note] (no
/// octave), as used within `<harmony>`.
///
/// [prefix] selects which wrapper and child element names to use: `'root'`
/// produces `<root><root-step/><root-alter/></root>`, `'bass'` produces
/// `<bass><bass-step/><bass-alter/></bass>`.
///
/// See the [root element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/root/)
/// and [bass element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/bass/).
final class RootBassXmlNotation extends XmlNotationSystem<Note> {
  /// The wrapper/child element prefix (`'root'` or `'bass'`).
  final String prefix;

  /// The [NoteNameXmlNotation] used to format/parse the step.
  final NoteNameXmlNotation noteNameNotation;

  /// The [AlterXmlNotation] used to format/parse the alter.
  final AlterXmlNotation alterNotation;

  /// A [RootBassXmlNotation] for `<root>`.
  const RootBassXmlNotation.root({
    this.noteNameNotation = const NoteNameXmlNotation(),
    this.alterNotation = const AlterXmlNotation(),
  }) : prefix = 'root';

  /// A [RootBassXmlNotation] for `<bass>`.
  const RootBassXmlNotation.bass({
    this.noteNameNotation = const NoteNameXmlNotation(),
    this.alterNotation = const AlterXmlNotation(),
  }) : prefix = 'bass';

  @override
  String get elementName => prefix;

  String get _stepName => '$prefix-step';
  String get _alterName => '$prefix-alter';

  /// Example:
  /// ```dart
  /// const RootBassXmlNotation.root().parseElement(XmlDocument.parse('''
  ///   <root><root-step>E</root-step><root-alter>-1</root-alter></root>
  /// ''').rootElement) == Note.e.flat
  /// ```
  @override
  Note parseElement(XmlElement element) {
    final step =
        element.getElement(_stepName) ??
        (throw FormatException('Missing <$_stepName> in <$prefix>'));
    final noteName = noteNameNotation.parseElement(step);

    final alterElement = element.getElement(_alterName);
    final accidental = alterElement == null
        ? Accidental.natural
        : alterNotation.parseElement(alterElement);

    return Note(noteName, accidental);
  }

  /// Example:
  /// ```dart
  /// const RootBassXmlNotation.root().format(Note.f.sharp).toXmlString()
  ///   == '<root><root-step>F</root-step><root-alter>1</root-alter></root>'
  /// ```
  @override
  XmlElement format(Note value) => XmlElement(XmlName(prefix), [], [
    XmlElement(XmlName(_stepName), [], [
      XmlText(value.noteName.name.toUpperCase()),
    ]),
    if (!value.accidental.isNatural)
      XmlElement(XmlName(_alterName), [], [
        XmlText('${value.accidental.semitones}'),
      ]),
  ]);
}
