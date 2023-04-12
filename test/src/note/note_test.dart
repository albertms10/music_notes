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
          expect(
            const Note(Notes.e, Accidental.sharp).difference(Note.f),
            0,
          );
          expect(Note.d.difference(Note.aFlat), 6);
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
        const interval = 1;
        expect(
          Note.c.exactInterval(Note.c),
          equals(const Interval.perfect(interval, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.cSharp),
          equals(const Interval.perfect(interval, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a second', () {
        const interval = 2;
        expect(
          Note.c.exactInterval(const Note(Notes.d, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(interval, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.dFlat),
          equals(const Interval.imperfect(interval, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.d),
          equals(const Interval.imperfect(interval, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(Note.dSharp),
          equals(
            const Interval.imperfect(interval, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a third', () {
        const interval = 3;
        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(interval, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.eFlat),
          equals(const Interval.imperfect(interval, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.e),
          equals(const Interval.imperfect(interval, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.sharp)),
          equals(
            const Interval.imperfect(interval, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a fourth', () {
        const interval = 4;
        expect(
          Note.c.exactInterval(const Note(Notes.f, Accidental.flat)),
          equals(const Interval.perfect(interval, PerfectQuality.diminished)),
        );
        expect(
          Note.c.exactInterval(Note.f),
          equals(const Interval.perfect(interval, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.fSharp),
          equals(const Interval.perfect(interval, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a fifth', () {
        const interval = 5;
        expect(
          Note.c.exactInterval(Note.gFlat),
          equals(const Interval.perfect(interval, PerfectQuality.diminished)),
        );
        expect(
          Note.c.exactInterval(Note.g),
          equals(const Interval.perfect(interval, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.gSharp),
          equals(const Interval.perfect(interval, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a sixth', () {
        const interval = 6;
        expect(
          Note.c.exactInterval(const Note(Notes.a, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(interval, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.aFlat),
          equals(const Interval.imperfect(interval, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.a),
          equals(const Interval.imperfect(interval, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(Note.aSharp),
          equals(
            const Interval.imperfect(interval, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a seventh', () {
        const interval = 7;
        expect(
          Note.c.exactInterval(const Note(Notes.b, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(interval, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.bFlat),
          equals(const Interval.imperfect(interval, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.b),
          equals(const Interval.imperfect(interval, ImperfectQuality.major)),
        );
        // TODO(albertms10): add test case for:
        //  Note.c.exactInterval(const Note(Notes.b, Accidental.sharp)).
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
