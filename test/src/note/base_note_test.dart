import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('BaseNote', () {
    group('.intervalSize()', () {
      test(
        'should return the Interval size between this BaseNote and other',
        () {
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
        },
      );
    });

    group('.difference()', () {
      test('should return the difference in semitones with other', () {
        expect(BaseNote.b.difference(BaseNote.c), -11);
        expect(BaseNote.a.difference(BaseNote.d), -7);
        expect(BaseNote.e.difference(BaseNote.c), -4);
        expect(BaseNote.e.difference(BaseNote.d), -2);
        expect(BaseNote.c.difference(BaseNote.c), 0);
        expect(BaseNote.c.difference(BaseNote.d), 2);
        expect(BaseNote.c.difference(BaseNote.e), 4);
        expect(BaseNote.c.difference(BaseNote.f), 5);
        expect(BaseNote.e.difference(BaseNote.b), 7);
        expect(BaseNote.d.difference(BaseNote.b), 9);
        expect(BaseNote.c.difference(BaseNote.b), 11);
      });
    });

    group('.positiveDifference()', () {
      test('should return the positive difference in semitones with other', () {
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
      test('should throw an assertion error when size is zero', () {
        expect(
          () => BaseNote.c.transposeBySize(0),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should transpose this BaseNote enum item by Interval', () {
        expect(BaseNote.f.transposeBySize(-8), BaseNote.f);
        expect(BaseNote.g.transposeBySize(-3), BaseNote.e);
        expect(BaseNote.c.transposeBySize(-2), BaseNote.b);
        expect(BaseNote.d.transposeBySize(-1), BaseNote.d);
        expect(BaseNote.c.transposeBySize(1), BaseNote.c);
        expect(BaseNote.d.transposeBySize(2), BaseNote.e);
        expect(BaseNote.e.transposeBySize(3), BaseNote.g);
        expect(BaseNote.e.transposeBySize(4), BaseNote.a);
        expect(BaseNote.f.transposeBySize(5), BaseNote.c);
        expect(BaseNote.a.transposeBySize(6), BaseNote.f);
        expect(BaseNote.b.transposeBySize(7), BaseNote.a);
        expect(BaseNote.c.transposeBySize(8), BaseNote.c);
      });
    });
  });
}
