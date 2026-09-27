import 'package:music_notes/music_notes.dart';
import 'package:xml/xml.dart';

import 'xml_notation_system.dart';

/// The MusicXML `<transpose>` notation system for [Interval], expressed as
/// `<diatonic>` (diatonic steps, 0-based) and `<chromatic>` (semitones).
///
/// [Interval.size] and [Interval.semitones] together fully determine an
/// [Interval], so the pair round-trips exactly via
/// [Interval.fromSizeAndSemitones]. `<octave-change>` is not covered, since
/// a compound [Interval] already encodes its own octave span in
/// [Interval.size].
///
/// See the [transpose element](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/transpose/).
final class IntervalXmlNotation extends XmlNotationSystem<Interval> {
  /// Creates a new [IntervalXmlNotation].
  const IntervalXmlNotation();

  @override
  String get elementName => 'transpose';

  /// Example:
  /// ```dart
  /// const IntervalXmlNotation().parseElement(XmlDocument.parse('''
  ///   <transpose><diatonic>2</diatonic><chromatic>4</chromatic></transpose>
  /// ''').rootElement) == Interval.M3
  /// ```
  @override
  Interval parseElement(XmlElement element) {
    final diatonicElement =
        element.getElement('diatonic') ??
        (throw const FormatException('Missing <diatonic> in <transpose>'));
    final chromaticElement =
        element.getElement('chromatic') ??
        (throw const FormatException('Missing <chromatic> in <transpose>'));

    final diatonic = int.parse(diatonicElement.innerText.trim());
    final chromatic = int.parse(chromaticElement.innerText.trim());
    final size = Size(diatonic.sign * (diatonic.abs() + 1));

    return .fromSizeAndSemitones(size, chromatic);
  }

  /// Example:
  /// ```dart
  /// const IntervalXmlNotation().format(Interval.P4).toXmlString() ==
  ///   '<transpose><diatonic>3</diatonic><chromatic>5</chromatic></transpose>'
  /// ```
  @override
  XmlElement format(Interval value) {
    final diatonic = value.size.sign * (value.size.abs() - 1);

    return XmlElement(XmlName(elementName), [], [
      XmlElement(XmlName('diatonic'), [], [XmlText('$diatonic')]),
      XmlElement(XmlName('chromatic'), [], [
        XmlText('${value.semitones}'),
      ]),
    ]);
  }
}
