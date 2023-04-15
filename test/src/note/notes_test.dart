import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Notes', () {
    group('.intervalSize()', () {
      test(
        'should return the interval size between this Notes and other',
        () {
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
        },
      );
    });
  });
}
