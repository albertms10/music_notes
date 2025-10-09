import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('NoteName', () {
    group('EnglishNoteNameNotation', () {
      group('.parse()', () {
        test('throws a FormatException when source is invalid', () {
          expect(() => NoteName.parse('x'), throwsFormatException);
          expect(
            () => NoteName.parse('H', chain: [const EnglishNoteNameNotation()]),
            throwsFormatException,
          );
          expect(() => NoteName.parse('X'), throwsFormatException);
          expect(() => NoteName.parse(''), throwsFormatException);
          expect(() => NoteName.parse('AB'), throwsFormatException);
        });

        test('parses source as a NoteName', () {
          expect(NoteName.parse('a'), NoteName.a);
          expect(NoteName.parse('b'), NoteName.b);
          expect(NoteName.parse('c'), NoteName.c);
          expect(NoteName.parse('d'), NoteName.d);
          expect(NoteName.parse('e'), NoteName.e);
          expect(NoteName.parse('f'), NoteName.f);
          expect(NoteName.parse('g'), NoteName.g);

          expect(NoteName.parse('A'), NoteName.a);
          expect(NoteName.parse('B'), NoteName.b);
          expect(NoteName.parse('C'), NoteName.c);
          expect(NoteName.parse('D'), NoteName.d);
          expect(NoteName.parse('E'), NoteName.e);
          expect(NoteName.parse('F'), NoteName.f);
          expect(NoteName.parse('G'), NoteName.g);
        });

        test('.toString() and .parse() are inverses', () {
          for (final noteName in NoteName.values) {
            expect(noteName, NoteName.parse(noteName.toString()));
          }
        });
      });
    });

    group('GermanNoteNameNotation', () {
      group('.parse()', () {
        const chain = [GermanNoteNameNotation()];

        test('throws a FormatException when source is invalid', () {
          expect(
            () => NoteName.parse('X', chain: chain),
            throwsFormatException,
          );
          expect(() => NoteName.parse('', chain: chain), throwsFormatException);
          expect(
            () => NoteName.parse('AH', chain: chain),
            throwsFormatException,
          );
        });

        test('parses source as a NoteName', () {
          expect(NoteName.parse('A', chain: chain), NoteName.a);
          expect(NoteName.parse('B', chain: chain), NoteName.b);
          expect(NoteName.parse('C', chain: chain), NoteName.c);
          expect(NoteName.parse('D', chain: chain), NoteName.d);
          expect(NoteName.parse('E', chain: chain), NoteName.e);
          expect(NoteName.parse('F', chain: chain), NoteName.f);
          expect(NoteName.parse('G', chain: chain), NoteName.g);
          expect(NoteName.parse('H', chain: chain), NoteName.b);

          expect(NoteName.parse('h', chain: chain), NoteName.b);
          expect(NoteName.parse('a', chain: chain), NoteName.a);
        });

        test('.toString() and .parse() are inverses', () {
          for (final noteName in NoteName.values) {
            expect(
              noteName,
              NoteName.parse(
                noteName.toString(formatter: const GermanNoteNameNotation()),
                chain: chain,
              ),
            );
          }
        });
      });
    });

    group('RomanceNoteNameNotation', () {
      group('.parse()', () {
        const chain = [RomanceNoteNameNotation()];

        test('throws a FormatException when source is invalid', () {
          expect(
            () => NoteName.parse('X', chain: chain),
            throwsFormatException,
          );
          expect(() => NoteName.parse('', chain: chain), throwsFormatException);
          expect(
            () => NoteName.parse('A', chain: chain),
            throwsFormatException,
          );
          expect(
            () => NoteName.parse('DoRe', chain: chain),
            throwsFormatException,
          );
          expect(
            () => const RomanceNoteNameNotation().parse('x'),
            throwsFormatException,
          );
        });

        test('parses source as a NoteName', () {
          expect(NoteName.parse('Do', chain: chain), NoteName.c);
          expect(NoteName.parse('Re', chain: chain), NoteName.d);
          expect(NoteName.parse('Mi', chain: chain), NoteName.e);
          expect(NoteName.parse('Fa', chain: chain), NoteName.f);
          expect(NoteName.parse('Sol', chain: chain), NoteName.g);
          expect(NoteName.parse('La', chain: chain), NoteName.a);
          expect(NoteName.parse('Si', chain: chain), NoteName.b);

          expect(NoteName.parse('do', chain: chain), NoteName.c);
          expect(NoteName.parse('DO', chain: chain), NoteName.c);
          expect(NoteName.parse('re', chain: chain), NoteName.d);
          expect(NoteName.parse('mi', chain: chain), NoteName.e);
          expect(NoteName.parse('fa', chain: chain), NoteName.f);
          expect(NoteName.parse('sol', chain: chain), NoteName.g);
          expect(NoteName.parse('la', chain: chain), NoteName.a);
          expect(NoteName.parse('si', chain: chain), NoteName.b);
        });

        test('.toString() and .parse() are inverses', () {
          for (final noteName in NoteName.values) {
            expect(
              noteName,
              NoteName.parse(
                noteName.toString(formatter: const RomanceNoteNameNotation()),
                chain: chain,
              ),
            );
          }
        });
      });
    });

    group('.intervalSize()', () {
      test('returns the Interval size between this NoteName and other', () {
        expect(NoteName.c.intervalSize(NoteName.c), 1);
        expect(NoteName.d.intervalSize(NoteName.e), 2);
        expect(NoteName.e.intervalSize(NoteName.f), 2);
        expect(NoteName.b.intervalSize(NoteName.c), 2);
        expect(NoteName.a.intervalSize(NoteName.c), 3);
        expect(NoteName.f.intervalSize(NoteName.b), 4);
        expect(NoteName.b.intervalSize(NoteName.e), 4);
        expect(NoteName.a.intervalSize(NoteName.e), 5);
        expect(NoteName.c.intervalSize(NoteName.a), 6);
        expect(NoteName.a.intervalSize(NoteName.g), 7);
      });
    });

    group('.difference()', () {
      test('returns the difference in semitones with another NoteName', () {
        expect(NoteName.f.difference(NoteName.b), -6);
        expect(NoteName.e.difference(NoteName.b), -5);
        expect(NoteName.e.difference(NoteName.c), -4);
        expect(NoteName.d.difference(NoteName.b), -3);
        expect(NoteName.e.difference(NoteName.d), -2);
        expect(NoteName.c.difference(NoteName.b), -1);
        expect(NoteName.c.difference(NoteName.c), 0);
        expect(NoteName.b.difference(NoteName.c), 1);
        expect(NoteName.c.difference(NoteName.d), 2);
        expect(NoteName.c.difference(NoteName.e), 4);
        expect(NoteName.a.difference(NoteName.d), 5);
        expect(NoteName.c.difference(NoteName.f), 5);
        expect(NoteName.b.difference(NoteName.f), 6);
      });
    });

    group('.positiveDifference()', () {
      test('returns the positive difference in semitones with other', () {
        expect(NoteName.c.positiveDifference(NoteName.c), 0);
        expect(NoteName.b.positiveDifference(NoteName.c), 1);
        expect(NoteName.c.positiveDifference(NoteName.d), 2);
        expect(NoteName.c.positiveDifference(NoteName.e), 4);
        expect(NoteName.c.positiveDifference(NoteName.f), 5);
        expect(NoteName.a.positiveDifference(NoteName.d), 5);
        expect(NoteName.e.positiveDifference(NoteName.b), 7);
        expect(NoteName.e.positiveDifference(NoteName.c), 8);
        expect(NoteName.d.positiveDifference(NoteName.b), 9);
        expect(NoteName.e.positiveDifference(NoteName.d), 10);
        expect(NoteName.c.positiveDifference(NoteName.b), 11);
      });
    });

    group('.transposeBySize()', () {
      test('transposes this NoteName by Interval size', () {
        expect(NoteName.f.transposeBySize(-Size.octave), NoteName.f);
        expect(NoteName.g.transposeBySize(-Size.third), NoteName.e);
        expect(NoteName.c.transposeBySize(-Size.second), NoteName.b);
        expect(NoteName.d.transposeBySize(-Size.unison), NoteName.d);
        expect(NoteName.c.transposeBySize(Size.unison), NoteName.c);
        expect(NoteName.d.transposeBySize(Size.second), NoteName.e);
        expect(NoteName.e.transposeBySize(Size.third), NoteName.g);
        expect(NoteName.e.transposeBySize(Size.fourth), NoteName.a);
        expect(NoteName.f.transposeBySize(Size.fifth), NoteName.c);
        expect(NoteName.a.transposeBySize(Size.sixth), NoteName.f);
        expect(NoteName.b.transposeBySize(Size.seventh), NoteName.a);
        expect(NoteName.c.transposeBySize(Size.octave), NoteName.c);
      });
    });

    group('.next', () {
      test('returns the next ordinal NoteName', () {
        expect(NoteName.c.next, NoteName.d);
        expect(NoteName.e.next, NoteName.f);
        expect(NoteName.f.next, NoteName.g);
        expect(NoteName.b.next, NoteName.c);
      });
    });

    group('.previous', () {
      test('returns the previous ordinal NoteName', () {
        expect(NoteName.b.previous, NoteName.a);
        expect(NoteName.f.previous, NoteName.e);
        expect(NoteName.d.previous, NoteName.c);
        expect(NoteName.c.previous, NoteName.b);
      });
    });

    group('.compareTo()', () {
      test('sorts NoteNames in a collection', () {
        final orderedSet = SplayTreeSet<NoteName>.of({
          NoteName.b,
          NoteName.e,
          NoteName.d,
          NoteName.c,
          NoteName.g,
          NoteName.f,
          NoteName.a,
        });
        expect(orderedSet.toList(), [
          NoteName.c,
          NoteName.d,
          NoteName.e,
          NoteName.f,
          NoteName.g,
          NoteName.a,
          NoteName.b,
        ]);
      });
    });
  });
}
