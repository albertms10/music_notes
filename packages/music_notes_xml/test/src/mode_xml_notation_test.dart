import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('ModeXmlNotation', () {
    const notation = ModeXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not <mode>', () {
        final element = XmlDocument.parse(
          '<tonality>major</tonality>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException for an unsupported word', () {
        final element = XmlDocument.parse('<mode>none</mode>').rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses TonalMode words', () {
        expect(
          notation.parse(XmlDocument.parse('<mode>major</mode>').rootElement),
          TonalMode.major,
        );
        expect(
          notation.parse(XmlDocument.parse('<mode>minor</mode>').rootElement),
          TonalMode.minor,
        );
      });

      test('parses ModalMode words', () {
        for (final modalMode in ModalMode.values) {
          final element = XmlDocument.parse(
            '<mode>${modalMode.name}</mode>',
          ).rootElement;
          expect(notation.parse(element), modalMode);
        }
      });

      test('parses source case-insensitively', () {
        final element = XmlDocument.parse('<mode>Dorian</mode>').rootElement;
        expect(notation.parse(element), ModalMode.dorian);
      });
    });

    group('.format()', () {
      test('returns the lowercase mode name', () {
        expect(
          notation.format(TonalMode.minor).toXmlString(),
          '<mode>minor</mode>',
        );
        expect(
          notation.format(ModalMode.mixolydian).toXmlString(),
          '<mode>mixolydian</mode>',
        );
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses for every Mode', () {
        for (final mode in TonalMode.values) {
          expect(notation.parse(notation.format(mode)), mode);
        }
        for (final mode in ModalMode.values) {
          expect(notation.parse(notation.format(mode)), mode);
        }
      });
    });
  });
}
