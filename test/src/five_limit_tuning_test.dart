import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('FiveLimitTuning', () {
    group('.ratio()', () {
      test('returns 1 for the fork’s own pitch', () {
        expect(const FiveLimitTuning().ratio(Note.c.inOctave(4)), 1);
      });

      test('returns the 5-limit ratio for the diatonic notes', () {
        expect(
          const FiveLimitTuning().ratio(Note.d.inOctave(4)),
          closeTo(9 / 8, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.e.inOctave(4)),
          closeTo(5 / 4, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.f.inOctave(4)),
          closeTo(4 / 3, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.inOctave(4)),
          closeTo(3 / 2, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.a.inOctave(4)),
          closeTo(5 / 3, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.b.inOctave(4)),
          closeTo(15 / 8, 1e-12),
        );
      });

      test('returns the 5-limit ratio for the chromatic notes', () {
        expect(
          const FiveLimitTuning().ratio(Note.c.sharp.inOctave(4)),
          closeTo(25 / 24, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.d.flat.inOctave(4)),
          closeTo(16 / 15, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.d.sharp.inOctave(4)),
          closeTo(75 / 64, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.e.flat.inOctave(4)),
          closeTo(6 / 5, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.f.sharp.inOctave(4)),
          closeTo(45 / 32, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.flat.inOctave(4)),
          closeTo(64 / 45, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.g.sharp.inOctave(4)),
          closeTo(25 / 16, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.a.flat.inOctave(4)),
          closeTo(8 / 5, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.a.sharp.inOctave(4)),
          closeTo(225 / 128, 1e-12),
        );
        expect(
          const FiveLimitTuning().ratio(Note.b.flat.inOctave(4)),
          closeTo(16 / 9, 1e-12),
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

      test('computes ratios for notes outside the standard 12, unlike a '
          'fixed lookup table', () {
        // F𝄪 (double sharp, distance 13): 3 ascending thirds and 1
        // ascending fifth, landing in the same octave as the fork.
        expect(
          const FiveLimitTuning().ratio(Note.f.sharp.sharp.inOctave(4)),
          closeTo(375 / 256, 1e-12),
        );
      });

      test('respects real octave placement even when it crosses a letter '
          'boundary', () {
        // C♭ ’s accidental pushes its real pitch height *below* its
        // letter’s octave: C♭4 is enharmonically B3 (see
        // Pitch.respelledSimple’s doc comment). Its 5-limit pitch class,
        // 48/25 (2 descending thirds + 1 ascending fifth), therefore gets
        // folded down by one octave to land where C♭4 really sits: just
        // under the C4 fork, not almost an octave above it.
        expect(
          const FiveLimitTuning().ratio(Note.c.flat.inOctave(4)),
          closeTo(24 / 25, 1e-9),
        );
        expect(
          const FiveLimitTuning().ratio(Note.c.flat.inOctave(4)),
          lessThan(1),
        );
      });

      test('prefers the fewest fifths, matching the “asymmetric scale” '
          'convention for C♯ (25/24, not the also-common 135/128)', () {
        expect(
          const FiveLimitTuning().ratio(Note.c.sharp.inOctave(4)),
          closeTo(25 / 24, 1e-12),
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
