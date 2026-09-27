import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('NoteNameXmlNotation', () {
    const notation = NoteNameXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not <step>', () {
        final element = XmlDocument.parse('<note>C</note>').rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses uppercase source as a NoteName', () {
        for (final MapEntry(key: source, value: noteName) in <String, NoteName>{
          'C': .c,
          'D': .d,
          'E': .e,
          'F': .f,
          'G': .g,
          'A': .a,
          'B': .b,
        }.entries) {
          final element = XmlDocument.parse('<step>$source</step>').rootElement;
          expect(notation.parse(element), noteName);
        }
      });

      test('parses lowercase source case-insensitively', () {
        final element = XmlDocument.parse('<step>d</step>').rootElement;
        expect(notation.parse(element), NoteName.d);
      });
    });

    group('.format()', () {
      test('returns an uppercase <step> element', () {
        expect(notation.format(NoteName.f).toXmlString(), '<step>F</step>');
        expect(notation.format(NoteName.b).toXmlString(), '<step>B</step>');
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses for every NoteName', () {
        for (final noteName in NoteName.values) {
          expect(notation.parse(notation.format(noteName)), noteName);
        }
      });
    });
  });
}
