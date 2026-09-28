import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'alter_xml_notation.dart';
import 'note_name_xml_notation.dart';
import 'xml_notation_system.dart';

/// The MusicXML `<pitch>` notation system for [Pitch].
///
/// See the [pitch element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/pitch/).
final class PitchXmlNotation extends XmlNotationSystem<Pitch> {
  /// The [NoteNameXmlNotation] used to format/parse the `<step>`.
  final NoteNameXmlNotation noteNameNotation;

  /// The [AlterXmlNotation] used to format/parse the `<alter>`.
  final AlterXmlNotation alterNotation;

  /// Creates a new [PitchXmlNotation].
  const PitchXmlNotation({
    this.noteNameNotation = const NoteNameXmlNotation(),
    this.alterNotation = const AlterXmlNotation(),
  });

  @override
  String get elementName => 'pitch';

  /// Example:
  /// ```dart
  /// const PitchXmlNotation().parseElement(XmlDocument.parse('''
  ///   <pitch><step>C</step><alter>1</alter><octave>4</octave></pitch>
  /// ''').rootElement) == Note.c.sharp.inOctave(4)
  /// ```
  @override
  Pitch parseElement(XmlElement element) {
    final step =
        element.getElement('step') ??
        (throw const FormatException('Missing <step> in <pitch>'));
    final noteName = noteNameNotation.parseElement(step);

    final alterElement = element.getElement('alter');
    final accidental = alterElement == null
        ? Accidental.natural
        : alterNotation.parseElement(alterElement);

    final octaveElement =
        element.getElement('octave') ??
        (throw const FormatException('Missing <octave> in <pitch>'));
    final octave = int.parse(octaveElement.innerText.trim());

    return Note(noteName, accidental).inOctave(octave);
  }

  /// Example:
  /// ```dart
  /// const PitchXmlNotation().format(Note.b.flat.inOctave(3)).toXmlString()
  ///   == '<pitch><step>B</step><alter>-1</alter><octave>3</octave></pitch>'
  /// ```
  @override
  XmlElement format(Pitch value) => XmlElement(XmlName(elementName), [], [
    noteNameNotation.format(value.note.noteName),
    if (!value.note.accidental.isNatural)
      alterNotation.format(value.note.accidental),
    XmlElement(XmlName('octave'), [], [XmlText('${value.octave}')]),
  ]);
}
