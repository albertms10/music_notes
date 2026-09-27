import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('PitchXmlNotation', () {
    const notation = PitchXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not <pitch>', () {
        final element = XmlDocument.parse(
          '<note><step>C</step><octave>4</octave></note>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException when <step> is missing', () {
        final element = XmlDocument.parse(
          '<pitch><octave>4</octave></pitch>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException when <octave> is missing', () {
        final element = XmlDocument.parse(
          '<pitch><step>C</step></pitch>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses a sharp Pitch with <alter>', () {
        final element = XmlDocument.parse(
          '<pitch><step>C</step><alter>1</alter><octave>4</octave></pitch>',
        ).rootElement;
        expect(notation.parse(element), Note.c.sharp.inOctave(4));
      });

      test('parses a natural Pitch without <alter>', () {
        final element = XmlDocument.parse(
          '<pitch><step>A</step><octave>3</octave></pitch>',
        ).rootElement;
        expect(notation.parse(element), Note.a.inOctave(3));
      });

      test('parses a negative octave', () {
        final element = XmlDocument.parse(
          '<pitch><step>G</step><octave>-1</octave></pitch>',
        ).rootElement;
        expect(notation.parse(element), Note.g.inOctave(-1));
      });
    });

    group('.format()', () {
      test('includes <alter> for an altered Pitch', () {
        expect(
          notation.format(Note.b.flat.inOctave(3)).toXmlString(),
          '<pitch><step>B</step><alter>-1</alter><octave>3</octave></pitch>',
        );
      });

      test('omits <alter> for a natural Pitch', () {
        final element = notation.format(Note.d.inOctave(4));
        expect(element.getElement('alter'), isNull);
        expect(
          element.toXmlString(),
          '<pitch><step>D</step><octave>4</octave></pitch>',
        );
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses', () {
        for (final pitch in [
          Note.c.inOctave(4),
          Note.f.sharp.inOctave(5),
          Note.e.flat.inOctave(-1),
          Note.b.sharp.sharp.inOctave(2),
        ]) {
          expect(notation.parse(notation.format(pitch)), pitch);
        }
      });
    });
  });
}
