import 'package:music_notes/music_notes.dart';
import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('IterableExtension', () {
    group('.closestTo()', () {
      test('throws an exception when this Iterable is empty', () {
        expect(() => const <num>[].closestTo(1), throwsStateError);
      });

      test('throws an ArgumentError when difference is required', () {
        expect(
          () => [DateTime(2025, 1, 2), DateTime(2023, 12, 15)]
              .closestTo(DateTime.now()),
          throwsArgumentError,
        );
        expect(() => const ['A', 'B'].closestTo('C'), throwsArgumentError);
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
          [Note.c, Note.e, Note.f.sharp, Note.a]
              .closestTo(Note.g, (a, b) => b.semitones - a.semitones),
          Note.f.sharp,
        );
      });
    });

    group('.compact()', () {
      test('returns this Iterable with ranges compacted', () {
        expect(
          const [1, 2, 3, 4, 5].compact(
            nextValue: (current) => current + 1,
            compare: Comparable.compare,
          ),
          const [(from: 1, to: 5)],
        );
        expect(
          'abcdefxyz'.split('').compact(
                nextValue: (current) =>
                    String.fromCharCodes(current.codeUnits.map((a) => a + 1)),
                compare: Comparable.compare,
              ),
          const [(from: 'a', to: 'f'), (from: 'x', to: 'z')],
        );

        expect(const <Note>[].compact(), const <List<Note>>[]);
        expect(const [Note.c].compact(), const [(from: Note.c, to: Note.c)]);
        expect(
          const [Note.c, Note.d, Note.e, Note.g, Note.a, Note.b].compact(),
          const [
            (from: Note.c, to: Note.c),
            (from: Note.d, to: Note.d),
            (from: Note.e, to: Note.e),
            (from: Note.g, to: Note.g),
            (from: Note.a, to: Note.a),
            (from: Note.b, to: Note.b),
          ],
        );
        expect([Note.c, Note.c.sharp].compact(), [
          (from: Note.c, to: Note.c.sharp),
        ]);
        expect([Note.c, Note.d.flat].compact(), [
          (from: Note.c, to: Note.d.flat),
        ]);
        expect([Note.c, Note.d.flat].compact(inclusive: true), [
          (from: Note.c, to: Note.d),
        ]);
        expect([Note.c, Note.d.flat, Note.d].compact(), [
          (from: Note.c, to: Note.d),
        ]);
        expect([Note.c, Note.d.flat, Note.d, Note.e.flat, Note.g].compact(), [
          (from: Note.c, to: Note.e.flat),
          (from: Note.g, to: Note.g),
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
              (from: Note.c, to: Note.e.flat),
              (from: Note.f.sharp, to: Note.f.sharp),
              (from: Note.a, to: Note.c.sharp),
            ]);

        expect([Note.c.inOctave(2)].compact(), [
          (from: Note.c.inOctave(2), to: Note.c.inOctave(2)),
        ]);
        expect([Note.c.inOctave(4), Note.c.sharp.inOctave(4)].compact(), [
          (from: Note.c.inOctave(4), to: Note.c.sharp.inOctave(4)),
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
              (from: Note.c.inOctave(4), to: Note.e.inOctave(4)),
              (from: Note.g.flat.inOctave(4), to: Note.g.sharp.inOctave(4)),
              (from: Note.b.flat.inOctave(4), to: Note.d.flat.inOctave(5)),
            ]);
      });
    });
  });
}
