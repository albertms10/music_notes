import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('FiveLimitTuning', () {
    group('.ratio()', () {
      test('returns 1 for the fork’s own pitch', () {
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(4)), 1);
      });

      test('returns the 5-limit ratio for the diatonic notes', () {
        expect(const FiveLimitTuning().ratio(Note.d.inOctave(4)), 9 / 8);
        expect(const FiveLimitTuning().ratio(Note.e.inOctave(4)), 5 / 4);
        expect(const FiveLimitTuning().ratio(Note.f.inOctave(4)), 4 / 3);
        expect(const FiveLimitTuning().ratio(Note.g.inOctave(4)), 3 / 2);
        expect(const FiveLimitTuning().ratio(Note.a.inOctave(4)), 5 / 3);
        expect(const FiveLimitTuning().ratio(Note.b.inOctave(4)), 15 / 8);
      });

      test('returns the 5-limit ratio for the chromatic notes', () {
        expect(
          const FiveLimitTuning().ratio(Note.c.sharp.inOctave(4)),
          135 / 128,
        );
        expect(
          const FiveLimitTuning().ratio(Note.d.flat.inOctave(4)),
          16 / 15,
        );
        expect(
          const FiveLimitTuning().ratio(Note.d.sharp.inOctave(4)),
          75 / 64,
        );
        expect(const FiveLimitTuning().ratio(Note.e.flat.inOctave(4)), 6 / 5);
        expect(
          const FiveLimitTuning().ratio(Note.f.sharp.inOctave(4)),
          45 / 32,
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.flat.inOctave(4)),
          64 / 45,
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.sharp.inOctave(4)),
          25 / 16,
        );
        expect(const FiveLimitTuning().ratio(Note.a.flat.inOctave(4)), 8 / 5);
        expect(
          const FiveLimitTuning().ratio(Note.a.sharp.inOctave(4)),
          225 / 128,
        );
        expect(
          const FiveLimitTuning().ratio(Note.b.flat.inOctave(4)),
          16 / 9,
        );
      });

      test('gives enharmonic spellings different ratios', () {
        // Unlike 12-EDO, C♯ and D♭ are not the same pitch in just
        // intonation: they differ by the diesis (128/125).
        expect(
          const FiveLimitTuning().ratio(Note.c.sharp.inOctave(4)),
          isNot(const FiveLimitTuning().ratio(Note.d.flat.inOctave(4))),
        );
      });

      test('returns values within a single octave [1, 2)', () {
        for (final note in <Note>[
          .c, .c.sharp, .d.flat, .d, .d.sharp, .e.flat, .e, .f, .f.sharp, //
          .g.flat, .g, .g.sharp, .a.flat, .a, .a.sharp, .b.flat, .b,
        ]) {
          final ratio = const FiveLimitTuning().ratio(note.inOctave(4));
          expect(
            ratio,
            allOf(greaterThanOrEqualTo(1), lessThan(2)),
            reason: '$note ratio $ratio should fall within [1, 2)',
          );
        }
      });

      test('scales by an octave for pitches above the fork’s octave', () {
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(5)), 2);
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(6)), 4);
        expect(const FiveLimitTuning().ratio(Note.e.inOctave(5)), 2.5);
      });

      test('scales by an octave for pitches below the fork’s octave', () {
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(3)), 0.5);
        expect(const FiveLimitTuning().ratio(Note.g.inOctave(3)), 0.75);
      });

      test('throws for notes outside the standard 12-note chromatic set', () {
        expect(
          () => const FiveLimitTuning().ratio(Note.c.flat.inOctave(4)),
          throwsUnsupportedError,
        );
        expect(
          () => const FiveLimitTuning().ratio(Note.f.sharp.sharp.inOctave(4)),
          throwsUnsupportedError,
        );
      });
    });

    group('.generator', () {
      test('returns the pure ascending fifth, inherited from '
          'JustIntonation', () {
        expect(
          const FiveLimitTuning().generator,
          const PythagoreanTuning().generator,
        );
      });
    });
  });
}
