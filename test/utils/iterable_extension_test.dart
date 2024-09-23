import 'package:music_notes/music_notes.dart';
import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('IterableExtension', () {
    group('.closestTo()', () {
      test('throws an exception when this Iterable is empty', () {
        expect(() => const <num>[].closestTo(1), throwsStateError);
      });

      test('returns the closest element to target in this Iterable', () {
        expect(const [5].closestTo(1), 5);
        expect(const [5].closestTo(-1), 5);
        expect(const [-5, 5].closestTo(0), -5);
        expect(const [2, 5, 6, 8, 10].closestTo(7), 6);
        expect(
          [DateTime(2025, 1, 2), DateTime(2023, 12, 15)].closestTo(
            DateTime(2024),
            (a, b) => b.millisecondsSinceEpoch - a.millisecondsSinceEpoch,
          ),
          DateTime(2023, 12, 15),
        );
        expect(
          [Note.c, Note.e, Note.f.sharp, Note.a].closestTo(Note.g),
          Note.f.sharp,
        );
      });
    });

    group('.compact()', () {
      test('returns this Iterable with ranges compacted', () {
        expect(
          const [1, 2, 3, 4, 5, 8].compact(
            nextValue: (current) => current + 1,
            compare: Comparable.compare,
          ),
          const [(from: 1, to: 6), (from: 8, to: 9)],
        );
        expect(
          'abcdefxyz'.split('').compact(
                nextValue: (current) =>
                    String.fromCharCodes(current.codeUnits.map((a) => a + 1)),
                compare: Comparable.compare,
              ),
          const [(from: 'a', to: 'g'), (from: 'x', to: '{')],
        );

        expect(const <Note>[].compact(), const <List<Note>>[]);
        expect(const [Note.c].compact(), [(from: Note.c, to: Note.d.flat)]);
        expect(
          const [Note.c, Note.d, Note.e, Note.g, Note.a, Note.b].compact(),
          [
            (from: Note.c, to: Note.d.flat),
            (from: Note.d, to: Note.e.flat),
            (from: Note.e, to: Note.f),
            (from: Note.g, to: Note.a.flat),
            (from: Note.a, to: Note.b.flat),
            (from: Note.b, to: Note.c),
          ],
        );
        expect([Note.c, Note.c.sharp].compact(), [
          (from: Note.c, to: Note.d),
        ]);
        expect([Note.c, Note.d.flat].compact(), [
          (from: Note.c, to: Note.d),
        ]);
        expect([Note.c, Note.d.flat, Note.d].compact(), [
          (from: Note.c, to: Note.e.flat),
        ]);
        expect([Note.c, Note.d.flat, Note.d, Note.e.flat, Note.g].compact(), [
          (from: Note.c, to: Note.e),
          (from: Note.g, to: Note.a.flat),
        ]);
        expect(
            [
              Note.c,
              Note.d.flat,
              Note.d,
              Note.e.flat,
              Note.f.sharp,
              Note.a,
              Note.b.flat,
              Note.b,
              Note.c,
              Note.c.sharp,
            ].compact(),
            [
              (from: Note.c, to: Note.e),
              (from: Note.f.sharp, to: Note.g),
              (from: Note.a, to: Note.d),
            ]);

        expect([Note.c.inOctave(2)].compact(), [
          (from: Note.c.inOctave(2), to: Note.d.flat.inOctave(2)),
        ]);
        expect([Note.c.inOctave(4), Note.c.sharp.inOctave(4)].compact(), [
          (from: Note.c.inOctave(4), to: Note.d.inOctave(4)),
        ]);
        expect(
            [
              Note.c.inOctave(4),
              Note.d.flat.inOctave(4),
              Note.d.inOctave(4),
              Note.d.sharp.inOctave(4),
              Note.e.inOctave(4),
              Note.g.flat.inOctave(4),
              Note.g.inOctave(4),
              Note.g.sharp.inOctave(4),
              Note.b.flat.inOctave(4),
              Note.b.inOctave(4),
              Note.b.sharp.inOctave(4),
              Note.d.flat.inOctave(5),
            ].compact(),
            [
              (from: Note.c.inOctave(4), to: Note.f.inOctave(4)),
              (from: Note.g.flat.inOctave(4), to: Note.a.inOctave(4)),
              (from: Note.b.flat.inOctave(4), to: Note.d.inOctave(5)),
            ]);
      });
    });
  });
}
