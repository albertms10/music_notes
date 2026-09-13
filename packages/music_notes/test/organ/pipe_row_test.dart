import 'package:music_notes/music_notes.dart';
import 'package:music_notes/organ.dart';
import 'package:test/test.dart';

void main() {
  group('PipeRow', () {
    group('.ranks()', () {
      test('converts rank feet to intervals', () {
        expect(
          PipeRow(Note.c.inOctave(2), const [
            .fromMixed(1, 1, 3),
            .new(1),
            .new(2, 3),
          ]).rankIntervals,
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
        final row = PipeRow(Note.c.inOctave(2), const [
          .fromMixed(1, 1, 3),
          .new(1),
          .new(2, 3),
        ]);

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
        final a = PipeRow(Note.c.inOctave(2), const [
          .fromMixed(1, 1, 3),
          .new(1),
          .new(2, 3),
        ]);
        final b = PipeRow(Note.c.inOctave(2), const [
          .fromMixed(1, 1, 3),
          .new(1),
          .new(2, 3),
        ]);

        expect(a, equals(b));
      });

      test('rows with different breakpoints are not equal', () {
        final a = PipeRow(Note.c.inOctave(2), const [
          .fromMixed(1, 1, 3),
          .new(1),
          .new(2, 3),
        ]);
        final b = PipeRow(Note.c.inOctave(3), const [
          .fromMixed(1, 1, 3),
          .new(1),
          .new(2, 3),
        ]);

        expect(a, isNot(equals(b)));
      });

      test('rows with different rank feet are not equal', () {
        final a = PipeRow(Note.c.inOctave(2), const [
          .new(1),
          .new(2, 3),
        ]);
        final b = PipeRow(Note.c.inOctave(2), const [
          .new(1),
          .new(1, 2),
        ]);

        expect(a, isNot(equals(b)));
      });

      test('rank order matters', () {
        final a = PipeRow(Note.c.inOctave(2), const [
          .new(1),
          .new(2, 3),
        ]);
        final b = PipeRow(Note.c.inOctave(2), const [
          .new(2, 3),
          .new(1),
        ]);

        expect(a, isNot(equals(b)));
      });

      test('different number of ranks are not equal', () {
        final a = PipeRow(Note.c.inOctave(2), const [
          .new(1),
          .new(2, 3),
        ]);
        final b = PipeRow(Note.c.inOctave(2), const [
          .new(1),
        ]);

        expect(a, isNot(equals(b)));
      });

      test('equality is symmetric', () {
        final a = PipeRow(Note.c.inOctave(2), const [
          .new(1),
          .new(2, 3),
        ]);
        final b = PipeRow(Note.c.inOctave(2), const [
          .new(1),
          .new(2, 3),
        ]);

        expect(a == b, equals(b == a));
      });

      test('equal rows behave as a single Set element', () {
        final rows = {
          PipeRow(Note.c.inOctave(2), const [
            .new(1),
            .new(2, 3),
          ]),
          PipeRow(Note.c.inOctave(2), const [
            .new(1),
            .new(2, 3),
          ]),
        };

        expect(rows, hasLength(1));
      });
    });

    group('.hashCode', () {
      test('equal rows have equal hash codes', () {
        expect(
          PipeRow(Note.c.inOctave(2), const [
            .fromMixed(1, 1, 3),
            .new(1),
            .new(2, 3),
          ]).hashCode,
          equals(
            PipeRow(Note.c.inOctave(2), const [
              .fromMixed(1, 1, 3),
              .new(1),
              .new(2, 3),
            ]).hashCode,
          ),
        );
      });
    });
  });

  group('StopComposition', () {
    group('.parse()', () {
      test('parses multiple rows', () {
        final rows = StopComposition.parse('''
C2 1 1/3, 1, 2/3
C3 2 2/3, 2, 1 1/3, 1
C4 4, 2 2/3, 2, 1 1/3
C5 5 1/3, 4, 2 2/3, 2
''');

        expect(rows, hasLength(4));
      });

      test('ignores empty lines', () {
        final rows = StopComposition.parse('''

C2 1 1/3, 1, 2/3

C3 2 2/3, 2, 1 1/3, 1

''');

        expect(rows, hasLength(2));
      });
    });

    group('.rowFor()', () {
      final rows = StopComposition.parse('''
C2 1 1/3, 1, 2/3
C3 2 2/3, 2, 1 1/3, 1
C4 4, 2 2/3, 2, 1 1/3
C5 5 1/3, 4, 2 2/3, 2
''');

      test('returns the row at the exact breakpoint', () {
        expect(rows.rowFor(.parse('C3')), same(rows[1]));
      });

      test('returns the highest breakpoint below the key', () {
        expect(rows.rowFor(.parse('F3')), same(rows[1]));
        expect(rows.rowFor(.parse('G4')), same(rows[2]));
      });

      test('returns the first row for keys below the next breakpoint', () {
        expect(rows.rowFor(.parse('C2')), same(rows[0]));
        expect(rows.rowFor(.parse('B2')), same(rows[0]));
      });
    });
  });

  group('.format()', () {
    test('formats multiple rows', () {
      expect(
        StopComposition.parse('''
  C2 1 1/3, 1, 2/3
  C3 2 2/3, 2, 1 1/3, 1
  C4 4, 2 2/3, 2, 1 1/3
  C5 5 1/3, 4, 2 2/3, 2
  ''').format(),
        '''
C                            1 1/3′  1′  2/3′
c                2 2/3′  2′  1 1/3′  1′
c'           4′  2 2/3′  2′  1 1/3′
c''  5 1/3′  4′  2 2/3′  2′''',
      );

      expect(
        StopComposition.parse('''
          C			1 1/3'	1'	2/3'	1/2'
          c			2'	1 1/3'	1'	2/3'
          g		2'	1 1/3'	1' 	1'	2/3'
          c'	2 2/3'	2'	1 1/3'	1' 	1'	2/3'
          c''	4'	2 2/3'	2'	2'	1 1/3' 	1'
          gis''	5 1/3'	4'	2 2/3'	2'	2'	4/3'
          cis\'''	5 1/3'	4'	2 2/3'	2 2/3'	2'	2'
  ''').format(),
        equals('''
C                                           1 1/3′  1′      2/3′  1/2′
c                                   2′      1 1/3′  1′      2/3′
g                                   2′      1 1/3′  1′  1′  2/3′
c'                  2 2/3′          2′      1 1/3′  1′  1′  2/3′
c''             4′  2 2/3′          2′  2′  1 1/3′  1′
gis''   5 1/3′  4′  2 2/3′          2′  2′  1 1/3′
cis\'''  5 1/3′  4′  2 2/3′  2 2/3′  2′  2′'''),
      );
    });
  });
}
