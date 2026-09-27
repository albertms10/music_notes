import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'chord_pattern_xml_notation.dart';
import 'root_bass_xml_notation.dart';
import 'xml_notation_system.dart';

/// The MusicXML `<harmony>` notation system for [Chord], combining
/// `<root>`, `<kind>`, and an optional `<bass>` for slash chords.
///
/// See the [harmony element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/harmony/).
final class ChordXmlNotation extends XmlNotationSystem<Chord> {
  /// The [RootBassXmlNotation] used to format/parse `<root>`.
  final RootBassXmlNotation rootNotation;

  /// The [RootBassXmlNotation] used to format/parse `<bass>`.
  final RootBassXmlNotation bassNotation;

  /// The [ChordPatternXmlNotation] used to format/parse `<kind>`.
  final ChordPatternXmlNotation chordPatternNotation;

  /// Creates a new [ChordXmlNotation].
  const ChordXmlNotation({
    this.rootNotation = const .root(),
    this.bassNotation = const .bass(),
    this.chordPatternNotation = const ChordPatternXmlNotation(),
  });

  @override
  String get elementName => 'harmony';

  /// Example:
  /// ```dart
  /// const ChordXmlNotation().parseElement(XmlDocument.parse('''
  ///   <harmony><root><root-step>C</root-step></root>
  ///     <kind>major</kind></harmony>
  /// ''').rootElement) == ChordPattern.majorTriad.on(.c)
  /// ```
  @override
  Chord parseElement(XmlElement element) {
    final rootElement =
        element.getElement('root') ??
        (throw const FormatException('Missing <root> in <harmony>'));
    final root = rootNotation.parseElement(rootElement);

    final kindElement =
        element.getElement('kind') ??
        (throw const FormatException('Missing <kind> in <harmony>'));
    final pattern = chordPatternNotation.parseElement(kindElement);

    final rootPositionChord = pattern.on(root);

    final bassElement = element.getElement('bass');
    if (bassElement == null) return rootPositionChord;

    final bass = bassNotation.parseElement(bassElement);
    final items = rootPositionChord.items;
    final bassIndex = items.indexOf(bass);
    // When the bass is not one of the chord's own tones, it is added below
    // as a foreign bass note rather than rotating into an inversion.
    if (bassIndex == -1) return Chord([bass, ...items]);

    // Rotate so the matching tone becomes the new bass.
    return Chord([...items.skip(bassIndex), ...items.take(bassIndex)]);
  }

  /// Example:
  /// ```dart
  /// const ChordXmlNotation()
  ///     .format(ChordPattern.minorTriad.on(.a))
  ///     .toXmlString()
  ///   == '<harmony><root><root-step>A</root-step></root>'
  ///      '<kind>minor</kind></harmony>'
  /// ```
  @override
  XmlElement format(Chord value) {
    final bass = value.root; // items.first: the actual sounding bass.
    final Chord rootPositionChord;
    try {
      rootPositionChord = value.rootPosition;
      // ignore: avoid_catching_errors ease
    } on StateError {
      // A foreign bass (e.g. C/D): format the remaining tones on their own.
      final withoutBass = Chord(value.items.skip(1).toList(growable: false));

      return _element(withoutBass.items.first, withoutBass.pattern, bass);
    }

    final root = rootPositionChord.items.first;

    return _element(
      root,
      rootPositionChord.pattern,
      root == bass ? null : bass,
    );
  }

  XmlElement _element(Note root, ChordPattern pattern, Note? bass) =>
      XmlElement(XmlName(elementName), [], [
        rootNotation.format(root),
        chordPatternNotation.format(pattern),
        if (bass != null) bassNotation.format(bass),
      ]);
}
