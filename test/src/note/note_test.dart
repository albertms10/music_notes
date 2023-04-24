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
          expect(Note.b.difference(Note.c), -11);
          expect(Note.f.difference(Note.g), 2);
          expect(Note.f.difference(Note.aFlat), 3);
          expect(Note.e.difference(Note.aFlat), 4);
          expect(Note.a.difference(Note.d), -7);
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

    group('.exactFifthsDistance()', () {
      test(
        'should return the fifths distance between this and other Note',
        () {
          expect(Note.c.exactFifthsDistance(Note.c), 0);
          expect(Note.aFlat.exactFifthsDistance(Note.cSharp), 11);
        },
      );
    });

    group('.exactInterval()', () {
      test('should return the Interval between this Note and other', () {
        expect(Note.c.exactInterval(Note.c), Interval.perfectUnison);
        expect(Note.c.exactInterval(Note.cSharp), Interval.augmentedUnison);

        expect(
          Note.c.exactInterval(const Note(Notes.d, Accidental.doubleFlat)),
          Interval.diminishedSecond,
        );
        expect(Note.c.exactInterval(Note.dFlat), Interval.minorSecond);
        expect(Note.c.exactInterval(Note.d), Interval.majorSecond);
        expect(Note.c.exactInterval(Note.dSharp), Interval.augmentedSecond);

        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.doubleFlat)),
          Interval.diminishedThird,
        );
        expect(Note.c.exactInterval(Note.eFlat), Interval.minorThird);
        expect(Note.c.exactInterval(Note.e), Interval.majorThird);
        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.sharp)),
          Interval.augmentedThird,
        );

        expect(
          Note.c.exactInterval(const Note(Notes.f, Accidental.flat)),
          Interval.diminishedFourth,
        );
        expect(Note.c.exactInterval(Note.f), Interval.perfectFourth);
        expect(Note.c.exactInterval(Note.fSharp), Interval.augmentedFourth);

        expect(Note.c.exactInterval(Note.gFlat), Interval.diminishedFifth);
        expect(Note.c.exactInterval(Note.g), Interval.perfectFifth);
        expect(Note.c.exactInterval(Note.gSharp), Interval.augmentedFifth);

        expect(
          Note.c.exactInterval(const Note(Notes.a, Accidental.doubleFlat)),
          Interval.diminishedSixth,
        );
        expect(Note.c.exactInterval(Note.aFlat), Interval.minorSixth);
        expect(Note.c.exactInterval(Note.a), Interval.majorSixth);
        expect(Note.c.exactInterval(Note.aSharp), Interval.augmentedSixth);

        expect(
          Note.c.exactInterval(const Note(Notes.b, Accidental.doubleFlat)),
          Interval.diminishedSeventh,
        );
        expect(Note.c.exactInterval(Note.bFlat), Interval.minorSeventh);
        expect(Note.c.exactInterval(Note.b), Interval.majorSeventh);
        // TODO(albertms10): add test case for:
        //  `Note.c.exactInterval(const Note(Notes.b, Accidental.sharp))`.
      });
    });

    group('.transposeBy()', () {
      test('should return this Note transposed by Interval', () {
        expect(
          Note.c.transposeBy(Interval.diminishedUnison),
          const Note(Notes.c, Accidental.flat),
        );
        expect(Note.c.transposeBy(Interval.perfectUnison), Note.c);
        expect(Note.c.transposeBy(Interval.augmentedUnison), Note.cSharp);

        expect(
          Note.c.transposeBy(Interval.diminishedSecond),
          const Note(Notes.d, Accidental.doubleFlat),
        );
        expect(Note.c.transposeBy(Interval.minorSecond), Note.dFlat);
        expect(Note.c.transposeBy(Interval.majorSecond), Note.d);
        expect(Note.c.transposeBy(Interval.augmentedSecond), Note.dSharp);

        expect(Note.e.transposeBy(Interval.minorThird), Note.g);
        expect(Note.e.transposeBy(Interval.majorThird), Note.gSharp);
        expect(
          Note.aFlat.transposeBy(Interval.minorThird),
          const Note(Notes.c, Accidental.flat),
        );
        expect(Note.aFlat.transposeBy(Interval.majorThird), Note.c);

        expect(
          Note.f.transposeBy(Interval.diminishedFourth),
          const Note(Notes.b, Accidental.doubleFlat),
        );
        expect(Note.f.transposeBy(Interval.perfectFourth), Note.bFlat);
        expect(Note.f.transposeBy(Interval.augmentedFourth), Note.b);
        expect(Note.a.transposeBy(Interval.diminishedFourth), Note.dFlat);
        expect(Note.a.transposeBy(Interval.perfectFourth), Note.d);
        expect(Note.a.transposeBy(Interval.augmentedFourth), Note.dSharp);

        expect(Note.d.transposeBy(Interval.diminishedFifth), Note.aFlat);
        expect(Note.d.transposeBy(Interval.perfectFifth), Note.a);
        expect(Note.d.transposeBy(Interval.augmentedFifth), Note.aSharp);

        expect(Note.d.transposeBy(Interval.minorSixth), Note.bFlat);
        expect(Note.d.transposeBy(Interval.majorSixth), Note.b);
        expect(Note.fSharp.transposeBy(Interval.minorSixth), Note.d);
        expect(Note.fSharp.transposeBy(Interval.majorSixth), Note.dSharp);

        expect(Note.c.transposeBy(Interval.minorSeventh), Note.bFlat);
        expect(Note.c.transposeBy(Interval.majorSeventh), Note.b);
        expect(
          Note.c.transposeBy(Interval.augmentedSeventh),
          const Note(Notes.b, Accidental.sharp),
        );
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
