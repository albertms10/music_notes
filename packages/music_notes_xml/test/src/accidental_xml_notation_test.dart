import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('AccidentalXmlNotation', () {
    const notation = AccidentalXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not '
          '<accidental>', () {
        final element = XmlDocument.parse('<alter>sharp</alter>').rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException for an unsupported accidental-value', () {
        final element = XmlDocument.parse(
          '<accidental>quarter-sharp</accidental>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses each supported accidental-value word', () {
        for (final MapEntry(key: source, value: accidental)
            in <String, Accidental>{
              'triple-flat': .tripleFlat,
              'flat-flat': .doubleFlat,
              'flat': .flat,
              'natural': .natural,
              'sharp': .sharp,
              'double-sharp': .doubleSharp,
              'triple-sharp': .tripleSharp,
            }.entries) {
          final element = XmlDocument.parse(
            '<accidental>$source</accidental>',
          ).rootElement;
          expect(notation.parse(element), accidental);
        }
      });

      test('parses source case-insensitively', () {
        final element = XmlDocument.parse(
          '<accidental>Double-Sharp</accidental>',
        ).rootElement;
        expect(notation.parse(element), Accidental.doubleSharp);
      });
    });

    group('.format()', () {
      test('returns the matching accidental-value word', () {
        expect(
          notation.format(Accidental.flat).toXmlString(),
          '<accidental>flat</accidental>',
        );
        expect(
          notation.format(Accidental.doubleFlat).toXmlString(),
          '<accidental>flat-flat</accidental>',
        );
      });

      test('throws an ArgumentError outside the representable range', () {
        expect(() => notation.format(const Accidental(4)), throwsArgumentError);
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
