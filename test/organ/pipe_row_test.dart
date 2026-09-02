import 'package:music_notes/music_notes.dart';
import 'package:music_notes/organ.dart';
import 'package:test/test.dart';

void main() {
  group('PipeRow', () {
    group('.parse()', () {
      test('throws a FormatException when source is invalid', () {
        expect(() => PipeRow.parse('x'), throwsFormatException);
        expect(() => PipeRow.parse(' C2 1'), throwsFormatException);
      });

      test('parses a row', () {
        final row = PipeRow.parse('C2 1 1/3, 1, 2/3');

        expect(row.breakpoint, equals(Pitch.parse('C2')));
        expect(
          row.ranks,
          equals(const <Rational>[.fromMixed(1, 1, 3), .new(1), .new(2, 3)]),
        );
      });

      test('accepts whitespace around commas', () {
        expect(
          PipeRow.parse('C2 1 1/3,1,  2/3').ranks,
          equals(const <Rational>[.fromMixed(1, 1, 3), .new(1), .new(2, 3)]),
        );
      });
    });

    group('.format()', () {
      test('formats a row in parseable form', () {
        const row = PipeRow(
          Pitch(.c, octave: 2),
          [.fromMixed(1, 1, 3), .new(1), .new(2, 3)],
        );

        expect(row.format(), equals('C2 1 1/3, 1, 2/3'));
      });

      test('format and parse are symmetric', () {
        const sources = [
          'C2 1 1/3, 1, 2/3',
          'C3 2 2/3, 2, 1 1/3, 1',
          'C4 4, 2 2/3, 2, 1 1/3',
          'C5 5 1/3, 4, 2 2/3, 2',
        ];

        for (final source in sources) {
          final row = PipeRow.parse(source);
          expect(PipeRow.parse(row.format()), equals(row));
        }
      });
    });

    group('.ranks()', () {
      test('converts rank feet to intervals', () {
        expect(
          PipeRow.parse('C2 1 1/3, 1, 2/3').rankIntervals,
          equals(<Interval>[
            .fromRatio(
              (PipeRow.referenceHeight / .parse('1 1/3')).toDouble(),
            ),
            .fromRatio(
              (PipeRow.referenceHeight / .parse('1')).toDouble(),
            ),
            .fromRatio(
              (PipeRow.referenceHeight / .parse('2/3')).toDouble(),
            ),
          ]),
        );
      });

      test('returns ranks in the same order as rankFeet', () {
        final row = PipeRow.parse('C2 1 1/3, 1, 2/3');

        expect(row.rankIntervals.length, equals(row.ranks.length));

        for (var i = 0; i < row.rankIntervals.length; i++) {
          final expectedRatio = (PipeRow.referenceHeight / row.ranks[i])
              .toDouble();

          expect(
            row.rankIntervals[i],
            equals(Interval.fromRatio(expectedRatio)),
          );
        }
      });
    });

    group('operator ==()', () {
      test('equal rows compare equal', () {
        final a = PipeRow.parse('C2 1 1/3, 1, 2/3');
        final b = PipeRow.parse('C2 1 1/3, 1, 2/3');

        expect(a, equals(b));
      });

      test('rows with different breakpoints are not equal', () {
        final a = PipeRow.parse('C2 1 1/3, 1, 2/3');
        final b = PipeRow.parse('C3 1 1/3, 1, 2/3');

        expect(a, isNot(equals(b)));
      });

      test('rows with different rank feet are not equal', () {
        final a = PipeRow.parse('C2 1 1/3, 1, 2/3');
        final b = PipeRow.parse('C2 1 1/3, 1, 1/2');

        expect(a, isNot(equals(b)));
      });

      test('rank order matters', () {
        final a = PipeRow.parse('C2 1, 2/3');
        final b = PipeRow.parse('C2 2/3, 1');

        expect(a, isNot(equals(b)));
      });

      test('different number of ranks are not equal', () {
        final a = PipeRow.parse('C2 1, 2/3');
        final b = PipeRow.parse('C2 1');

        expect(a, isNot(equals(b)));
      });

      test('equality is symmetric', () {
        final a = PipeRow.parse('C2 1 1/3, 1, 2/3');
        final b = PipeRow.parse('C2 1 1/3, 1, 2/3');

        expect(a == b, equals(b == a));
      });

      test('equal rows behave as a single Set element', () {
        final rows = {
          PipeRow.parse('C2 1, 2/3'),
          PipeRow.parse('C2 1, 2/3'),
        };

        expect(rows, hasLength(1));
      });
    });

    group('.hashCode', () {
      test('equal rows have equal hash codes', () {
        expect(
          PipeRow.parse('C2 1 1/3, 1, 2/3').hashCode,
          equals(PipeRow.parse('C2 1 1/3, 1, 2/3').hashCode),
        );
      });
    });
  });

  group('StopDisposition', () {
    group('.parse()', () {
      test('parses multiple rows', () {
        final rows = StopDisposition.parse('''
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
        final rows = StopDisposition.parse('''

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
C5 5 1/3, 4, 2 2/3, 2''';

        expect(StopDisposition.parse(source).format(), equals(source));
      });
    });

    group('.rowFor()', () {
      final rows = StopDisposition.parse('''
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
