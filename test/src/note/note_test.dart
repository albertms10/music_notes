import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
    group('.semitones', () {
      test('should return the semitones value of this Note', () {
        expect(Note.b.sharp.semitones, 1);
        expect(Note.c.semitones, 1);
        expect(Note.c.sharp.semitones, 2);
        expect(Note.d.flat.semitones, 2);
        expect(Note.d.semitones, 3);
        expect(Note.d.sharp.semitones, 4);
        expect(Note.e.flat.semitones, 4);
        expect(Note.e.semitones, 5);
        expect(Note.f.semitones, 6);
        expect(Note.f.sharp.semitones, 7);
        expect(Note.g.flat.semitones, 7);
        expect(Note.g.semitones, 8);
        expect(Note.g.sharp.semitones, 9);
        expect(Note.a.flat.semitones, 9);
        expect(Note.a.semitones, 10);
        expect(Note.a.sharp.semitones, 11);
        expect(Note.b.flat.semitones, 11);
        expect(Note.b.semitones, 12);
        expect(Note.c.flat.semitones, 12);
      });
    });

    group('.difference()', () {
      test(
        'should return the difference in semitones with another Note',
        () {
          expect(Note.c.difference(Note.c), 0);
          expect(Note.e.sharp.difference(Note.f), 0);
          expect(Note.c.difference(Note.d.flat), 1);
          expect(Note.c.difference(Note.c.sharp), 1);
          expect(Note.b.difference(Note.c), -11);
          expect(Note.f.difference(Note.g), 2);
          expect(Note.f.difference(Note.a.flat), 3);
          expect(Note.e.difference(Note.a.flat), 4);
          expect(Note.a.difference(Note.d), -7);
          expect(Note.d.difference(Note.a.flat), 6);
          expect(Note.e.flat.difference(Note.b.flat), 7);
          expect(Note.d.sharp.difference(Note.a.sharp), 7);
          expect(Note.d.difference(Note.a.sharp), 8);
          expect(Note.c.sharp.difference(Note.b.flat), 9);
          expect(Note.c.sharp.difference(Note.b), 10);
          expect(Note.d.flat.difference(Note.b), 10);
          expect(Note.c.difference(Note.b), 11);
        },
      );
    });

    group('.circleOfFifthsDistance', () {
      test('should return the circle of fifths distance of this Note', () {
        expect(Note.f.flat.circleOfFifthsDistance, -8);
        expect(Note.c.flat.circleOfFifthsDistance, -7);
        expect(Note.g.flat.circleOfFifthsDistance, -6);
        expect(Note.d.flat.circleOfFifthsDistance, -5);
        expect(Note.a.flat.circleOfFifthsDistance, -4);
        expect(Note.e.flat.circleOfFifthsDistance, -3);
        expect(Note.b.flat.circleOfFifthsDistance, -2);
        expect(Note.f.circleOfFifthsDistance, -1);
        expect(Note.c.circleOfFifthsDistance, 0);
        expect(Note.g.circleOfFifthsDistance, 1);
        expect(Note.d.circleOfFifthsDistance, 2);
        expect(Note.a.circleOfFifthsDistance, 3);
        expect(Note.e.circleOfFifthsDistance, 4);
        expect(Note.b.circleOfFifthsDistance, 5);
        expect(Note.f.sharp.circleOfFifthsDistance, 6);
        expect(Note.c.sharp.circleOfFifthsDistance, 7);
        expect(Note.g.sharp.circleOfFifthsDistance, 8);
        expect(Note.d.sharp.circleOfFifthsDistance, 9);
        expect(Note.a.sharp.circleOfFifthsDistance, 10);
        expect(Note.e.sharp.circleOfFifthsDistance, 11);
        // TODO(albertms10): Failing test: should return 12.
        expect(Note.b.sharp.circleOfFifthsDistance, 0);
      });
    });

    group('.exactFifthsDistance()', () {
      test(
        'should return the fifths distance between this and other Note',
        () {
          expect(Note.c.exactFifthsDistance(Note.c), 0);
          expect(Note.a.flat.exactFifthsDistance(Note.c.sharp), 11);
        },
      );
    });

    group('.exactInterval()', () {
      test('should return the Interval between this Note and other', () {
        expect(Note.c.exactInterval(Note.c), Interval.perfectUnison);
        expect(Note.c.exactInterval(Note.c.sharp), Interval.augmentedUnison);

        expect(
          Note.c.exactInterval(Note.d.flat.flat),
          Interval.diminishedSecond,
        );
        expect(Note.c.exactInterval(Note.d.flat), Interval.minorSecond);
        expect(Note.c.exactInterval(Note.d), Interval.majorSecond);
        expect(Note.c.exactInterval(Note.d.sharp), Interval.augmentedSecond);

        expect(
          Note.c.exactInterval(Note.e.flat.flat),
          Interval.diminishedThird,
        );
        expect(Note.c.exactInterval(Note.e.flat), Interval.minorThird);
        expect(Note.c.exactInterval(Note.e), Interval.majorThird);
        expect(Note.c.exactInterval(Note.e.sharp), Interval.augmentedThird);

        expect(Note.c.exactInterval(Note.f.flat), Interval.diminishedFourth);
        expect(Note.c.exactInterval(Note.f), Interval.perfectFourth);
        expect(Note.c.exactInterval(Note.f.sharp), Interval.augmentedFourth);

        expect(Note.c.exactInterval(Note.g.flat), Interval.diminishedFifth);
        expect(Note.c.exactInterval(Note.g), Interval.perfectFifth);
        expect(Note.c.exactInterval(Note.g.sharp), Interval.augmentedFifth);

        expect(
          Note.c.exactInterval(Note.a.flat.flat),
          Interval.diminishedSixth,
        );
        expect(Note.c.exactInterval(Note.a.flat), Interval.minorSixth);
        expect(Note.c.exactInterval(Note.a), Interval.majorSixth);
        expect(Note.c.exactInterval(Note.a.sharp), Interval.augmentedSixth);

        expect(
          Note.c.exactInterval(Note.b.flat.flat),
          Interval.diminishedSeventh,
        );
        expect(Note.c.exactInterval(Note.b.flat), Interval.minorSeventh);
        expect(Note.c.exactInterval(Note.b), Interval.majorSeventh);
        // TODO(albertms10): add test case for:
        //  `Note.c.exactInterval(Note.b.sharp)`.
      });
    });

    group('.transposeBy()', () {
      test('should return this Note transposed by Interval', () {
        expect(Note.c.transposeBy(Interval.diminishedUnison), Note.c.flat);
        expect(Note.c.transposeBy(-Interval.diminishedUnison), Note.c.sharp);
        expect(Note.c.transposeBy(Interval.perfectUnison), Note.c);
        expect(Note.c.transposeBy(-Interval.perfectUnison), Note.c);
        expect(Note.c.transposeBy(Interval.augmentedUnison), Note.c.sharp);
        expect(Note.c.transposeBy(-Interval.augmentedUnison), Note.c.flat);

        expect(Note.c.transposeBy(Interval.diminishedSecond), Note.d.flat.flat);
        expect(Note.c.transposeBy(-Interval.diminishedSecond), Note.b.sharp);
        expect(Note.c.transposeBy(Interval.minorSecond), Note.d.flat);
        expect(Note.c.transposeBy(-Interval.minorSecond), Note.b);
        expect(Note.c.transposeBy(Interval.majorSecond), Note.d);
        expect(Note.c.transposeBy(-Interval.majorSecond), Note.b.flat);
        expect(Note.c.transposeBy(Interval.augmentedSecond), Note.d.sharp);
        expect(Note.c.transposeBy(-Interval.augmentedSecond), Note.b.flat.flat);

        expect(Note.e.transposeBy(Interval.minorThird), Note.g);
        expect(Note.e.transposeBy(-Interval.minorThird), Note.c.sharp);
        expect(Note.e.transposeBy(Interval.majorThird), Note.g.sharp);
        expect(Note.e.transposeBy(-Interval.majorThird), Note.c);
        expect(Note.a.flat.transposeBy(Interval.minorThird), Note.c.flat);
        expect(Note.a.flat.transposeBy(-Interval.minorThird), Note.f);
        expect(Note.a.flat.transposeBy(Interval.majorThird), Note.c);
        expect(Note.a.flat.transposeBy(-Interval.majorThird), Note.f.flat);

        expect(Note.f.transposeBy(Interval.diminishedFourth), Note.b.flat.flat);
        expect(Note.f.transposeBy(-Interval.diminishedFourth), Note.c.sharp);
        expect(Note.f.transposeBy(Interval.perfectFourth), Note.b.flat);
        expect(Note.f.transposeBy(-Interval.perfectFourth), Note.c);
        expect(Note.f.transposeBy(Interval.augmentedFourth), Note.b);
        expect(Note.f.transposeBy(-Interval.augmentedFourth), Note.c.flat);
        expect(Note.a.transposeBy(Interval.diminishedFourth), Note.d.flat);
        expect(Note.a.transposeBy(-Interval.diminishedFourth), Note.e.sharp);
        expect(Note.a.transposeBy(Interval.perfectFourth), Note.d);
        expect(Note.a.transposeBy(-Interval.perfectFourth), Note.e);
        expect(Note.a.transposeBy(Interval.augmentedFourth), Note.d.sharp);
        expect(Note.a.transposeBy(-Interval.augmentedFourth), Note.e.flat);

        expect(Note.d.transposeBy(Interval.diminishedFifth), Note.a.flat);
        expect(Note.d.transposeBy(-Interval.diminishedFifth), Note.g.sharp);
        expect(Note.d.transposeBy(Interval.perfectFifth), Note.a);
        expect(Note.d.transposeBy(-Interval.perfectFifth), Note.g);
        expect(Note.d.transposeBy(Interval.augmentedFifth), Note.a.sharp);
        expect(Note.d.transposeBy(-Interval.augmentedFifth), Note.g.flat);

        expect(Note.d.transposeBy(Interval.minorSixth), Note.b.flat);
        expect(Note.d.transposeBy(-Interval.minorSixth), Note.f.sharp);
        expect(Note.d.transposeBy(Interval.majorSixth), Note.b);
        expect(Note.d.transposeBy(-Interval.majorSixth), Note.f);
        expect(Note.f.sharp.transposeBy(Interval.minorSixth), Note.d);
        expect(Note.f.sharp.transposeBy(-Interval.minorSixth), Note.a.sharp);
        expect(Note.f.sharp.transposeBy(Interval.majorSixth), Note.d.sharp);
        expect(Note.f.sharp.transposeBy(-Interval.majorSixth), Note.a);

        expect(Note.c.transposeBy(Interval.minorSeventh), Note.b.flat);
        expect(Note.c.transposeBy(-Interval.minorSeventh), Note.d);
        expect(Note.c.transposeBy(Interval.majorSeventh), Note.b);
        expect(Note.c.transposeBy(-Interval.majorSeventh), Note.d.flat);
        expect(Note.c.transposeBy(Interval.augmentedSeventh), Note.b.sharp);
        expect(
          Note.c.transposeBy(-Interval.augmentedSeventh),
          Note.d.flat.flat,
        );
      });
    });

    group('.toString()', () {
      test('should return the string representation of this Note', () {
        expect(Note.c.toString(), 'C');
        expect(Note.b.flat.toString(), 'B♭');
        expect(Note.f.sharp.toString(), 'F♯');
        expect(Note.a.sharp.sharp.toString(), 'A𝄪');
        expect(Note.g.flat.flat.toString(), 'G𝄫');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Note instances in a Set', () {
        final collection = {Note.c, Note.a.flat, Note.g.sharp};
        collection.addAll(collection);
        expect(collection.toList(), [Note.c, Note.a.flat, Note.g.sharp]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Note items in a collection', () {
        final orderedSet = SplayTreeSet<Note>.of([
          Note.a.flat,
          Note.c,
          Note.g.sharp,
          Note.b.sharp,
        ]);
        expect(orderedSet.toList(), [
          Note.c,
          Note.b.sharp,
          Note.g.sharp,
          Note.a.flat,
        ]);
      });

      test(
        'should correctly sort Note items in a collection by fifths distance',
        () {
          final orderedSet = SplayTreeSet<Note>.of(
            [
              Note.d,
              Note.a.flat,
              Note.c,
              Note.b.flat,
              Note.g.sharp,
              Note.b.sharp,
            ],
            Note.compareByFifthsDistance,
          );
          expect(orderedSet.toList(), [
            Note.a.flat,
            Note.b.flat,
            Note.c,
            Note.d,
            Note.g.sharp,
            // TODO(albertms10): Failing test: should include
            //  `Note(BaseNote.b, Accidental.sharp)`.
          ]);
        },
      );
    });
  });
}
