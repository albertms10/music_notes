import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ScaleDegree', () {
    group('constructor', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(() => ScaleDegree(-1), throwsA(isA<AssertionError>()));
        expect(() => ScaleDegree(0), throwsA(isA<AssertionError>()));
      });
    });

    group('.isRaised', () {
      test('returns whether this ScaleDegree is raised', () {
        expect(ScaleDegree.ii.isRaised, isFalse);
        expect(ScaleDegree.vi.lowered.isRaised, isFalse);
        expect(const ScaleDegree(3, accidental: .sharp).isRaised, isTrue);
      });
    });

    group('.isLowered', () {
      test('returns whether this ScaleDegree is lowered', () {
        expect(ScaleDegree.iv.isLowered, isFalse);
        expect(ScaleDegree.vi.raised.isLowered, isFalse);
        expect(const ScaleDegree(6, accidental: .sharp).isLowered, isFalse);
      });
    });

    group('.raised', () {
      test('returns this ScaleDegree raised by 1 semitone', () {
        expect(ScaleDegree.vi.raised, const ScaleDegree(6, accidental: .sharp));
        expect(
          ScaleDegree.ii.raised.raised,
          const ScaleDegree(2, accidental: .doubleSharp),
        );
        expect(ScaleDegree.ii.raised.lowered, ScaleDegree.ii);
      });
    });

    group('.lowered', () {
      test('returns this ScaleDegree lowered by 1 semitone', () {
        expect(
          ScaleDegree.ii.lowered,
          const ScaleDegree(2, accidental: .flat),
        );
        expect(
          ScaleDegree.vi.lowered.lowered,
          const ScaleDegree(6, accidental: .doubleFlat),
        );
        expect(ScaleDegree.iii.lowered.raised, ScaleDegree.iii);
      });
    });

    group('.toString()', () {
      test(
        'returns the verbose string representation of this ScaleDegree',
        () {
          expect(
            ScaleDegree.iii.toString(),
            'ScaleDegree(ordinal: 3, accidental: Accidental(semitones: 0))',
          );
          expect(
            ScaleDegree.vi.lowered.toString(),
            'ScaleDegree(ordinal: 6, accidental: Accidental(semitones: -1))',
          );
        },
      );
    });

    group('.hashCode', () {
      test('returns the same hashCode for equal ScaleDegrees', () {
        // ignore: prefer_const_constructors test
        expect(ScaleDegree(1).hashCode, ScaleDegree(1).hashCode);
        expect(
          // ignore: prefer_const_constructors test
          ScaleDegree(2, accidental: .flat).hashCode,
          // ignore: prefer_const_constructors test
          ScaleDegree(2, accidental: .flat).hashCode,
        );
      });

      test('returns different hashCodes for different ScaleDegrees', () {
        expect(ScaleDegree.i.hashCode, isNot(ScaleDegree.ii.hashCode));
      });

      test('ignores equal ScaleDegree instances in a Set', () {
        final collection = <ScaleDegree>{
          .i,
          .iii,
          const ScaleDegree(6, accidental: .flat),
        };
        collection.addAll(collection);
        expect(collection.toList(), const <ScaleDegree>[
          .i,
          .iii,
          ScaleDegree(6, accidental: .flat),
        ]);
      });
    });

    group('.compareTo()', () {
      test('sorts ScaleDegrees in a collection', () {
        final orderedSet = SplayTreeSet<ScaleDegree>.of({
          .vii,
          .ii,
          .ii.lowered,
          .i,
        });
        expect(orderedSet.toList(), <ScaleDegree>[.i, .ii.lowered, .ii, .vii]);
      });
    });
  });

  group('RomanScaleDegreeNotation', () {
    const english = RomanScaleDegreeNotation(
      accidentalNotation: EnglishAccidentalNotation(),
    );
    const chain = [english];

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => ScaleDegree.parse(''), throwsFormatException);
        expect(() => ScaleDegree.parse('x'), throwsFormatException);
        expect(() => ScaleDegree.parse('H'), throwsFormatException);
        expect(() => ScaleDegree.parse('vv'), throwsFormatException);
        expect(() => ScaleDegree.parse('♯ II'), throwsFormatException);
      });

      test('parses source as a ScaleDegree', () {
        expect(ScaleDegree.parse('I'), ScaleDegree.i);
        expect(ScaleDegree.parse('bii'), ScaleDegree.ii.lowered);
        expect(ScaleDegree.parse('Vi'), ScaleDegree.vi);
        expect(ScaleDegree.parse('♯Vi'), ScaleDegree.vi.raised);
        expect(
          ScaleDegree.parse('flat VII', chain: chain),
          ScaleDegree.vii.lowered,
        );
      });
    });

    group('.format()', () {
      test('returns the string representation of this ScaleDegree', () {
        expect(ScaleDegree.i.format(), 'I');
        expect(ScaleDegree.vii.lowered.format(), '♭VII');
        expect(const ScaleDegree(10).format(), '10');
        expect(const ScaleDegree(10).raised.format(), '♯10');
        expect(ScaleDegree.vi.raised.format(english), 'sharp VI');

        expect(
          ScaleDegree.vii.format(
            const RomanScaleDegreeNotation(useUppercase: false),
          ),
          'vii',
        );
      });
    });
  });

  group('NumericScaleDegreeNotation', () {
    const formatter = NumericScaleDegreeNotation();
    const chain = [formatter];

    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => ScaleDegree.parse('z'), throwsFormatException);
        expect(() => ScaleDegree.parse('0'), throwsFormatException);
        expect(() => ScaleDegree.parse(''), throwsFormatException);
      });

      test('parses source as a ScaleDegree', () {
        expect(ScaleDegree.parse('1̂'), ScaleDegree.i);
        expect(ScaleDegree.parse('7̂'), ScaleDegree.vii);

        expect(ScaleDegree.parse('♯4̂'), ScaleDegree.iv.raised);
        expect(ScaleDegree.parse('♭7̂'), ScaleDegree.vii.lowered);

        expect(ScaleDegree.parse('𝄪4̂'), ScaleDegree.iv.raised.raised);
        expect(ScaleDegree.parse('𝄫2̂'), ScaleDegree.ii.lowered.lowered);

        expect(ScaleDegree.parse('4^'), ScaleDegree.iv);
        expect(ScaleDegree.parse('b2^'), ScaleDegree.ii.lowered);
        expect(ScaleDegree.parse('3'), ScaleDegree.iii);
        expect(ScaleDegree.parse('♭7^'), ScaleDegree.vii.lowered);
        expect(ScaleDegree.parse('♭6'), ScaleDegree.vi.lowered);
      });

      test('is the inverse of .format()', () {
        for (final scaleDegree in [
          ScaleDegree.i,
          ScaleDegree.ii.raised,
          ScaleDegree.iii.lowered,
          ScaleDegree.vii.lowered,
        ]) {
          expect(
            ScaleDegree.parse(formatter.format(scaleDegree), chain: chain),
            scaleDegree,
          );
        }
      });
    });

    group('.format()', () {
      test('returns the string representation of this ScaleDegree', () {
        expect(ScaleDegree.i.format(formatter), '1̂');
        expect(ScaleDegree.iii.format(formatter), '3̂');
        expect(ScaleDegree.vii.format(formatter), '7̂');

        expect(ScaleDegree.iv.raised.format(formatter), '♯4̂');
        expect(ScaleDegree.i.raised.format(formatter), '♯1̂');

        expect(ScaleDegree.vii.lowered.format(formatter), '♭7̂');
        expect(ScaleDegree.vi.lowered.format(formatter), '♭6̂');

        expect(ScaleDegree.iv.raised.raised.format(formatter), '𝄪4̂');
        expect(ScaleDegree.ii.lowered.lowered.format(formatter), '𝄫2̂');

        const plain = NumericScaleDegreeNotation.plain();
        expect(ScaleDegree.iii.format(plain), '3');
        expect(ScaleDegree.vii.lowered.format(plain), '♭7');
        expect(ScaleDegree.vi.raised.format(plain), '♯6');
      });
    });
  });
}
