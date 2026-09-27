import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('ChordXmlNotation', () {
    const notation = ChordXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not '
          '<harmony>', () {
        final element = XmlDocument.parse(
          '<chord><root><root-step>C</root-step></root>'
          '<kind>major</kind></chord>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException when <root> is missing', () {
        final element = XmlDocument.parse(
          '<harmony><kind>major</kind></harmony>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException when <kind> is missing', () {
        final element = XmlDocument.parse(
          '<harmony><root><root-step>C</root-step></root></harmony>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses a root-position triad without a <bass>', () {
        final element = XmlDocument.parse(
          '<harmony><root><root-step>C</root-step></root>'
          '<kind>major</kind></harmony>',
        ).rootElement;
        expect(notation.parse(element), ChordPattern.majorTriad.on(.c));
      });

      test('parses a slash chord whose bass is one of its own tones '
          '(inversion)', () {
        final element = XmlDocument.parse(
          '<harmony><root><root-step>C</root-step></root>'
          '<kind>major</kind><bass><bass-step>E</bass-step></bass></harmony>',
        ).rootElement;
        expect(notation.parse(element), const Chord([.e, .g, .c]));
      });

      test('parses a slash chord whose bass is foreign to the chord', () {
        final element = XmlDocument.parse(
          '<harmony><root><root-step>C</root-step></root>'
          '<kind>major</kind><bass><bass-step>D</bass-step></bass></harmony>',
        ).rootElement;
        expect(notation.parse(element), const Chord([.d, .c, .e, .g]));
      });
    });

    group('.format()', () {
      test('omits <bass> for a root-position Chord', () {
        final element = notation.format(ChordPattern.minorTriad.on(.a));
        expect(element.getElement('bass'), isNull);
        expect(
          element.toXmlString(),
          '<harmony><root><root-step>A</root-step></root>'
          '<kind>minor</kind></harmony>',
        );
      });

      test('includes <bass> for an inverted Chord', () {
        expect(
          notation.format(const Chord([.e, .g, .c])).toXmlString(),
          '<harmony><root><root-step>C</root-step></root>'
          '<kind>major</kind><bass><bass-step>E</bass-step></bass></harmony>',
        );
      });

      test('includes <bass> for a Chord with a foreign bass note', () {
        expect(
          notation.format(const Chord([.d, .c, .e, .g])).toXmlString(),
          '<harmony><root><root-step>C</root-step></root>'
          '<kind>major</kind><bass><bass-step>D</bass-step></bass></harmony>',
        );
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses', () {
        for (final chord in <Chord>[
          ChordPattern.majorTriad.on(.g),
          ChordPattern.minorTriad.add7().on(.f.sharp),
          const Chord([.e, .g, .c]),
          const Chord([.d, .c, .e, .g]),
        ]) {
          expect(notation.parse(notation.format(chord)), chord);
        }
      });
    });
  });
}
