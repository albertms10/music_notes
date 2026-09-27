import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('AlterXmlNotation', () {
    const notation = AlterXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not <alter>', () {
        final element = XmlDocument.parse(
          '<accidental>1</accidental>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses a positive source as a sharp Accidental', () {
        final element = XmlDocument.parse('<alter>1</alter>').rootElement;
        expect(notation.parse(element), Accidental.sharp);
      });

      test('parses a negative source as a flat Accidental', () {
        final element = XmlDocument.parse('<alter>-2</alter>').rootElement;
        expect(notation.parse(element), Accidental.doubleFlat);
      });

      test('parses a zero source as a natural Accidental', () {
        final element = XmlDocument.parse('<alter>0</alter>').rootElement;
        expect(notation.parse(element), Accidental.natural);
      });
    });

    group('.format()', () {
      test('returns the signed semitones as a plain integer', () {
        expect(
          notation.format(Accidental.tripleFlat).toXmlString(),
          '<alter>-3</alter>',
        );
        expect(
          notation.format(Accidental.natural).toXmlString(),
          '<alter>0</alter>',
        );
        expect(
          notation.format(Accidental.tripleSharp).toXmlString(),
          '<alter>3</alter>',
        );
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses across the representable '
          'range', () {
        for (var semitones = -3; semitones <= 3; semitones++) {
          final accidental = Accidental(semitones);
          expect(notation.parse(notation.format(accidental)), accidental);
        }
      });
    });
  });
}
