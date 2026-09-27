import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('XmlNotationSystem', () {
    const notation = _EchoXmlNotation();

    group('.parse()', () {
      test('delegates to parseElement when the tag name matches '
          'elementName', () {
        final element = XmlDocument.parse('<echo>hello</echo>').rootElement;
        expect(notation.parse(element), 'hello');
      });

      test('throws a FormatException when the tag name does not match '
          'elementName', () {
        final element = XmlDocument.parse('<other>hello</other>').rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });
    });

    group('.parseElement()', () {
      test('does not validate the tag name, unlike .parse()', () {
        // A differently-named element is still accepted by parseElement,
        // which is what lets composite systems reuse a sub-system's
        // parseElement on a differently-named child element.
        final element = XmlDocument.parse(
          '<root-step>C</root-step>',
        ).rootElement;
        expect(notation.parseElement(element), 'C');
      });
    });

    group('.format()', () {
      test('produces an XmlElement named elementName', () {
        final element = notation.format('hello');
        expect(element.name.local, 'echo');
        expect(element.innerText, 'hello');
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses', () {
        expect(notation.parse(notation.format('round-trip')), 'round-trip');
      });
    });
  });
}

/// A minimal concrete [XmlNotationSystem] used only to exercise the
/// shared [XmlNotationSystem.parse] contract in isolation.
final class _EchoXmlNotation extends XmlNotationSystem<String> {
  const _EchoXmlNotation();

  @override
  String get elementName => 'echo';

  @override
  String parseElement(XmlElement element) => element.innerText;

  @override
  XmlElement format(String value) =>
      XmlElement(XmlName(elementName), [], [XmlText(value)]);
}
