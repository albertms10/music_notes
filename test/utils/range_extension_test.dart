import 'package:music_notes/music_notes.dart';
import 'package:music_notes/utils.dart';
import 'package:test/test.dart';

void main() {
  group('RangeExtension', () {
    group('.explode()', () {
      test('throws an assertion error when arguments are incorrect', () {
        expect(
          () => (from: Note.c.inOctave(4), to: Note.b.inOctave(3)).explode(),
          throwsA(isA<AssertionError>()),
        );
      });

      test('returns the list of all items between from and to', () {
        expect(
          const (from: 1, to: 10).explode(
            nextValue: (current) => current + 1,
            compare: Comparable.compare,
          ),
          const [1, 2, 3, 4, 5, 6, 7, 8, 9],
        );
        expect(const (from: Note.c, to: Note.c).explode(), const <Note>[]);
        expect((from: Note.c, to: Note.d.flat).explode(), const [Note.c]);
        expect(const (from: Note.c, to: Note.b).explode(), [
          Note.c,
          Note.d.flat,
          Note.d,
          Note.e.flat,
          Note.e,
          Note.f,
          Note.g.flat,
          Note.g,
          Note.a.flat,
          Note.a,
          Note.b.flat,
        ]);
        expect(
          (from: Note.e, to: Note.e.flat).explode(
            nextValue: (note) => note.transposeBy(Interval.A1).respelledSimple,
          ),
          [
            Note.e,
            Note.f,
            Note.f.sharp,
            Note.g,
            Note.g.sharp,
            Note.a,
            Note.a.sharp,
            Note.b,
            Note.c,
            Note.c.sharp,
            Note.d,
          ],
        );
        expect((from: Note.b, to: Note.c.sharp).explode(), const [
          Note.b,
          Note.c,
        ]);
        expect(
          const (from: Note.c, to: Note.b).explode(
            nextValue: (note) => note.transposeBy(Interval.M2).respelledSimple,
          ),
          [Note.c, Note.d, Note.e, Note.f.sharp, Note.g.sharp, Note.a.sharp],
        );

        expect((from: Note.c.inOctave(3), to: Note.g.inOctave(5)).explode(), [
          Note.c.inOctave(3),
          Note.d.flat.inOctave(3),
          Note.d.inOctave(3),
          Note.e.flat.inOctave(3),
          Note.e.inOctave(3),
          Note.f.inOctave(3),
          Note.g.flat.inOctave(3),
          Note.g.inOctave(3),
          Note.a.flat.inOctave(3),
          Note.a.inOctave(3),
          Note.b.flat.inOctave(3),
          Note.b.inOctave(3),
          Note.c.inOctave(4),
          Note.d.flat.inOctave(4),
          Note.d.inOctave(4),
          Note.e.flat.inOctave(4),
          Note.e.inOctave(4),
          Note.f.inOctave(4),
          Note.g.flat.inOctave(4),
          Note.g.inOctave(4),
          Note.a.flat.inOctave(4),
          Note.a.inOctave(4),
          Note.b.flat.inOctave(4),
          Note.b.inOctave(4),
          Note.c.inOctave(5),
          Note.d.flat.inOctave(5),
          Note.d.inOctave(5),
          Note.e.flat.inOctave(5),
          Note.e.inOctave(5),
          Note.f.inOctave(5),
          Note.g.flat.inOctave(5),
        ]);

        expect(
          skip:
              'TODO(albertms10): should stop when the loop gets out of range.',
          () => (
            from: Note.c,
            to: Note.a,
          ).explode(nextValue: (note) => note.transposeBy(Interval.P4)),
          const [Note.c, Note.f],
        );
        expect(
          skip:
              'TODO(albertms10): should stop when the loop gets out of range.',
          () => (
            from: Note.c.inOctave(3),
            to: Note.b.flat.inOctave(3),
          ).explode(nextValue: (note) => note.transposeBy(Interval.P5)),
          [Note.c.inOctave(3), Note.g.inOctave(3)],
        );
      });
    });
  });

  group('RangeIterableExtension', () {
    group('.format()', () {
      test('returns the string representation of this Range iterable.', () {
        expect(const <Range<Note>>[].format(), '');
        expect([(from: Note.e, to: Note.e)].format(), 'E');
        expect([(from: Note.d.flat, to: Note.f.sharp)].format(), 'D♭–F♯');
        expect(
          [
            (from: Note.c, to: Note.e.flat),
            (from: Note.g, to: Note.g),
            (from: Note.a.flat, to: Note.d),
          ].format(),
          'C–E♭, G, A♭–D',
        );
        expect(
          [
            (from: Note.c.inOctave(3), to: Note.e.flat.inOctave(3)),
            (from: Note.g.inOctave(4), to: Note.g.inOctave(4)),
            (from: Note.a.flat.inOctave(5), to: Note.d.sharp.inOctave(5)),
          ].format(
            rangeSeparator: ' to ',
            nonConsecutiveSeparator: '; ',
            formatter: HelmholtzPitchNotation.english,
          ),
          'c to e♭; g′; a♭″ to d♯″',
        );
      });
    });
  });
}
