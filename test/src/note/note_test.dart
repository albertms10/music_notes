import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
    group('.semitones', () {
      test('should return the semitones value of this Note', () {
        expect(const Note(Notes.b, Accidental.sharp).semitones, 1);
        expect(Note.c.semitones, 1);
        expect(Note.cSharp.semitones, 2);
        expect(Note.dFlat.semitones, 2);
        expect(Note.d.semitones, 3);
        expect(Note.dSharp.semitones, 4);
        expect(Note.eFlat.semitones, 4);
        expect(Note.e.semitones, 5);
        expect(Note.f.semitones, 6);
        expect(Note.fSharp.semitones, 7);
        expect(Note.gFlat.semitones, 7);
        expect(Note.g.semitones, 8);
        expect(Note.gSharp.semitones, 9);
        expect(Note.aFlat.semitones, 9);
        expect(Note.a.semitones, 10);
        expect(Note.aSharp.semitones, 11);
        expect(Note.bFlat.semitones, 11);
        expect(Note.b.semitones, 12);
        expect(const Note(Notes.c, Accidental.flat).semitones, 12);
      });
    });

    group('.difference()', () {
      test(
        'should return the difference in semitones with another Note',
        () {
          expect(Note.c.difference(Note.c), 0);
          expect(const Note(Notes.e, Accidental.sharp).difference(Note.f), 0);
          expect(Note.c.difference(Note.dFlat), 1);
          expect(Note.c.difference(Note.cSharp), 1);
          expect(Note.b.difference(Note.c), 1);
          expect(Note.f.difference(Note.g), 2);
          expect(Note.f.difference(Note.aFlat), 3);
          expect(Note.e.difference(Note.aFlat), 4);
          expect(Note.a.difference(Note.d), 5);
          expect(Note.d.difference(Note.aFlat), 6);
          expect(Note.eFlat.difference(Note.bFlat), 7);
          expect(Note.dSharp.difference(Note.aSharp), 7);
          expect(Note.d.difference(Note.aSharp), 8);
          expect(Note.cSharp.difference(Note.bFlat), 9);
          expect(Note.cSharp.difference(Note.b), 10);
          expect(Note.dFlat.difference(Note.b), 10);
          expect(Note.c.difference(Note.b), 11);
        },
      );
    });

    group('.exactFifthsDistance', () {
      test(
        'should return the fifths distance between this and other Note',
        () {
          expect(Note.c.exactFifthsDistance(Note.c), 0);
          expect(Note.aFlat.exactFifthsDistance(Note.cSharp), 11);
        },
      );
    });

    group('.exactInterval()', () {
      test('should return the Interval for a unison', () {
        expect(
          Note.c.exactInterval(Note.c),
          equals(const Interval.perfect(1, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.cSharp),
          equals(const Interval.perfect(1, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a second', () {
        expect(
          Note.c.exactInterval(const Note(Notes.d, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(2, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.dFlat),
          equals(const Interval.imperfect(2, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.d),
          equals(const Interval.imperfect(2, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(Note.dSharp),
          equals(
            const Interval.imperfect(2, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a third', () {
        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(3, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.eFlat),
          equals(const Interval.imperfect(3, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.e),
          equals(const Interval.imperfect(3, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.sharp)),
          equals(
            const Interval.imperfect(3, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a fourth', () {
        expect(
          Note.c.exactInterval(const Note(Notes.f, Accidental.flat)),
          equals(const Interval.perfect(4, PerfectQuality.diminished)),
        );
        expect(
          Note.c.exactInterval(Note.f),
          equals(const Interval.perfect(4, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.fSharp),
          equals(const Interval.perfect(4, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a fifth', () {
        expect(
          Note.c.exactInterval(Note.gFlat),
          equals(const Interval.perfect(5, PerfectQuality.diminished)),
        );
        expect(
          Note.c.exactInterval(Note.g),
          equals(const Interval.perfect(5, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.gSharp),
          equals(const Interval.perfect(5, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a sixth', () {
        expect(
          Note.c.exactInterval(const Note(Notes.a, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(6, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.aFlat),
          equals(const Interval.imperfect(6, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.a),
          equals(const Interval.imperfect(6, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(Note.aSharp),
          equals(
            const Interval.imperfect(6, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a seventh', () {
        expect(
          Note.c.exactInterval(const Note(Notes.b, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(7, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.bFlat),
          equals(const Interval.imperfect(7, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.b),
          equals(const Interval.imperfect(7, ImperfectQuality.major)),
        );
        // TODO(albertms10): add test case for:
        //  `Note.c.exactInterval(const Note(Notes.b, Accidental.sharp))`.
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Note', () {
        expect(Note.c.toString(), 'C');
        expect(Note.bFlat.toString(), 'B♭');
        expect(Note.fSharp.toString(), 'F♯');
        expect(const Note(Notes.a, Accidental.doubleSharp).toString(), 'A𝄪');
        expect(const Note(Notes.g, Accidental.doubleFlat).toString(), 'G𝄫');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Note instances in a Set', () {
        final collection = {Note.c, Note.aFlat, Note.gSharp};
        collection.addAll(collection);
        expect(collection.toList(), const [Note.c, Note.aFlat, Note.gSharp]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Note items in a collection', () {
        final orderedSet = SplayTreeSet<Note>.of(const [
          Note.aFlat,
          Note.c,
          Note.gSharp,
          Note(Notes.b, Accidental.sharp),
        ]);
        expect(orderedSet.toList(), const [
          Note.c,
          Note(Notes.b, Accidental.sharp),
          Note.gSharp,
          Note.aFlat,
        ]);
      });
    });
  });
}
