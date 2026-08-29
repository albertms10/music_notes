import 'package:music_notes/music_notes.dart';
import 'package:music_notes/organ.dart';
import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('MixtureRow', () {
    group('.parse()', () {
      test('parses a row', () {
        final row = MixtureRow.parse('C2 1 1/3, 1, 2/3');

        expect(row.breakpoint, equals(Pitch.parse('C2')));
        expect(
          row.rankFeet,
          equals(const <Rational>[.fromMixed(1, 1, 3), .new(1), .new(2, 3)]),
        );
      });

      test('ignores surrounding whitespace', () {
        final row = MixtureRow.parse('  C2 1 1/3, 1, 2/3  ');

        expect(row.breakpoint, equals(Pitch.parse('C2')));
        expect(
          row.rankFeet,
          equals(const <Rational>[.fromMixed(1, 1, 3), .new(1), .new(2, 3)]),
        );
      });

      test('accepts whitespace around commas', () {
        expect(
          MixtureRow.parse('C2 1 1/3,1,  2/3').rankFeet,
          equals(const <Rational>[.fromMixed(1, 1, 3), .new(1), .new(2, 3)]),
        );
      });
    });

    group('.format()', () {
      test('formats a row in parseable form', () {
        const row = MixtureRow(
          Pitch(.c, octave: 2),
          [.fromMixed(1, 1, 3), .new(1), .new(2, 3)],
        );

        expect(row.format(), equals('C2 1 1/3, 1, 2/3'));
      });

      test('toString and parse are symmetric', () {
        const sources = [
          'C2 1 1/3, 1, 2/3',
          'C3 2 2/3, 2, 1 1/3, 1',
          'C4 4, 2 2/3, 2, 1 1/3',
          'C5 5 1/3, 4, 2 2/3, 2',
        ];

        for (final source in sources) {
          final row = MixtureRow.parse(source);
          expect(MixtureRow.parse(row.toString()), equals(row));
        }
      });
    });

    group('.ranks()', () {
      test('converts rank feet to intervals', () {
        final row = MixtureRow.parse('C2 1 1/3, 1, 2/3');

        expect(
          row.ranks,
          equals([
            Interval.fromRatio(
              (MixtureRow.referenceHeight * Rational.parse('1 1/3')).toDouble(),
            ),
            Interval.fromRatio(
              (MixtureRow.referenceHeight * Rational.parse('1')).toDouble(),
            ),
            Interval.fromRatio(
              (MixtureRow.referenceHeight * Rational.parse('2/3')).toDouble(),
            ),
          ]),
        );
      });

      test('returns ranks in the same order as rankFeet', () {
        final row = MixtureRow.parse('C2 1 1/3, 1, 2/3');

        expect(row.ranks.length, equals(row.rankFeet.length));

        for (var i = 0; i < row.ranks.length; i++) {
          final expectedRatio = (MixtureRow.referenceHeight * row.rankFeet[i])
              .toDouble();

          expect(
            row.ranks[i],
            equals(Interval.fromRatio(expectedRatio)),
          );
        }
      });
    });

    group('operator ==()', () {
      test('equal rows compare equal', () {
        final a = MixtureRow.parse('C2 1 1/3, 1, 2/3');
        final b = MixtureRow.parse('C2 1 1/3, 1, 2/3');

        expect(a, equals(b));
      });

      test('rows with different breakpoints are not equal', () {
        final a = MixtureRow.parse('C2 1 1/3, 1, 2/3');
        final b = MixtureRow.parse('C3 1 1/3, 1, 2/3');

        expect(a, isNot(equals(b)));
      });

      test('rows with different rank feet are not equal', () {
        final a = MixtureRow.parse('C2 1 1/3, 1, 2/3');
        final b = MixtureRow.parse('C2 1 1/3, 1, 1/2');

        expect(a, isNot(equals(b)));
      });

      test('rank order matters', () {
        final a = MixtureRow.parse('C2 1, 2/3');
        final b = MixtureRow.parse('C2 2/3, 1');

        expect(a, isNot(equals(b)));
      });

      test('different number of ranks are not equal', () {
        final a = MixtureRow.parse('C2 1, 2/3');
        final b = MixtureRow.parse('C2 1');

        expect(a, isNot(equals(b)));
      });

      test('equality is symmetric', () {
        final a = MixtureRow.parse('C2 1 1/3, 1, 2/3');
        final b = MixtureRow.parse('C2 1 1/3, 1, 2/3');

        expect(a == b, equals(b == a));
      });

      test('equal rows behave as a single Set element', () {
        final rows = {
          MixtureRow.parse('C2 1, 2/3'),
          MixtureRow.parse('C2 1, 2/3'),
        };

        expect(rows, hasLength(1));
      });
    });

    group('.hashCode', () {
      test('equal rows have equal hash codes', () {
        expect(
          MixtureRow.parse('C2 1 1/3, 1, 2/3').hashCode,
          equals(MixtureRow.parse('C2 1 1/3, 1, 2/3').hashCode),
        );
      });
    });
  });

  group('MixtureDisposition', () {
    group('.parse()', () {
      test('parses multiple rows', () {
        final rows = MixtureDisposition.parse('''
C2 1 1/3, 1, 2/3
C3 2 2/3, 2, 1 1/3, 1
C4 4, 2 2/3, 2, 1 1/3
C5 5 1/3, 4, 2 2/3, 2
''');

        expect(rows, hasLength(4));
        expect(rows[0].format(), equals('C2 1 1/3, 1, 2/3'));
        expect(rows[1].format(), equals('C3 2 2/3, 2, 1 1/3, 1'));
        expect(rows[2].format(), equals('C4 4, 2 2/3, 2, 1 1/3'));
        expect(rows[3].format(), equals('C5 5 1/3, 4, 2 2/3, 2'));
      });

      test('ignores empty lines', () {
        final rows = MixtureDisposition.parse('''

C2 1 1/3, 1, 2/3

C3 2 2/3, 2, 1 1/3, 1

''');

        expect(rows, hasLength(2));
      });

      test('round-trips each parsed row', () {
        const source = '''
C2 1 1/3, 1, 2/3
C3 2 2/3, 2, 1 1/3, 1
C4 4, 2 2/3, 2, 1 1/3
C5 5 1/3, 4, 2 2/3, 2
''';

        final rows = MixtureDisposition.parse(source);

        expect(
          rows.map((row) => row.format()).join('\n'),
          equals(source.trim()),
        );
      });
    });

    group('.rowFor()', () {
      final rows = MixtureDisposition.parse('''
C2 1 1/3, 1, 2/3
C3 2 2/3, 2, 1 1/3, 1
C4 4, 2 2/3, 2, 1 1/3
C5 5 1/3, 4, 2 2/3, 2
''');

      test('returns the row at the exact breakpoint', () {
        expect(rows.rowFor(Pitch.parse('C3')), same(rows[1]));
      });

      test('returns the highest breakpoint below the key', () {
        expect(rows.rowFor(Pitch.parse('F3')), same(rows[1]));
        expect(rows.rowFor(Pitch.parse('G4')), same(rows[2]));
      });

      test('returns the first row for keys below the next breakpoint', () {
        expect(rows.rowFor(Pitch.parse('C2')), same(rows[0]));
        expect(rows.rowFor(Pitch.parse('B2')), same(rows[0]));
      });
    });
  });
}
