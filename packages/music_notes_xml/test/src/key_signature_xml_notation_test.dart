import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('KeySignatureXmlNotation', () {
    const notation = KeySignatureXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not <key>', () {
        final element = XmlDocument.parse(
          '<signature><fifths>0</fifths></signature>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException when <fifths> is missing', () {
        final element = XmlDocument.parse('<key></key>').rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses a positive fifths distance', () {
        final element = XmlDocument.parse(
          '<key><fifths>2</fifths></key>',
        ).rootElement;
        expect(notation.parse(element), KeySignature.fromDistance(2));
      });

      test('parses a negative fifths distance', () {
        final element = XmlDocument.parse(
          '<key><fifths>-4</fifths></key>',
        ).rootElement;
        expect(notation.parse(element), KeySignature.fromDistance(-4));
      });

      test('parses a zero fifths distance as empty', () {
        final element = XmlDocument.parse(
          '<key><fifths>0</fifths></key>',
        ).rootElement;
        expect(notation.parse(element), KeySignature.empty);
      });
    });

    group('.format()', () {
      test('returns the fifths distance for a canonical KeySignature', () {
        expect(
          notation.format(KeySignature.fromDistance(-3)).toXmlString(),
          '<key><fifths>-3</fifths></key>',
        );
        expect(
          notation.format(KeySignature.empty).toXmlString(),
          '<key><fifths>0</fifths></key>',
        );
      });

      test('throws an ArgumentError for a non-canonical KeySignature', () {
        expect(
          () => notation.format(KeySignature([.g.sharp])),
          throwsArgumentError,
        );
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses for canonical '
          'KeySignatures', () {
        for (var distance = -7; distance <= 7; distance++) {
          final keySignature = KeySignature.fromDistance(distance);
          expect(notation.parse(notation.format(keySignature)), keySignature);
        }
      });
    });
  });
}
