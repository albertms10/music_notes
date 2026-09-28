import 'package:music_notes/music_notes.dart';
import 'package:music_notes_xml/music_notes_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('ChordPatternXmlNotation', () {
    const notation = ChordPatternXmlNotation();

    group('.parse()', () {
      test('throws a FormatException when the tag name is not <kind>', () {
        final element = XmlDocument.parse(
          '<quality>major</quality>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('throws a FormatException for an unsupported kind-value', () {
        final element = XmlDocument.parse(
          '<kind>suspended-fourth</kind>',
        ).rootElement;
        expect(() => notation.parse(element), throwsFormatException);
      });

      test('parses every supported kind-value word', () {
        for (final MapEntry(key: source, value: pattern)
            in <String, ChordPattern>{
              'major': .majorTriad,
              'minor': .minorTriad,
              'augmented': .augmentedTriad,
              'diminished': .diminishedTriad,
              'dominant': ChordPattern.majorTriad.add7(),
              'major-seventh': ChordPattern.majorTriad.add7(.major),
              'minor-seventh': ChordPattern.minorTriad.add7(),
              'diminished-seventh': ChordPattern.diminishedTriad.add7(
                .diminished,
              ),
              'half-diminished': ChordPattern.diminishedTriad.add7(),
              'augmented-seventh': ChordPattern.augmentedTriad.add7(),
            }.entries) {
          final element = XmlDocument.parse('<kind>$source</kind>').rootElement;
          expect(notation.parse(element), pattern);
        }
      });
    });

    group('.format()', () {
      test('returns the matching kind-value word for each supported '
          'ChordPattern', () {
        expect(
          notation.format(ChordPattern.majorTriad).toXmlString(),
          '<kind>major</kind>',
        );
        expect(
          notation.format(ChordPattern.majorTriad.add7()).toXmlString(),
          '<kind>dominant</kind>',
        );
        expect(
          notation.format(ChordPattern.minorTriad.add7()).toXmlString(),
          '<kind>minor-seventh</kind>',
        );
        expect(
          notation
              .format(ChordPattern.diminishedTriad.add7(.diminished))
              .toXmlString(),
          '<kind>diminished-seventh</kind>',
        );
        expect(
          notation.format(ChordPattern.diminishedTriad.add7()).toXmlString(),
          '<kind>half-diminished</kind>',
        );
      });

      test('throws an ArgumentError for an unsupported ChordPattern', () {
        expect(
          () => notation.format(const ChordPattern([.m2, .m3, .P4])),
          throwsArgumentError,
        );
      });
    });

    group('round-trip', () {
      test('.parse() and .format() are inverses for every supported '
          'ChordPattern', () {
        for (final pattern in <ChordPattern>[
          .majorTriad,
          .minorTriad,
          .augmentedTriad,
          .diminishedTriad,
          ChordPattern.majorTriad.add7(),
          ChordPattern.majorTriad.add7(.major),
          ChordPattern.minorTriad.add7(),
          ChordPattern.diminishedTriad.add7(.diminished),
          ChordPattern.diminishedTriad.add7(),
          ChordPattern.augmentedTriad.add7(),
        ]) {
          expect(notation.parse(notation.format(pattern)), pattern);
        }
      });
    });
  });
}
