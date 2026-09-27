import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('RootBassXmlNotation', () {
    group('.root', () {
      const notation = RootBassXmlNotation.root();

      test('has elementName "root"', () {
        expect(notation.elementName, 'root');
      });

      group('.parse()', () {
        test('throws a FormatException when the tag name is not <root>', () {
          final element = XmlDocument.parse(
            '<bass><bass-step>C</bass-step></bass>',
          ).rootElement;
          expect(() => notation.parse(element), throwsFormatException);
        });

        test('throws a FormatException when <root-step> is missing', () {
          final element = XmlDocument.parse(
            '<root><root-alter>1</root-alter></root>',
          ).rootElement;
          expect(() => notation.parse(element), throwsFormatException);
        });

        test('parses an altered root Note', () {
          final element = XmlDocument.parse(
            '<root><root-step>E</root-step><root-alter>-1</root-alter></root>',
          ).rootElement;
          expect(notation.parse(element), Note.e.flat);
        });

        test('parses a natural root Note without <root-alter>', () {
          final element = XmlDocument.parse(
            '<root><root-step>G</root-step></root>',
          ).rootElement;
          expect(notation.parse(element), Note.g);
        });
      });

      group('.format()', () {
        test('includes <root-alter> for an altered Note', () {
          expect(
            notation.format(Note.f.sharp).toXmlString(),
            '<root><root-step>F</root-step><root-alter>1</root-alter></root>',
          );
        });

        test('omits <root-alter> for a natural Note', () {
          final element = notation.format(Note.c);
          expect(element.getElement('root-alter'), isNull);
        });
      });
    });

    group('.bass', () {
      const notation = RootBassXmlNotation.bass();

      test('has elementName "bass"', () {
        expect(notation.elementName, 'bass');
      });

      group('.parse()', () {
        test('parses a bass Note using the bass- prefix', () {
          final element = XmlDocument.parse(
            '<bass><bass-step>D</bass-step><bass-alter>1</bass-alter></bass>',
          ).rootElement;
          expect(notation.parse(element), Note.d.sharp);
        });
      });

      group('.format()', () {
        test('uses the bass- prefix for child element names', () {
          expect(
            notation.format(Note.a.flat).toXmlString(),
            '<bass><bass-step>A</bass-step><bass-alter>-1</bass-alter></bass>',
          );
        });
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses for both root and bass', () {
        for (final note in <Note>[.c, .f.sharp, .a.flat, .b.sharp.sharp]) {
          expect(
            const RootBassXmlNotation.root().parse(
              const RootBassXmlNotation.root().format(note),
            ),
            note,
          );
          expect(
            const RootBassXmlNotation.bass().parse(
              const RootBassXmlNotation.bass().format(note),
            ),
            note,
          );
        }
      });
    });
  });
}
