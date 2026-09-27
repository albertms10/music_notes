import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('IntervalXmlNotation', () {
    const notation = IntervalXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not '
          '<transpose>', () {
        final element = XmlDocument.parse(
          '<interval><diatonic>2</diatonic><chromatic>4</chromatic></interval>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException when <diatonic> is missing', () {
        final element = XmlDocument.parse(
          '<transpose><chromatic>4</chromatic></transpose>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException when <chromatic> is missing', () {
        final element = XmlDocument.parse(
          '<transpose><diatonic>2</diatonic></transpose>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses an ascending simple Interval', () {
        final element = XmlDocument.parse(
          '<transpose><diatonic>2</diatonic><chromatic>4</chromatic></transpose>',
        ).rootElement;
        expect(notation.parse(element), Interval.M3);
      });

      test('parses a perfect Interval', () {
        final element = XmlDocument.parse(
          '<transpose><diatonic>3</diatonic><chromatic>5</chromatic></transpose>',
        ).rootElement;
        expect(notation.parse(element), Interval.P4);
      });

      test('parses a descending Interval from negative values', () {
        final element = XmlDocument.parse(
          '<transpose><diatonic>-2</diatonic><chromatic>-4</chromatic></transpose>',
        ).rootElement;
        expect(notation.parse(element), -Interval.M3);
      });

      test('parses a compound Interval', () {
        final element = XmlDocument.parse(
          '<transpose><diatonic>8</diatonic><chromatic>14</chromatic></transpose>',
        ).rootElement;
        expect(notation.parse(element), Interval.M9);
      });
    });

    group('.format()', () {
      test('returns diatonic and chromatic for an ascending Interval', () {
        expect(
          notation.format(Interval.P5).toXmlString(),
          '<transpose><diatonic>4</diatonic><chromatic>7</chromatic>'
          '</transpose>',
        );
      });

      test('returns negative diatonic and chromatic for a descending '
          'Interval', () {
        expect(
          notation.format(-Interval.M3).toXmlString(),
          '<transpose><diatonic>-2</diatonic><chromatic>-4</chromatic>'
          '</transpose>',
        );
      });

      test('returns a zero diatonic for a unison Interval', () {
        expect(
          notation.format(Interval.P1).toXmlString(),
          '<transpose><diatonic>0</diatonic><chromatic>0</chromatic>'
          '</transpose>',
        );
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses', () {
        for (final interval in <Interval>[
          .P1,
          .m2,
          .M3,
          .P4,
          .P5,
          .M6,
          .m7,
          .P8,
          .M9,
          .P11,
          .M13,
          -Interval.M3,
          -Interval.P5,
        ]) {
          expect(
            notation.parse(notation.format(interval)),
            equals(interval),
            reason: 'Invalid $interval',
          );
        }
      });
    });
  });
}
