import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('BaseNote', () {
    test('throws a FormatException when source is invalid', () {
      expect(() => BaseNote.parse('x'), throwsFormatException);
    });

    group('.parse()', () {
      test('parses source as a BaseNote and return its value', () {
        expect(BaseNote.parse('a'), BaseNote.a);
        expect(BaseNote.parse('b'), BaseNote.b);
        expect(BaseNote.parse('c'), BaseNote.c);
        expect(BaseNote.parse('d'), BaseNote.d);
        expect(BaseNote.parse('e'), BaseNote.e);
        expect(BaseNote.parse('f'), BaseNote.f);
        expect(BaseNote.parse('g'), BaseNote.g);

        expect(BaseNote.parse('A'), BaseNote.a);
        expect(BaseNote.parse('B'), BaseNote.b);
        expect(BaseNote.parse('C'), BaseNote.c);
        expect(BaseNote.parse('D'), BaseNote.d);
        expect(BaseNote.parse('E'), BaseNote.e);
        expect(BaseNote.parse('F'), BaseNote.f);
        expect(BaseNote.parse('G'), BaseNote.g);
      });
    });

    group('.intervalSize()', () {
      test('returns the Interval size between this BaseNote and other', () {
        expect(BaseNote.c.intervalSize(BaseNote.c), 1);
        expect(BaseNote.d.intervalSize(BaseNote.e), 2);
        expect(BaseNote.e.intervalSize(BaseNote.f), 2);
        expect(BaseNote.b.intervalSize(BaseNote.c), 2);
        expect(BaseNote.a.intervalSize(BaseNote.c), 3);
        expect(BaseNote.f.intervalSize(BaseNote.b), 4);
        expect(BaseNote.b.intervalSize(BaseNote.e), 4);
        expect(BaseNote.a.intervalSize(BaseNote.e), 5);
        expect(BaseNote.c.intervalSize(BaseNote.a), 6);
        expect(BaseNote.a.intervalSize(BaseNote.g), 7);
      });
    });

    group('.difference()', () {
      test('returns the difference in semitones with another BaseNote', () {
        expect(BaseNote.f.difference(BaseNote.b), -6);
        expect(BaseNote.e.difference(BaseNote.b), -5);
        expect(BaseNote.e.difference(BaseNote.c), -4);
        expect(BaseNote.d.difference(BaseNote.b), -3);
        expect(BaseNote.e.difference(BaseNote.d), -2);
        expect(BaseNote.c.difference(BaseNote.b), -1);
        expect(BaseNote.c.difference(BaseNote.c), 0);
        expect(BaseNote.b.difference(BaseNote.c), 1);
        expect(BaseNote.c.difference(BaseNote.d), 2);
        expect(BaseNote.c.difference(BaseNote.e), 4);
        expect(BaseNote.a.difference(BaseNote.d), 5);
        expect(BaseNote.c.difference(BaseNote.f), 5);
        expect(BaseNote.b.difference(BaseNote.f), 6);
      });
    });

    group('.positiveDifference()', () {
      test('returns the positive difference in semitones with other', () {
        expect(BaseNote.c.positiveDifference(BaseNote.c), 0);
        expect(BaseNote.b.positiveDifference(BaseNote.c), 1);
        expect(BaseNote.c.positiveDifference(BaseNote.d), 2);
        expect(BaseNote.c.positiveDifference(BaseNote.e), 4);
        expect(BaseNote.c.positiveDifference(BaseNote.f), 5);
        expect(BaseNote.a.positiveDifference(BaseNote.d), 5);
        expect(BaseNote.e.positiveDifference(BaseNote.b), 7);
        expect(BaseNote.e.positiveDifference(BaseNote.c), 8);
        expect(BaseNote.d.positiveDifference(BaseNote.b), 9);
        expect(BaseNote.e.positiveDifference(BaseNote.d), 10);
        expect(BaseNote.c.positiveDifference(BaseNote.b), 11);
      });
    });

    group('.transposeBySize()', () {
      test('transposes this BaseNote by Interval size', () {
        expect(BaseNote.f.transposeBySize(-Size.octave), BaseNote.f);
        expect(BaseNote.g.transposeBySize(-Size.third), BaseNote.e);
        expect(BaseNote.c.transposeBySize(-Size.second), BaseNote.b);
        expect(BaseNote.d.transposeBySize(-Size.unison), BaseNote.d);
        expect(BaseNote.c.transposeBySize(Size.unison), BaseNote.c);
        expect(BaseNote.d.transposeBySize(Size.second), BaseNote.e);
        expect(BaseNote.e.transposeBySize(Size.third), BaseNote.g);
        expect(BaseNote.e.transposeBySize(Size.fourth), BaseNote.a);
        expect(BaseNote.f.transposeBySize(Size.fifth), BaseNote.c);
        expect(BaseNote.a.transposeBySize(Size.sixth), BaseNote.f);
        expect(BaseNote.b.transposeBySize(Size.seventh), BaseNote.a);
        expect(BaseNote.c.transposeBySize(Size.octave), BaseNote.c);
      });
    });

    group('.compareTo()', () {
      test('sorts BaseNotes in a collection', () {
        final orderedSet = SplayTreeSet<BaseNote>.of({
          BaseNote.b,
          BaseNote.e,
          BaseNote.d,
          BaseNote.c,
          BaseNote.g,
          BaseNote.f,
          BaseNote.a,
        });
        expect(orderedSet.toList(), [
          BaseNote.c,
          BaseNote.d,
          BaseNote.e,
          BaseNote.f,
          BaseNote.g,
          BaseNote.a,
          BaseNote.b,
        ]);
      });
    });
  });
}
