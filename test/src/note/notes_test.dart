import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Notes', () {
    group('.intervalSize()', () {
      test('should return the Interval size between this Notes and other', () {
        expect(Notes.c.intervalSize(Notes.c), 1);
        expect(Notes.d.intervalSize(Notes.e), 2);
        expect(Notes.e.intervalSize(Notes.f), 2);
        expect(Notes.a.intervalSize(Notes.e), 5);
        expect(Notes.a.intervalSize(Notes.g), 7);
        expect(Notes.b.intervalSize(Notes.c), 2);

        expect(Notes.d.intervalSize(Notes.d, descending: true), 1);
        expect(Notes.c.intervalSize(Notes.b, descending: true), 2);
        expect(Notes.a.intervalSize(Notes.e, descending: true), 4);
        expect(Notes.e.intervalSize(Notes.f, descending: true), 7);
        expect(Notes.f.intervalSize(Notes.e, descending: true), 2);
        expect(Notes.b.intervalSize(Notes.c, descending: true), 7);
      });
    });

    group('.difference()', () {
      test('should return the difference in semitones with other', () {
        expect(Notes.b.difference(Notes.c), -11);
        expect(Notes.a.difference(Notes.d), -7);
        expect(Notes.e.difference(Notes.c), -4);
        expect(Notes.e.difference(Notes.d), -2);
        expect(Notes.c.difference(Notes.c), 0);
        expect(Notes.c.difference(Notes.d), 2);
        expect(Notes.c.difference(Notes.e), 4);
        expect(Notes.c.difference(Notes.f), 5);
        expect(Notes.e.difference(Notes.b), 7);
        expect(Notes.d.difference(Notes.b), 9);
        expect(Notes.c.difference(Notes.b), 11);
      });
    });

    group('.positiveDifference()', () {
      test('should return the positive difference in semitones with other', () {
        expect(Notes.c.positiveDifference(Notes.c), 0);
        expect(Notes.b.positiveDifference(Notes.c), 1);
        expect(Notes.c.positiveDifference(Notes.d), 2);
        expect(Notes.c.positiveDifference(Notes.e), 4);
        expect(Notes.c.positiveDifference(Notes.f), 5);
        expect(Notes.a.positiveDifference(Notes.d), 5);
        expect(Notes.e.positiveDifference(Notes.b), 7);
        expect(Notes.e.positiveDifference(Notes.c), 8);
        expect(Notes.d.positiveDifference(Notes.b), 9);
        expect(Notes.e.positiveDifference(Notes.d), 10);
        expect(Notes.c.positiveDifference(Notes.b), 11);
      });
    });

    group('.transposeBy()', () {
      test('should throw an assertion error when size is zero', () {
        expect(() => Notes.c.transposeBy(0), throwsA(isA<AssertionError>()));
      });

      test('should transpose this Notes enum item by Interval', () {
        expect(Notes.f.transposeBy(-8), Notes.f);
        expect(Notes.g.transposeBy(-3), Notes.e);
        expect(Notes.c.transposeBy(-2), Notes.b);
        expect(Notes.d.transposeBy(-1), Notes.d);
        expect(Notes.c.transposeBy(1), Notes.c);
        expect(Notes.d.transposeBy(2), Notes.e);
        expect(Notes.e.transposeBy(3), Notes.g);
        expect(Notes.e.transposeBy(4), Notes.a);
        expect(Notes.f.transposeBy(5), Notes.c);
        expect(Notes.a.transposeBy(6), Notes.f);
        expect(Notes.b.transposeBy(7), Notes.a);
        expect(Notes.c.transposeBy(8), Notes.c);
      });
    });
  });
}
